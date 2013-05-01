require './spec/spec_helper'

describe Rollin::Blog do
  context 'reading articles from articles folder' do
    subject (:blog) { Rollin::Blog.new(articles_folder: 'spec/fixtures/articles') }

    it 'has the right amount of articles' do
      blog.articles.size.should == 3
    end

    it 'has the right amount of monthly archives' do
      blog.monthly_archive.size.should == 2
    end
  end
end
