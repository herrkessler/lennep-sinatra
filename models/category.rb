class Category
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :title, String
  property :synopsis, Text
  property :slug, String
  property :created_at, DateTime, :lazy => [ :show ]
  property :update_at, DateTime, :lazy => [ :show ]

  has n, :venues, :through => Resource
end