shared_context "Admin session", user: :admin do
  before do
    User.create admin: true, token: "my_token"
  end
end

shared_context "Customer session", user: :customer do
  before do
    User.create admin: false, token: "my_token"
  end
end

def authorized_action verb, *params
  params << { "HTTP_AUTHORIZATION" => "Token token=\"my_token\"" }
  send verb, *params
end

def authorized_post *params
  authorized_action :post, *params
end

def authorized_get *params
  authorized_action :get, *params
end
