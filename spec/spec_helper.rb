require 'rubygems'
require 'bundler/setup'
Bundler.require :development

require './lib/rollin'

class Rollin::Article
  def ==(other)
    id == other.id && title == other.title && date == other.date
  end
end

class TestArticle
  attr_reader :id, :title, :date

  def initialize(properties)
    @id = properties[:id]
    @title = properties[:title]
    @date = properties[:date]
  end
end
