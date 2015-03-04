class Lennep < Sinatra::Base

  # category
  # -----------------------------------------------------------

  get '/categories' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      @categories = Category.all
      slim :"category/index", :layout => :layout
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/categories/new' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      
      @category = Category.new
      slim :"category/new"
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  post '/categories' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      category = Category.create(params[:category])

      if category.saved? == true
        flash[:success] = 'Neue Kategorie: "' + category.title + '" angelegt'
        redirect to("/categories/#{category.id}")
      else
        redirect to('/categories/new')
        flash[:error] = @categorie
      end
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/categories/:id/edit' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      @category = Category.get(params[:id])
      slim :"category/edit"
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  put '/categories/:id' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      category = Category.get(params[:id])
      category.update(params[:category])
      if category.saved?
        flash[:success] = 'Category update successful'
        redirect to("/categories/#{category.id}")
      else
        flash[:error] = 'Something went wrong'
        redirect to("/categories/#{category.id}/edit")
      end
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

  get '/categories/:id' do
    env['warden'].authenticate!
    if env['warden'].user.admin?
      @sessionUser = env['warden'].user
      @category = Category.get(params[:id])
      if @category != nil
        slim :"category/show"
      else
        flash[:error] = 'What you are looking for does not exist'
        redirect to("/categories")
      end
    else
      flash[:error] = 'Youre not the admin'
      redirect to('/')
    end
  end

end