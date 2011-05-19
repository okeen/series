require 'spec_helper'

describe "series/edit.html.erb" do
  before(:each) do
    @serie = assign(:serie, stub_model(Serie,
      :title => "MyString",
      :description => "MyText",
      :seasons_count => 1,
      :capitles_count => 1
    ))
  end

  it "renders the edit serie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => series_path(@serie), :method => "post" do
      assert_select "input#serie_title", :name => "serie[title]"
      assert_select "textarea#serie_description", :name => "serie[description]"
      assert_select "input#serie_seasons_count", :name => "serie[seasons_count]"
      assert_select "input#serie_capitles_count", :name => "serie[capitles_count]"
    end
  end
end
