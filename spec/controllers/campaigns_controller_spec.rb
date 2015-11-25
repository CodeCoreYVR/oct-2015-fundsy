require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do

  # let will define a variable names whatever you give to the let which is `user`
  # in this case. The variable will be available in any test exmple within the
  # same `describe` or `context`. This `let` is defined in the top level describe
  # which makes it availalbe for all examples.
  # `let` will only invoke the block you give it when you call the variable.
  # if you use `let!` then it will automatically invoke the block every time
  # you run an example even if you don't use the variable.
  let(:user) { FactoryGirl.create(:user) }
  # def user
  #   @user ||= FactoryGirl.create(:user)
  # end

  describe "#new" do
    context "with user not signed in" do
      it "redirects to user sign up page" do
        get :new
        expect(response).to redirect_to(new_user_path)
      end
    end
    context "with user signed in" do
      before do
        # GIVEN
        u = FactoryGirl.create(:user)
        request.session[:user_id] = u.id

        # WHEN
        get :new
      end

      it "renders the new template" do
        # THEN
        expect(response).to render_template(:new)
      end

      it "create a new campaign object assigned to `campaign` instance variable" do
        # THEN
        expect(assigns(:campaign)).to be_a_new(Campaign)
      end
    end
  end

  describe "#create" do
    context "with no user signed in" do
      it "redirects to the sign up page" do
        post :create, {campaign: {}} # params don't matter here becuase the
                                     # controller should redirect before making
                                     # use of the campaign params
        expect(response).to redirect_to new_user_path
      end
    end

    context "With user signed in" do
      def valid_params
        FactoryGirl.attributes_for(:campaign)
      end

      before do
        request.session[:user_id] = user.id
      end

      context "with valid parameters" do
        it "creates a campaign record in the database" do
          before_count = Campaign.count
          post :create, campaign: valid_params
          after_count  = Campaign.count
          expect(after_count - before_count).to eq(1)
        end

        it "associates the campaign with the signed in user" do
          post :create, campaign: valid_params
          expect(Campaign.last.user).to eq(user)
        end

        it "redirects to campaign show page" do
          post :create, campaign: valid_params
          expect(response).to redirect_to(campaign_path(Campaign.last))
        end
      end
      context "with invalid parameters" do
        def request_with_invalid_title
          post :create, campaign: valid_params.merge({title: nil})
        end

        it "doesn't create a campaign record in the database" do
          # expect { request_with_invalid_title }.not_to change { Campaign.count }
          before_count = Campaign.count
          request_with_invalid_title
          after_count  = Campaign.count
          expect(before_count).to eq(after_count)
        end

        it "renders the new template" do
          request_with_invalid_title
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
