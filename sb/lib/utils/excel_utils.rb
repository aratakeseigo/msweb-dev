require "rubyXL/convenience_methods"
require "date"

module Utils
  class ExcelUtils
    def self.excel_to_h(excel_file_path,
                        worksheet_index: 0,
                        header_row_index: 0,
                        list_start_row_index: 1,
                        list_end_row_index: 30,
                        start_col_index: 0,
                        end_col_index: 30,
                        header_mapping: {})
      res = []
      unless File.extname(excel_file_path) == ".xlsx"
        raise ArgumentError.new("Excelファイル(.xlsx)を指定してください")
      end
      begin
        RubyXL::Parser.parse(excel_file_path).tap do |workbook|
          worksheet = workbook.worksheets[worksheet_index]
          return {} if (worksheet).nil? || (worksheet[header_row_index]).nil?
          header = (worksheet[header_row_index])[start_col_index..end_col_index]&.map(&:value) || []
          keys = header.map { |h| header_mapping[h] }
          return {} if keys.compact.empty?
          worksheet.drop(list_start_row_index).each.with_index do |row, row_num|
            break if row_num + list_start_row_index > list_end_row_index
            cells = row&.cells
            next unless cells
            res << cells.drop(start_col_index).map.with_index do |cell, col_num|
              key = keys[col_num]
              next unless key
              { key => cell&.value || "" }
            end
              .compact
              .reduce(&:merge)
          end
        end
        res
      rescue Zip::Error
        raise ArgumentError.new("Excelファイルが読み込みませんでした。ファイルの中身を確認してください")
      end
    end
  end
end
