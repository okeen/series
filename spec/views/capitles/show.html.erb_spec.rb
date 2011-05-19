require 'spec_helper'

describe "capitles/show.html.erb" do
  before(:each) do
    @capitle = assign(:capitle, stub_model(Capitle,
      :title => "Title",
      :serie => nil,
      :season => 1,
      :order => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
