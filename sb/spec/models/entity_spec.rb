require "rails_helper"

RSpec.describe Entity, type: :model do
  context "社内企業コード生成" do
    context "新規のEntityに社内企業コードを設定した場合" do
      let!(:entity) { Entity.new }
      subject { -> { entity.assign_house_company_code } }
      it "社内企業コードが生成される" do
        expect(entity.assign_house_company_code).to match(/KG[0-9]{9}/)
      end
      it "シーケンステーブルがインクリメントされる" do
        is_expected.to change { SeqHouseCompanyCode.count }.by(1)
      end
    end
    context "既存のEntityに社内企業コードを設定した場合" do
      let!(:entity) { create :entity }
      let!(:house_company_code) { entity.house_company_code }
      subject { -> { entity.assign_house_company_code } }
      it "新規には生成されない" do
        expect(entity.assign_house_company_code).to eq entity.house_company_code
      end
      it "シーケンステーブルがインクリメントされない" do
        is_expected.to change { SeqHouseCompanyCode.count }.by(0)
      end
    end
  end
  context "法人番号と住所の町名までで検索で" do
    let(:entity) { create :entity }

    context "法人番号と住所の町名までがどちらも一致する場合" do
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).count
        ).to eq 1
        expect(
          Entity.select_by_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).first.house_company_code
        ).to eq entity.house_company_code
      end
    end
    context "法人番号が一致しない場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_no_and_address(
            taxagency_corporate_number: entity_other.corporation_number,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "法人番号がnilの場合" do
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_no_and_address(
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "住所の町名までが一致しない場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_no_and_address(
            taxagency_corporate_number: entity_other.corporation_number,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei("川崎市高津区９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "住所がnilの場合" do
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            prefecture: entity.entity_profile.prefecture,
            address: nil,
          ).count
        ).to eq 0
      end
    end
  end

  context "会社名と代表者で検索で" do
    let(:entity) { create :entity }

    context "会社名と代表者がどちらも一致する場合" do
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          ).first.house_company_code
        ).to eq entity.house_company_code
      end
    end
    context "会社名の法人格が一致しないが、代表者は一致する場合" do
      it "レコードが取得できる" do
        short_name = Utils::CompanyNameUtils.to_short_name entity.entity_profile.corporation_name
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: short_name + "有限会社",
            daihyo_name: entity.entity_profile.daihyo_name,
          ).count
        ).to eq 1
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: short_name + "有限会社",
            daihyo_name: entity.entity_profile.daihyo_name,
          ).first.house_company_code
        ).to eq entity.house_company_code
      end
    end
    context "会社名が一致しない場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          ).count
        ).to eq 0
      end
    end
    context "会社名がnilの場合一致しない場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            daihyo_name: entity.entity_profile.daihyo_name,
          ).count
        ).to eq 0
      end
    end
    context "代表者が一致しない場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
          ).count
        ).to eq 0
      end
    end
    context "代表者がnilの場合" do
      let(:entity_other) { build :entity } #保存しない
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name(
            company_name: entity.entity_profile.corporation_name,
          ).count
        ).to eq 0
      end
    end
  end
  context "法人番号と会社名と代表者でOR検索で" do
    let(:entity) { create :entity }

    context "全部一致する場合" do
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_or_daihyo_name_or_company_no(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          ).count
        ).to eq 1
        expect(
          Entity.select_by_company_name_or_daihyo_name_or_company_no(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          ).first.house_company_code
        ).to eq entity.house_company_code
      end
    end
    context "法人番号だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_or_daihyo_name_or_company_no(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
          ).count
        ).to eq 1
      end
    end
    context "会社名だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_or_daihyo_name_or_company_no(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
          ).count
        ).to eq 1
      end
    end
    context "代表名だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_or_daihyo_name_or_company_no(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          ).count
        ).to eq 1
      end
    end
  end

  context "全パラメータで検索で" do
    let(:entity) { create :entity }

    context "全部一致する場合" do
      it "レコードが取得できる" do
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).count
        ).to eq 1
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
          ).first.house_company_code
        ).to eq entity.house_company_code
      end
    end
    context "法人番号だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei("大和市福田９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "会社名だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei("大和市福田９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "代表名だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei("大和市福田９９－９９－９９"),
          ).count
        ).to eq 0
      end
    end
    context "住所だけ一致する場合" do
      let(:entity_other) { build :entity }
      it "レコードが取得できない" do
        expect(
          Entity.select_by_company_name_and_daihyo_name_company_no_and_address(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
            prefecture: entity.entity_profile.prefecture,
            address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address),
          ).count
        ).to eq 0
      end
    end
  end

  context "企業特定" do
    let(:entity) { create :entity }
    let(:entity_copy) {
      # entityの情報をコピー
      en = create :entity, corporation_number: entity.corporation_number
      prof = en.entity_profile
      prof.corporation_name = entity.entity_profile.corporation_name
      prof.prefecture = entity.entity_profile.prefecture
      prof.address = entity.entity_profile.address
      prof.daihyo_name = entity.entity_profile.daihyo_name
      en.save!
      en
    }

    context "全部パラメータ検索で１件一致した場合" do
      context "１件一致した場合" do
        it "企業特定OK" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: entity.corporation_number,
              company_name: entity.entity_profile.corporation_name,
              daihyo_name: entity.entity_profile.daihyo_name,
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
            ).house_company_code
          ).to eq entity.house_company_code
        end
      end

      context "2件以上あった場合" do
        before { entity_copy }
        it "企業特定NG" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: entity.corporation_number,
              company_name: entity.entity_profile.corporation_name,
              daihyo_name: entity.entity_profile.daihyo_name,
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
            )
          ).to be_nil
        end
      end
    end
    context "法人番号と住所の町名まで検索で" do
      context "１件一致した場合" do
        it "企業特定OK" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: entity.corporation_number,
              company_name: "フロンターレ協会",
              daihyo_name: "三苫　薫",
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
            ).house_company_code
          ).to eq entity.house_company_code
        end
      end

      context "2件以上あった場合" do
        before { entity_copy }
        it "企業特定NG" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: entity.corporation_number,
              company_name: "フロンターレ協会",
              daihyo_name: "三苫　薫",
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei(entity.entity_profile.address + "９９－９９－９９"),
            )
          ).to be_nil
        end
      end
    end
    context "会社名と代表者で検索で" do
      context "１件一致した場合" do
        it "企業特定OK" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: "9999999999888",
              company_name: entity.entity_profile.corporation_name,
              daihyo_name: entity.entity_profile.daihyo_name,
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei("横浜市港北区日吉９９－９９－９９"),
            ).house_company_code
          ).to eq entity.house_company_code
        end
      end

      context "2件以上あった場合" do
        before { entity_copy }
        it "企業特定NG" do
          expect(
            Entity.assign_entity(
              taxagency_corporate_number: "9999999999888",
              company_name: entity.entity_profile.corporation_name,
              daihyo_name: entity.entity_profile.daihyo_name,
              prefecture: entity.entity_profile.prefecture,
              address: Utils::AddressUtils.substr_before_choumei("横浜市港北区日吉９９－９９－９９"),
            )
          ).to be_nil
        end
      end
    end
  end

  context "法人番号と会社名と代表者でどれか一致するEntityがあるか検索で" do
    let(:entity) { create :entity }

    context "一致するレコードがある場合" do
      it "trueが返る" do
        expect(
          Entity.recommend_entity_exists?(
            taxagency_corporate_number: entity.corporation_number,
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
          )
        ).to eq true
      end
    end
    context "一致するレコードがない場合" do
      let(:entity_other) { build :entity }
      it "trueが返る" do
        expect(
          Entity.recommend_entity_exists?(
            taxagency_corporate_number: entity_other.corporation_number,
            company_name: entity_other.entity_profile.corporation_name,
            daihyo_name: entity_other.entity_profile.daihyo_name,
          )
        ).to eq false
      end
    end
  end
end
