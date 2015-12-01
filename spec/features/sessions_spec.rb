require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  context "signing in" do
    let(:user) { create(:user) }

    it "correct credentials: takes you to root path / See your user name / see logout / see flash" do

      # visit the log in page
      visit new_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign In"

      expect(page).to have_text /#{user.full_name}/i
      expect(page).to have_selector "a", text: "Logout"
      expect(page).to have_text /You're Logged In/i
      expect(current_path).to eq(root_path)

    end

    it "incorrect credentials: renders sign in page / see alert message " do
      visit new_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password + "asdf"
      click_button "Sign In"

      expect(current_path).to eq(sessions_path)
      expect(page).to have_text /wrong credentials/i
      expect(page).not_to have_text /#{user.full_name}/i

    end

  end

end
