class Rollin::Blog
  def initialize(options = {})
    @articles_folder = options[:articles_folder] || 'articles'
  end

  def article(search = {})
    read_articles.find { |article| article.matches?(search) }
  end

  def articles(search = {})
    read_articles.select { |article| article.matches?(search) }
  end

  def unfiltered_articles
    read_articles
  end

  def metatags
    metatag_labels = unfiltered_articles.map do |article|
      article.metatags.keys
    end.flatten.uniq

    metatag_labels.map do |metatag_label|
      values = unfiltered_articles.select { |article| article.metatags.has_key?(metatag_label) }.map do |article|
        article.metatags[metatag_label]
      end.flatten.uniq.map do |metatag_content|
        Rollin::MetatagValue.new(metatag_content, articles(metatag_label => metatag_content))
      end
      Rollin::MetatagKey.new(metatag_label, values)
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

  private

  def read_articles
    Dir["#{@articles_folder}/**/*.mk"].sort.map do |article_source|
      Rollin::Article.new(article_source)
    end
  end
end
