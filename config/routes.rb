Tolk::Application.routes.draw do
  scope 'tolk', :as => "tolk" do
    resources :locales, :controller => 'Tolk::Locales' do
      member do
        get :all
        get :updated
      end
      resource :search
    end
    match '/', :controller => 'Tolk::Locales', :action => 'index', :as => 'root'
  end
end
