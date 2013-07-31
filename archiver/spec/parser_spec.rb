require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Archiver::Parser" do
  before do
    @parser = Archiver::Parser.new(Archiver::Scraper.new.data)
  end

  it "should be able to split and normalize a datetime (1)" do
    @parser.split_date("January 12 2013").
      should eq({ date: ["January 12 2013"], time: nil })
  end

  it "should be able to split and normalize a datetime (2)" do
    @parser.split_date("January 18 2013 at 19:00").
      should eq({ date: ["January 18 2013"], time: ["19:00"] })
  end

  it "should be able to split and normalize a datetime (3)" do
    @parser.split_date("March 8 - March 9 2012").
      should eq({ date: ["March 8 2012", "March 9 2012"], time: nil })
  end

  it "should be able to split and normalize a datetime (4)" do
    @parser.split_date("October 27 2000 - January 21 2001").
      should eq({ date: ["October 27 2000", "January 21 2001"], time: nil })
  end

  it "should be able to split and normalize a datetime (5)" do
    @parser.split_date("after May 3 2001").
      should eq({ date: ["May 3 2001"], time: nil })
  end

  it "should be able to split and normalize a datetime (6)" do
    @parser.split_date("October 13 2012 at 15:00 - 16:00").
      should eq({ date: ["October 13 2012"], time: ["15:00", "16:00"] })
  end

  it "should be able to split and normalize a datetime (7)" do
    @parser.split_date("2002").
      should eq( { date: ["January 1 2002", "December 31 2002"], time: nil })
  end

  it "should be able to split and normalize a datetime (8)" do
    @parser.split_date("October 24 2012 at 18:30").
      should eq({ date: ["October 24 2012"], time: ["18:30"] })
  end

  it "should have all the appropriate keys merged when normalized" do
    [:starting, :ending, :mid, :time].map do |key|
      @parser.normalize(@parser.occurrences.first).keys.include?(key)
    end.should eq([true, true, true, true])
  end

  it "should be able to normalize an input (1)" do
    @parser.normalize({:title=>"Outside New York: Lectures on Contemporary Creative Activity in the United States and England", :date=>"November 8 1978"}).
      should eq({:title=>"Outside New York: Lectures on Contemporary Creative Activity in the United States and England", :date=>"November 8 1978", :starting=>["1978","11","08"], :ending=>["1978","11","08"], :mid=>["1978","11","08"], :time=>nil})
  end

  it "should be able to normalize an input (2)" do
    @parser.normalize({:title=>"Judith Bernstein and Paul McCarthy in Conversation", :date=>"January 18 2013 at 19:00"}).
      should eq({:title=>"Judith Bernstein and Paul McCarthy in Conversation", :date=>"January 18 2013 at 19:00", :starting=>["2013","01","18"], :ending=>["2013","01","18"], :mid=>["2013","01","18"], :time=>{:starting=>["19","00"], :ending=>["19","00"]}})
  end
end
