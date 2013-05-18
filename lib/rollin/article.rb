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

  def published?
    !metatags.has_key?('published') || metatags['published'] == 'true'
  end

  def title
    metatags['title'] || @title_from_filename
  end

  def matches?(search)
    return @id == search if search.is_a? String

    search = search.inject({}) { |hash, (k,v)| hash[k.to_s] = v; hash }

    return false unless published? || show_unpublished?(search)

    if search.has_key?('year')
      return false if search.delete('year') != @year
      if search.has_key?('month')
        return false if search.delete('month') != @month
        if search.has_key?('day')
          return false if search.delete('day') != @day
        end
      end
    end

    if search.keys.empty?
      return true
    else
      search.each do |key, value|
        return true if metatags[key] != nil && (metatags[key] == value || metatags[key].include?(value))
      end
      return false
    end
  end

  def metatags
    file = read_from_file
    return {} unless file.has_front_matter?
    begin
      return YAML.safe_load(file.yaml_front_matter)
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
    html_renderer_options = { hard_wrap: false }
    parser_options = { autolink: true,
                       space_after_headers: true,
                       fenced_code_blocks: true,
                       disable_indented_code_blocks: true }
    render = Redcarpet::Render::HTML.new(html_renderer_options)
    redcarpet = Redcarpet::Markdown.new(render, parser_options)
    redcarpet.render(read_from_file.content)
  end

  private

  def read_from_file
    raw = File.read(@source_file)

    # Stolen from Jekyll
    if raw =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
      content = $POSTMATCH
      yaml_front_matter = $1
      content = raw[yaml_front_matter.size + 3, raw.size - 1]
      FileContent.new(yaml_front_matter, content)
    else
      FileContent.new(nil, raw)
    end
  end

  def show_unpublished?(search)
    search.has_key?('published') && search['published'].to_s != 'true' && search['published'] != 'yes'
  end
end

class FileContent
  attr_reader :yaml_front_matter, :content

  def initialize(yaml_front_matter, content)
    @yaml_front_matter = yaml_front_matter
    @content = content
  end

  def has_front_matter?
    !yaml_front_matter.nil?
  end
end
