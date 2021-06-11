require "rails_helper"

describe Utils::StringUtils do
  it "to_zenkaku" do
    expect(Utils::StringUtils.to_zenkaku("川崎市.ﾀｶﾂ区A北見方\"9-9-9/R")).to eq "川崎市．タカツ区Ａ北見方”９－９－９／Ｒ"
  end
end
