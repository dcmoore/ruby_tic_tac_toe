require File.dirname(__FILE__) + "/spec_helper"
require 'space'

describe Space do
  it "Space initializer with 2 arguments" do
    space1 = Space.new(1,1)
    space1.row.should == 1
    space1.col.should == 1
    space1.val.should == 0
  end

  it "Space initializer with 3 arguments" do
    space1 = Space.new(1,1,X)
    space1.row.should == 1
    space1.col.should == 1
    space1.val.should == X
  end
end
