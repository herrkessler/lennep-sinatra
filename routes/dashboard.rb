class Lennep < Sinatra::Base

  # Dashbaord
  # -----------------------------------------------------------

  get '/dashboard/:id' do
    env['warden'].authenticate!
    @user = User.get(params[:id])
    @user_venues = @user.venues.sort_by {|venue| venue.title}

    # Render View

    if @user != nil
      @sessionUser = env['warden'].user
      slim :"dashboard/show"
    else
      flash[:error] = 'What you are looking for does not exist'
      redirect to("/")
    end
  end

end