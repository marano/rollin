describe Rollin::MonthArchive do
  let (:article) { Rollin::Article.new('spec/fixtures/2013_05_01_My_first_post.mk') }
  subject (:month_archive) { Rollin::MonthArchive.new(2013, 05, [ article ]) }

  it 'tells the year' do
    month_archive.year.should == 2013
  end

  it 'tells the month' do
    month_archive.month.should == 5
  end

  it 'has a list of articles' do
    month_archive.articles.first.should == article
  end
end
