require './spec/spec_helper'

describe Rollin::Blog do
  context 'reading articles from articles folder' do
    subject (:blog) { Rollin::Blog.new(articles_folder: 'spec/fixtures/articles') }

    it 'has the right amount of articles' do
      blog.articles.size.should == 4
    end

    it 'has the right amount of monthly archives' do
      blog.monthly_archive.size.should == 3
    end

    it 'has the right amount of yearly archives' do
      blog.annually_archive.size.should == 2
    end

    it 'finds article by its id' do
      blog.find_article_by_id('2013_05_01_My_first_post').title.should == 'My first post'
    end
  end
end
