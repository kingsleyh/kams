require File.dirname(__FILE__) + '/../../util/expectancy'
require 'ostruct'

describe Expectancy do

  it "should return true if condition met" do
    event = OpenStruct.new(:name => nil, :id => nil)
    Expectancy.when(1==1) do
      event.name = 'expectancy was met'
      event.id = 1
    end
    event.name.should == 'expectancy was met'
    event.id.should == 1
  end

  it "should return false if condition not met" do
    Expectancy.when(1==2) do
      'expectancy was met'
    end.should == nil
  end

end

