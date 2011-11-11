require 'httparty'
require 'hashie'

module BigCartel
  # Alias for BigCartel::Store.find
  #
  # @return [BigCartel::Store]
  def self.store(subdomain)
    BigCartel::Store.find(subdomain)
  end

  # Delegate to BigCartel::Store
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end
    
    
  
    
  class Base < Hashie::Mash
    include HTTParty
    
    base_uri "http://api.bigcartel.com"  
    headers 'Content-Type' => 'application/json' 
    
    def self.fetch(path)
      response = get(path)     
      self.new(response)  
    end
    
    def self.list(path, opts={})
      limit = opts[:limit] || 100      
      
      response = get(path, :query =>  {'limit' => limit})           
      response.map { |c| self.new(c)}
    end
    
  end 

 
  class Store < Base

    def self.find(subdomain)
      store = fetch("/#{subdomain}/store.js")
      store.products = Product.all(subdomain)
      store      
    end    

  end
  
  class Page < Base
    def self.find(subdomain, permalink)
      fetch("/#{subdomain}/page/#{permalink}.js")
    end    
  end  
  
  class Product < Base
    def self.all(subdomain, opts={})
      list("/#{subdomain}/products.js", opts)
    end    
  end  
  
end
