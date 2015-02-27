class Category
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :title, String
  property :synopsis, Text
  property :slug, String
  property :icon, String
  property :colour, String
  property :created_at, DateTime, :lazy => [ :show ]
  property :update_at, DateTime, :lazy => [ :show ]

  has n, :venues, :through => Resource

  before :save, :sluggish

  def sluggish
    self.slug = self.title.to_s.downcase
  end
end