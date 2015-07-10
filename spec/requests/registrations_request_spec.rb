require "rails_helper"

describe "Registrations" do
  before do
    @user_attributes = attributes_for(:user,
                                      confirm_success_url: "/")
  end

  describe "when user signs up with valid credentials" do
    before do
      post( "/api/auth", @user_attributes )
    end

    it "should respond with status 200" do
      expect(response.status).to eq(200)
    end

    it "should respond with authorization headers" do
      count = headers_count(response.headers.keys)
      expect(count).to eq(3)
    end

    it "should respond with id of new user" do
      expect(json.key?("data") && json["data"].key?("id")).to eq(true)
    end
  end

  describe "when user signs up with invalid credentials" do
    before do
      @user_attributes = attributes_for(:user,
                                        password: "",
                                        confirm_success_url: "/")
      post( "/api/auth", @user_attributes )
    end

    it "should respond with status 403" do
      expect(response.status).to eq(403)
    end

    it "should respond with errors" do
      expect(json.keys).to include("errors")
    end
  end
end

def headers_count(headers)
  headers_count = 0
  headers.each do |key|
    if ["access-token", "client", "uid"].include?(key.downcase)
      headers_count += 1
    end
  end
  headers_count
end
