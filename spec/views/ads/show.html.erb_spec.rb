require 'spec_helper'

describe "ads/show.html.erb" do
  before(:each) do
    @ad = assign(:ad, stub_model(Ad))
  end

  it "renders attributes in <p>" do
    render
  end
end
