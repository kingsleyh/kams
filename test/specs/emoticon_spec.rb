require File.dirname(__FILE__) + '/../../util/emoticon'

describe Emoticon do

  it "should return text in place of emoticons" do
    Emoticon.find_first_from("hello :)").should == "smile"
  end

  it "should return nil when no emoticons found" do
    Emoticon.find_first_from("hello").should == nil
  end

  it "should return all emoticons" do
    Emoticon.emoticons.should == {":)"=>"smile", ":("=>"frown", ":D"=>"laugh"}
  end

  it "should convert an emoticon to text" do
    Emoticon.convert(":D").should == "laugh"
  end

  it "should reverse an emoticon from text to icon" do
    Emoticon.reverse("smile").should == ":)"
  end

  it "should strip an emoticon from a phrase" do
    Emoticon.strip_from('hello :)').should == 'hello'
    Emoticon.strip_from('hello').should == 'hello'
  end

end