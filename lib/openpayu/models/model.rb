# -*- encoding : utf-8 -*-
require 'active_model'

module OpenPayU
  module Models
    class Model

      include ActiveModel::Validations
      include ActiveModel::Serializers::JSON

      attr_accessor :all_errors

      def initialize(values)
        values.each_pair do |k, v|
          send("#{k}=", v)
        end
        after_initialize
      end

      def after_initialize
      end

      def attributes
        instance_values
      end

      def to_json
        prepare_keys.to_json
      end

      def prepare_data
        prepare_keys.to_json
      end

      def get_instance_values
        instance_values.delete_if do |k, v|
          %w(all_errors errors validation_context).include?(k)
        end
      end

      def prepare_keys(attrs = {}, hash = get_instance_values)
        hash.each_pair do |k, v|
          attrs[k.camelize(:lower)] =
            if v.is_a? Array
              { k.camelize(:lower) =>  v.map(&:prepare_keys) }
            elsif v.class.name =~ /OpenPayU::Models/
              v.prepare_keys
            else
              v
            end
        end
        attrs
      end

      def validate_all_objects
        @all_errors = {}
        instance_values.each_pair do |k, v|
          if v.is_a? Array
            v.each do |element|
              if element.validate_all_objects.any?
                @all_errors[element.class.name] = element.errors
              end
            end
          elsif v.class.name =~ /OpenPayU::Models/
            @all_errors[v.class.name] = v.errors unless v.valid?
          end
        end
        @all_errors[self.class.name] = errors unless valid?

        @all_errors
      end

      def all_objects_valid?
        !validate_all_objects.any?
      end

      def to_flatten_hash(source = nil, target = {}, namespace = nil, index = nil)
        source ||= prepare_keys(instance_values)
        prefix = "#{namespace}." if namespace
        case source
        when Hash
          array_index = "[#{index}]" if index
          source.each do |key, value|
            to_flatten_hash(value, target, "#{prefix}#{key}#{array_index}")
          end
        when Array
          source.each_with_index do |value, i|
            to_flatten_hash(value, target, namespace, i)
          end
        else
          target[namespace] = source
        end
        target
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
