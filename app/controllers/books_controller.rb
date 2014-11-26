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
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      head :no_content
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    head :no_content
  end

  private

  def book_params
    params.require(:book).permit(:name, :year, :author)
  end

end
