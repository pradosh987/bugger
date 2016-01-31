module Bugger
  class Snapdeal

    ROW_HEADER = 3
    ROW_DATA_START = 4

    @@mapping = {
      "Color(Snapdeal)" => "assert_color",
      "Size(Snapdeal)" => "assert_size",
      "Fabric(Flipkart)" => "assert_fabric"
    }

    def self.get_color_parent_element(webpage)
      webpage.find("#similarBlk li").select{|e| e.children[1].text.strip == "Color:"}.first
    end

    def self.add_html_error_style(element)
      element['style'] = "border: 5px solid red"
      return element
    end

    def self.assert_color(row, webpage, res, excel_key)
      # #similarBlk > div > ul > li:nth-child(4) > span.greyText
      expected_color = row[excel_key]
      parent = self.get_color_parent_element(webpage)
      if parent.blank?
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISSING)
        return
      end
      actual_value = parent.children[3].text
      is_equal = (actual_value == expected_color)
      if !is_equal
        self.add_html_error_style(parent)
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISMATCH, expected_value: expected_color, actual_value: actual_value)
        return
      end
    end

    def self.assert_fabric(row, webpage, res, excel_key)
      expected_value = row[excel_key]
      parent = webpage.find("#similarBlk li").select{|e| e.children[1].text.strip == "Fabric:"}.first
      if parent.blank?
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISSING)
        return
      end
      actual_value = parent.children[3].text
      is_equal = (actual_value == expected_value)
      if !is_equal
        self.add_html_error_style(parent)
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISMATCH, expected_value: expected_value, actual_value: actual_value)
        return
      end
    end

    def self.assert_size(row, webpage, res, excel_key)
      expected_value = row[excel_key]
      # #attribute-select-0 > ul > li
      parent = webpage.find("#attribute-select-0 > ul").first
      if parent.blank?
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISSING)
        return
      end
      is_present = parent.children.collect{|e| e.text.strip}.include?(expected_value.to_s)
      if !is_present
        self.add_html_error_style(parent)
        res.push_error(key: excel_key, type: BuggerJobResult::ERROR_TYPE_MISSING, :expected_value => expected_value.to_s)
        return
      end
    end

    def self.get_product_link(row)
      return row["Live Link"]
    end

    def self.get_product_ref(row)
      return row["Variation SKU"]
    end

    def self.assert_row(row, webpage, res)

      @@mapping.each do |key, val|
        self.send("#{val}", row, webpage, res, key)
      end

      return res
    end

    def self.run_test
      @filepath = './Mens Trackpant - Master Catalog(200) (1).xlsx'
      @sheet_name = "Men's Trackpant"
      @bugger_job_id = 123

      # Queue a delayed job

      # This will most probably be inside custom delayed job
      xl_file = Bugger::XlExtractor.new(@filepath, @sheet_name, ROW_HEADER, ROW_DATA_START)

      res_array = []
      xl_file.each do |row|
        #puts row
        link = Bugger::Snapdeal.get_product_link(row)
        break if link.blank?
        wp = Bugger::Webpage.new(link)
        bugger_res = BuggerJobResult.new({:bugger_job_id => @bugger_job_id, :product_ref => Bugger::Snapdeal.get_product_ref(row)}, {:without_protection => true})
        res = Bugger::Snapdeal.assert_row(row, wp, bugger_res)
        res_array.push(res)

        #puts res.data_errors.inspect
        res.data_errors.each do |err|
          puts "Product_ref: #{res.product_ref}, Key: #{err.key}, type: #{err.type}, expected_value: #{err.expected_value}, actual_value: #{err.actual_value}"
        end
        puts "Product_ref: #{res.product_ref} matched" if res.data_errors.blank?
        #break
      end
      puts res_array.inspect
      #binding.pry
    end

  end
end