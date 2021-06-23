module Utils
  class StringUtils
    require "nkf"

    def is_integer?(str)
      nil != (str =~ /^[0-9]+$/)
    end

    # --------------------------------
    # 半角英数カナの全角メソッド
    # （取引先名入力時の変換等に使用）
    # --------------------------------
    def self.to_zenkaku(s)
      return s if s.blank?
      # 英数の全角化
      ret = s.tr("0-9a-zA-Z", "０-９ａ-ｚＡ-Ｚ")
      # 半角英数カナを全角に変換
      ret = NKF.nkf("-Xw", ret)
      # スペースと記号を全角に変換
      ret = ret.tr(" .'/-", "　．’／－")
      ret = ret.tr('"', "”")
      return ret
    end

    # # --------------------------------
    # # 取引先メモ用の文字変換メソッド
    # # --------------------------------
    # def self.conv_for_textarea(s)
    #   # 1.改行コードを統一し、
    #   # 2.バックスラッシュを表示できるように変換し、
    #   # 3.ダブルクォーテーションをエスケープする。
    #   ret = s.gsub(/(\r\n|\r|\n)/, "\\n").gsub(/\\(?![nr])/, "\\\\\\\\").gsub(/\"/, "\\\"")
    #   return ret
    # end

    # # --------------------------------
    # # トリム処理
    # # （stripが全角スペース非対応なので）
    # # --------------------------------
    # def self.trim(s)
    #   return s.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, "")
    # end
  end
end
