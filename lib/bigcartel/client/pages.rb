module BigCartel
  class Client
    module Pages
    
      def pages
        initialize_store
          @pages ||= @store.pages.map { |p| page(p.permalink) }	  
      end
      
      def page(permalink=nil)
        self.class.fetch(URI.encode("/#{@subdomain}/page/#{permalink}.js"))
      end  
      
    end
  end
end
