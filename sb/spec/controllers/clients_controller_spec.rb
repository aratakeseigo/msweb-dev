require "rails_helper"

RSpec.describe ClientsController, type: :controller do
  xdescribe "GET #list" do
    let(:entity) { create :entity }
    let(:client) { create :sb_client }
    before do
      user = create(:internal_user)
      sign_in user
    end
    before { get :list }
    it "render assings client to @client" do
      expect(assigns(nil)).to eq client
    end
  end
end
