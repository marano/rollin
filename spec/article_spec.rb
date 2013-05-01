require './spec/spec_helper'

describe Rollin::Article do
  subject (:article) { Rollin::Article.new('spec/fixtures/articles/2013_05_01_My_first_post.mk') }

  it 'tells article title' do
    article.title == 'My first post'
  end
  
  it 'compiles article body to html' do
    article.body.should == "<h2>This is my first post</h2>\n\n<p>And here we go!</p>\n"
  end

  it 'tells article year' do
    article.year.should == 2013
  end

  it 'tells article month' do
    article.month.should == 5
  end

  it 'tells article day' do
    article.day.should == 1
  end

  it 'tells article date' do
    article.date.should == Date.new(2013, 5, 1)
  end
end
