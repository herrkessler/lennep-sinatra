class Lennep < Sinatra::Base

  # Favourites without account
  # -----------------------------------------------------------

   get '/favourites' do
      @sessionUser = env['warden'].user
      @favs = @sessionUser.favourites
      slim :"favourites/index"
   end

end