require File.dirname(__FILE__) + "/spec_helper"
require 'board'

describe Board do
  before do
    @board = Board.new(3, 3)
  end

  it "make_move(row, col, team) - updates the game board to reflect a move by the specified team" do
    @board.make_move(0,0,1)
    @board.make_move(1,1,2).should == [[1, 0, 0], [0, 2, 0], [0, 0, 0]]
  end

  it "reset - clears all previous moves from the game board" do
    @board.make_move(0,0,2)
    @board.reset.should == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  it "space_contents(row, col) - returns the contents of the specified space" do
    @board.make_move(0,0,1)
    @board.space_contents(0,0).should == 1
  end

  it "convert_space_val_to_graphic - graphically converts 0 to empty space, 1 to X, and 2 to O" do
    @board.convert_space_val_to_graphic(0).should == " "
    @board.convert_space_val_to_graphic(1).should == "X"
    @board.convert_space_val_to_graphic(2).should == "O"
  end

  it "dim_rows - returns the number of rows in the board" do
    @board.dim_rows.should == 3
  end

  it "dim_cols - returns the number of columns in the board" do
    @board.dim_cols.should == 3
  end
end
