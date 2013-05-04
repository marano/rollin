class Rollin::MetatagValue
  attr_reader :content, :articles

  def initialize(content, articles)
    @content, @articles = content, articles
  end
end
