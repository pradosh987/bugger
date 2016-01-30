require "open-uri"

module Bugger
  class Webpage
    attr_accessor :url

    def initialize(url)
      @data = Nokogiri::HTML(open(url))
    end

    # doc.find(".productSpecs")
    def find(klass)
      return false if @data.blank?
      @data.find( 
        klass)
    end

    def data
      @data
    end


    # private
    # def self.normalize_url(url)
    #   begin
    #     result = Curl::Easy.perform(URI(url).to_s) do |curl|
    #       curl.follow_location = true
    #     end
    #     return URI(result.last_effective_url)
    #   rescue
    #     return nil
    #   end
    # end
  end
  # module ClassMethods
    
  # end
  
  # module InstanceMethods
    
  # end
  
  # def self.included(receiver)
  #   receiver.extend         ClassMethods
  #   receiver.send :include, InstanceMethods
  # end
end