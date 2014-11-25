require 'spec_helper'

describe "Books API" do

  let(:valid_params) {{ name: "Valid book", year: 2010, author: "Someone" }}
  let(:invalid_params) {{ name: nil, year: 2010, author: "Someone" }}

  describe "POST /books", user: :admin do
    describe "with valid params" do
      it "creates a new Book" do
        expect {
          authorized_post "/books", { book: valid_params }
        }.to change(Book, :count).by(1)
      end

      it "returns new book attributes" do
        authorized_post "/books", book: valid_params
        expect(json["name"]).to be valid_params[:name]
        expect(json["author"]).to be valid_params[:author]
        expect(json["id"]).to not_be_nil
      end

      it "returns status code 201" do
        authorized_post "/books", book: valid_params
        expect(response.status).to be(201)
      end
    end

    describe "with invalid params" do
      it "returns status code 400" do
        authorized_post :create, book: invalid_params
        expect(response.status).to be(400)
      end
    end
  end

  describe "GET /books", user: :customer do
    before do
      Book.create name: "El Aleph", year: 1984, author: "Jorge Luis Borges"
      Book.create name: "La Resistencia", year: 1988, author: "Ernesto Sabato"
      Book.create name: "El Tunel", year: 1998, author: "Ernesto Sabato", borrowed_date: 5.days.ago
    end

    describe "with a query string" do
      it "lists available books that match a name search" do
        authorized_get "/books", q: "Aleph"
        expect(json.first.name).to be("El Aleph")
      end

      it "doesn't include unavailable books" do
        authorized_get "/books", q: "El"
        expect(json.count).to be(1)
      end

    end

    describe "without a query string" do
      it "returns 400 status code" do
        authorized_get "/books"
        expect(response.status).to be(400)
      end
    end
  end

  describe "POST /books/:id/borrow", user: :customer do
    let(:available_book) { Book.create name: "Test book", year: 2000, author: "Test", borrowed_date: 8.days.ago }
    let(:unavailable_book) { Book.create name: "Another book", year: 2000, author: "Test", borrowed_date: 2.days.ago }

    describe "with an available book" do
      it "returns 200 status code" do
        authorized_post "/books/#{ available_post.id }/borrow"
        expect(response.status).to be(200)
      end

      it "makes the book unavailable" do
        authorized_get "/books", q: "Test book"
        expect(json.count).to be(1)
        authorized_post "/books/#{ available_post.id }/borrow"
        authorized_get "/books", q: "Test book"
        expect(json.count).to be(0)
      end

    end

    describe "with an unavailable book" do
      it "returns 400 status code" do
        authorized_post "/books/#{ unavailable_post.id }/borrow"
        expect(response.status).to be(400)
      end
    end
  end
end
