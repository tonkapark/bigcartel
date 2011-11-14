require 'helper'

describe BigCartel do
  before do
    
    stub_request(:get, "api.bigcartel.com/park/store.js").
      to_return(:body=>fixture("store.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      
    stub_request(:get, /api.bigcartel.com\/park\/products.js/).      
      to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})        

     stub_request(:get, /api.bigcartel.com\/park\/page\/\w+.js/).
      to_return(:body=>fixture("page.json"), :headers => {:content_type => "application/json; charset=utf-8"})
  end  
    
    it "will delegate BigCartel.new to client " do
      client = BigCartel.new
      client.should be_an_instance_of BigCartel::Client   
    end      

end


describe BigCartel::Client do
  
  before do
    
    stub_request(:get, "api.bigcartel.com/park/store.js").
      to_return(:body=>fixture("store.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      
    stub_request(:get, /api.bigcartel.com\/park\/products.js\?limit=\d+/).      
      to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})  

     stub_request(:get, /api.bigcartel.com\/park\/page\/\w+.js/).
      to_return(:body=>fixture("page.json"), :headers => {:content_type => "application/json; charset=utf-8"})
 end  
  
  
  #base client features
  describe "client" do
      
    before(:each) do
      @client = BigCartel::Client.new
    end    
      
    it "is properly classed" do           
      @client.should be_an_instance_of BigCartel::Client 
    end 
    
    it "can fetch" do
      store = BigCartel::Client.fetch("/park/store.js")
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made          
    end
          
    it "can list" do
      store = BigCartel::Client.list("/park/products.js", {:limit => 100})
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made          
    end
  end
  
  #########################################
  #store features
  describe ".store" do
    before do
      @client = BigCartel::Client.new   
    end
    
    it "with no options makes 1 http call" do
      store = @client.store("park")
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made   
            
      a_request(:get, /api.bigcartel.com\/park\/products.js/).
            should have_been_made          
    end    

    it "with show_products makes 2 http call" do
      store = @client.store("park", {:show_products => true, :product_limit => 2})
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=2").
            should have_been_made          
    end   

    it "with show_products false makes 1 http call" do
      store = @client.store("park", {:show_products => false, :product_limit => 2})
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=2").
            should_not have_been_made          
    end 
  
    context "will be a valid hash" do
      before{@store = @client.store("park")}
      
      it {@store.should be_a Hash}
      
      it "should have a url" do        
        @store.url.should be_an String
        @store.url.should eq("http://park.bigcartel.com")
      end  
        
      it { @store.categories.should be_an Array  }
      it { @store.artists.should be_an Array  }
      it { @store.website.should be_a String  }
      it { @store.description.should be_a String  }
      it { @store.name.should be_a String  }
      it { @store.products_count.should be_an Integer  }
      it { @store.country.should be_an Hash  }
      it { @store.currency.should be_an Hash  }
      it { @store.pages.should be_an Array  }            
      it { @store.products.should be_a Array  }           
    end
    
  end
  
  
  #########################################
  # product methods
  
  describe ".products" do
    before do
      @client = BigCartel::Client.new
    end
      
    it "will make http api calls" do
      products = @client.products("park")
      a_request(:get, "api.bigcartel.com/park/store.js").
            should_not have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made          
    end     

    it "accepts limit parameter" do
      products = @client.products("park", {:limit => 10}  )
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=10").
            should have_been_made                     
    end    
      
    context "will be a valid hash" do
      before{@product = @client.products("park").first}
      
      it {@product.should be_a Hash}
      
      it "should have a permalink" do        
        @product.permalink.should be_an String
        @product.permalink.should eq("watch-test")
      end  
        
      it { @product.tax.should be_an Float  }
      it { @product.created_at.should be_a String  }
      it { @product.shipping.should be_an Array  }
      it { @product.status.should be_a String  }      
      it { @product.artists.should be_an Array  }
      it { @product.categories.should be_an Array  }
      it { @product.position.should be_an Integer  }
      it { @product.images.should be_an Array  }
      it { @product.images.first.thumb.should be_a String  }
      it { @product.images.first.medium.should be_a String  }
      it { @product.images.first.large.should be_a String  }
      
      it { @product.on_sale.should eq(!!@product.on_sale) }  #Boolean test
      it { @product.description.should be_a String  }      
      it { @product.price.should be_an Float }      
      it { @product.name.should be_a String }      
      it { @product.url.should be_a String }      
      it { @product.default_price.should be_a Float }      
      it { @product.id.should be_an Integer }      
      it { @product.options.should be_an Array }     
         
    end      
      
  end
  
##################
  describe ".page" do
    before do
      @client = BigCartel::Client.new
   end

   it "will make http api calls" do     
     page = @client.page("park", "about")
     a_request(:get, "api.bigcartel.com/park/page/about.js").
            should have_been_made
            
      a_request(:get, "api.bigcartel.com/park/store.js").
            should_not have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should_not have_been_made   
   end   
          
    describe 'should build hash' do
      before(:each) { @page = @client.page("park", "about")}
      
      it "should have a permalink" do                
        @page.permalink.should be_a String
        @page.permalink.should eq("about")
      end  
      
      it { @page.content.should be_a String }
      it { @page.category.should be_a String  }
      it { @page.name.should be_a String  }
      it { @page.url.should be_a String  }
      it { @page.id.should be_an Integer  }
    end    
    
  end
  
  

  
  
end
