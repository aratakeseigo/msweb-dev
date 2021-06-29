class Industry < ActiveHash::Base
  self.data = [
    #################################
    # 追加する場合はIDは変更しないように注意してください
    # 表示順を変更する場合orderを変更してください。その際idと一致している必要はありません
    #################################
    { id: 101, category_id: 1, order: 101, category: "卸売業", name: "繊維・衣服卸売業" },
    { id: 102, category_id: 1, order: 102, category: "卸売業", name: "靴・かばん卸売業" },
    { id: 103, category_id: 1, order: 103, category: "卸売業", name: "飲食料品卸売業" },
    { id: 104, category_id: 1, order: 104, category: "卸売業", name: "建築材料卸売業" },
    { id: 105, category_id: 1, order: 105, category: "卸売業", name: "事務用機械器具卸売業" },
    { id: 106, category_id: 1, order: 106, category: "卸売業", name: "産業機械器具卸売業" },
    { id: 107, category_id: 1, order: 107, category: "卸売業", name: "自動車中古部品卸売業" },
    { id: 201, category_id: 2, order: 201, category: "情報通信業", name: "情報サービス業" },
    { id: 202, category_id: 2, order: 202, category: "情報通信業", name: "インターネット付属サービス業" },
    { id: 203, category_id: 2, order: 203, category: "情報通信業", name: "通信業" },
    { id: 301, category_id: 3, order: 301, category: "製造業", name: "食品製造業" },
    { id: 302, category_id: 3, order: 302, category: "製造業", name: "繊維工業" },
    { id: 303, category_id: 3, order: 303, category: "製造業", name: "木材製品製造業" },
    { id: 304, category_id: 3, order: 304, category: "製造業", name: "家具製造業" },
    { id: 305, category_id: 3, order: 305, category: "製造業", name: "紙加工品製造業" },
    { id: 306, category_id: 3, order: 306, category: "製造業", name: "印刷業" },
    { id: 307, category_id: 3, order: 307, category: "製造業", name: "化学工業" },
    { id: 308, category_id: 3, order: 308, category: "製造業", name: "皮製品製造業" },
    { id: 309, category_id: 3, order: 309, category: "製造業", name: "プラスチック製造業" },
    { id: 310, category_id: 3, order: 310, category: "製造業", name: "ゴム製品製造業" },
    { id: 311, category_id: 3, order: 311, category: "製造業", name: "業務用機械器具製造業" },
    { id: 312, category_id: 3, order: 312, category: "製造業", name: "金属製品製造業" },
    { id: 313, category_id: 3, order: 313, category: "製造業", name: "その他製造業" },
    { id: 401, category_id: 4, order: 401, category: "運輸業", name: "運輸付帯サービス業" },
    { id: 501, category_id: 5, order: 501, category: "サービス業", name: "協同組合" },
    { id: 502, category_id: 5, order: 502, category: "サービス業", name: "廃棄物処理業" },
    { id: 503, category_id: 5, order: 503, category: "サービス業", name: "人材派遣業" },
    { id: 504, category_id: 5, order: 504, category: "サービス業", name: "機械器具修理業" },
    { id: 505, category_id: 5, order: 505, category: "サービス業", name: "広告業" },
    { id: 601, category_id: 6, order: 601, category: "建設業", name: "総合工事業" },
    { id: 602, category_id: 6, order: 602, category: "建設業", name: "職別工事業" },
    { id: 603, category_id: 6, order: 603, category: "建設業", name: "設備工事業" },
    { id: 9901, category_id: 99, order: 9901, category: "その他", name: "その他" },
  ]
end
