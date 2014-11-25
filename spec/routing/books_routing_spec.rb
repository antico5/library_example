require "spec_helper"

describe BooksController do
  describe "routing" do
    it "routes to #create" do
      post("/books").should route_to("books#create")
    end

  end
end
