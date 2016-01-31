module PropertiesMixin
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    def with_hstore_properties(props)
      props.each do |prop|
        self.class_eval %Q[
          def #{prop}
            self.get_property("#{prop}")
          end

          def #{prop}=(v)
            self.set_property("#{prop}", v)
          end
        ]
      end
    end

    ##
    def with_hstore_boolean_properties(props)
      props.each do |prop|
        self.class_eval %Q[
          def #{prop}
            value = self.get_property("#{prop}")
            return value == "true" || value == true
          end

          def #{prop}=(v)
            self.set_property("#{prop}", v)
          end
        ]
      end
    end

    ##
    def with_hstore_array(key_prefix)
      self.class_eval %Q[
        def add_#{key_prefix}(*args)
          index = #{key_prefix}_index
          args.each do |a|
            self.properties["#{key_prefix}.\#\{index\}"] = a
            index = index + 1
          end
          return self.#{key_prefix}(false)
        end

        def #{key_prefix}_index
          index = 0
          self.properties.keys.each do |k|
            if k =~ /^#{key_prefix}/
              i = k.split('.', 2)[1].to_i
              index = i if i > index
            end
          end
          return index
        end

        def #{key_prefix}(cache=true)
          if cache && @#{key_prefix}
            return @#{key_prefix}
          end
          @#{key_prefix} = self.properties.collect {|k, v| k =~ /^#{key_prefix}/ ? v : nil }.compact
        end
      ]
    end
  end

  def properties
    raise "Properties hash has not been loaded for #{self.class.name}##{self.id} | attributes = #{self.attributes} | #{self.new_record?}" if !has_attribute?(:properties)
    read_attribute(:properties) || write_attribute(:properties, {})
  end

  def get_property(name)
    properties[name]
  end

  ##
  def set_property(name, value)
    properties[name] = value
  end


  def self.included(base)
    base.class_eval do
      serialize :properties, ActiveRecord::Coders::Hstore
    end
  end
end
