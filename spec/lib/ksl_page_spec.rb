require 'spec_helper'

describe 'KSLPage' do
  test_files = File.join(Rails.root, "test_data", "*.html")
  Dir.glob(test_files).each do |test_file|
    ad_number = test_file.split('/').last.scan(/\d/).join
    describe ad_number do
      before(:each) do
        @doc = Nokogiri::HTML(File.read(test_file))
        @ksl_page = KSLPage.new
      end
      
      it "shoud be parseable" do
        @doc.should be_instance_of(Nokogiri::HTML::Document)
      end
      
      it "should be scrapeable" do
        @ksl_page.scrape_doc(@doc)
        @ksl_page.ad_number.should_not be(nil)
        
        puts "------------"
        [ :title, :description, :image_url, :contact_name, :phone_numbers,
          :city, :state, :zip, :price, :ad_number, :post_date,
          :expire_date, :listing_type, :page_views, :breadcrumbs ].each do |attr|
          
          puts "#{attr.to_s}: #{@ksl_page.send(attr)}"
                    
        end  
        puts "------------"
      end

    end
  end

  describe "parses directly from KSL" do
    before(:each) do
      @ksl_page = KSLPage.new
    end
    
    (17294862..17294872).each do |ad_id|
      it "with ad_id of #{ad_id}" do
        @ksl_page.scrape_ad_id(ad_id)
        if @ksl_page.valid?
          puts "------------ AD: #{ad_id} ------------"
          [ :title, :description, :image_url, :contact_name, :phone_numbers,
            :city, :state, :zip, :price, :ad_number, :post_date,
            :expire_date, :listing_type, :page_views, :breadcrumbs ].each do |attr|

            puts "#{attr.to_s}: #{@ksl_page.send(attr)}"

          end
        else
          puts "Does not exist"
        end
      end
    end
  end
end
