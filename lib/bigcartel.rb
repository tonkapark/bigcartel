require 'httparty'
require 'uri'

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

    attr_reader :id, :description, :categories, :website, :products_count, :pages, :name, :url, :currency, :country, :artists, :currency_sign, :products
    
    def initialize(id, data={})
      @id = id
      @description = data['description']
      @website = data['website']
      @products_count = data['products_count']
      @pages = data['pages'].map{|p| Page.add(id, data['url'], p)}  unless data['pages'].blank?
      @name = data['name']
      @url = data['url']
      @currency = data['currency']['code']
      @currency_sign = data['currency']['sign']
      @country = data['country']['name']
      @categories = data['categories'].blank?  ? [] : data['categories'].map{|cat| Category.new(data['url'], cat)}
      @artists = data['artists'].blank? ? [] : data['artists'].map{|cat| Artist.new(data['url'], cat)} 
      @products = Product.all(@id, @url)
    end  
    
    def self.find(id)
      Store.new(id, self.fetch(id))    
    end  
    
    def product_find(permalink)
      #self.products.select{|f| f["permalink"] == permalink}
      @products.each do |p|
        if p.permalink == permalink 
          return p
        end
      end      
    end    
    
    def page(permalink)
      self.pages.each do |p|
        return p if p.permalink == permalink
      end
    end
    
    def category(permalink)
      self.categories.each do |cat, idx|
        return cat if cat.permalink == permalink
      end
    end    
    
    def artist(permalink)
      self.artists.each do |a, idx|
        return a if a.permalink == permalink
      end
    end      
    
    def products_by_category(cat)      
      result = []
      if self.categories.size > 0
        self.products.each do |p|
          cats = {}
          if p.categories.size > 0 
            cats = p.categories.collect {|c| c.permalink}          
            result << p if cats.include?(cat)
          end
        end      
      end
      result
    end    
    
    def products_by_artist(slug)      
      result = []
      if self.artists.size > 0
        self.products.each do |p|
          temp = {}
          if p.artists.size > 0 
            temp = p.artists.collect {|a| a.permalink}          
            result << p if temp.include?(slug)
          end
        end      
      end
      result
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
      url_parts = data['url'].scan(/(https?:\/\/.*\/product_images\/\d*\/)(.*).(jpg|png|gif|jpeg)/i)
      
      @height = data['height']
      @width = data['width']    
      @url = data['url']
      @thumb = "#{url_parts[0][0]}75.#{url_parts[0][2]}"
      @medium = "#{url_parts[0][0]}175.#{url_parts[0][2]}"
      @large = "#{url_parts[0][0]}300.#{url_parts[0][2]}"
    end  
  end   


  class Page < Base
    attr_reader :id, :name, :permalink, :url, :content, :category
    def initialize(store_url, data={})
      @id = data['id']
      @name = data['name']
      @permalink = data['permalink']    
      @url = "#{store_url}/#{data['permalink']}"
      @content = data['content']
      @category = data['category']
    end
    
    def self.add(id, store_url, page)
      page_permalink = page['permalink']
      Page.new(store_url, self.fetch(id, page_permalink))
    end
    
    protected
      def self.fetch(id, page)
        get(URI.encode("/#{id}/page/#{page}.js"), :headers => {'Accept' => 'application/json'})
      end      
  end
  
  class Product < Base
    attr_reader :name, :permalink, :url, :full_url, :description, :artists, :on_sale, :status, :categories, :price, :position, :url, :id, :tax, :images, :shipping, :options,:default_price,:image, :image_count
    def initialize(store_url, data={})
      @name = data['name']
      @description = data['description']
      @artists = data['artists'].blank? ? [] : data['artists'].map{|cat| Artist.new(data['url'], cat)}  
      @on_sale= data['on_sale']
      @status = data['status']
      @categories = data['categories'].blank? ? [] : data['categories'].map{|cat| Category.new(data['url'], cat)}
      @price = data['price']
      @default_price = data['default_price']
      @position = data['position']
      @full_url = "#{store_url}#{data['url']}"
      @url = "#{data['url']}"
      @id = data['id']
      @tax = data['tax']
      @permalink = data['permalink']  
      @images = data['images'].blank?  ? [] : data['images'].map{|img| Image.new(img)}  
      @image_count = data['images'].blank? ? 0 : data['images'].size
      @shipping = data['shipping'].map{|ship| Shipping.new(ship)}  unless data['shipping'].blank?
      @options = data['options'].map{|opt| ProductOption.new(opt)}  unless data['options'].blank?
      @image = Image.new(data['images'][0]) unless data['images'].blank?      
    end
        
    def has_default_option
      names = {}
      if self.options.size <= 1
        names = self.options.collect {|x| x.name }        
      end      
      return names.include?("Default")
    end
    
    def option
      self.options.first
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
    attr_reader :name, :id,:has_custom_price, :price
    def initialize(data={})
      @name = data['name']
      @id = data['id']        
      @has_custom_price = data['has_custom_price']
      @price = data['price']
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
