class Lennep < Sinatra::Base

  # Dashbaord
  # -----------------------------------------------------------

  get '/dashboard/:id' do
    env['warden'].authenticate!
    @user = User.get(params[:id])
    @user_venues = @user.venues.sort_by {|venue| venue.title}

    # Render View

    if @user == env['warden'].user
      @sessionUser = env['warden'].user
      slim :"dashboard/show"
    else
      flash[:error] = 'You are not allowed to view this site!'
      redirect to("/")
    end
  end

end