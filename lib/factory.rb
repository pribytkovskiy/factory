# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable. The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?

class Factory
  class << self
    def new(*key, &block)
      const_set(key.shift.capitalize, class_new(*key, &block)) if key.first.is_a?(String)
      class_new(*key, &block)
    end

    def class_new(*key, &block)
      Class.new do
        attr_accessor(*key)

        define_method :initialize do |*value|
          raise ArgumentError, 'ArgumentError' if key.count != value.count
          key.zip(value).each {|key, value| send("#{key}=", value)}
        end

        class_eval(&block) if block_given?

        def map_instance_variables
          instance_variables.map { |variable| instance_variable_get(variable) }
        end

        def ==(obj)
          self.class == obj.class && self.map_instance_variables == obj.map_instance_variables
        end

        def [](key)
          (key.is_a? Numeric) ? map_instance_variables[key] : instance_variable_get("@#{key}")
        end

        def []=(key, value)
          instance_variable_set("@#{key}", value)
        end

        def dig(*args)
          
        end



        class_eval(&block) if block_given?
      end
    end
  end    
end

