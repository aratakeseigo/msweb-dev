module Utils
  class AddressUtils
    REG_CHOUMEI_AND_AFTER = Regexp.new("([^0-9０-９]*)([0-9０-９].*)")

    # 住所に入った最初の数字より前をざっくり取得するメソッドです
    # 大文字０－９と半角0-9を探してその前を取り出します
    # 分割できない場合はそのまま返却します（空文字含む）
    # nilの場合は空文字に変換してそのまま返却します
    #
    # 検証用コマンド
    # EntityProfile.all.first(100).each {|b|a=b.address;c=Utils::AddressUtils.substr_before_choumei(a);puts "#{a} => #{c}";""}
    #
    def self.substr_before_choumei(address)
      return "" if address.blank?
      m = REG_CHOUMEI_AND_AFTER.match(address)
      return address unless m #分割できなければそのまま
      m[1]
    end

    #分割できなければそのまま
    def self.split_prefecture_and_other(address)
      return { prefecture: nil, address: "" } if address.blank?
      Prefecture.all.each do |prefecture|
        return { prefecture: prefecture, address: address.sub(prefecture.name, "") } if address.starts_with? prefecture.name
      end
      return { prefecture: nil, address: address }
    end
  end
end
