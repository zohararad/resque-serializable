# Resque-Serializable

This gem adds support for serializing and deserializing Resque job arguments. Although not considered the "pure" way by some philosophers, sometimes passing complex objects to a 
background processor (Resque in this case), rather than just simple objects (String, Integer, Hash etc.) does make our lives a bit easier.

## Enter Resque-Serializable...

Suppose you want run a lengthy background process using Resque and wish to pass on to your background worker an instance of some class you have in your code. Without Resque-Serializable
you'd probably save your instance state somehow and pass on that state as a list of arguments.

With Resque-Serializable, you would do something like that:

    c = SomeClass.new
    c.some_attr = 'Some Value'
    Resque.enqueue(LongBackgroundJob,'some random string',[1,2,3,4], :serialize => [c])

Your background job process method will look something like that:

    class LongBackgroundJob
      @queue = :my_queue
      
      def self.process(str, arr, c)
        puts str #output 'some random string'
        puts arr.inspect #output [1,2,3,4]
        puts c.some_attr #output 'Some Value'
      end
    end

To serialize an argument using Resque-Serializable, you simply pass the Resque.enqueue method an argument **:serialze** => [].
The value of the **:serialize** should be an array of objects that should be serialized before queuing and deserialized before processing

## Words of caution

Serializing and deserializing is done via YAML. Please make sure you only pass objects that respond to **to_yaml** method to the :serialize array

Argument order is kept between the enqueue and process methods, however the serializable objects inside our **:serialize** array will be passed on to the process method without their
containing **:serialize** hash. Here's an example to clarify:
  
    # Enqueue a job
    # Note :serialize receives an array of 3 objects for serializing
    Resque.enqueue(LongBackgroundJob,:serialize => [a,b,c], Time.now.to_i)
  
    # Process the job
    class LongBackgroundJob
      @queue = :my_queue
      
      # Note that the unserialized objects are passed in the order they appear
      # inside the :serialize argument in the enqueue method above
      def self.process(a, b, c, timestamp)
      end
    end