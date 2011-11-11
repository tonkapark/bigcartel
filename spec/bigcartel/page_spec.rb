require 'helper'

describe BigCartel::Store do
  
   before do
     stub_request(:get, "api.bigcartel.com/park/page/about.js").
      to_return(:body=>fixture("page.json"), :headers => {:content_type => "application/json; charset=utf-8"})
   end

   it "BigCartel::Page.find return a page" do     
     BigCartel::Page.find("park", "about")
     a_request(:get, "api.bigcartel.com/park/page/about.js").
            should have_been_made
   end   
          
    describe 'should build hash' do
      before(:each) { @store = BigCartel::Page.find("park", "about")}
      
      it "should have a permalink" do                
        @store.permalink.should be_a String
        @store.permalink.should eq("about")
      end  
      
      it { @store.content.should be_a String }
      it { @store.category.should be_a String  }
      it { @store.name.should be_a String  }
      it { @store.url.should be_a String  }
      it { @store.id.should be_an Integer  }
    end
             
  
end
