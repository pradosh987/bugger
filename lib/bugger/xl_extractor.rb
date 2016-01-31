 require 'roo'
 require 'roo-xls'
#require 'spreadsheet'
module Bugger
  class XlExtractor

    ROW_HEADER = 1
    ROW_DATA_START = 5

    def initialize(name, sheet)
      # puts "name: #{name}, sheet: #{sheet}"
      @workbook = open_excel(name)
      @sheet = @workbook.sheet(sheet)
    end

    def row(idx)
      headers = get_column_headers
      row = @workbook.row(idx)
      row_hash = headers.zip(row).to_h
      return row_hash
    end

    def get_column_headers(sheet: @sheet)
      @workbook.row(ROW_HEADER)
    end

    def each(from=ROW_DATA_START, &block)
      headers = get_column_headers
      @workbook.each_with_index do |r, i|
        next if (i < from - 1)
        h = headers.zip(r).to_h
        yield h
      end
    end

    def set_sheet(sheet)
      @workbook.default_sheet = sheet
      @sheet = sheet
    end

    def get_sheet(sheet)
      @workbook.sheet(sheet)
    end

    def open_excel(name)
      Roo::Spreadsheet.open(name)
    end

    def self.run_test
      xl = self.new('./C_Tops_muqqvoa79pvme6qm_2801-174401_REQEFE7J0LAMV.xls', 't_shirt')
      #headers = xl.get_column_headers
      # xl.set_sheet('kurta')
      xl.each do |r|
        puts r
      end
    end
    
  end
end