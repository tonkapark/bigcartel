require 'helper'

describe BigCartel do
  
  describe ".store" do
    it "should be a BigCartel::Store" do
      BigCartel.store("tonkapark").should be_a BigCartel::Store
    end    
      
    it "should have id" do
      store = BigCartel.store('tonkapark')
      store.id.should == 'tonkapark'
    end
    
  end
  
end
