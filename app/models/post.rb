class Post
  attr_accessor :title, :body, :blog

  def initialize(attrs = {})
    attrs.each do |k,v|
      send("#{k}=", v)
    end
  end

  def publish
    blog.add_entry(self)
  end
end
