require "rails_helper"

RSpec.describe IdentifyCompanyController do
    let(:internal_user) { create :internal_user }

    describe "GET #index " do
        before do
            sign_in internal_user
        end
        context "法人番号が一致した場合" do
            before do
                @sb_client = FactoryBot.create(:identify_company_sb_client1)
                FactoryBot.create(:identify_company_entity1)
                get :index, params: {id:  @sb_client.id, classification: '1'}
            end
            it "リストに法人番号が一致する企業が１件ヒットする" do
                expect(assigns(:entities).size).to eq 1
                expect(assigns(:entities).first.corporation_number).to eq @sb_client.taxagency_corporate_number
            end
        end

        context "企業名が一致した場合" do
            before do
                @sb_client = FactoryBot.create(:identify_company_sb_client2)
                FactoryBot.create(:identify_company_entity2)
                get :index, params: {id: @sb_client.id, classification: '1'}
            end
            it "リストに企業名が一致する企業が１件ヒットする" do
                expect(assigns(:entities).size).to eq 1
                expect(assigns(:entities).first.entity_profile.corporation_name).to eq @sb_client.name
            end
        end

        context "代表者名が一致した場合" do
            before do
                @sb_client = FactoryBot.create(:identify_company_sb_client3)
                FactoryBot.create(:identify_company_entity3)
                get :index, params: {id: @sb_client.id, classification: '1'}
            end
            it "リストに代表者名が一致する企業が１件ヒットする" do
                expect(assigns(:entities).size).to eq 1
                expect(assigns(:entities).first.entity_profile.daihyo_name).to eq @sb_client.daihyo_name
            end
        end

        context "企業特定画面で企業を特定する" do
            before do
                @sb_client = FactoryBot.create(:identify_company_sb_client4)
                @entity = FactoryBot.create(:identify_company_entity4)
                post :update, params: {id: @sb_client.id, classification: '1', entity_id: @entity.id}
                @updated_sb_client = SbClient.find(@sb_client.id)
            end
            it "SBクライアントのエンティティIDに登録される" do
                expect(@updated_sb_client.entity_id).to eq @entity.id
            end
            it "SBクライアントのステータスが2に更新される" do
                expect(@updated_sb_client.status_id).to eq Status::ClientStatus::READY_FOR_EXAM.id
            end
            it "パラーメータパスで指定された画面へリダイレクトされる" do
                expect(response).to redirect_to clients_list_path
            end
        end
    end    
end
