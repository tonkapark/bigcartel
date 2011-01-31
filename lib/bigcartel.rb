require 'httparty'

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
    
  class Base
    include HTTParty
    base_uri "http://api.bigcartel.com"  
    headers 'Content-Type' => 'application/json' 
    
    attr_reader :subdomain
    
    def initialize(subdomain)
      @subdomain = subdomain
    end
       
  end   
    
  class Store < Base

    attr_reader :id, :description, :categories, :website, :products_count, :pages, :name, :url, :currency, :country
    
    def initialize(id, data={})
      @id = id
      @description = data['description']
      @website = data['website']
      @products_count = data['products_count']
      @pages = data['pages'].map{|p| Page.new(data['url'], p)}  unless data['pages'].blank?
      @name = data['name']
      @url = data['url']
      @currency = data['currency']['code']
      @country = data['country']['name']
      @categories = data['categories'].map{|cat| Category.new(data['url'], cat)}  unless data['categories'].blank?    
    end  
    
    def self.find(id)
      Store.new(id, self.fetch(id))    
    end  
    
    def products
      Product.all(@id, @url)
    end
      
    protected
      def self.fetch(id)
        get("/#{id}/store.js", :headers => {'Accept' => 'application/json'})
      end  
    end


  class Artist < Base  
    attr_reader :name, :url, :id, :permalink  
    def initialize(store_url, data={})
      @name = data['name']
      @url = "#{store_url}#{data['url']}"
      @id = data['id']
      @permalink = data['permalink']
    end
  end
  
  class Category < Artist  
  end  
    
    
  class Image < Base
    attr_reader :height, :width, :url, :thumb, :medium, :large
    def initialize(data={})
      url_parts = data['url'].scan(/(http:\/\/cache(0|1).bigcartel.com\/product_images\/\d*\/)(.*).(jpg|png|gif)/i)
      
      @height = data['height']
      @width = data['width']    
      @url = data['url']
      @thumb = "#{url_parts[0][0]}75.#{url_parts[0][3]}"
      @medium = "#{url_parts[0][0]}175.#{url_parts[0][3]}"
      @large = "#{url_parts[0][0]}300.#{url_parts[0][3]}"
    end  
  end   


  class Page < Base
    attr_reader :name, :permalink, :url
    def initialize(store_url, data={})
      @name = data['name']
      @permalink = data['permalink']    
      @url = "#{store_url}/#{data['permalink']}"
    end
  end
  
  class Product < Base
    attr_reader :name, :permalink, :url, :description, :artists, :on_sale, :status, :categories, :price, :position, :url, :id, :tax, :images, :shipping
    def initialize(store_url, data={})
      @name = data['name']
      @description = data['description']
      @artists = data['artists'].map{|cat| Artist.new(data['url'], cat)}  unless data['artists'].blank?
      @on_sale= data['on_sale']
      @status = data['status']
      @categories = data['categories'].map{|cat| Category.new(data['url'], cat)}  unless data['categories'].blank?
      @price = data['price']
      @position = data['position']
      @url = "#{store_url}#{data['url']}"
      @id = data['id']
      @tax = data['tax']
      @permalink = data['permalink']  
      @images = data['images'].blank?  ? [] : data['images'].map{|img| Image.new(img)}  
      @shipping = data['shipping'].map{|ship| Shipping.new(ship)}  unless data['shipping'].blank?
    end
    
    def img
      self.images.first
    end    
    
    def self.all(id, store_url)
      self.fetch(id).map{|p| Product.new(store_url, p)} 
    end  
      
    protected
      def self.fetch(id)
        get("/#{id}/products.js", :headers => {'Accept' => 'application/json'})
      end    
    end  
    
    
  class ProductOption < Base
    attr_reader :name, :id
    def initialize(data={})
      @name = data['name']
      @id = data['id']        
    end   
  end    
  
  class Shipping < Base
    attr_reader :amount_alone, :amount_combined, :country
    def initialize(data={})
      @amount_alone = data['amount_alone']
      @amount_combined = data['amount_with_others']        
      @country = data['country']['code'] unless data['country'].blank?
    end     
  end
  
end
