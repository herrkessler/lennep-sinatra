class Lennep < Sinatra::Base

  # venue
  # -----------------------------------------------------------

  get '/venues' do
    @sessionUser = env['warden'].user
    @venues = Venue.all.paginate(:page => params[:page], :per_page => 35)
    @categories = Category.all
    slim :"venue/index", :layout => :layout_venue
  end

  get '/venues-map', :provides => :json do
    @sessionUser = env['warden'].user
    venues = Venue.all.paginate(:page => params[:page], :per_page => 35)
    return_data = [];
    return_data << venues
    halt 200, return_data.to_json
  end

  get '/venues/new' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      @venue = Venue.new
      @categories = Category.all
      slim :"venue/new"
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  post '/venues' do
    env['warden'].authenticate!
    @sessionUser = env['warden'].user
    venue = Venue.create(params[:venue])

    if venue.saved? == true
      flash[:success] = 'Neuer POI: "' + venue.title + '" angelegt'
      redirect to("/venues/#{venue.id}")
    else
      redirect to('/venues/new')
      flash[:error] = @venue
    end
  end

  get '/venues/:id' do
    @sessionUser = env['warden'].user
    @venue = Venue.get(params[:id])
    if @venue != nil
      slim :"venue/show"
    else
      flash[:error] = 'What you are looking for does not exist'
      redirect to("/venues")
    end
  end

  get '/venues/:id/edit' do
    env['warden'].authenticate!
    @sessionUser = env['warden'].user
    if env['warden'].user.admin?
      
      @venue = Venue.get(params[:id])
      @categories = Category.all
      slim :"venue/edit"
    else 
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  put '/venues/:id' do
    env['warden'].authenticate!
    @sessionUser = env['warden'].user
    if env['warden'].user.admin?
      
      venue = Venue.get(params[:id])
      venue.update(params[:venue])
      if venue.saved?
        flash[:success] = 'Venue update successful'
        redirect to("/venues/#{venue.id}")
      else
        flash[:error] = 'Something went wrong'
        redirect to("/venues/#{venue.id}/edit")
      end
    else 
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/venues/:id/addCategory/:category', :provides => :json do
    env['warden'].authenticate!
    @sessionUser = env['warden'].user
    if env['warden'].user.admin?
      
      venue = Venue.get(params[:id])
      category = Category.get(params[:category])
      selectedCategory = CategoryVenue.all(:venue_id => venue.id)
      if selectedCategory != []
        selectedCategory.destroy
        venue.categories << category
        venue.save
        venue.categories.save
        return_data = []
        return_data << venue
        halt 200, return_data.to_json
      else
        venue.categories << category
        venue.save
        venue.categories.save
        return_data = []
        return_data << venue
        halt 200, return_data.to_json
      end
    else 
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/venues/:id/add/:user' do

    env['warden'].authenticate!
    venue = Venue.get(params[:id])
    user = User.get(params[:user])
    user.venues << venue
    user.save
    user.venues.save
    if request.xhr?
      halt 200
    else
      flash[:success] = 'POI: "' + venue.title + '" zu Deinen Favouriten hinzugefuegt'
      redirect to("/venues/#{venue.id}")
    end
  end

  get '/venues/:id/delete/:user' do
    env['warden'].authenticate!
    venue = Venue.get(params[:id])
    user = User.get(params[:user])
    UserVenue.all(:user_id => user.id, :venue_id => venue.id).destroy
    if request.xhr?
      halt 200
    else
      flash[:success] = 'POI: "' + venue.title + '" aus Deinen Favouriten entfernt'
      redirect to("/venues/#{venue.id}")
    end
  end

end