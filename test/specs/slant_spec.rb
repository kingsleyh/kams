require File.dirname(__FILE__) + '/../../util/slant'

describe Slant do

  it "should return text in place of slants" do
    Slant.find_first_from("hello!").should == "exclaim"
  end

  it "should return nil when no slants found" do
    Slant.find_first_from("hello").should == nil
  end

  it "should return all slants" do
    Slant.slants.should =={"?" => "ask", "!" => "exclaim", "." => "say"}
  end

  it "should convert a slant to text" do
    Slant.convert("?").should == "ask"
  end

  it "should reverse a slant to an icon " do
    Slant.reverse("ask").should == "?"
  end

  it "should apply slant icon to phrase" do
    Slant.apply_to('hello there',"exclaim").should == 'hello there!'
    Slant.apply_to('hello',"invalid").should == 'hello.'
  end

end