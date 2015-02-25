class Lennep < Sinatra::Base

  # Login
  # -----------------------------------------------------------

   get '/auth/login' do
     slim :"login"
   end

   post '/auth/login' do
    env['warden'].authenticate!
    if session[:return_to].nil?
      sessionUser = env['warden'].user

      # flash[:success] = 'Hallo ' +sessionUser.forename+ ', du hast Dich erfolgreich eingeloggt.'
      flash[:success] = env['warden'].message
      redirect to("/")
    else
      redirect session[:return_to]
      flash[:error] = env['warden'].message
    end
  end
     
  get '/auth/logout' do
    sessionUser = env['warden'].user
    
    env['warden'].raw_session.inspect
    env['warden'].logout

    flash[:success] = 'Du hast Dich erfolgreich ausgeloggt.'
    redirect '/'
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    puts env['warden.options'][:attempted_path]
    puts env['warden']
    flash[:error] = env['warden'].message || "Du musst Dich anmelden um diese Seite sehen zu können"
    redirect '/auth/login'
end

end