module BigCartel
  class Client
    module Stores
    
      def store
        @store ||= self.class.fetch("/#{@subdomain}/store.js")
        @url = @store.url
        @store.products = products
        @store        
      end
      
      def initialize_store
       store unless @store.is_a?(Hash)
       true
      end    
  
    end
  end
end