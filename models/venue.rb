class Venue
  include DataMapper::Resource

  property :id, Serial

  property :title, String, :required => true, :length => 128
  property :description, Text, :lazy => [ :show ]

  property :street, String, :lazy => [ :show ]
  property :zip, String, :lazy => [ :show ]
  property :town, String, :lazy => [ :show ]
  property :location, PgHStore, :default => {lat: "", lng: ""}

  property :url, String

  property :gallery, PgArray

  property :created_at, DateTime, :lazy => [ :show ]
  property :update_at, DateTime, :lazy => [ :show ]

  has n, :categories, :through => Resource
  has n, :favourites, :through => Resource

  before :save do
    full_address = self.street, self.zip, self.town
    data = Geokit::Geocoders::GoogleGeocoder.geocode full_address.to_s
    self.attributes = {:location => {lat: data.lat, lng: data.lng}}
  end
end