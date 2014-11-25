require 'spec_helper'

describe BooksController do

  let(:valid_params) {{ name: "Valid book", year: 2010, author: "Someone" }}
  let(:invalid_params) {{ name: nil, year: 2010, author: "Someone" }}

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Book" do
        expect {
          post :create, book: valid_params
        }.to change(Book, :count).by(1)
      end

      it "returns status code 201" do
        post :create, book: valid_params
        expect(response.status).to be(201)
      end
    end

    describe "with invalid params" do
      it "returns status code 400" do
        post :create, { book: invalid_params }
        expect(response.status).to be(400)
      end
    end
  end

  describe "GET index" do
    before do
      Book.create name: "El Aleph", year: 1984, author: "Jorge Luis Borges"
      Book.create name: "La Resistencia", year: 1988, author: "Ernesto Sabato"
      Book.create name: "El Tunel", year: 1998, author: "Ernesto Sabato", borrowed_date: 5.days.ago
    end

    describe "with a query string" do
      it "lists available books that match a name search" do
        get :index, q: "Aleph"
        expect(assigns[:books].first.name).to eq("El Aleph")
      end

    end

    describe "without a query string" do
      it "returns 400 status code" do
        get :index
        expect(response.status).to eq(400)
      end
    end
  end
end
