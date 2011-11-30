module Resque
  module Serializable
    module Job
    
      def self.included(base)
    
        base.class_eval do
          
          # Alias Resque's Job.perform to Job.perform_after_deserializing
          alias_method :perform_after_deserializing, :perform
          
          # Deserializes serialized arguments from YAML by looking for
          # an argument of type Hash with a key :serialize and deserializing its value from YAML.
          
          def perform
            args.collect! do |arg|
              if arg.is_a?(Hash) && arg.key?('serialize')
                if arg['serialize'].is_a?(Hash)
                  arg['serialize'].values.collect{|a| YAML::load(a) }
                elsif arg['serialize'].is_a?(Array)
                  arg['serialize'].collect{|a| YAML::load(a) }
                end
              else
                arg
              end
            end
            args.flatten!
            perform_after_deserializing
          end # perform
          
          class << self
            
            # Alias Resque's Job.create to Job.create_after_serializing
            alias_method :create_after_serializing, :create
            
            # Attempts to serialize job arguments before creating a new job, by looking for
            # an argument of type Hash with a key :serialize and serializing its value to YAML.
            
            def create(queue, klass, *args)
              args.collect! do |arg|
                if arg.is_a?(Hash) && arg.key?(:serialize)
                  if arg[:serialize].is_a?(Hash)
                    arg[:serialize].each{|k,v| arg[:serialize][k] = v.to_yaml }
                  elsif arg[:serialize].is_a?(Array)
                    arg[:serialize].collect!{|a| a.to_yaml }
                  end
                end
                arg
              end
              create_after_serializing(queue, klass, *args)
            end #create
  
          end #class << self
          
        end# base.class_eval
      
      end #self.included
    
    end #Job
  end
end