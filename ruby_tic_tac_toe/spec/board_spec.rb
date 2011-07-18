require File.dirname(__FILE__) + "/spec_helper"
require 'board'

describe Board do
  before do
    @board = Board.new(3, 3)
  end

  it "make_move(row, col, team) - updates the game board to reflect a move by the specified team" do
    @board.make_move(0,0,1)
    @board.space_contents(0,0).should == 1
  end

  it "reset - clears all previous moves from the game board" do
    @board.make_move(0,0,2)
    @board.reset
    @board.space_contents(0,0).should == 0
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

  it "clone_board - returns a copy of the current board as a new object" do
    make_3_moves
    new_board = @board.clone_board
    new_board.object_id.should_not == @board.object_id
    new_board.space_contents(1,1).should == O
  end

  it "num_moves_made - returns the number of moves that have been made on the board" do
    make_3_moves
    @board.num_moves_made.should == 3
    @board.reset
  end

  it "is_board_full?(board)" do
    make_9_moves
    @board.is_board_full? == true
    @board.reset

    make_3_moves
    @board.is_board_full? == false
  end

  it "dim_rows - returns the number of rows in the board" do
    @board.dim_rows.should == 3
  end

  it "dim_cols - returns the number of columns in the board" do
    @board.dim_cols.should == 3
  end

  it "spaces - returns the spaces in the board" do
    @board.spaces.length.should == 9
  end



  def make_9_moves
    @board.make_move(0,0,X)
    @board.make_move(0,1,O)
    @board.make_move(0,2,X)
    @board.make_move(1,0,O)
    @board.make_move(1,1,X)
    @board.make_move(1,2,O)
    @board.make_move(2,0,X)
    @board.make_move(2,1,O)
    @board.make_move(2,2,X)
  end

  def make_3_moves
    @board.make_move(0,0,X)
    @board.make_move(1,0,X)
    @board.make_move(1,1,O)
  end
end
