class Rollin::YearArchive
  attr_reader :year, :monthly_archive

  def initialize(year, monthly_archive)
    @year, @monthly_archive = year, monthly_archive
  end

  def articles
    monthly_archive.map { |month_archive| month_archive.articles }.flatten
  end
end
