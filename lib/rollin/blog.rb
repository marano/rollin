class Rollin::Blog
  def initialize(options = {})
    @articles_folder = options[:articles_folder] || 'articles'
  end

  def find_article_by_id(article_id)
    articles.find { |article| article.id == article_id }
  end

  def articles
    Dir["#{@articles_folder}/**/*.mk"].sort.map do |article_source|
      Rollin::Article.new(article_source)
    end
  end

  def annually_archive
    monthly_archive.map { |month_archive| month_archive.year }.uniq.map do |year|
      Rollin::YearArchive.new(year, monthly_archive.map { |aMonth| aMonth.year == year })
    end
  end

  def monthly_archive
    years = {}
    articles.each do |article|
      if years.has_key?(article.year)
        year = years[article.year]
        if year.has_key?(article.month)
          year[article.month] << article
        else
          year[article.month] = [ article ]
        end
      else
        years[article.year] = { article.month => [ article ] }
      end
    end
    archives_list = []
    years.each do |year, months|
      months.each do |month|
        month_articles = articles.map { |article| article.year == year && article.month == month }
        archives_list << Rollin::MonthArchive.new(year, month, month_articles)
      end
    end
    return archives_list
  end
end
