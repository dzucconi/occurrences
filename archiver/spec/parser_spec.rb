require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Archiver::Parser" do
  before do
    @parser = Archiver::Parser.new(Archiver::Scraper.new.data)
  end

  it "should be able to split a date (1)" do
    @parser.split_date("January 12 2013").
      should == ["January 12 2013"]
  end

  it "should be able to split a date (2)" do
    @parser.split_date("January 18 2013 at 19:00").
      should == ["January 18 2013"]
  end

  it "should be able to split a date (3)" do
    @parser.split_date("March 8 - March 9 2012").
      should == ["March 8", "March 9 2012"]
  end

  it "should be able to split a date (4)" do
    @parser.split_date("October 27 2000 - January 21 2001").
      should == ["October 27 2000", "January 21 2001"]
  end

  it "should be able to split a date (5)" do
    @parser.split_date("after May 3 2001").
      should == ["May 3 2001"]
  end

  it "should be able to split a date (6)" do
    @parser.split_date("October 13 2012 at 15:00 - 16:00").
      should == ["October 13 2012"]
  end

  it "should be able to normalize a pair of date strings (1)" do
    @parser.normalize_date_pair(["January 12 2013"]).
      should == ["January 12 2013"]
  end

  it "should be able to normalize a pair of date strings (2)" do
    @parser.normalize_date_pair(["January 18 2013"]).
      should == ["January 18 2013"]
  end

  it "should be able to normalize a pair of date strings (3)" do
    @parser.normalize_date_pair(["March 8", "March 9 2012"]).
      should == ["March 8 2012", "March 9 2012"]
  end

  it "should be able to normalize a pair of date strings (4)" do
    @parser.normalize_date_pair(["October 27 2000", "January 21 2001"]).
      should == ["October 27 2000", "January 21 2001"]
  end

  it "should be able to normalize a pair of date strings (5)" do
    @parser.normalize_date_pair(["May 3 2001"]).
      should == ["May 3 2001"]
  end

  it "should be able to normalize a pair of date strings (6)" do
    @parser.normalize_date_pair(["October 13 2012"]).
      should == ["October 13 2012"]
  end

  it "should be able to normalize a pair of date strings (7)" do
    @parser.normalize_date_pair(["October 13 2012", "October 24"]).
      should == ["October 13 2012", "October 24 2012"]
  end

  it "should have the keys :start, :end, and :mid when normalized" do
    [:start, :end, :mid].map do |key|
      @parser.normalize(@parser.occurrences.first).keys.include?(key)
    end.should == [true, true, true]
  end

  it "should be able to normalize a hash" do
    @parser.normalize({:title=>"Outside New York: Lectures on Contemporary Creative Activity in the United States and England", :date=>"November 8 1978"}).
      should == {:title=>"Outside New York: Lectures on Contemporary Creative Activity in the United States and England", :date=>"November 8 1978", :start=>"1978-11-08", :end=>"1978-11-08", :mid=>"1978-11-08"}
  end
end
