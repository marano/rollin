require 'spec_helper'

# Fixtures
#
# 2013_05_01_My_first_post.mk
# 2013_05_02_My_second_post.mk
# 2013_06_01_My_third_post.mk
# 2014_01_01_My_fourth_post.mk

describe 'how rollin works' do

  subject (:blog) { Rollin::Blog.new(articles_folder: 'spec/fixtures') }

  context 'article content' do
    let (:article) { blog.articles.first }
    let (:article_with_title_metatag) { blog.articles[1] }
    let (:article_with_custom_metatags) { blog.articles[2] }

    it 'exposes article information and content' do
      article.id.should == '2013_05_01_My_first_post'
      article.title.should == 'My first post'
      article.year.should == 2013
      article.month.should == 5
      article.day.should == 1
      article.date.should == Date.new(2013, 5, 1)
      article.body.should == "<h2>This is my first post</h2>\n\n<p>And here we go!</p>\n"
      article.metatags.should be_empty
    end

    it 'allows article title definition with metatag' do
      article_with_title_metatag.title.should == 'This is a super post!'
    end

    it 'exposes the list of defined metatags' do
      article_with_custom_metatags.metatags.should == { tags: ['manero', 'massa', 'bacana'], published: false }
    end
  end

  context 'searching for articles' do
    let (:first_article) { blog.articles.first }
    let (:second_article) { blog.articles[1] }
    let (:third_article) { blog.articles[2] }
    let (:article_with_custom_metatags) { blog.articles[2] }

    it 'searches by article id' do
      blog.article('2013_05_01_My_first_post').should == first_article
    end

    it 'searches by metatags' do
      blog.article(tags: 'manero').should == article_with_custom_metatags
      blog.articles(tags: 'manero').should == [ article_with_custom_metatags ]

      blog.article(published: false).should == article_with_custom_metatags
      blog.articles(published: false).should == [ article_with_custom_metatags ]
    end

    it 'searches by date' do
      blog.articles_by_publication(2013).should include(first_article, second_article, third_article)
      blog.articles_by_publication(2013, 5).should include(first_article, second_article)
      blog.articles_by_publication(2013, 5, 1).should include(first_article)
    end
  end

  context 'listing articles' do
    let (:first_article) { TestArticle.new(id: '2013_05_01_My_first_post', title: 'My first post', date: Date.new(2013, 5, 1)) }
    let (:second_article) { TestArticle.new(id: '2013_05_02_My_second_post', title: 'This is a super post!', date: Date.new(2013, 5, 2)) }
    let (:third_article) { TestArticle.new(id: '2013_06_01_My_third_post', title: 'My third post', date: Date.new(2013, 6, 1)) }
    let (:fourth_article) { TestArticle.new(id: '2014_01_01_My_fourth_post', title: 'My fourth post', date: Date.new(2014, 1, 1)) }

    it 'lists all articles' do
      blog.should have(4).articles

      blog.articles[0].should == first_article
      blog.articles[1].should == second_article
      blog.articles[2].should == third_article
      blog.articles[3].should == fourth_article
    end

    it 'provides monthly archive' do
      blog.monthly_archive.should have(3).articles

      blog.monthly_archive[0].year.should == 2013
      blog.monthly_archive[0].month.should == 5
      blog.monthly_archive[0].should have(2).articles
      blog.monthly_archive[0].articles.should include(first_article, second_article)

      blog.monthly_archive[1].year.should == 2013
      blog.monthly_archive[1].month.should == 6
      blog.monthly_archive[1].should have(1).articles
      blog.monthly_archive[1].articles.should include(third_article)

      blog.monthly_archive[2].year.should == 2014
      blog.monthly_archive[2].month.should == 1
      blog.monthly_archive[2].should have(1).articles
      blog.monthly_archive[2].articles.should include(fourth_article)
    end

    it 'provides annual archive' do
      blog.should have(2).annual_archive

      blog.annual_archive[0].year.should == 2013
      blog.annual_archive[0].should have(2).monthly_archive
      blog.annual_archive[0].monthly_archive[0].year.should == 2013
      blog.annual_archive[0].monthly_archive[0].month.should == 5
      blog.annual_archive[0].monthly_archive[0].should have(2).articles
      blog.annual_archive[0].monthly_archive[0].articles.should include(first_article, second_article)
      blog.annual_archive[0].monthly_archive[1].year.should == 2013
      blog.annual_archive[0].monthly_archive[1].month.should == 6
      blog.annual_archive[0].monthly_archive[1].should have(1).articles
      blog.annual_archive[0].monthly_archive[1].articles.should include(third_article)
      blog.annual_archive[0].should have(3).articles
      blog.annual_archive[0].articles.should include(first_article, second_article, third_article)

      blog.annual_archive[1].year.should == 2014
      blog.annual_archive[1].should have(1).monthly_archive
      blog.annual_archive[1].monthly_archive[0].year.should == 2014
      blog.annual_archive[1].monthly_archive[0].month.should == 1
      blog.annual_archive[1].monthly_archive[0].should have(1).articles
      blog.annual_archive[1].monthly_archive[0].articles.should include(fourth_article)
      blog.annual_archive[1].should have(1).articles
      blog.annual_archive[1].articles.should include(fourth_article)
    end
  end
end
