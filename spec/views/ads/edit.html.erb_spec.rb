require 'spec_helper'

describe "ads/edit.html.erb" do
  before(:each) do
    @ad = assign(:ad, stub_model(Ad))
  end

  it "renders the edit ad form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ads_path(@ad), :method => "post" do
    end
  end
end
