require 'rails_helper'

RSpec.describe "Coupons", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/coupons/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/coupons/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/coupons/create"
      expect(response).to have_http_status(:success)
    end
  end

end
