require 'rails_helper'

RSpec.describe "reports/edit", type: :view do
  before(:each) do
    @report = assign(:report, Report.create!(
      :group_by => 1,
      :unit => false,
      :state => false,
      :kind => false,
      :onu => false,
      :blend => false,
      :code => false,
      :total => "",
      :collection => nil
    ))
  end

  it "renders the edit report form" do
    render

    assert_select "form[action=?][method=?]", report_path(@report), "post" do

      assert_select "input#report_group_by[name=?]", "report[group_by]"

      assert_select "input#report_unit[name=?]", "report[unit]"

      assert_select "input#report_state[name=?]", "report[state]"

      assert_select "input#report_kind[name=?]", "report[kind]"

      assert_select "input#report_onu[name=?]", "report[onu]"

      assert_select "input#report_blend[name=?]", "report[blend]"

      assert_select "input#report_code[name=?]", "report[code]"

      assert_select "input#report_total[name=?]", "report[total]"

      assert_select "input#report_collection_id[name=?]", "report[collection_id]"
    end
  end
end
