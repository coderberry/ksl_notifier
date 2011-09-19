require 'spec_helper'

describe "ads/new.html.erb" do
  before(:each) do
    assign(:ad, stub_model(Ad).as_new_record)
  end

  it "renders new ad form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ads_path, :method => "post" do
    end
  end
end
