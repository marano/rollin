class Rollin::MonthArchive
  attr_reader :year, :month

  def initialize(year, month)
    @year, @month = year, month
  end

  def articles
  end
end
