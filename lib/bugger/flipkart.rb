module Bugger
  class Flipkart

    ROW_HEADER = 1
    ROW_DATA_START = 5

    def self.get_product_link(row)
      return row["Flipkart Product Link"]
    end

    def self.get_product_ref(row)
      return row["Flipkart Serial Number"]
    end

    def self.assert_key_specs(row, webpage, res)
      # "Key Spec 1"=>"Brand-Wolfpack", 
      # "Key Spec 2"=>"Ideal For-Men's", 
      # "Key Spec 3"=>"Material-Cotton", 
      # "Key Spec 4"=>"Color-Dark Blue", 
      key_specs_webpage_data = webpage.find('ul.key-specifications')
      idx = 1
      while row.has_key?("Key Spec #{idx}")
        key = "Key Spec #{idx}"
        val = get_escaped_text(row["Key Spec #{idx}"])
        x = key_specs_webpage_data.xpath(%{.//li[text()[contains(.,concat(#{val}))]]})
        
        if x.blank?
          res.push_error(key: key, type: BuggerJobResult::ERROR_TYPE_MISSING)
        end
        idx = idx.next
      end
    end

    def self.assert_key_features(row, webpage, res)
      # "Key Features"=>"100% Cotton::Wildlife::Conservation::Outdoors::Birds", 
      expected_key_features = row["Key Features"].split("::")
      fk_key_features = webpage.find('ul.keyFeaturesList')
      missing_keys = []
      expected_key_features.each do |kf|
        val = get_escaped_text(kf)
        x = fk_key_features.xpath(%{.//li[text()[contains(.,concat(#{val}))]]})
        missing_keys.push(kf) if x.blank?
      end
      if missing_keys.present?
        actual_value = expected_key_features - missing_keys 
        res.push_error(key: "Key Features", type: BuggerJobResult::ERROR_TYPE_MISMATCH, expected_value: expected_key_features.join(", "), actual_value: actual_value.join(", "))
      end
    end

    def self.assert_description_text(row, webpage, res)
      expected_description_text = row["Description"]
      fk_description = webpage.find("div.description-text")
      if (expected_description_text != fk_description.text)
        res.push_error(key: "Description", type: BuggerJobResult::ERROR_TYPE_MISMATCH, expected_value: expected_description_text, actual_value: fk_description.text)
      end
    end

    def self.assert_product_specs
      fk_prod_specs = self.find("div.productSpecs")
      all_tds = fk_prod_specs.xpath(%{.//td[@class='specsValue']})
      puts "all_tds ==> #{all_tds}"

      values = all_tds.collect do |td|
        td.text.strip
      end
      puts "values ==> #{values}"
    end

    def self.assert_product_sizes(row, webpage, res)
      fk_size_container = webpage.find("div.multiSelectionWrapper .multiSelectionWidget")[1]
      key = "Size"
      expected_size = row[key]

      size_css_selector = "div.multiSelectionWidget-selectors-wrap div[data-selectorvalue=#{expected_size}]"
      fk_size = fk_size_container.find(size_css_selector)
      if fk_size.blank?
        res.push_error(key: key, type: BuggerJobResult::ERROR_TYPE_MISSING)
      end
    end

    def self.assert_product_images(row, webpage, res)
      expected_images_count = Flipkart.get_image_count(row)
      uploaded_product_image_count = webpage.find(".productImages img").count
      if (expected_images_count != uploaded_product_image_count)
        res.push_error(key: "Product Images", type: BuggerJobResult::ERROR_TYPE_MISMATCH, expected_value: expected_images_count, actual_value: uploaded_product_image_count)
      end
    end

    def self.get_image_count(row)
      mandatory_images_count = 3
      total_images = mandatory_images_count
      total_images += 1 if row["Other Image URL 3"].present?
      total_images += 1 if row["Other Image URL 4"].present?
      return total_images
    end

    def self.assert_fk_row(row, webpage, res)
      assert_key_specs(row, webpage, res)
      assert_product_sizes(row, webpage, res)
      assert_product_images(row, webpage, res)
      assert_key_features(row, webpage, res)
      assert_description_text(row, webpage, res)

      # assert_product_specs(row, webpage, res)
      return res
    end

    # NOTE: This is super complex. Don't break your head over it. But, SHIT WORKS!!
    def self.get_escaped_text(text)
      escaped = "'#{text.split("'").join("', \"'\", '")}', ''"
      return escaped
    end
    
  end
end