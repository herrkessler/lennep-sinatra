class Lennep < Sinatra::Base

  # Favourites without account
  # -----------------------------------------------------------

   get '/favourites' do
      reqVenues = params[:favs].split(",").map { |s| s.to_i }
      @venues = Venue.all(:id => reqVenues)
      slim :"favourites/index"
   end

end