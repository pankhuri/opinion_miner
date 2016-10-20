module TweetsHelper
	def get_image(sentiment)
		if sentiment == "positive"
			return "positive.png"
		elsif sentiment == "negative"
			return "negative.png"
		elsif sentiment == "neutral"
			return "neutral.png"
		end	
	end
end
