require './spec/spec_helper'

describe Rollin::Article do
  subject (:article) { Rollin::Article.new('spec/fixtures/articles/2013_05_01_My_first_post.mk') }
  
  it 'compiles article body to html' do
    article.body.should == "<h2>This is my first post</h2>\n\n<p>And here we go!</p>\n"
  end

  it 'tells article year' do
    article.year == 2013
  end

  it 'tells article month' do
    article.month == 5
  end

  it 'tells article day' do
    article.day == 1
  end

  it 'tells article date' do
    article.date.should == Date.new(2013, 5, 1)
  end
end