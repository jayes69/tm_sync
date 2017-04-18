module TmSync

  class Command

    attr_accessor :payload

    def name
      raise RuntimeError.new('No name given')
    end

    class << self
      module ClassMethods

        def payload(*payloads)
          payloads.each do |payload|
            if not payload.is_a? Hash
              define_method payload do
                self.payload[payload.to_s]
              end

              define_method :"#{payload}=" do |value|
                self.ppayload[payload.to_s] = value
              end
            else
              payload.each do |p_method_name, p_payload_name|
                define_method p_method_name do
                  self.payloads[p_payload_name.to_s]
                end
                define_method :"#{p_method_name}=" do |value|
                  self.payloads[p_payload_name.to_s] = value
                end
              end
            end
          end
        end
      end
      extend ClassMethods

      def [](name)
        @commands ||= {}

        @commands[name] = Class.new(Command) do
          define_method :name do
            name
          end

          define_singleton_method :command_name do
            name
          end
        end
      end

      def create(name, payload=nil)
        result = (@commands[name] || raise(RuntimeError.new("Can't find command #{name}"))).new
        result.payload = payload if not payload.nil?
        result
      end

      def inherited(klass)
        klass.extend ClassMethods
      end

    end

  end


  class Command
    class Register < Command[:register]
      payload :url
      payload :client_id => 'client-id'
      payload :auth_token => 'auth-token'
      payload :slave_token => 'slave-token'
      payload :version
      payload :flags
    end

    class Notify < Command[:notify]
      payload :command, :data
    end

    class Push < Command[:push]; end

    class Pull < Command[:pull]
      payload :type
      payload :query
    end

    class Subscribe < Command[:subscribe]
      payload :pull_query => 'pull-query'
      payload :method
    end

    class Unsubscribe < Command[:unsubscribe]
      payload :subscription_id => 'subscription-id'
    end
  end

end