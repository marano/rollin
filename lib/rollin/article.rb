class Rollin::Article
  attr_reader :id, :year, :month, :day

  def initialize(source_file)
    @source_file = source_file
    filename = File.basename(@source_file)
    @id = filename[0, filename.length - 3]
    @title_from_filename = filename[11, filename.length - 11 - 3].gsub('_', ' ')
    @year = filename[0, 4].to_i
    @month = filename[5, 2].to_i
    @day = filename[8, 2].to_i
  end

  def title
    metatags["title"] || @title_from_filename
  end

  def metatags
    # Stolen from Jekyll
    begin
      content = File.read(@source_file)

      if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        content = $POSTMATCH
        return YAML.safe_load($1)
      end
    rescue SyntaxError => e
      puts "YAML Exception reading #{File.join(@source_file)}: #{e.message}"
    rescue Exception => e
      puts "Error reading file #{File.join(@source_file)}: #{e.message}"
    end

    return {}
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
