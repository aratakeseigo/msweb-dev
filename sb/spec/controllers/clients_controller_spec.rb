require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  describe 'GET #list' do
    let(:entity) { create :entity }
    let(:client) { create :sb_client }
    before { get :list }
    it "render assings client to @client" do
      #client = create(:sb_client_alarmbox)
      # get :list
      expect(assigns(nil)).to eq client
    end
  end
end