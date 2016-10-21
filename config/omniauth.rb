Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TwitterConfig["consumer_key"], TwitterConfig["consumer_secret"]
end


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TwitterConfig["consumer_key"], TwitterConfig["consumer_secret"],
    {
      :secure_image_url => 'true',
      :image_size => 'original',
      :authorize_params => {
        :force_login => 'true',
        :lang => 'pt'
      }
    }
end