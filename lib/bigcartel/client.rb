require 'httparty'
require 'hashie'
    
module BigCartel

  class Client
    
    include HTTParty
    base_uri "http://api.bigcartel.com"
    headers 'Content-Type' => 'application/json' 

	
    attr_reader :subdomain, :store, :url, :pages, :products
    
    def initialize(subdomain)
      @subdomain = subdomain
      @url = "http://#{subdomain}.bigcartel.com"
        #set_store #initialize store data
      #nitialize_store
    end
	
	
    def self.fetch(path)
      response = get(path)     
      Hashie::Mash.new(response)  
    end
    
    def self.list(path, opts={})
      limit = opts[:limit] || 100      
      
      response = get(path, :query =>  {'limit' => limit})           
      response.map { |c| Hashie::Mash.new(c)}
    end	
	
    ##############################################
    ## STORE
    def store
      @store ||= self.class.fetch("/#{@subdomain}/store.js")
      @url = @store.url
      @store.products = products
      @store        
    end
    
    #~ def initialize_store
     #~ self.store unless @store.is_a?(Hash)
     #~ true
    #~ end    
    ##############################################
    ## 
      def products(opts={})
        self.store unless @store.is_a?(Hash)
          @products ||= self.class.list("/#{@subdomain}/products.js", opts)

        @products.each do |p|
        p.images = images_helper(p.images)
        p.full_url = "#{@url}#{p.url}"
        p.has_default_option = has_default_option?(p.options)
        p.option = p.options.first
        end
        
        @products	 
      end
      
      def product(id)
        return product_by_id(id) if id.is_a?(Integer)
        return product_by_permalink(id) if id.is_a?(String)
      end
      
      def product_by_id(product_id)
       @products.each do |p|
         return p if p.id == product_id
       end	
      end

      def product_by_permalink(permalink)
       @products.each do |p|
         return p if p.permalink == permalink
       end	
      end
	
      def products_by_category(permalink)      
        result = []
        if @store.categories.size > 0
          @products.each do |p|
            cats = {}
            if p.categories.size > 0 
              cats = p.categories.collect {|c| c.permalink}          
              result << p if cats.include?(permalink)
            end
          end      
        end
        result
      end    
      
      def products_by_artist(permalink)      
        result = []
        if @store.artists.size > 0
          @products.each do |p|
            temp = {}
            if p.artists.size > 0 
              temp = p.artists.collect {|a| a.permalink}          
              result << p if temp.include?(permalink)
            end
          end      
        end
        result
      end      
    ##############################################
    ## CATEGORIES

      def category(permalink)
       @store.categories.each do |c|
         return c if c.permalink == permalink
       end
      end
      
      def categories
       @store.categories
     end
     
    ##############################################
    ## ARTISTS
          
      def artist(permalink)
       @store.artists.each do |a|
         return a if a.permalink == permalink
       end
      end
      
      def artists
       initialize_store
       @store.artists
      end
     
    ##############################################
    ## PAGES
      def pages
        initialize_store
          @pages ||= @store.pages.map { |p| page(p.permalink) }	  
      end
      
      def page(permalink=nil)
        self.class.fetch(URI.encode("/#{@subdomain}/page/#{permalink}.js"))
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
      url_parts = img.url.scan(/(http:\/\/cache(0|1).bigcartel.com\/product_images\/\d*\/)(.*).(jpg|png|gif|jpeg)/i)
        
          img.thumb = "#{url_parts[0][0]}75.#{url_parts[0][3]}"
          img.medium = "#{url_parts[0][0]}175.#{url_parts[0][3]}"
          img.large = "#{url_parts[0][0]}300.#{url_parts[0][3]}"
      end
      images
    end    
    
  end
end
