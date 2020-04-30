Rails.application.routes.draw do
  namespace 'api' do
    namespace 'status'do
      puts '1'

  get 'welcome/status'
  root 'welcome#index'
    end
  end
end
