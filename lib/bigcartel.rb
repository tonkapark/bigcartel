require 'httparty'

module BigCartel
    
  class Base
    include HTTParty
    base_uri "http://api.bigcartel.com"  
    headers 'Content-Type' => 'application/json' 
    
    attr_reader :subdomain
    
    def initialize(subdomain)
      @subdomain = subdomain
    end
    
    
    def store
      self.class.get("/#{@subdomain}/store.js")
    end
    
    def products(limit=10)
      self.class.get("/#{@subdomain}/products.js?limit=#{limit}")
    end
    
       
  end
end
