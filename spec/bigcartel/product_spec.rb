require 'helper'

describe BigCartel::Product do
  
 describe 'get' do
   
   before do
     stub_request(:get, "api.bigcartel.com/park/products.js?limit=100").
      to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})
   end
      

    it "BigCartel::Product.all returns products" do     
     BigCartel::Product.all("park")
     a_request(:get, "api.bigcartel.com/park/products.js?limit=100").
            should have_been_made
    end   

    describe 'should build hash' do
      before(:each) { @product = BigCartel::Product.all("park").first}
      
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
  
 describe 'get with options' do
    it "BigCartel::Product.all allows limit" do     
      stub_request(:get, "api.bigcartel.com/park/products.js?limit=5").
      to_return(:body=>fixture("products.json"), :headers => {:content_type => "application/json; charset=utf-8"})     

     BigCartel::Product.all("park", {:limit => 5})
     a_request(:get, "api.bigcartel.com/park/products.js?limit=5").
            should have_been_made
   end  
 end
 
 
end
