require "rails_helper"

describe "Sessions" do
  before do
    @user_attributes = attributes_for(:user)
    @user = User.create(@user_attributes)
  end

  describe "when user logs in with valid credentials" do
    before do
      post(
        "/api/auth/sign_in",
        {
          email: @user_attributes[:email],
          password: @user_attributes[:password]
        }
      )
    end

    it "should respond with status 200" do
      expect(response.status).to eq(200)
    end

    it "should respond with Authorization headers" do
      count = headers_count(response.headers.keys)
      expect(count).to eq(3)
    end
  end

  describe "when user logs in with invalid credentials" do
    before do
      post(
        "/api/auth/sign_in",
        {
          email: @user_attributes[:email],
          password: "#{@user_attributes[:password]}#{rand(1000)}"
        }
      )
    end

    it "should respond with status 401" do
      expect(response.status).to eq(401)
    end

    it "should not respond with Authorization headers" do
      count = headers_count(response.headers.keys)
      expect(count).to eq(0)
    end
  end

  describe "when user logs out" do
    before do
      @tokens = @user.create_new_auth_token("test")

      delete(
        "/api/auth/sign_out",
        {},
        @tokens
      )
    end

    it "should respond with status 200" do
      expect(response.status).to eq(200)
    end

    describe "when Authorization tokens are expired" do
      before do
        get(
          "/api/users/#{@user.id}",
          {},
          @tokens
        )
      end

      it "should respond with status 401" do
        expect(response.status).to eq(401)
      end
    end

    it "should not respond with Authorization headers" do
      count = headers_count(response.headers.keys)
      expect(count).to eq(0)
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
