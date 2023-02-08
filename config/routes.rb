Rails.application.routes.draw do
  root 'companies#index'
  resources :companies
  resources :employees do
    collection do
      get :prepare_import
      post :bulk_upload
    end
  end  
end
