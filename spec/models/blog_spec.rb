require_relative '../spec_helper_lite'
require_relative '../../app/models/blog'

describe Blog do
  def stub_entry_with_date(date)
    OpenStruct.new(:pubdate => DateTime.parse(date))
  end

  before do
    @it = Blog.new
  end

  it "should have no entries" do
    @it.entries.must_be_empty
  end

  describe "#new_post" do
    before do
      @new_post = OpenStruct.new
      @it.post_maker = ->{ @new_post }
    end

    it "should return a new post" do
      @it.new_post.must_equal @new_post
    end

    it "should set the post's blog reference to itself" do
      @it.new_post.blog.must_equal(@it)
    end

    it "should accept an attribute hash on behalf of the post maker" do
      post_maker = MiniTest::Mock.new
      post_maker.expect(:call, @new_post, [{:x => 42, :y => 'z'}])
      @it.post_maker = post_maker
      @it.new_post(:x => 42, :y => 'z')
      post_maker.verify
    end
  end

  describe "#add_entry" do
    it "should add entry to the blog" do
      entry = stub_entry_with_date("2011-09-09")
      @it.add_entry(entry)
      @it.entries.must_include(entry)
    end
  end

  describe "#entries" do
    it "should be sorted in reverse-chronological order" do
      oldest = stub_entry_with_date("2011-09-09")
      newest = stub_entry_with_date("2011-09-11")
      middle = stub_entry_with_date("2011-09-10")

      @it.add_entry(oldest)
      @it.add_entry(newest)
      @it.add_entry(middle)
      @it.entries.must_equal([newest, middle, oldest])
    end

    it "should be limited to 10 items" do
      10.times do |i|
        @it.add_entry(stub_entry_with_date("2011-09-#{i+1}"))
      end

      oldest = stub_entry_with_date("2011-08-30")

      @it.add_entry(oldest)
      @it.entries.size.must_equal(10)
      @it.entries.wont_include(oldest)
    end
  end
end
