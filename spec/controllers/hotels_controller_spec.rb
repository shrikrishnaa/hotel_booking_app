require 'rails_helper'

RSpec.describe 'Hotels', type: :request do
  let!(:user) { create(:user) }
  let!(:hotels) { FactoryBot.create_list(:hotel, 10) }
  let(:hotel_id) { hotels.first.id }

  let!(:headers) {
    user.create_new_auth_token.merge({'Content-Type' => 'application/json'})
  }

  describe "GET /hotels" do
    before { get '/hotels', headers: headers }

    it 'returns hotels' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /hotels/:id" do
    before { get "/hotels/#{hotel_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the hotel' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(hotel_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:hotel_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Hotel/)
      end
    end
  end
end

RSpec.describe HotelsController, type: :controller do
  let!(:hotel) { create(:hotel) }
  let!(:hotel_in_california) { create(:hotel, location: "California") }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "without location filter" do
      it "returns all hotels" do
        get :index
        expect(assigns(:hotels)).to match_array([hotel, hotel_in_california])
      end
    end

    context "with location filter" do
      it "returns hotels filtered by location" do
        get :index, params: { location: "California" }
        assigns(:hotels).each do |hotel|
          expect(hotel.location).to eq("California")
        end
        # expect(assigns(:hotels)).to match_array([hotel_in_california])
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested hotel to @hotel" do
      get :show, params: { id: hotel.id }
      expect(assigns(:hotel)).to eq(hotel)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "should have a signed-in user" do
        expect(controller.current_user).not_to be_nil
      end
      it "creates a new hotel" do
        expect {
          post :create, params: { hotel: FactoryBot.attributes_for(:hotel) }
        }.to change(Hotel, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not save the new hotel" do
        expect {
          post :create, params: { hotel: {name: nil} }
        }.to_not change(Hotel, :count)
      end
    end
  end

  describe "PATCH/PUT #update" do
    it "updates the hotel" do
      patch :update, params: { id: hotel.id, hotel: { name: "Updated Name" } }
      hotel.reload
      expect(hotel.name).to eq("Updated Name")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the hotel" do
      expect {
        delete :destroy, params: { id: hotel.id }
      }.to change(Hotel, :count).by(-1)
    end
  end

end
