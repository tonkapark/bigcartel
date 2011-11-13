require 'helper'

describe BigCartel::Client do
  
  #base client features
  describe "client" do
    before do
      stub_request(:get, "api.bigcartel.com/park/store.js").
        to_return(:body=>fixture("store.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        
      stub_request(:get, "api.bigcartel.com/park/products.js?limit=100").
        to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})        
    end
      
    before(:each) do
      @client = BigCartel::Client.new("park")
    end
    
      
    it "BigCartel::Client.new is proper class" do           
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
      @client = BigCartel::Client.new("park")
      
      stub_request(:get, "api.bigcartel.com/park/store.js").
        to_return(:body=>fixture("store.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        
      stub_request(:get, "api.bigcartel.com/park/products.js?limit=100").
        to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})        
    end
    
    it "will make http api calls" do
      store = @client.store
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made          
    end     
  
    it "will use stored hash instead of http calls" do 
      store = @client.store        
      a_request(:get, "api.bigcartel.com/park/store.js").
            should_not have_been_made   
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should_not have_been_made  
    end            
    
    context "will be a valid hash" do
      before{@store = @client.store}
      
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
      it { @store.products.should be_an Array }
    end
  end
  
  
  
end
