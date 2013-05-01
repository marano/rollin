describe Rollin::YearArchive do
  let (:article) { Rollin::Article.new('spec/fixtures/2013_05_01_My_first_post.mk') }
  subject (:month_archive) { Rollin::MonthArchive.new(2013, 05, [ article ]) }
  subject (:year_archive) { Rollin::YearArchive.new(2013, [ month_archive ]) }

  it 'tells the year' do
    year_archive.year.should == 2013
  end

  it 'has monthly archives' do
    year_archive.monthly_archive.size.should == 1
  end

  it 'has a list of articles' do
    year_archive.articles.first.should == article
  end
end
