module OpenMovilforum
  module MMS
    module Sender
      # base abstract class for MMS senders
      class Base
        # constructor
        def initialize(user, pass)
          @login = user
          @password = pass
        end
        
        # send (virtual method)
        def send(msg)
          raise "This method should be implemented in a subclass"
        end
      end
    end
  end
end