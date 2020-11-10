Then(/^I should see the (.+) page$/) do |page_name|
  if page_name == 'closed'
    expect(current_path).to eq "/student/closed"
  elsif page_name == 'terms'
    expect(current_path).to eq "/student/view_terms"
  elsif page_name == 'new term'
    expect(current_path).to eq "/admin/new_term"
  elsif page_name == 'admin terms'
    expect(current_path).to eq "/admin/view_term_admin"
  elsif page_name == 'open semester'
    expect(current_path).to eq "/admin/open_semester"
  elsif page_name == 'login'
    expect(current_path).to eq "/"
  elsif page_name == 'view cohort semester'
    expect(current_path).to eq "/admin/view_cohort_semester"
  else
    fail("not valid page name")
  end
end

Then (/^I should see the (.+) page for (.+)$/) do |page_name, cohort_name|
  term = Term.find_by(:active => true)
  active_cohort = Cohort.find_by(:name => cohort_name)
  if page_name == 'view result'
    puts page.body
    expect(current_path).to eq "/admin/view_result/#{active_cohort.id}"
  elsif page_name == 'view cohort'
    expect(current_path).to eq "/admin/cohorts/#{active_cohort.id}"
  elsif page_name == 'view conflicts'
    #timeslot = TimeSlot.find_by(:time => DateTime.new(2001,2,3,8,0,6,'-05:00'), :cohort_id => active_cohort.id)
    timeslot = TimeSlot.where(:cohort_id => active_cohort.id).order(:cost).limit(1).first
    puts timeslot.time
    expect(current_path).to eq "/admin/view_conflicts/#{active_cohort.id}/#{timeslot.id+1}"
  else
    fail("not valid page name")
  end
end

When /I click the logo/ do
  click_link("Tamu zlp logo", match: :first)
end