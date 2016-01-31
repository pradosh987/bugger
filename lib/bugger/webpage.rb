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
    
    private

  end
end