require 'open-uri'
require 'nokogiri'

class KSLPage
  
  attr_accessor :title, :description, :image_url, :contact_name, :phone_numbers,
                :city, :state, :zip, :price, :ad_number, :post_date,
                :expire_date, :listing_type, :page_views, :breadcrumbs
  
  def scrape_doc(doc)
    @doc = doc
    scrape
  end
  
  def scrape_ad_id(ad_id)
    @doc = Nokogiri::HTML(open("http://www.ksl.com/index.php?nid=218&ad=#{ad_id}"))
    scrape
  end
  
  def valid?
    @doc.search('div.productPriceBox').first.present?
  end
  
  def scrape
    if valid?
      parse_title(@doc)
      parse_description(@doc)
      parse_image_url(@doc)
      parse_contact_name(@doc)
      parse_phone_numbers(@doc)
      parse_price(@doc)
      parse_breadcrumbs(@doc)

      csz_str = @doc.search("div.productContentLoc").text.to_s
      parse_city(csz_str)
      parse_state(csz_str)
      parse_zip(csz_str)
    
      more_info = @doc.search('div.productMoreInfo > span.productMoreInfoData').map(&:text)
      parse_ad_number(more_info)
      parse_post_date(more_info)
      parse_expire_date(more_info)
      parse_listing_type(more_info)
      parse_page_views(more_info)
    end
  end
  
  private
  
    def parse_title(doc)
      @title = doc.search("div.productContentTitle").text.strip
    end
  
    def parse_description(doc)
      @description = doc.search("div.productContentText").text.strip
    end
    
    def parse_image_url(doc)
      @image_url = doc.search('div.productImage').search('img').first.attributes['src'].value.split("?").first
      if @image_url.include? "/resources/classifieds/"
        @image_url = nil
      end
    end
  
    def parse_contact_name(doc)
      @contact_name = doc.search("div.productContactName").text.strip
    end
  
    def parse_phone_numbers(doc)
      @phone_numbers = []
      doc.search("div.productContactPhone").each do |item|
        str = item.text.to_s
        @phone_numbers << str.scan(/(\d+)/).flatten.join('-')
      end
      @phone_numbers = @phone_numbers.uniq
    end
  
    def parse_city(csz_str)
      @city = csz_str.scan(/(.*),\s+([a-zA-Z]+)\D*(\d+)/)[0][0]
    end
    
    def parse_state(csz_str)
      @state = csz_str.scan(/(.*),\s+([a-zA-Z]+)\D*(\d+)/)[0][1]
    end
    
    def parse_zip(csz_str)
      @zip = csz_str.scan(/(.*),\s+([a-zA-Z]+)\D*(\d+)/)[0][2]
    end
  
    def parse_price(doc)
      dollars = doc.search('div.productPriceBox').first.children.first.text.strip.gsub(/\$|,/,'')
      cents = doc.search('div.productPriceBox > span.productPriceCents').text.strip
      @price = "#{dollars}.#{cents}".to_f
    end
    
    def parse_breadcrumbs(doc)
      @breadcrumbs = doc.search('div.productTopBreadCrumbs > a').map(&:text)
    end
  
    def parse_ad_number(more_info)
      @ad_number = more_info[0]
    end
  
    def parse_post_date(more_info)
      @post_date = Date.parse(more_info[1])
    end
  
    def parse_expire_date(more_info)
      @expire_date = Date.parse(more_info[2])
    end
  
    def parse_listing_type(more_info)
      @listing_type = more_info[5]
    end
  
    def parse_page_views(more_info)
      @page_views = more_info[6]
    end
  
end