require "bcrypt"
require "gravatarify"

# -----------------------------------------------------------
# DataMapper Setup
# -----------------------------------------------------------

# DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 
# DataMapper::setup(:default, "postgres:lennepMap")

# :production
DataMapper::setup(:default, ENV["HEROKU_POSTGRESQL_IVORY_URL"] || "postgres://lpgonkfzpqtzra:qzmoEyeZ_xAeQnXdlUMnztMPl1@ec2-107-21-102-69.compute-1.amazonaws.com/dflo4qtaut1i4m")

# -----------------------------------------------------------
# Model and Associations
# -----------------------------------------------------------

require_relative "models/user"
require_relative "models/venue"
require_relative "models/post"
require_relative "models/category"
require_relative "models/favourite"

# -----------------------------------------------------------
# DataMapper Finalization
# -----------------------------------------------------------

DataMapper.finalize
DataMapper.auto_upgrade!

# -----------------------------------------------------------
# Create Dummy Data
# -----------------------------------------------------------

if User.count == 0
  user = User.new()
  user.username = "admin"
  user.email = "admin@lennep.map"
  user.password = "admin"
  user.forename = "the ADMIN"
  user.familyname = ""
  user.admin = true
  user.avatar = ""
  user.save
end

if Post.count == 0
  post = Post.new()
  post.title = "Erster Eintrag"
  post.synopsis = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
  post.content = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
  post.user_id = 1
  post.save
end

if Venue.count == 0
  venue = Venue.new()
  venue.attributes = {:title => "Pizzeria Daunia"}
  venue.description = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
  venue.street = "Badische Str. 76 "
  venue.zip = "42389"
  venue.town = "Wuppertal"
  venue.url = "http://www.wupperwaende.de/"
  venue.save
end


if Favourite.count == 0
  user = User.get(1)
  venue = Venue.get(1)
  favourite = Favourite.new()

  favourite.user_id = user.id
  favourite.venue_id = venue.id

  user.favourites << favourite
  user.favourites.save

  venue.favourites << favourite
  venue.favourites.save
  
  favourite.save
end