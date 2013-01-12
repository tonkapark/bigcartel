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
      url_parts = img.url.scan(/(http:\/\/.*.bigcartel.com\/product_images\/\d*\/)(.*).(jpg|png|gif|jpeg)/i)
        
          img.thumb = "#{url_parts[0][0]}75.#{url_parts[0][3]}"
          img.medium = "#{url_parts[0][0]}175.#{url_parts[0][3]}"
          img.large = "#{url_parts[0][0]}300.#{url_parts[0][3]}"
      end
      images
    end    
    
  end
end
