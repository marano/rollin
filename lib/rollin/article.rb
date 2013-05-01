class Rollin::Article
  attr_reader :id, :title, :year, :month, :day

  def initialize(source_file)
    @source_file = source_file
    filename = File.basename(@source_file)
    @id = filename[0, filename.length - 3]
    @title = filename[11, filename.length - 11 - 3].gsub('_', ' ')
    @year = filename[0, 4].to_i
    @month = filename[5, 2].to_i
    @day = filename[8, 2].to_i
  end

  def date
    Date.new(@year, @month, @day)
  end

  def body
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            autolink: true,
                            space_after_headers: true,
                            hard_wrap: true)
    redcarpet.render(File.read(@source_file))
  end
end
