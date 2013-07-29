require 'httparty'
require 'hashie'
    
module BigCartel

  class Client
    
    include HTTParty
    base_uri "http://api.bigcartel.com"
    headers 'Content-Type' => 'application/json' 

	def initialize(options={})
	end
	
    def self.fetch(path)
      response = get(path)     
      Hashie::Mash.new(response)  
    end
    
    def self.list(path, opts={})
#      opts = { :limit => 100 }.merge opts   
      
      response = get(path, :query =>  {'limit' => opts[:limit]})           
      response.map { |c| Hashie::Mash.new(c)}
    end	
	

    def store(account, opts={})
      opts = { :show_products => true, :product_limit => 100 }.merge opts
      
      store = self.class.fetch("/#{account}/store.js")             
      store.account = account
      store.products = opts[:show_products] ?  products(account,{:limit => opts[:product_limit]}) : {}
      store   
    end
    

    def products(account, opts={})
      opts = { :limit => 100 }.merge opts   
      products = self.class.list("/#{account}/products.js", opts)

      products.each do |p|
        p.images = images_helper(p.images) if p.has_key?("images")
        p.has_default_option = has_default_option?(p.options)
        p.option = p.options.first
      end
      
      products	 
    end

    
    def page(account, permalink=nil)
      self.class.fetch(URI.encode("/#{account}/page/#{permalink}.js"))
    end  
      
    ##############################################
    ## HELPERS
  private
      
      def has_default_option?(options)
        names = {}
        if options.size <= 1
          names = options.collect {|x| x.name }        
        end      
        return names.include?("Default")
      end

    def images_helper(images)
      output = Array.new
      images.each do |img|
        filename = File.basename(img.url)
        picture_id = img.url.match(/\/(\d+)\//)[1]              
        
        img.thumb = "http://images.cdn.bigcartel.com/bigcartel/product_images/#{picture_id}/max_h-75+max_w-75/#{filename}"
        img.medium = "http://images.cdn.bigcartel.com/bigcartel/product_images/#{picture_id}/max_h-155+max_w-150/#{filename}"
        img.large = "http://images.cdn.bigcartel.com/bigcartel/product_images/#{picture_id}/max_h-300+max_w-300/#{filename}"
      end
      images
    end    
    
  end
end
