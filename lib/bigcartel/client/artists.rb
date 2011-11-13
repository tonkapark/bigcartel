module BigCartel
  class Client
    module Artists
          
      def artist(permalink)
       @store.artists.each do |a|
         return a if a.permalink == permalink
       end
      end
      
      def artists
       initialize_store
       @store.artists
      end
      
    end
  end
end
