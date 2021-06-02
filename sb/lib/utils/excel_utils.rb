require "rubyXL/convenience_methods"
require "date"

module Utils
  class ExcelUtils
    def read(excel_file_path) # return worksheet[]
      RubyXL::Parser.parse(excel_file_path).worksheets
    end

    def self.excel_to_h(excel_file_path,
                        worksheet_index: 0,
                        header_row_index: 0,
                        list_start_row_index: 1,
                        start_col_index: 0,
                        end_col_index: 30,
                        header_mapping: {})
      res = nil
      RubyXL::Parser.parse(excel_file_path).tap do |workbook|
        worksheet = workbook.worksheets[worksheet_index]
        header = (worksheet[header_row_index])[start_col_index..end_col_index].map(&:value)
        res = worksheet.drop(list_start_row_index).map.with_index do |row, row_num|
          row&.cells&.drop(start_col_index).map.with_index() do |cell, col_num|
            key = header_mapping[header[col_num]]
            unless key
              nil
              next
            end
            { key => cell&.value || "" }
          end
            .compact
            .reduce(&:merge)
        end
      end
      res
    end
  end
end
