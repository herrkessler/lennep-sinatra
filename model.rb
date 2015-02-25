require "bcrypt"
require "gravatarify"

# -----------------------------------------------------------
# DataMapper Setup
# -----------------------------------------------------------

# DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 
DataMapper::setup(:default, "postgres:lennepMap")

# :production
#   DataMapper::setup(:default, ENV["HEROKU_POSTGRESQL_IVORY_URL"] || "postgres://gdvmfswxmmbcvb:wN5vnndqzGC3oJw5icH7Q_PL_A@ec2-107-20-191-205.compute-1.amazonaws.com/dbnt3lljncbi21")

# -----------------------------------------------------------
# Model and Associations
# -----------------------------------------------------------

require_relative "models/user"
require_relative "models/venue"
require_relative "models/post"
require_relative "models/category"

# -----------------------------------------------------------
# DataMapper Finalization
# -----------------------------------------------------------

DataMapper.finalize
DataMapper.auto_upgrade!

# -----------------------------------------------------------
# Create Dummy Data
# -----------------------------------------------------------

if User.count == 0
  @user = User.new()
  @user.username = "admin"
  @user.email = "admin@lennep.map"
  @user.password = "admin"
  @user.forename = "the ADMIN"
  @user.familyname = ""
  @user.admin = true
  @user.avatar = ""
  @user.save
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