require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Archiver::Parser" do
  before do
    @parser = Archiver::Parser.new(Archiver::Scraper.data)
  end

  it "should be able to split a date (1)" do
    @parser.send(:split_date, "January 12 2013").
      should == ["January 12 2013"]
  end

  it "should be able to split a date (2)" do
    @parser.send(:split_date, "January 18 2013 at 19:00").
      should == ["January 18 2013"]
  end

  it "should be able to split a date (3)" do
    @parser.send(:split_date, "March 8 - March 9 2012").
      should == ["March 8", "March 9 2012"]
  end

  it "should be able to split a date (4)" do
    @parser.send(:split_date, "October 27 2000 - January 21 2001").
      should == ["October 27 2000", "January 21 2001"]
  end

  it "should be able to split a date (5)" do
    @parser.send(:split_date, "after May 3 2001").
      should == ["May 3 2001"]
  end

  it "should be able to split a date (6)" do
    @parser.send(:split_date, "October 13 2012 at 15:00 - 16:00").
      should == ["October 13 2012"]
  end

  it "should be able to normalize a pair of date strings (1)" do
    @parser.send(:normalize_date_pair, ["January 12 2013"]).
      should == ["January 12 2013"]
  end

  it "should be able to normalize a pair of date strings (2)" do
    @parser.send(:normalize_date_pair, ["January 18 2013"]).
      should == ["January 18 2013"]
  end

  it "should be able to normalize a pair of date strings (3)" do
    @parser.send(:normalize_date_pair, ["March 8", "March 9 2012"]).
      should == ["March 8 2012", "March 9 2012"]
  end

  it "should be able to normalize a pair of date strings (4)" do
    @parser.send(:normalize_date_pair, ["October 27 2000", "January 21 2001"]).
      should == ["October 27 2000", "January 21 2001"]
  end

  it "should be able to normalize a pair of date strings (5)" do
    @parser.send(:normalize_date_pair, ["May 3 2001"]).
      should == ["May 3 2001"]
  end

  it "should be able to normalize a pair of date strings (6)" do
    @parser.send(:normalize_date_pair, ["October 13 2012"]).
      should == ["October 13 2012"]
  end

  it "should be able to normalize a pair of date strings (6)" do
    @parser.send(:normalize_date_pair, ["October 13 2012", "October 24"]).
      should == ["October 13 2012", "October 24 2012"]
  end
end
