class Post
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :title, :body, :blog
  attr_reader :pubdate

  def initialize(attrs = {})
    attrs.each do |k,v|
      send("#{k}=", v)
    end
  end

  def publish(clock = DateTime)
    @pubdate = clock.now
    blog.add_entry(self)
  end

  def persisted?
    false
  end
end
