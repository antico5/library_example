Rails.application.routes.draw do
  resources :books, only: [:create, :index]
  post 'books/:id/borrow' => "books#borrow"
end
