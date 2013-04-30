class Rollin::Blog
  def articles
    Dir['articles/**/*.mk'].map do |article_source|
      Article.new(article_source)
    end
  end
end

class Article
  def initialize(source_file)
    @source_file = source_file
  end

  def body
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            autolink: true,
                            space_after_headers: true,
                            hard_wrap: true)
    redcarpet.render(File.read(@source_file))
  end
end
