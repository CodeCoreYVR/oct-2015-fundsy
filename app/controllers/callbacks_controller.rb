class CallbacksController < ApplicationController

  def index
    omniauth_data = request.env['omniauth.auth']
    user = User.where(uid:      omniauth_data["uid"],
                      provider: omniauth_data["provider"]).first
    # user doesn't exist in the database
    unless user
      full_name = omniauth_data["info"]["name"].split
      user = User.create!(first_name: full_name[0],
                         last_name:  full_name[1],
                         address:    omniauth_data["info"]["location"],
                         uid:        omniauth_data["uid"],
                         provider:   omniauth_data["provider"],
                         twitter_client_token: omniauth_data["credentials"]["token"],
                         twitter_client_secret:  omniauth_data["credentials"]["secret"],
                         twitter_raw_data: omniauth_data,
                         password:         SecureRandom.hex(32))

    end
    session[:user_id] = user.id
    redirect_to root_path, notice: "Sigend in!"
  end
end
