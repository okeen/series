require 'spec_helper'

describe "series/show.html.erb" do
  before(:each) do
    @serie = assign(:serie, stub_model(Serie,
      :title => "Title",
      :description => "MyText",
      :seasons_count => 1,
      :capitles_count => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
