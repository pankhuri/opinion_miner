module TwitterApi

		# Authenticate Twitter REST API
		def client
			@client = Twitter::REST::Client.new do |config|
			  config.consumer_key        = TwitterConfig["consumer_key"]
			  config.consumer_secret     = TwitterConfig["consumer_secret"]
			  config.access_token        = TwitterConfig["access_token"]
			  config.access_token_secret = TwitterConfig["access_token_secret"]
			end		
		end

		# Search tweets with a given hashtag
		def search_tweets(hashtag, param_values)			
			hashtag = fetch_hashtag(hashtag, param_values[:include_rts])			
			client.search(hashtag || "@quovantis")#, query_params(param_values))
		end

		# Fetch a particular tweet with ID
		def fetch_tweet(tweet_id)
			client.status(tweet_id)
		end

		private
			def fetch_hashtag(hashtag, include_rts=false)
				hashtag = hashtag.blank? ? "@quovantis" : hashtag
				if include_rts
					hashtag[0].eql?("#") ? "#{hashtag}" : "##{hashtag}"
				else
					# Search without the word 'RT' in the tweet.
					hashtag[0].eql?("#") ? "#{hashtag} -RT" : "##{hashtag} -RT"
				end
			end

			def query_params(param_values)
				params = {
					:since => param_values[:since_date].strftime("%Y-%m-%d"),
					:until => param_values[:until_date].strftime("%Y-%m-%d"),
					:max_id => param_values[:max_id] # This param fetches tweets older than the given tweet ID
				}

				
				# When 'until' param(YYYY-MM-DD) is sent, Twitter API returns tweets created before YYYY-MM-DD"00:00:00". 
				# So the latest tweets are not fetched when you choose until params as Time.now.
				# This small hack below removes until param when until time is set to today.
				params.delete_if{|k, v| k.eql?(:until) and v.eql?(Time.now.strftime("%Y-%m-%d")) }
			end	
			
end
