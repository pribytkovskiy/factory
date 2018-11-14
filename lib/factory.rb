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

          key.zip(value).each { |key, value| send("#{key}=", value) }
        end

        class_eval(&block) if block_given?

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
          map_instance_keys_variables.dig(*args)
        end

        def each(&block)
          map_instance_variables.each(&block)
        end

        def each_pair(&block)
          map_instance_keys_variables.each_pair(&block)
        end

        def length
          instance_variables.length
        end

        def members
          map_instance_keys_variables.keys
        end

        def select(&block)
          map_instance_variables.select(&block)
        end

        def to_a
          map_instance_variables
        end

        def values_at(*keys)
          keys.map { |key| map_instance_variables[key] }
        end

        alias_method :size, :length

        protected

        def map_instance_variables
          instance_variables.map { |variable| instance_variable_get(variable) }
        end

        def map_instance_keys_variables
          Hash[instance_variables.map { |var| [var.to_s.delete('@').to_sym, instance_variable_get(var)] }]
        end
      end
    end
  end
end
