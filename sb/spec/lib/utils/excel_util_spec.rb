require "rails_helper"

RSpec.describe Utils::ExcelUtils do
  describe "excel_to_h" do
    it ".xlsx以外を指定された場合、ArgumentErrorが発生する" do
      file = file_fixture("utils_excel_utils/test.xls")
      expect {
        Utils::ExcelUtils.excel_to_h(file)
      }.to raise_error(ArgumentError, "Excelファイル(.xlsx)を指定してください")
    end

    it "拡張子は.xlsxだが中身がExcelじゃないファイルを指定された場合、ArgumentErrorが発生する" do
      file = file_fixture("utils_excel_utils/img.xlsx")
      expect {
        Utils::ExcelUtils.excel_to_h(file)
      }.to raise_error(ArgumentError, "Excelファイルが読み込みませんでした。ファイルの中身を確認してください")
    end

    it "空のxlsxを指定された場合、空のハッシュが返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file, worksheet_index: 1)
      expect(res).to be_empty
    end
    it "ヘッダのマッピングが一致しない場合、空のハッシュが返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file,
                                         worksheet_index: 0,
                                         header_row_index: 1,
                                         header_mapping: { "名前" => "name" })
      expect(res).to be_empty
    end
    it "ヘッダのマッピングが一致した場合、一致したカラムのハッシュが返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file,
                                         worksheet_index: 0,
                                         header_row_index: 2,
                                         start_col_index: 1,
                                         header_mapping: { "氏名" => "name" },
                                         list_start_row_index: 3)
      expect(res.count).to eq 4
      expect(res.first.keys).to eq ["name"]
      expect(res.map { |u| u["name"] }).to eq %w( 伊藤 具志堅 武田 菊池 )
    end

    it "ヘッダのマッピングが一致した場合、一致したカラムのハッシュが返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file,
                                         worksheet_index: 0,
                                         header_row_index: 2,
                                         start_col_index: 1,
                                         list_start_row_index: 3,
                                         list_end_row_index: 10,
                                         header_mapping: {
                                           "出席番号" => "no",
                                           "氏名" => "name",
                                           "理科" => "science",
                                           "算数" => "math",
                                           "英語" => "english",
                                         })
      expect(res.count).to eq 4
      expect(res.first.keys.sort).to eq ["no", "name", "science", "math", "english"].sort
      expect(res.map { |u| u["name"] }).to eq %w( 伊藤 具志堅 武田 菊池 )
    end

    it "list_end_row_indexが指定された場合、その行までの値が返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file,
                                         worksheet_index: 0,
                                         header_row_index: 2,
                                         start_col_index: 1,
                                         list_start_row_index: 3,
                                         list_end_row_index: 4,
                                         header_mapping: {
                                           "出席番号" => "no",
                                           "氏名" => "name",
                                           "理科" => "science",
                                           "算数" => "math",
                                           "英語" => "english",
                                         })
      expect(res.count).to eq 2
      expect(res.first.keys.sort).to eq ["no", "name", "science", "math", "english"].sort
      expect(res.map { |u| u["name"] }).to eq %w( 伊藤 具志堅 )
    end

    it "end_col_indexが指定された場合、その列までの値が返却される" do
      file = file_fixture("utils_excel_utils/test.xlsx")
      res = Utils::ExcelUtils.excel_to_h(file,
                                         worksheet_index: 0,
                                         header_row_index: 2,
                                         start_col_index: 1,
                                         end_col_index: 2,
                                         list_start_row_index: 3,
                                         header_mapping: {
                                           "出席番号" => "no",
                                           "氏名" => "name",
                                           "理科" => "science",
                                           "算数" => "math",
                                           "英語" => "english",
                                         })
      expect(res.count).to eq 4
      expect(res.first.keys.sort).to eq ["no", "name"].sort
      expect(res.map { |u| u["name"] }).to eq %w( 伊藤 具志堅 武田 菊池 )
    end
  end
end
