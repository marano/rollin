require './spec/spec_helper'

describe Rollin::Blog do
  context 'reading articles from articles folder' do
    subject (:blog) { Rollin::Blog.new(articles_folder: 'spec/fixtures/articles') }

    it 'has the right amount of articles' do
      blog.articles.size.should == 4
    end

    it 'has monthly archives' do
      blog.monthly_archive.size.should == 3
      blog.monthly_archive.first.class.should == Rollin::MonthArchive
    end

    it 'has annual archives' do
      blog.annual_archive.size.should == 2
      blog.annual_archive.first.class.should == Rollin::YearArchive
      blog.annual_archive.first.monthly_archive.size.should == 2
      blog.annual_archive.first.monthly_archive.first.class.should == Rollin::MonthArchive
      blog.annual_archive.first.monthly_archive.first.articles.size.should == 2
      blog.annual_archive.first.monthly_archive.first.articles.first.class.should == Rollin::Article
    end

    it 'finds article by its id' do
      blog.find_article_by_id('2013_05_01_My_first_post').title.should == 'My first post'
    end
  end
end
