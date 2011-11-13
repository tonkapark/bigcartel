module BigCartel
  class Client
    module Categories
      
      def category(permalink)
       @store.categories.each do |c|
         return c if c.permalink == permalink
       end
      end
      
      def categories
       @store.categories
      end
      
      
    end
  end
end
