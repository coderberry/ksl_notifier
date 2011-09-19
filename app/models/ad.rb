class Ad
  include Mongoid::Document
  
  # Fields
  field :ad_number, :type => BigDecimal
  field :title, :type => String
  field :price, :type => Float
  field :post_date, :type => Date
  field :expire_date, :type => Date
  field :listing_type, :type => String
  field :page_views, :type => Integer
  field :image_url, :type => String
  field :city, :type => String
  field :state, :type => String
  field :zip, :type => String
  field :description, :type => String
  field :contact_name, :type => String
  field :phone_numbers, :type => Array
  field :breadcrumbs, :type => Array
  
  # Indexes
  index :ad_number, unique: true
  index :breadcrumbs, unique: true
  
  # Validations
  validates_presence_of :ad_number
  validates_uniqueness_of :ad_number
  validates_presence_of :title
  validates_presence_of :post_date
  validates_presence_of :expire_date
  
  # Methods
  
  def self.init_from_remote_ad(ad_id)
    @ksl_page = KSLPage.new
    @ksl_page.scrape_ad_id(ad_id)
    if @ksl_page.valid?
      ad = Ad.new
      ad.ad_number     = @ksl_page.ad_number
      ad.title         = @ksl_page.title
      ad.price         = @ksl_page.price
      ad.post_date     = @ksl_page.post_date
      ad.expire_date   = @ksl_page.expire_date
      ad.listing_type  = @ksl_page.listing_type
      ad.page_views    = @ksl_page.page_views
      ad.image_url     = @ksl_page.image_url
      ad.city          = @ksl_page.city
      ad.state         = @ksl_page.state
      ad.zip           = @ksl_page.zip
      ad.description   = @ksl_page.description
      ad.contact_name  = @ksl_page.contact_name
      ad.phone_numbers = @ksl_page.phone_numbers
      ad.breadcrumbs   = @ksl_page.breadcrumbs
      ad.save
      return ad
    else
      raise "Ad does not exist"
    end
  end
  
  def self.init_from_range(first_id, last_id)
    (first_id..last_id).each do |ad_id|
      begin
        ad = Ad.init_from_remote_ad(ad_id)
        puts "#{ad.title}"
      rescue
        puts "Ad does not exist"
      end
    end
  end
  
  def self.sub_categories(parent_category_name)
    criteria = Ad.any_in(breadcrumbs: [parent_category_name])
    criteria.execute.map{ |it| it.breadcrumbs }.map(&:last).uniq.sort
  end
  
  def self.top_level_categories
    Ad.all.execute.map{ |it| it.breadcrumbs }.map(&:first).uniq.sort
  end
  
  def self.ads_in_category(category_name)
    if category_name
      Ad.any_in(breadcrumbs: [category_name])
    else
      Ad.all
    end
  end
  
  def small_image_url
    if image_url
      "#{image_url}?filter=marketplace/product_large"
    else
      "/images/missing.png"
    end
  end
end
