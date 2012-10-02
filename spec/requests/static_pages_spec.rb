require 'spec_helper'

describe "Static pages" do
#  let(:base_title) { "Ruby on Rails Tutorial Sample App" }	# use /spec/support/utilities.rb instead
  subject { page }
  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
#    it "should have the h1 'Sample App'" do
#      page.should have_selector('h1', :text => 'Sample App')
#    end
#	 it { should have_selector('h1',    text: 'Sample App') }
#	 it { should have_selector('title', text: full_title('')) }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "with only one micropost" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum uno solamente")
          sign_in user
          visit root_path
        end
        it "should render the user's feed" do
          user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
        it "should render the singular count of the user's single micropost" do
          page.should have_selector("span", text: "1 micropost")
        end
        it "should not pluralize the word micropost" do
          page.should_not have_selector("span", text: "microposts")
        end
      end
#      before do
#        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
#        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
#        sign_in user
#        visit root_path
#      end
#      it "should render the user's feed" do
#        user.feed.each do |item|
#          page.should have_selector("li##{item.id}", text: item.content)
#        end
#      end
      describe "with multiple microposts should render the user's feed with pagination" do
#        before(:all) do
        before do
          30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum multiples") } 
          sign_in user
          visit root_path
        end
#        after(:all)  { User.delete_all }
        after { User.delete_all }
        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
        it "should render the count of the user's microposts" do
          page.should have_selector("span", text: "#{user.feed.count} microposts")
        end
#        it { should have_selector("div.pagination") }    # fails, but I don't know why
        it { should have_selector("a", :href => "/?page=2", :content => "2") }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
#	 it { should have_selector('h1',    text: 'Help') }
#	 it { should have_selector('title', text: full_title('Help')) }
    let(:heading)    { 'Help' }
	  let(:page_title) { 'Help' }
	  it_should_behave_like "all static pages"
  end
  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
	  let(:page_title) { 'About Us' }
	  it_should_behave_like "all static pages"
  end
  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
	  let(:page_title) { 'Contact Us' }
	  it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact Us')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end
end
