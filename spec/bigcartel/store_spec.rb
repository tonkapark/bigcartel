require 'helper'

describe BigCartel::Store do
  
  describe 'get' do
   
    before do
      stub_request(:get, "api.bigcartel.com/park/store.js").
        to_return(:body=>fixture("store.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        
      stub_request(:get, "api.bigcartel.com/park/products.js?limit=100").
        to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})        
    end
      
    it "BigCartel.store return a store" do     
      BigCartel.store("park")
      a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made
    end 

    it "BigCartel::Store.find return a store" do     
     BigCartel::Store.find("park")
     a_request(:get, "api.bigcartel.com/park/store.js").
            should have_been_made
            
      a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made            
    end   
          
    describe 'should build hash' do
      before(:each) { @store = BigCartel.store("park")}
      
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
