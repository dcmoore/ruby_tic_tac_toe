require 'rubygems'
require 'rspec'
require '../lib/board'

describe Board do
  before do
    @board = Board.new(3, 3)
  end

  it "makeMove(row, col, team) - updates the game board to reflect a move by the specified team" do
    @board.makeMove(0,0,1)
    @board.makeMove(1,1,2).should == [[1, 0, 0], [0, 2, 0], [0, 0, 0]]
  end

  it "reset - clears all previous moves from the game board" do
    @board.makeMove(0,0,2)
    @board.reset.should == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  it "spaceContents(row, col) - returns the contents of the specified space" do
    @board.makeMove(0,0,1)
    @board.spaceContents(0,0).should == 1
  end

  it "dimRows - returns the number of rows in the board" do
    @board.dimRows.should == 3
  end

  it "dimCols - returns the number of columns in the board" do
    @board.dimCols.should == 3
  end
end
