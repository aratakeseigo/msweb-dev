require "rails_helper"

describe Utils::AddressUtils do
  describe "substr_before_choumei" do
    it "addressが空文字の場合、空文字が返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("")).to eq ""
    end
    it "addressがnilの場合、空文字が返却される" do
      expect(Utils::AddressUtils.substr_before_choumei(nil)).to eq ""
    end
    it "addressに数字が含まれない場合、adressがそのまま返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("横浜市港北区日吉五丁目")).to eq "横浜市港北区日吉五丁目"
    end
    it "addressに全角数字が一つ含まれる場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("横浜市港北区日吉５丁目")).to eq "横浜市港北区日吉"
    end
    it "addressに数字が複数含まれる場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("横浜市港北区日吉５丁目６番地７号")).to eq "横浜市港北区日吉"
    end
    it "addressに半角数字が一つ含まれる場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("大和市福田300")).to eq "大和市福田"
    end
    it "addressに半角数字が複数含まれる場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("大和市福田300-4")).to eq "大和市福田"
    end
    it "addressに数字が全半角混在している場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("大和市福田４－300-4")).to eq "大和市福田"
    end
    it "addressの最後に数字がしている場合、adressの最初の数字の前までが返却される" do
      expect(Utils::AddressUtils.substr_before_choumei("大和市福田４－300-4")).to eq "大和市福田"
    end
  end
  describe "split_prefecture_and_other" do
    it "addressが空文字の場合、prefectureはnil、addressは空文字が返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("")).to eq({ prefecture: nil, address: "" })
    end
    it "addressがnilの場合、prefectureはnil、addressは空文字が返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other(nil)).to eq({ prefecture: nil, address: "" })
    end
    it "addressに都道府県名が含まれない場合、prefectureはnil、addressは引数がそのまま返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("横浜市港北区日吉５丁目")).to eq({ prefecture: nil, address: "横浜市港北区日吉５丁目" })
    end
    it "addressに都道府県名が含まれる場合、prefectureはPrefectureの定数、adressは都道府県以外の部分が返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("神奈川県横浜市港北区日吉５丁目")).to eq({ prefecture: Prefecture.find_by_name("神奈川県"), address: "横浜市港北区日吉５丁目" })
    end
    it "addressの中間に都道府県名が含まれる場合、prefectureはPrefectureの定数、adressは都道府県以外の部分が返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("東神奈川県横浜市港北区日吉５丁目")).to eq({ prefecture: nil, address: "東神奈川県横浜市港北区日吉５丁目" })
    end
    it "addressが都道府県名だけの場合、prefectureはPrefectureの定数、adressは空文字が返却される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("沖縄県")).to eq({ prefecture: Prefecture.find_by_name("沖縄県"), address: "" })
    end
    it "addressが都道府県名が複数含まれる場合、最初の都道府県だけが採用される" do
      expect(Utils::AddressUtils.split_prefecture_and_other("沖縄県神奈川県東京都府６－７－８")).to eq({ prefecture: Prefecture.find_by_name("沖縄県"), address: "神奈川県東京都府６－７－８" })
    end
  end
end
