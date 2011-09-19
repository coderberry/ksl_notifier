require 'spec_helper'

describe Ad do
  describe "Validations", :pending => true do
    
  end
  describe "Methods" do
    it "#init_from_remote_ad" do
      @ad = Ad.init_from_remote_ad('10187428')
      @ad.title.should eq("Vinyl material for your cutting machine")
      @ad.image_url.should eq("http://img.bonnint.net/slc/1897/189708/18970835.JPG")
    end
  end
end
