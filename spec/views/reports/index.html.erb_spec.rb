require 'rails_helper'

RSpec.describe "reports/index", type: :view do
  before(:each) do
    assign(:reports, [
      Report.create!(
        :group_by => 2,
        :unit => false,
        :state => false,
        :kind => false,
        :onu => false,
        :blend => false,
        :code => false,
        :total => "",
        :collection => nil
      ),
      Report.create!(
        :group_by => 2,
        :unit => false,
        :state => false,
        :kind => false,
        :onu => false,
        :blend => false,
        :code => false,
        :total => "",
        :collection => nil
      )
    ])
  end

  it "renders a list of reports" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
