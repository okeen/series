require 'spec_helper'

describe "series/new.html.erb" do
  before(:each) do
    assign(:serie, stub_model(Serie,
      :title => "MyString",
      :description => "MyText",
      :seasons_count => 1,
      :capitles_count => 1
    ).as_new_record)
  end

  it "renders new serie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => series_path, :method => "post" do
      assert_select "input#serie_title", :name => "serie[title]"
      assert_select "textarea#serie_description", :name => "serie[description]"
      assert_select "input#serie_seasons_count", :name => "serie[seasons_count]"
      assert_select "input#serie_capitles_count", :name => "serie[capitles_count]"
    end
  end
end
