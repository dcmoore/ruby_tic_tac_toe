require 'rubygems'
require 'rspec'
require '../lib/calculate'

describe Calculate do
  before do
    @board = @board.new(3, 3)
  end

  it "should return false for game not over" do
    @board.makeMove(0,0,1)
    @board.makeMove(0,2,2)
    Calculate.isGameOver?(@board).should == false
  end

  it "should return true for game over. Top Row, X wins." do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,1)
    @board.makeMove(0,2,1)
    Calculate.isGameOver?(@board).should == true
  end

  it "should return false for x not winning" do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(0,2,1)
    @board.makeMove(1,0,2)
    @board.makeMove(1,1,2)
    @board.makeMove(1,2,2)
    @board.makeMove(2,0,1)
    @board.makeMove(2,1,1)
    Calculate.xWin?(@board).should == false
  end

  it "should return true for game over. First Column, O wins." do
    @board.makeMove(0,0,2)
    @board.makeMove(1,0,2)
    @board.makeMove(2,0,2)
    Calculate.oWin?(@board).should == true
  end

  it "should return true for game over. Forward Diagonal, X wins." do
    @board.makeMove(0,0,1)
    @board.makeMove(1,1,1)
    @board.makeMove(2,2,1)
    Calculate.isGameOver?(@board).should == true
  end

  it "should return true for game over. Reverse Diagonal, O wins." do
    @board.makeMove(0,2,2)
    @board.makeMove(1,1,2)
    @board.makeMove(2,0,2)
    Calculate.isGameOver?(@board).should == true
  end

  it "should return false for no draw." do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(0,2,1)
    @board.makeMove(1,0,2)
    @board.makeMove(1,1,1)
    @board.makeMove(1,2,2)
    @board.makeMove(2,0,1)
    Calculate.draw?(@board).should == false
  end

  it "should return true for draw." do
    @board.makeMove(0,0,1)
    @board.makeMove(1,0,1)
    @board.makeMove(2,0,1)
    @board.makeMove(0,1,1)
    @board.makeMove(1,1,1)
    @board.makeMove(2,1,1)
    @board.makeMove(0,2,1)
    @board.makeMove(1,2,1)
    @board.makeMove(2,2,1)
    Calculate.isGameOver?(@board).should == true
  end

  it "should return 5 for 5th turn." do
    @board.makeMove(0,0,1)
    @board.makeMove(1,0,2)
    @board.makeMove(2,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(1,1,1)
    Calculate.turnNumber(@board).should == 5
  end

  it "should return 2 for it being O's turn" do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(0,2,1)
    @board.makeMove(1,0,2)
    @board.makeMove(1,1,1)
    Calculate.currentTeam(@board).should == 2
  end

  it "should return 1 for it being X's turn" do
    Calculate.currentTeam(@board).should == 1
  end

  it "should return [0, 1] for ai calculating that as the best move" do
    @board.makeMove(0,0,1)
    @board.makeMove(2,2,2)
    @board.makeMove(2,0,1)
    Calculate.aiBestMove(@board).should == [1, 0]
  end

  it "should return [2, 0] for ai calculating that as the best move" do
    @board.makeMove(0,0,1)
    @board.makeMove(1,1,2)
    @board.makeMove(1,0,1)
    Calculate.aiBestMove(@board).should == [2, 0]
  end

  it "should return [2, 0] for ai calculating that as the best move" do
    @board.makeMove(0,0,1)
    @board.makeMove(1,1,2)
    @board.makeMove(1,0,1)
    Calculate.aiBestMove(@board).should == [2, 0]
  end

  it "should return [2,2]" do
    @board.makeMove(2,0,1)
    @board.makeMove(1,1,2)
    @board.makeMove(1,2,1)
    @board.makeMove(0,1,2)
    @board.makeMove(2,1,1)
    Calculate.aiBestMove(@board).should == [2, 2]
  end

  it "should return [0,0]" do
    @board.makeMove(2,0,1)
    @board.makeMove(1,1,2)
    @board.makeMove(0,1,1)
    @board.makeMove(2,2,2)
    Calculate.aiBestMove(@board).should == [0, 0]
  end
end
