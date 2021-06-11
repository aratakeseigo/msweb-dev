module Utils
  class CompanyNameUtils

    # 法人略称用の正規表現
    CORP_NAME_REGEX = /[\p{Han}\p{Hiragana}\p{Katakana}\p{Latin}０-９－ー]+/.freeze
    REMOVE_CHARS_FOR_COMPARE = " 　＆’，？・．／”".freeze
    HOUJIN_KAKUS = %w( 株式会社 有限会社 合同会社
                       合資会社 消防団員等公務災害補償等共済基金 原子力損害賠償・廃炉等支援機構
                       農水産業協同組合貯金保険機構 日本私立学校振興・共済事業団 地方公共団体情報システム機構
                       全国市町村職員共済組合連合会 日本土地家屋調査士会連合会 全国社会保険労務士会連合会
                       地方公務員共済組合連合会 水産加工業協同組合連合会 社会保険診療報酬支払基金
                       国家公務員共済組合連合会 広域臨海環境整備センター 共済水産業協同組合連合会
                       認可金融商品取引業協会 土地改良事業団体連合会 地方公務員災害補償基金
                       全国中小企業団体中央会 生活衛生同業組合連合会 消費生活協同組合連合会
                       自動車安全運転センター 国民健康保険団体連合会 原子力発電環境整備機構
                       銀行等保有株式取得機構 防災街区整備事業組合 防災街区計画整備組合
                       日本司法書士会連合会 日本司法支援センター 日本行政書士会連合会
                       中央労働災害防止協会 中央職業能力開発協会 地方公共団体金融機構
                       たばこ耕作組合連合会 たばこ耕作組合中央会 大学共同利用機関法人
                       損害保険料率算出団体 船主責任相互保険組合 商店街振興組合連合会
                       使用済燃料再処理機構 外国法事務弁護士法人 沖縄振興開発金融公庫
                       マンション建替組合 保険契約者保護機構 農業協同組合連合会
                       農業共済組合連合会 日本水先人会連合会 日本電気計器検定所
                       日本税理士会連合会 日本公認会計士協会 日本勤労者住宅協会
                       土地家屋調査士法人 特定非営利活動法人 中小企業団体中央会
                       地方公務員共済組合 地方議会議員共済会 生活衛生同業小組合
                       水産加工業協同組合 社会保険労務士法人 国家公務員共済組合
                       国民年金基金連合会 小型船相互保険組合 広域的運営推進機関
                       健康保険組合連合会 勤労者財産形成基金 金融商品会員制法人
                       漁業協同組合連合会 漁業共済組合連合会 危険物保安技術協会
                       外国人技能実習機構 労働災害防止協会 農業信用基金協会
                       日本弁護士連合会 日本消防検定協会 日本下水道事業団
                       土地区画整理組合 土地家屋調査士会 地方独立行政法人
                       地方住宅供給公社 地方競馬全国協会 団地管理組合法人
                       全国健康保険協会 船員災害防止協会 石炭鉱業年金基金
                       生活衛生同業組合 水害予防組合連合 職業能力開発協会
                       商品先物取引協会 消費生活協同組合 住宅街区整備組合
                       社会保険労務士会 市街地再開発組合 国立研究開発法人
                       国民健康保険組合 小型船舶検査機構 高圧ガス保安協会
                       軽自動車検査協会 漁業信用基金協会 火災共済協同組合
                       労働金庫連合会 輸出水産業組合 日本中央競馬会 日本商工会議所 土地改良区連合 投資者保護基金
                       たばこ耕作組合 森林組合連合会 信用金庫連合会 商店街振興組合 商工組合連合会 酒販組合連合会
                       酒販組合中央会 酒造組合連合会 酒造組合中央会 事業協同小組合 漁船保険中央会 協同組合連合会
                       企業年金連合会 会員商品取引所 委託者保護基金 預金保険機構 負債整理組合 農林中央金庫
                       農事組合法人 農業協同組合 農業共済組合 認可地縁団体 日本放送協会 日本弁理士会
                       日本年金機構 日本赤十字社 特許業務法人 土地開発公社 独立行政法人 特定目的会社
                       地方道路公社 生産森林組合 水害予防組合 信用保証協会 信用協同組合 職業訓練法人
                       商工会連合会 社会医療法人 社会福祉法人 司法書士法人 自主規制法人 事業協同組合
                       国立大学法人 国民年金基金 公立大学法人 更生保護法人 公益社団法人
                       公益財団法人 健康保険組合 漁船保険組合 漁業生産組合 漁業協同組合
                       漁業共済組合 行政書士法人 技術研究組合 企業年金基金 管理組合法人 一般社団法人
                       一般財団法人 一部事務組合 弁護士法人 土地改良区 税理士法人 商工会議所
                       準学校法人 司法書士会 行政書士会 合併特例区 協同組合 労働組合 労働金庫
                       輸入組合 輸出組合 水先人会 弁護士会 農住組合 日本銀行 投資法人 相続財産
                       相互会社 税理士会 森林組合 信用金庫 信託財産 職員団体 商工組合 酒販組合 酒造組合
                       宗教法人 合名会社 広域連合 協業組合 企業組合 監査法人 学校法人 海運組合 医療法人
                       特別区 商工会 財産区 港務局 政党 ).freeze

    # DBの実際のデータで変換結果を確認するメソッド
    # def self.check_short(num = 100)
    #   EntityProfile.all.last(num).map do |e|
    #     n = e.corporation_name
    #     sn = e.corporation_name_short
    #     new_sn = to_short_name(n)
    #     next "sn:#{n} o:#{sn} n:#{new_sn}" if sn != new_sn
    #     nil
    #   end.compact
    # end

    # def self.check_comp(num = 100)
    #   EntityProfile.all.last(num).map do |e|
    #     n = e.corporation_name
    #     cn = e.corporation_name_compare
    #     new_cn = to_compare_name(n)
    #     next "cn:#{n} o:#{cn} n:#{new_cn}" if cn != new_cn
    #     nil
    #   end.compact
    # end

    #
    # 会社名設定用
    #   全角変換のみ
    #
    def self.to_zenkaku_name(corporation_name)
      StringUtils.to_zenkaku(corporation_name)
    end

    #
    # 比較用会社名
    #   全角変換、特殊記号除去、全角マイナス
    #
    def self.to_compare_name(corporation_name)
      ret = to_zenkaku_name(corporation_name)
      REMOVE_CHARS_FOR_COMPARE.chars.each do |c|
        ret.gsub!(c, "") # 全角マイナスをハイフンに置換
      end
      ret.gsub!("－", "ー") # 全角マイナスをハイフンに置換
      ret
    end

    #
    # 短縮会社名
    #   全角変換、法人格除去、全文検索でNGな記号除去
    #
    def self.to_short_name(corporation_name)
      zenkaku = to_zenkaku_name(corporation_name)
      no_houjin_kaku = remove_houjin_kaku(zenkaku)
      remove_marks_for_search(no_houjin_kaku)
    end

    private

    #
    # 法人格除去
    #
    def self.remove_houjin_kaku(comp_name)
      return comp_name if comp_name.blank?
      ret_name = comp_name

      HOUJIN_KAKUS.each do |hujin_kaku|
        if ret_name.include?(hujin_kaku)
          ret_name = ret_name.sub(hujin_kaku, "")
        end
      end

      return ret_name
    end

    #
    # 全文検索で記号とみなされる文字を除去した文字列を返す
    #
    def self.remove_marks_for_search(prm_keyword)
      ret_str = ""

      if prm_keyword.present?
        # 許可文字のみを抽出
        tmp_ary = prm_keyword.scan(CORP_NAME_REGEX)
        # 許可文字があれば、文字をつなげて返す
        if tmp_ary.present?
          ret_str = tmp_ary.join
        end
      end

      return ret_str
    end
  end
end
