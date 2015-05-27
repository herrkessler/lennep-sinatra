class Favourite
  include DataMapper::Resource

  property :id, Serial, :key => true

  property :created_at, DateTime, :lazy => [ :show ]
  property :update_at, DateTime, :lazy => [ :show ]

  belongs_to :user, :key => true
  belongs_to :venue, :key => true
end