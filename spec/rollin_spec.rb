require 'spec_helper'

# Fixtures
#
# 2013_05_01_My_first_post.mk
# 2013_05_02_My_second_post.mk
# 2013_06_01_My_third_post.mk
# 2014_01_01_My_fourth_post.mk
# 2014_01_01_My_fifth_article.mk

describe 'how rollin works' do

  subject (:blog) { Rollin::Blog.new(articles_folder: 'spec/fixtures') }

  let (:first_article) { blog.articles[3] }
  let (:second_article) { blog.articles[2] }
  let (:third_article) { blog.articles[1] }
  let (:fifth_article) { blog.articles[0] }

  let (:article_with_single_tag_metatag) { blog.articles[3] }
  let (:article_with_title_metatag) { blog.articles[2] }
  let (:article_with_multiple_tag_metatag) { blog.articles[1] }
  let (:unpublished_article) { blog.article(:published => false) }

  context 'article content' do
    let (:article) { blog.articles.last }

    it 'exposes article information and content' do
      article.id.should == '2013_05_01_My_first_post'
      article.title.should == 'My first post'
      article.year.should == 2013
      article.month.should == 5
      article.day.should == 1
      article.date.should == Date.new(2013, 5, 1)
      article.published?.should be_true
      article.body.should == "<h2>This is my first post</h2>\n\n<p>And here we go!</p>\n"
      article.metatags.should == { 'tags' => [ 'manero' ] }
      article.filename.should == '2013_05_01_My_first_post.mk'
    end

    it 'allows article title definition with metatag' do
      article_with_title_metatag.title.should == 'This is a super post!'
    end

    it 'exposes the list of defined metatags' do
      article_with_multiple_tag_metatag.metatags.should == { 'tags' => ['manero', 'massa', 'bacana'] }
      unpublished_article.metatags.should == { 'published' => false }
    end
  end

  context 'searching for articles' do
    it 'searches by article id' do
      blog.article('2013_05_01_My_first_post').should == first_article
      blog.article('this_article_does_not_exist').should be_nil
    end

    it 'searches by metatags' do
      blog.article(:tags => 'manero').should == article_with_multiple_tag_metatag
      blog.article('tags' => 'manero').should == article_with_multiple_tag_metatag

      blog.articles(:tags => 'manero').should == [ article_with_multiple_tag_metatag, article_with_single_tag_metatag ]
      blog.articles('tags' => 'manero').should == [ article_with_multiple_tag_metatag, article_with_single_tag_metatag ]

      blog.article(:published => false).should == unpublished_article
      blog.article('published' => false).should == unpublished_article

      blog.articles(:published => false).should == [ unpublished_article ]
      blog.articles('published' => false).should == [ unpublished_article ]
    end

    it 'searches by date' do
      blog.articles(year: 2013).should == [ third_article, second_article, first_article ]
      blog.articles(year: 2013, month: 5).should == [second_article, first_article ]
      blog.articles(year: 2013, month: 5, day: 1).should  == [ first_article ]
    end

    it 'narrows search by date when searching for metatags' do
      blog.articles(year: 2013, :tags => 'manero').should { article_with_custom_metatags }
      blog.articles(year: 2014, :tags => 'manero').should be_empty
    end
  end

  context 'inquiring metatags' do
    it 'shows a list of existent metatags' do
      blog.should have(3).metatags

      blog.metatags[0].label.should == 'published'
      blog.metatags[0].should have(1).values
      blog.metatags[0].values[0].content.should == false
      blog.metatags[0].values[0].articles.should == [ unpublished_article ]

      blog.metatags[1].label.should == 'tags'
      blog.metatags[1].should have(3).values
      blog.metatags[1].values[2].content.should == 'bacana'
      blog.metatags[1].values[2].articles.should == [ article_with_multiple_tag_metatag ]
      blog.metatags[1].values[1].content.should == 'massa'
      blog.metatags[1].values[1].articles.should == [ article_with_multiple_tag_metatag ]
      blog.metatags[1].values[0].content.should == 'manero'
      blog.metatags[1].values[0].articles.should == [ article_with_multiple_tag_metatag, article_with_single_tag_metatag ]

      blog.metatags[2].label.should == 'title'
      blog.metatags[2].should have(1).values
      blog.metatags[2].values[0].content.should == 'This is a super post!'
      blog.metatags[2].values[0].articles.should == [ article_with_title_metatag ]
    end
  end

  context 'listing articles' do
    let (:first_article) { TestArticle.new(id: '2013_05_01_My_first_post', title: 'My first post', date: Date.new(2013, 5, 1)) }
    let (:second_article) { TestArticle.new(id: '2013_05_02_My_second_post', title: 'This is a super post!', date: Date.new(2013, 5, 2)) }
    let (:third_article) { TestArticle.new(id: '2013_06_01_My_third_post', title: 'My third post', date: Date.new(2013, 6, 1)) }
    let (:fifth_article) { TestArticle.new(id: '2014_01_01_My_fifth_post', title: 'My fifth post', date: Date.new(2014, 1, 1)) }

    it 'lists all articles' do
      blog.should have(4).articles

      blog.articles[0].should == fifth_article
      blog.articles[1].should == third_article
      blog.articles[2].should == second_article
      blog.articles[3].should == first_article
    end
  end

  context 'archive' do
    it 'provides monthly archive' do
      blog.monthly_archive.should have(3).articles

      blog.monthly_archive[0].year.should == 2014
      blog.monthly_archive[0].month.should == 1
      blog.monthly_archive[0].articles.should == [ fifth_article ]

      blog.monthly_archive[1].year.should == 2013
      blog.monthly_archive[1].month.should == 6
      blog.monthly_archive[1].articles.should == [ third_article ]

      blog.monthly_archive[2].year.should == 2013
      blog.monthly_archive[2].month.should == 5
      blog.monthly_archive[2].articles.should == [ second_article, first_article ]
    end

    it 'provides annual archive' do
      blog.should have(2).annual_archive

      blog.annual_archive[0].year.should == 2014
      blog.annual_archive[0].articles.should == [ fifth_article ]
      blog.annual_archive[0].should have(1).monthly_archive
      blog.annual_archive[0].monthly_archive[0].year.should == 2014
      blog.annual_archive[0].monthly_archive[0].month.should == 1
      blog.annual_archive[0].monthly_archive[0].articles.should == [ fifth_article ]

      blog.annual_archive[1].year.should == 2013
      blog.annual_archive[1].articles.should == [ third_article, second_article, first_article ]
      blog.annual_archive[1].should have(2).monthly_archive
      blog.annual_archive[1].monthly_archive[0].year.should == 2013
      blog.annual_archive[1].monthly_archive[0].month.should == 6
      blog.annual_archive[1].monthly_archive[0].articles.should == [ third_article ]

      blog.annual_archive[1].monthly_archive[1].year.should == 2013
      blog.annual_archive[1].monthly_archive[1].month.should == 5
      blog.annual_archive[1].monthly_archive[1].articles.should == [ second_article, first_article ]
    end
  end
end
