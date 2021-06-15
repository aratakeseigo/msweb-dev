require "rails_helper"

describe Utils::CompanyNameUtils do
  it "to_zenkaku" do
    expect(Utils::CompanyNameUtils.to_zenkaku_name("株式会社M's corporation")).to eq "株式会社Ｍ’ｓ　ｃｏｒｐｏｒａｔｉｏｎ"
  end
  it "to_compare_name" do
    expect(Utils::CompanyNameUtils.to_compare_name("株式会社M's corporation")).to eq "株式会社Ｍｓｃｏｒｐｏｒａｔｉｏｎ"
  end
  it "to_short_name" do
    expect(Utils::CompanyNameUtils.to_short_name("株式会社M's corporation")).to eq "Ｍｓｃｏｒｐｏｒａｔｉｏｎ"
  end
end
