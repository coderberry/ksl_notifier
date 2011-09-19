require 'spec_helper'

describe "ads/index.html.erb" do
  before(:each) do
    assign(:ads, [
      stub_model(Ad),
      stub_model(Ad)
    ])
  end

  it "renders a list of ads" do
    render
  end
end
