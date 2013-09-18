require "active_model"

module OpenPayU
  module Models
    class Model
      
      include ActiveModel::Validations
      include ActiveModel::Serialization
      
      def initialize(values)
        values.each_pair do |k,v|
          self.send("#{k}=", v) 
        end
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
                    #{class_name.to_s.capitalize}.new(val)
                  end
                else
                  #{class_name.to_s.capitalize}.new(value)
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