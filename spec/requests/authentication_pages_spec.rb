require 'spec_helper'  

describe "Authentication" do
  subject { page }
  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_selector('title', text: 'Sign in') }
#      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { should have_error_message('Invalid') }
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
      end
    end
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it { should have_selector('title', text: user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
#        before { sign_in user }
        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
          describe "when signing in again" do
#            before do
#              visit signin_path
#              fill_in "Email",    with: user.email
#              fill_in "Password", with: user.password
#              click_button "Sign in"
#            end
            before { sign_in user }
            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end
      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
          it { should_not have_link('Users',    href: users_path) }
          it { should_not have_link('Profile',  href: user_path(user)) }
          it { should_not have_link('Settings', href: edit_user_path(user)) }
          it { should_not have_link('Sign out', href: signout_path) }
        end
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
          it { should_not have_link('Users',    href: users_path) }
          it { should_not have_link('Profile',  href: user_path(user)) }
          it { should_not have_link('Settings', href: edit_user_path(user)) }
          it { should_not have_link('Sign out', href: signout_path) }
        end
      end
    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end
      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }
      describe "trying to DELETE self" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    describe "as signed-in user" do   # should redirect to root if try to do New or Create
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      describe "trying to access New directly" do
        before { visit new_user_path }
        it { should_not have_selector('title', text: '|') }      
#        it { should have_selector('title', text: base_title) }   # undefined var base_title
        it { should have_selector('h1', text: 'Welcome to') }
      end
      describe "trying to access Create directly" do
        before { visit signup_path }
        it { should_not have_selector('title', text: '|') }
        it { should have_selector('h1', text: 'Welcome to') }
      end
    end
  end
end
