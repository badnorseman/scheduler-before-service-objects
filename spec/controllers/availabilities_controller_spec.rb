require "rails_helper"

describe AvailabilitiesController, type: :controller do
  before do
    @coach = create(:coach)
    sign_in @coach
    @availability = create_list(:availability,
                                2,
                                user: @coach).first
  end

  describe "GET #index" do
    it "should query 2 Availabilities" do
      get(
        :index
      )

      expect(json.count).to eq 2
    end
  end

  describe "GET #show" do
    it "should read 1 Availability" do
      get(
        :show,
        id: @availability.id
      )

      expect(json["start_at"]).to eq(@availability.start_at.as_json)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "should create Availability" do
        @availability_attributes = attributes_for(:availability)

        expect do
          post(
            :create,
            availability: @availability_attributes
          )
        end.to change(Availability, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "should not create Availability" do
        @availability_attributes = attributes_for(:availability,
                                                  start_at: nil)
        expect do
          post(
            :create,
            availability: @availability_attributes
          )
        end.to change(Availability, :count).by(0)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "should update Availability" do
        random_start_at = Date.today - rand(30).days

        patch(
          :update,
          id: @availability.id,
          availability: { start_at: random_start_at }
        )

        expect(Availability.find(@availability.id).start_at).to eq(random_start_at)
      end
    end

    context "with invalid attributes" do
      it "should not update Availability" do
        patch(
          :update,
          id: @availability.id,
          availability: { start_at: @availability.end_at }
        )

        expect(Availability.find(@availability.id).start_at).to eq(@availability.start_at)
      end
    end
  end

  describe "DELETE #destroy" do
    it "should delete Availability" do
      expect do
        delete(
          :destroy,
          id: @availability.id
        )
      end.to change(Availability, :count).by(-1)
    end
  end
end
