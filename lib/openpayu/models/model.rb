require "active_model"

module OpenPayU
  module Models
    class Model

      include ActiveModel::Validations
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml
      
      def initialize(values)
        values.each_pair do |k,v|
          self.send("#{k}=", v) 
        end
      end

      def attributes
        instance_values
      end

      def to_json
        prepare_hash.to_json
      end

      def prepare_data(request_type)
        { 
          'OpenPayU' => { 
            request_type => prepare_keys(instance_values) 
          }
        }.to_json 
      end

      def prepare_keys(hash)
        attrs = {}
        hash = hash.instance_values if hash.class.name =~ /OpenPayU::Models/
        hash.each_pair do |k,v| 
          if v.class.name == "Array"
            attrs[k.camelize] = {}
            v.each_with_index{ |element, i| attrs[k.camelize][element.class.name.gsub("OpenPayU::Models::","")] = prepare_keys(element) }
          else   
            attrs[k.camelize] = v
          end
        end
        attrs
      end

  
      
      class << self

        def has_many_objects(association, class_name)
          define_writer(association, class_name)
          define_reader(association)
        end

        def has_one_object(association)
          define_writer(association, association)
          define_reader(association)
        end

        def define_writer(association, class_name)
          class_eval <<-CODE
            def #{association}=(value)
              @#{association} = 
                if value.class.name == "Array"
                  value.collect do |val|
                    #{class_name.to_s.camelize}.new(val)
                  end
                else
                  #{class_name.to_s.camelize}.new(value)
                end
            end
          CODE
        end

        def define_reader(association)
          attr_reader association
        end

      end
    end
  end
end