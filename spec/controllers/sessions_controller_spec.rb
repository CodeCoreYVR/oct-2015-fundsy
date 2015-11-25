require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    it "renders the new template"
  end

  describe "#create" do
    context "with correct credentials" do
      it "sets the sessions user_id to the user with the email"
      it "redirects to home page"
    end
    context "with incorrect credentials" do
      it "renders the new template"
      it "shows an alert message"
      it "doesn't set the sessions id"
    end
  end

  describe "#destroy" do
    it "sets the sessions id to nil for the :user_id"
    it "redirects to home page"
  end
end
