module TmSync

  class Enum

    def self.inherited(klass)
      klass.extend ClassMethods
    end

    module ClassMethods

      alias_method :original_new, :new

      def value(name, *args, &block)
        val = original_new(*args, &block)
        def val.name
          name
        end

        const_set(name, val)
      end

      def new
        raise RuntimeError.new('Cannot instantiate new enum values')
      end

    end

  end

end