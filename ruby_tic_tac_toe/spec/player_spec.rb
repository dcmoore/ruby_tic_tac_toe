require 'rubygems'
require 'rspec'
require '../lib/player'

describe Player do
  it "type - returns the type of player (Human or Computer)" do
    player1 = Player.new("Human")
    player1.type.should == "Human"
  end
end
