require 'idol_api'
require 'twitter_api'

class TweetsController < ApplicationController
	include IdolApi
	include TwitterApi

	TWEET_COUNT = 100
	
	def index
		# Configure the number of tweets to be fetched in the TWEET_COUNT.
			# Set the max_id value (last tweet's id) and use it to get the next set of tweets.
	    @positive_result = []
	    @negative_result = []
	    @neutral_result = []
	    counter = 0
			@tweets = search_tweets(params[:hashtag], param_values(params))#.take(TWEET_COUNT)
			@tweets.each do |tweet|
				sentimental = get_sentimental(tweet.text)
				@positive_result << tweet.as_json.merge!(sentimental: sentimental) if sentimental[:sentiment] == "positive"
				@negative_result << tweet.as_json.merge!(sentimental: sentimental) if sentimental[:sentiment] == "negative"
				@neutral_result << tweet.as_json.merge!(sentimental: sentimental) if sentimental[:sentiment] == "neutral"
				counter+=1
			end
			@positive_percent = (@positive_result.count * 100 )/counter
			@negative_percent = (@positive_result.count * 100 )/counter
			@neutral_percent = (@positive_result.count * 100 )/counter
			p "--------#{counter}"
	end

	def show
		@tweet = fetch_tweet(params[:id])
		@language = JSON.parse identify_language(@tweet.text)
		@sentiment = JSON.parse detect_sentiment(@tweet.text, @language)
		
		# Positive terms in the tweet
		@positive_terms = @sentiment["positive"].sort_by{ |hsh| hsh["score"] }.reverse
		positive_sentiment_terms = @positive_terms.collect{ |hsh| hsh["sentiment"] }		
		@pos_highlighted_tweet = JSON.parse(highlight_text(
			@tweet.text, positive_sentiment_terms, "<span class='pos_highlight'>"))
		
		# Negative terms in the tweet
		@negative_terms = @sentiment["negative"].sort_by{ |hsh| hsh["score"] }.reverse
		negative_sentiment_terms = @negative_terms.collect{ |hsh| hsh["sentiment"] }
		@neg_highlighted_tweet = JSON.parse(highlight_text(
			@tweet.text, negative_sentiment_terms, "<span class='neg_highlight'>" ))
	end


	private
		def param_values(params)
			{
				:since_date => start_date(params),
				:until_date => end_date(params),
				:max_id => params[:max_id],  # This param fetches tweets older than the given tweet ID
				:include_rts => params[:include_rts]
			}
		end

	  def start_date(params)
	    parse_from_date(params) ? Time.parse(parse_from_date(params)) : (Time.now.ago 30.day)
	  end
	  
	  def end_date(params)  
	    parse_to_date(params) ? Time.parse(parse_to_date(params)).end_of_day : Time.now
	  end
	  
	  def parse_from_date(params)
	    (params[:date_range].split(" - ")[0]) || params[:date_range] unless params[:date_range].blank?
	  end
	  
	  def parse_to_date(params)
	    (params[:date_range].split(" - ")[1]) || params[:date_range] unless params[:date_range].blank?
	  end

	  def get_sentimental text
			analyzer = Sentimental.new
			sentiment = analyzer.sentiment text
			score = analyzer.score text
			data = {sentiment: sentiment.to_s, score: score}
	end
end