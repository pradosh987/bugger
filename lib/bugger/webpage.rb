require "open-uri"

module Bugger
  class Webpage
    attr_accessor :url

    @@flipkart_row1 =  {
      "Key Spec 1"=>"Brand-Wolfpack", 
      "Key Spec 2"=>"Ideal For-Men's", 
      "Key Spec 3"=>"Material-Cotton", 
      "Key Spec 4"=>"Color-Dark Blue", 
      "Key Spec 5"=>'Ideal For-Men"s', 
      "Flipkart Serial Number"=>"TSHEFE995UVAUZJK", 
      "QC Status"=>"Passed", 
      "QC Failed Reason (if any)"=>"", 
      "Flipkart Product Link"=>"http://www.flipkart.com/search.php?query=TSHEFE995UVAUZJK", 
      "Product Data Status"=>"Approved", 
      "Disapproval Reason (if any)"=>nil, 
      "Description"=>"In everything we do, we find reason, we find a story. This tee is probably closest to home when it comes to what we stand for. To run with the wolves means to live wild and free, yet be together, to be vivid and alive and in touch with your wild side. Don’t be sheep and follow the herd. Our t shirts on running on emphasises the importance of fitness and inspires you to get out there. Run with the wolves.", 
      "Key Features"=>"100% Cotton::Wildlife::Conservation::Outdoors::Birds", 
      
      "Seller SKU ID"=>"WP_RunningWiththeWolves_Blue_S", 
      "Brand"=>"Wolfpack", 
      "Style Code"=>"WP_RunningWiththeWolves_Blue", 
      "Size"=>"S", 
      "Size - Measuring Unit"=>"Regular", 
      "Neck Type"=>"Round Neck", 
      "Pattern"=>"Printed", 
      "Color"=>"Dark Blue", 
      "Plus Size"=>"No", 
      "Fabric"=>"Cotton", 
      "Brand Color"=>"Dark Blue", 
      "Ideal For"=>"Men's", 
      "Sleeve"=>"Half Sleeve", 
      "Occasion"=>"Casual", 
      "Pack of"=>"1", 
      "Brand Fit"=>"Regular", 
      "Fit"=>"Regular", 
      "Suitable For"=>"Western Wear", 
      "Main Image URL"=>"http://btesimages.s3.amazonaws.com/Wolfpack/wp_runningwiththewolves_blue_1.jpg", 
      "Other Image URL 1"=>"http://btesimages.s3.amazonaws.com/Wolfpack/wp_runningwiththewolves_blue_4.jpg", 
      "Other Image URL 2"=>"http://btesimages.s3.amazonaws.com/Wolfpack/wp_runningwiththewolves_blue_2.jpg", 
      "Other Image URL 3"=>"http://btesimages.s3.amazonaws.com/Wolfpack/wp_runningwiththewolves_blue_3.jpg", 
      "Other Image URL 4"=>nil, 
      "Main Palette Image URL"=>nil, 
      "Trend SS 16'"=>nil, 
      "Size For Inwarding"=>nil, 
      "Reversible"=>nil, 
      "Group ID"=>"WP_RunningWiththeWolves", 
      "Sleeve Fit"=>nil, 
      "EAN/UPC"=>nil, 
      "Category"=>nil, 
      "Sub Category"=>nil, 
      "Sub Category Value"=>nil, 
      "Fabric Care"=>nil, 
      "Character"=>nil, 
      "Pockets"=>nil, 
      "Other Details"=>nil, 
      "Sales Package"=>"1 T-Shirt", 
      "Search Keywords"=>"Wolves", 
      "Video URL"=>nil, 
      "Domestic Warranty"=>nil, 
      "Domestic Warranty - Measuring Unit"=>nil, 
      "International Warranty"=>nil, 
      "International Warranty - Measuring Unit"=>nil, 
      "Warranty Summary"=>nil, 
      "Warranty Service Type"=>nil, 
      "Covered in Warranty"=>nil, 
      "Not Covered in Warranty"=>nil, 
      "Primary Path"=>"Apparels>Men>Polos & T-Shirts", 
      "Category Path"=>nil, 
      "Supplier Image"=>nil
    }

    def initialize(url)
      @data = Nokogiri::HTML(open(url))
    end

    # doc.find(".productSpecs")
    def find(klass)
      return false if @data.blank?
      @data.css(klass)
    end

    def data
      @data
    end

    def assert_fk_data
      assert_key_specs(@data)
    end

    def assert_key_specs
      # "Key Spec 1"=>"Brand-Wolfpack", 
      # "Key Spec 2"=>"Ideal For-Men's", 
      # "Key Spec 3"=>"Material-Cotton", 
      # "Key Spec 4"=>"Color-Dark Blue", 
      key_specs_data = self.find('ul.key-specifications')
      idx = 1
      while @@flipkart_row1.has_key?("Key Spec #{idx}")
        val = @@flipkart_row1["Key Spec #{idx}"]
        val = get_escaped_text(val)
        x = key_specs_data.xpath(%{.//li[text()[contains(.,concat(#{val}))]]})
        # TODO: Push to errors if x is blank
        idx = idx.next
      end
    end

    def assert_key_features
      # "Key Features"=>"100% Cotton::Wildlife::Conservation::Outdoors::Birds", 
      key_features = @@flipkart_row1["Key Features"].split("::")
      fk_key_features = self.find('ul.keyFeaturesList')
      key_features.each do |kf|
        val = get_escaped_text(kf)
        x = fk_key_features.xpath(%{.//li[text()[contains(.,concat(#{val}))]]})
      end
    end

    def assert_description_text
      desc_text = self.find("div.description-text")
      description = @@flipkart_row1["Description"]
      description == desc_text.text
    end

    def assert_product_specs
      fk_prod_specs = self.find("div.productSpecs")
      all_tds = fk_prod_specs.xpath(%{.//td[@class='specsValue']})
      puts "all_tds ==> #{all_tds}"

      values = all_tds.collect do |td|
        td.text.strip
      end
      puts "values ==> #{values}"
    end

    def assert_product_sizes
      fk_size_container = self.find("div.multiSelectionWrapper .multiSelectionWidget")[1]
      puts "=========================================================="
      puts "fk_size_container => #{fk_size_container}"

      size_present = fk_size_container.find("div.multiSelectionWidget-selectors-wrap .selector-attr-size.current > div[data-selectorvalue=S]")
      puts "size_present => #{size_present}"
    end

    def assert_product_images
      product_images_count = self.find(".productImages img").count
      puts "product_images_count => #{product_images_count}"
    end

    def assert_row
      assert_key_specs
      assert_product_sizes
      assert_product_images
      assert_key_features
      assert_description_text
      assert_product_specs
    end


    private
    def tshirt_mappings
      return {
        "" => ""
      }
    end

    # NOTE: This is super complex. Don't break your head over it. But, SHIT WORKS!!
    def get_escaped_text(text)
      escaped = "'#{text.split("'").join("', \"'\", '")}', ''"
      return escaped
    end

    def assert_noko(type, selector, opts={})
      elements = (type==:xpath) ? @data.xpath(selector) : @data.css(selector)
      if(opts.has_key?(:text))
        nelements = elements.filter(".//*[contains(text(), '#{opts[:text]}')]")
        puts "nelements ==> #{nelements.inspect}"
        # assert_present(nelements, %Q`Did not find any element matching #{selector} with the text #{opts[:text]}. Found #{elements.count} elements matching partially ==> \n#{elements.collect(&:to_s).join("\n")}`)
        elements = nelements
      end
      if(opts.has_key?(:count))
        assert_equal(opts[:count].to_i, elements.count, "Expecting #{selector} to occur #{opts[:count]} times, but found #{elements.count} times")
      else 
        puts "Yay!!"
        # assert_present(elements)
      end
    end

  end
end