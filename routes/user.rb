class Lennep < Sinatra::Base

  # User
  # -----------------------------------------------------------

  get '/users' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      
      @sessionUser = env['warden'].user
      @users = User.all(:order => [:username.asc]).paginate(:page => params[:page], :per_page => 100)
      slim :"user/index"
    else 
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/users/new' do
    @user = User.new
    slim :"user/new"
  end

  post '/users' do

    data = params[:user]
    cookieVenues = cookies[:favourites]

    if data[:username].empty? or data[:email].empty? or data[:password].empty?
      flash[:error] = 'Something was missing'
      redirect to("/users/new")
    elsif data[:password] != data[:repeated_password]
      flash[:error] = 'Your passwords did not match'
      redirect to("/users/new")
    else
      data = data.except('repeated_password')
      @user = User.create(data)

      # Add Favourites from JSsession

      reqVenues = cookieVenues.split(",").map { |s| s.to_i }
      @venues = Venue.all(:id => reqVenues)
      @user.venues.concat(@venues)
      @user.save
      @user.venues.save

      cookies[:favourites] = ''

      if @user.saved?

        # Send welcome mail

        mandrill = Mandrill::API.new 'szZU6o0dhGUZ-e2dQEqdyg'
        message = {
            :subject => 'Howdy, ' + @user.forename,
            :from_name => "lennep.map",
            :text => 'Willkommen bei lennep.map.',
            :to => [
                {
                    :email => @user.email,
                    :name => @user.forename
                 }
            ],
            :html =>'<html><b>Willkommen bei lennep.map.</b></html>',
            :from_email => "willkommen@lennep.map"
        }
        sending = mandrill.messages.send message

        # Redirect to login

        flash[:new_user] = 'Hallo ' + @user.forename + ', du kannst Dich nun einloggen'
        redirect to("/auth/login")


      else

        flash[:error] = 'Something went wrong while signing up'
        redirect to("/users/new")

      end
    end
  end

  get '/users/:id' do
    env['warden'].authenticate!
    @user = User.get(params[:id])
    @user_venues = @user.venues.sort_by {|venue| venue.title}

    # Render View

    if @user != nil
      @sessionUser = env['warden'].user
      slim :"user/show"
    else
      flash[:error] = 'What you are looking for does not exist'
      redirect to("/")
    end
  end

  get '/users/:id/edit' do
    env['warden'].authenticate!
    @user = User.get(params[:id])
    
    slim :"user/edit"
  end

  put '/users/:id' do
    env['warden'].authenticate!
    user = User.get(params[:id])
    user.update(params[:user])
    if user.saved?
      flash[:success] = 'User update successful'
      redirect to("/users/#{user.id}")
    else
      flash[:error] = 'Something went wrong'
      redirect to("/users/#{user.id}/edit")
    end
  end

  delete '/users/:id' do
    env['warden'].authenticate!
    User.get(params[:id]).destroy
    redirect to('/')
  end

end