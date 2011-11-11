module BigCartel  
  class Base
    include HTTParty
    
    base_uri "http://api.bigcartel.com"  
    headers 'Content-Type' => 'application/json' 
    
    attr_reader :subdomain
    
    def initialize(subdomain)
      @subdomain = subdomain
    end
       
  end
end
