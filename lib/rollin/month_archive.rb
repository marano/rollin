class Rollin::MonthArchive
  attr_reader :year, :month, :articles

  def initialize(year, month, articles)
    @year, @month, @articles = year, month, articles
  end
end
