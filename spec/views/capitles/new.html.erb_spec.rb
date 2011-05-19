require 'spec_helper'

describe "capitles/new.html.erb" do
  before(:each) do
    assign(:capitle, stub_model(Capitle,
      :title => "MyString",
      :serie => nil,
      :season => 1,
      :order => 1
    ).as_new_record)
  end

  it "renders new capitle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => capitles_path, :method => "post" do
      assert_select "input#capitle_title", :name => "capitle[title]"
      assert_select "input#capitle_serie", :name => "capitle[serie]"
      assert_select "input#capitle_season", :name => "capitle[season]"
      assert_select "input#capitle_order", :name => "capitle[order]"
    end
  end
end
