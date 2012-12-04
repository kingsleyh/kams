require File.dirname(__FILE__) + '/../util/guid'

describe Guid do

  before(:each) do
    @guid = Guid.new
  end

  it "should display a guid in hexdigest, hex+dashes and raw bytes" do
    @guid.to_s.should =~ /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
    @guid.raw.length.should == 16
    @guid.hexdigest.should =~ /\A[0-9a-f]{32}\z/
    @guid.hexdigest.should == @guid.to_s.gsub(/-/, '')
  end

  it "should be different each time the guid is produced" do
    guid2 = Guid.new
    @guid.should_not == guid2
    @guid.to_s.should_not == guid2.to_s
    @guid.raw.should_not == guid2.raw
    @guid.hexdigest.should_not == guid2.hexdigest
    (1..1000).select { @guid != Guid.new }.length.should == 1000
  end

  it "should convert correctly from string" do
    guid2 = Guid.from_s(@guid.to_s)
    @guid.should == guid2
  end

  it "should convert correctly from bytes" do
    guid2 = Guid.from_raw(@guid.raw)
    @guid.should == guid2
  end

end
