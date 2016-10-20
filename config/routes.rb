Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :tweets do 
  	collection do 
  	end
  end

  root :to => 'tweets#index'
  
  
end
