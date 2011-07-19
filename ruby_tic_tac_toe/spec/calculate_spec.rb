require File.dirname(__FILE__) + "/spec_helper"
require 'board'
require 'calculate'

describe Calculate do
  before do
    @board = Board.new(3, 3)
  end

  it "self.is_game_over?(Board) - returns true if draw?(), x_win?(), or o_win?() returns true" do
    setup_x_win_on_full_board
    Calculate.is_game_over?(@board).should == true
    @board.reset
  end

  it "self.x_win?(Board) - returns true if team X has 3 consecutive spaces in a row" do
    setup_x_win_on_full_board
    Calculate.win?(@board, X).should == true
    @board.reset
  end

  it "self.o_win?(Board) - returns true if team O has 3 consecutive spaces in a row" do
    setup_o_win_in_three_moves
    Calculate.win?(@board, O).should == true
    @board.reset
  end

  it "self.draw?(Board) - returns true if X and O didn't win and the board is full" do
    setup_draw
    Calculate.draw?(@board).should == true
    @board.reset

    setup_x_win_on_full_board
    Calculate.draw?(@board).should == false
    @board.reset
  end

  it "self.current_team(Board) - returns the team who is next in line to make a move" do
    setup_x_win_choose_best_empty_winner
    Calculate.current_team(@board).should == X
    @board.reset
  end

  it "self.ai_best_move(Board) - returns an array containing the row and column of the best possible next move" do
    # Testing for 1st move
    Calculate.ai_best_move(@board).should == [1,1]
    @board.reset

    setup_x_win_on_row
    Calculate.ai_best_move(@board).should == [0,2]
    @board.reset

    setup_x_win_on_col
    Calculate.ai_best_move(@board).should == [2,0]
    @board.reset

    setup_o_win_on_forward_diag
    Calculate.ai_best_move(@board).should == [2,2]
    @board.reset

    setup_o_win_on_reverse_diag
    Calculate.ai_best_move(@board).should == [2,0]
    @board.reset

    setup_x_win_choose_best_empty_winner
    Calculate.ai_best_move(@board).should == [2,2]
    @board.reset

    setup_kiddie_corner_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == [0,2]
    best_move.should_not == [2,0]
    @board.reset

    setup_triangle_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == [0,1]
    best_move.should_not == [1,0]
    best_move.should_not == [2,1]
    best_move.should_not == [1,2]
    @board.reset

    setup_corner_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == [2,0]
    best_move.should_not == [1,0]
    best_move.should_not == [2,1]
    @board.reset
  end

  def setup_draw
    @board.make_move(0,0,X)
    @board.make_move(0,1,X)
    @board.make_move(0,2,O)
    @board.make_move(1,0,O)
    @board.make_move(1,1,X)
    @board.make_move(1,2,X)
    @board.make_move(2,0,X)
    @board.make_move(2,1,O)
    @board.make_move(2,2,O)
  end

  def setup_x_win_on_full_board
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

  def setup_o_win_in_three_moves
    @board.make_move(0,0,O)
    @board.make_move(1,0,O)
    @board.make_move(2,0,O)
  end

  def setup_x_win_on_row
    @board.make_move(0,0,X)
    @board.make_move(0,1,X)
    @board.make_move(1,1,O)
  end

  def setup_x_win_on_col
    @board.make_move(0,0,X)
    @board.make_move(1,0,X)
    @board.make_move(1,1,O)
  end

  def setup_o_win_on_forward_diag
    @board.make_move(1,0,X)
    @board.make_move(0,0,O)
    @board.make_move(1,2,X)
    @board.make_move(1,1,O)
    @board.make_move(2,1,X)
  end

  def setup_o_win_on_reverse_diag
    @board.make_move(0,0,X)
    @board.make_move(0,2,O)
    @board.make_move(0,1,X)
    @board.make_move(1,1,O)
    @board.make_move(1,2,X)
  end

  def setup_x_win_choose_best_empty_winner
    @board.make_move(0,0,O)
    @board.make_move(0,1,O)
    @board.make_move(2,0,X)
    @board.make_move(2,1,X)
  end

  def setup_kiddie_corner_trap
    @board.make_move(0,0,X)
    @board.make_move(1,1,O)
    @board.make_move(2,2,X)
  end

  def setup_triangle_trap
    @board.make_move(0,0,O)
    @board.make_move(1,1,X)
    @board.make_move(2,2,X)
  end

  def setup_corner_trap
    @board.make_move(0,1,X)
    @board.make_move(1,2,X)
    @board.make_move(1,1,O)
  end
end
