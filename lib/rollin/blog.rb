class Rollin::Blog
  def initialize(options = {})
    @articles_folder = options[:articles_folder] || 'articles'
  end

  def find(search)
    articles.find { |article| article.matches?(search) }
  end

  def find_all(search)
    articles.select { |article| article.matches?(search) }
  end

  def articles
    Dir["#{@articles_folder}/**/*.mk"].sort.map do |article_source|
      Rollin::Article.new(article_source)
    end
  end

  def annual_archive
    monthly_archive.map { |month_archive| month_archive.year }.uniq.map do |year|
      Rollin::YearArchive.new(year, monthly_archive.select { |aMonth| aMonth.year == year })
    end
  end

  def monthly_archive
    articles.map { |article| [article.year, article.month] }.uniq.map do |year_and_month|
      year = year_and_month[0]
      month = year_and_month[1]
      articles_for_month = articles.select { |anArticle| anArticle.year == year && anArticle.month == month }
      Rollin::MonthArchive.new(year, month, articles_for_month)
    end
  end
end
