require 'rubygems'
require 'rspec'
require '../constants'
require '../lib/board'
require '../lib/calculate'

describe Calculate do
  before do
    @board = Board.new(3, 3)
  end

  it "self.isGameOver?(Board) - returns true if draw?(), xWin?(), or oWin?() returns true" do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,1)
    @board.makeMove(0,2,1)
    Calculate.isGameOver?(@board).should == true
  end

  it "self.xWin?(Board) - returns true if team X has 3 consecutive spaces in a row" do
    @board.makeMove(0,0,X)
    @board.makeMove(0,1,O)
    @board.makeMove(0,2,X)
    @board.makeMove(1,0,O)
    @board.makeMove(1,1,O)
    @board.makeMove(1,2,O)
    @board.makeMove(2,0,X)
    @board.makeMove(2,1,X)
    Calculate.xWin?(@board).should == false
  end

  it "self.oWin?(Board) - returns true if team O has 3 consecutive spaces in a row" do
    @board.makeMove(0,0,O)
    @board.makeMove(1,0,O)
    @board.makeMove(2,0,O)
    Calculate.oWin?(@board).should == true
  end

  it "self.draw?(Board) - returns true if X and O didn't win and the board is full" do
    @board.makeMove(0,0,X)
    @board.makeMove(0,1,X)
    @board.makeMove(0,2,O)
    @board.makeMove(1,0,O)
    @board.makeMove(1,1,X)
    @board.makeMove(1,2,X)
    @board.makeMove(2,0,X)
    @board.makeMove(2,1,O)
    @board.makeMove(2,2,O)
    Calculate.draw?(@board).should == true

    @board.reset
    @board.makeMove(0,0,X)
    @board.makeMove(0,1,O)
    @board.makeMove(0,2,X)
    @board.makeMove(1,0,O)
    @board.makeMove(1,1,X)
    @board.makeMove(1,2,O)
    @board.makeMove(2,0,X)
    Calculate.draw?(@board).should == false  # Because X has 3 in a row
  end

  it "self.numMovesMade(Board) - returns the number of moves that have been made on the board" do
    @board.makeMove(0,0,1)
    @board.makeMove(1,0,2)
    @board.makeMove(2,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(1,1,1)
    Calculate.numMovesMade(@board).should == 5
  end

  it "self.currentTeam(Board) - returns the team who is next in line to make a move" do
    @board.makeMove(0,0,1)
    @board.makeMove(0,1,2)
    @board.makeMove(0,2,1)
    @board.makeMove(1,0,2)
    @board.makeMove(1,1,1)
    Calculate.currentTeam(@board).should == 2
  end

  it "self.aiBestMove(Board) - returns an array containing the row and column of the best possible next move" do
    setupKiddieCornerTrap
    Calculate.aiBestMove(@board).should == [1,1]
    setupDoubleSideTrap
    Calculate.aiBestMove(@board).should == [1,1]
    setupCornerTrap
    Calculate.aiBestMove(@board).should == [1,1]
    setupOddTrap
    Calculate.aiBestMove(@board).should == [1,1]
    setupChoosingBestEmptyWinner
    Calculate.aiBestMove(@board).should == [1,1]
  end

  def setupKiddieCornerTrap
  end

  def setupDoubleSideTrap
  end

  def setupCornerTrap
  end

  def setupOddTrap
  end

  def setupChoosingBestEmptyWinner
  end
end
