require 'cucumber/rspec/doubles'

Given /the following terms exist/ do |terms_table|
    terms_table.hashes.each do |term|
        Term.create term
    end
end

Given /the following cohorts exist/ do |cohorts_table|
    cohorts_table.hashes.each do |cohort|
        Cohort.create cohort
    end
end

Given /the active term is "(.*)"/ do |term|
    active_term = Term.find_by(:name => term)
    Term.update_all active: false
    active_term.update_attributes!({:active => true, :opendate => DateTime.yesterday, :closedate => DateTime.yesterday, :term_code => "code", :courses_import_complete => true})
end

Given /"(.*)" is in the current term/ do |cohort|
    term = Term.find_by(:active => true)
    active_cohort = Cohort.find_by(:name => cohort)
    active_cohort.term_id = term.id
end

Given /I am logged in as an admin/ do
    @user = FactoryBot.create(:user, :role => "admin")
    visit "/"
    fill_login_form
end

When /I click "(.*)"/ do |action|
    click_link("#{action}", match: :first)
end

When /I fill in the new term form( without cohorts)?/ do |cohorts|
    select("New Test Term", from: 'Term')
    if not cohorts
        select("Apple", from: 'cohort_select')
    end
    click_button("Activate")
end

When /I fill in the open term form/ do
    Time::DATE_FORMATS[:month] = '%B'
    option = DateTime.current.next_month.to_s(:month)
    select(option, from: 'term_closedate_2i')
    if option == 'January'
        Time::Date_FORMATS[:year] = '%Y'
        year = DateTime.current.next_month.to_s(:year)
        select(year, from: 'term_closedate_1i')
    end
    click_button("Save")
end

Then /I should (not )?see "(.*)"/ do |is_not, string|
    if is_not
        expect(page.body.match?(/#{string}/m)).to eq false
    else
        expect(page.body.match?(/#{string}/m)).to eq true
    end
end

Then /the term "(.*)" should be selected/ do |term|
    selected_term = Term.find_by(:name => term)
    expect(page.body.match?(/<option selected="selected" value="#{selected_term.id}">#{term}<\/option>/)).to eq true
end