require "active_model"

module OpenPayU
  module Models
    class Model

      include ActiveModel::Validations
      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml

      attr_accessor :all_errors


      def initialize(values)
        values.each_pair do |k,v|
          self.send("#{k}=", v)
        end
        after_initialize
      end

      def after_initialize
      end

      def attributes
        instance_values
      end

      def to_json
        prepare_hash.to_json
      end

      def prepare_data(request_type)
        if OpenPayU::Configuration.data_format == "xml"
          generate_xml(request_type)
        else
          { 
            "OpenPayU" => {
              request_type => prepare_keys(instance_values)
            }
          }.to_json
        end
      end

      def generate_xml(request_type)
        '<?xml version="1.0" encoding="UTF-8"?>
        <OpenPayU xmlns="http://www.openpayu.com/20/openpayu.xsd">'+
          prepare_keys(instance_values).to_xml(builder: OpenPayU::XmlBuilder.new(request_type, indent: 2), root: request_type, skip_types: true, skip_instruct: true) +
        '</OpenPayU>'
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
        attrs.delete_if{ |k,v| ["AllErrors", "Errors", "ValidationContext"].include?(k) }
      end

      #TODO: use validation
      def validate_all_objects
        @all_errors = {}
        instance_values.each_pair do |k,v|
          if v.class.name == "Array"
            v.each do |element|
              @all_errors[element.class.name] = element.errors if element.validate_all_objects.any?
            end
          elsif v.class.name =~ /OpenPayU::Models/
            @all_errors[v.class.name] = v.errors unless v.valid?
          end
        end
        @all_errors[self.class.name] = self.errors unless valid?

        @all_errors
      end

      def all_objects_valid?
        !validate_all_objects.any?
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
