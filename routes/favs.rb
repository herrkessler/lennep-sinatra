class Lennep < Sinatra::Base

  # Favourites without account
  # -----------------------------------------------------------

   get '/favourites' do
    @sessionUser = env['warden'].user
    unless @sessionUser == nil
      @favs = @sessionUser.favourites
      slim :"favourites/index"
    else
      reqVenues = params[:favs].split(",").map { |s| s.to_i }
      @favs = Venue.all(:id => reqVenues)
      slim :"favourites/nosession-index"
    end
   end

end