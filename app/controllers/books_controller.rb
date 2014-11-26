class BooksController < ApplicationController
  before_action :authenticate
  before_action :authorize_admin, only: [ :create ]

  def index
    if params[:query]
      @books = Book.search params[:query]
      render json: @books
    else
      render json: "Missing query parameter.", status: 400
    end
  end

  def create
    @book = current_user.books.new(book_params)

    if @book.save
      render json: @book, status: 201
    else
      render json: @book.errors, status: 400
    end
  end

  def borrow
    @book = Book.find params[:id]
    if @book.try :available?
      @book.borrow!
    else
      render json: "Book is either unavailable or doesn't exist", status: 404
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :year, :author)
  end

end
