require 'rails_helper'

RSpec.feature "Users", type: :feature do
  context "signing up" do
    context "with valid information" do
      it "redirects to root path / has text Account created! / see full_name" do
        visit new_user_path

        fill_in "user_first_name", with: "Tam"
        fill_in "user_last_name", with: "Kbeili"
        fill_in "user_email", with: "tam@codecore.ca"
        fill_in "user_password", with: "supersecret"
        fill_in "user_password_confirmation", with: "supersecret"
        save_and_open_page

        click_button "Create User"

        expect(current_path).to eq(root_path)
        expect(page).to have_text /Account created!/i
      end
    end
  end
end
