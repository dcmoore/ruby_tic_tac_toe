require File.dirname(__FILE__) + "/spec_helper"
require 'player'

describe Player do
  it "type - returns the type of player (Human or Computer)" do
    player1 = Player.new("Human")
    player1.type.should == "Human"
    player2 = Player.new("Computer")
    player2.type.should == "Computer"
  end
end
