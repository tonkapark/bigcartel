module BigCartel
  class Client
    module Products
    
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
      
    end
  end
end
