require "rails_helper"

describe "Availabilities" do
  before do
    @coach = create(:coach)
    @tokens = @coach.create_new_auth_token("test")
    @availability = create_list(:availability,
                                2,
                                user: @coach).first
  end

  describe "Unauthorized request" do
    before do
      get "/api/availabilities.json"
    end

    it "should respond with status 401" do
      expect(response.status).to eq 401
    end
  end

  describe "GET #index" do
    before do
      get(
        "/api/availabilities.json",
        {},
        @tokens
      )
    end

    it "should respond with array of 2 Availabilities" do
      expect(json.count).to eq(2)
    end

    it "should respond with status 200" do
      expect(response.status).to eq 200
    end
  end

  describe "GET #show" do
    before do
      get(
        "/api/availabilities/#{@availability.id}.json",
        {},
        @tokens
      )
    end

    it "should respond with 1 Availability" do
      expect(json["start_at"]).to eq(@availability.start_at.as_json)
    end

    it "should respond with status 200" do
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        @availability_params = attributes_for(:availability)

        post(
          "/api/availabilities.json",
          {
            availability: @availability_params
          },
          @tokens
        )
      end

      it "should respond with created Availability" do
        expect(json["start_at"].as_json).to eq @availability_params[:start_at].as_json
      end

      it "should respond with new id" do
        expect(json.keys).to include("id")
      end

      it "should respond with status 201" do
        expect(response.status).to eq 201
      end
    end

    context "with invalid attributes" do
      before do
        @availability_params = attributes_for(:availability, start_at: nil)

        post(
          "/api/availabilities.json",
          {
            availability: @availability_params
          },
          @tokens
        )
      end

      it "should respond with errors" do
        expect(json.keys).to include("errors")
      end

      it "should respond with status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      before do
        @random_start_at = Date.today - rand(30).days

        patch(
          "/api/availabilities/#{@availability.id}.json",
          {
            availability: { start_at: @random_start_at }
          },
          @tokens
        )
      end

      it "should respond with updated Availability" do
        expect(Availability.find(@availability.id).start_at.as_json).to eq(@random_start_at.as_json)
      end

      it "should respond with status 200" do
        expect(response.status).to eq 200
      end
    end

    context "with invalid attributes" do
      before do
        patch(
          "/api/availabilities/#{@availability.id}.json",
          {
            availability: { end_at: @availability.start_at }
          },
          @tokens
        )
      end

      it "should respond with errors" do
        expect(json.keys).to include("errors")
      end

      it "should respond with status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      delete(
        "/api/availabilities/#{@availability.id}.json",
        {},
        @tokens
      )
    end

    it "should respond with status 204" do
      expect(response.status).to eq 204
    end
  end
end
