require 'rubygems'
require 'rspec'
require 'ticTacToe'

describe Board do
  it "should return correct board after two moves" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,1,2).should == [[1, 0, 0], [0, 2, 0], [0, 0, 0]]
  end

  it "should return empty board" do
    board = Board.new(3,3)
    board.drawMove(0,0,2)
    board.reset.should == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  it "should return 0 for empty" do
    board = Board.new(3,3)
    board.spaceContents(2,2).should == 0
  end

  it "should return 1 for X" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.spaceContents(0,0).should == 1
  end
end

describe Player do
  it "should return team of player" do
    player1 = Player.new(1, 2)
    player1.team.should == 1
  end

  it "should return type of player" do
    player1 = Player.new(1, 2)
    player1.type.should == 2
  end
end

describe Calculate do
  it "should return false for game not over" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(0,2,2)
    Calculate.isGameOver?(board).should == false
  end

  it "should return true for game over. Top Row, X wins." do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(0,1,1)
    board.drawMove(0,2,1)
    Calculate.isGameOver?(board).should == true
  end

  it "should return false for x not winning" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(0,1,2)
    board.drawMove(0,2,1)
    board.drawMove(1,0,2)
    board.drawMove(1,1,2)
    board.drawMove(1,2,2)
    board.drawMove(2,0,1)
    board.drawMove(2,1,1)
    Calculate.xWin?(board).should == false
  end

  it "should return true for game over. First Column, O wins." do
    board = Board.new(3,3)
    board.drawMove(0,0,2)
    board.drawMove(1,0,2)
    board.drawMove(2,0,2)
    Calculate.oWin?(board).should == true
  end

  it "should return true for game over. Forward Diagonal, X wins." do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,1,1)
    board.drawMove(2,2,1)
    Calculate.isGameOver?(board).should == true
  end

  it "should return true for game over. Reverse Diagonal, O wins." do
    board = Board.new(3,3)
    board.drawMove(0,2,2)
    board.drawMove(1,1,2)
    board.drawMove(2,0,2)
    Calculate.isGameOver?(board).should == true
  end

  it "should return false for no draw." do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(0,1,2)
    board.drawMove(0,2,1)
    board.drawMove(1,0,2)
    board.drawMove(1,1,1)
    board.drawMove(1,2,2)
    board.drawMove(2,0,1)
    Calculate.draw?(board).should == false
  end

  it "should return true for draw." do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,0,1)
    board.drawMove(2,0,1)
    board.drawMove(0,1,1)
    board.drawMove(1,1,1)
    board.drawMove(2,1,1)
    board.drawMove(0,2,1)
    board.drawMove(1,2,1)
    board.drawMove(2,2,1)
    Calculate.isGameOver?(board).should == true
  end

  it "should return 5 for 5th turn." do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,0,2)
    board.drawMove(2,0,1)
    board.drawMove(0,1,2)
    board.drawMove(1,1,1)
    Calculate.turnNumber(board).should == 5
  end

  it "should return 2 for it being O's turn" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(0,1,2)
    board.drawMove(0,2,1)
    board.drawMove(1,0,2)
    board.drawMove(1,1,1)
    Calculate.currentTeam(board).should == 2
  end

  it "should return 1 for it being X's turn" do
    board = Board.new(3,3)
    Calculate.currentTeam(board).should == 1
  end

  it "should return [0, 1] for ai calculating that as the best move" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(2,2,2)
    board.drawMove(2,0,1)
    Calculate.aiBestMove(board).should == [1, 0]
  end

  it "should return [2, 0] for ai calculating that as the best move" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,1,2)
    board.drawMove(1,0,1)
    Calculate.aiBestMove(board).should == [2, 0]
  end

  it "should return [2, 0] for ai calculating that as the best move" do
    board = Board.new(3,3)
    board.drawMove(0,0,1)
    board.drawMove(1,1,2)
    board.drawMove(1,0,1)
    Calculate.aiBestMove(board).should == [2, 0]
  end

  it "should return [2,2]" do
    board = Board.new(3,3)
    board.drawMove(2,0,1)
    board.drawMove(1,1,2)
    board.drawMove(1,2,1)
    board.drawMove(0,1,2)
    board.drawMove(2,1,1)
    Calculate.aiBestMove(board).should == [2, 2]
  end

  it "should return [0,0]" do
    board = Board.new(3,3)
    board.drawMove(2,0,1)
    board.drawMove(1,1,2)
    board.drawMove(0,1,1)
    board.drawMove(2,2,2)
    Calculate.aiBestMove(board).should == [0, 0]
  end

  it "Testing the AI against random moves when the AI moves 1st" do
    failFlag = false
    numFails = 0
    board = Board.new(3,3)
    numGames = 50
    while numGames != 0
      while Calculate.isGameOver?(board) == false
        if Calculate.currentTeam(board) == 1
          aiMove = Calculate.aiBestMove(board)
          board.drawMove(aiMove[0], aiMove[1], 1)
        else
          row = rand(board.dimRows)
          col = rand(board.dimCols)
          while board.spaceContents(row, col) != 0
            row = rand(board.dimRows)
            col = rand(board.dimCols)
          end

          board.drawMove(row, col, 2)
        end

        if Calculate.oWin?(board) == true
          failFlag = true
        end
      end

      if failFlag == true && numFails == 0
        numFails += 1
        puts "---O Won---"
        puts board.spaceContents(0,0)
        puts board.spaceContents(0,1)
        puts board.spaceContents(0,2)
        puts board.spaceContents(1,0)
        puts board.spaceContents(1,1)
        puts board.spaceContents(1,2)
        puts board.spaceContents(2,0)
        puts board.spaceContents(2,1)
        puts board.spaceContents(2,2)
      end

      numGames -= 1
      board.reset
    end

    failFlag.should == false
  end

  it "Testing the AI against random moves when the AI moves 2nd" do
    failFlag = false
    numFails = 0
    board = Board.new(3,3)
    numGames = 50
    while numGames != 0
      while Calculate.isGameOver?(board) == false
        if Calculate.currentTeam(board) == 1
          row = rand(board.dimRows)
          col = rand(board.dimCols)
          while board.spaceContents(row, col) != 0
            row = rand(board.dimRows)
            col = rand(board.dimCols)
          end

          board.drawMove(row, col, 1)
        else
          aiMove = Calculate.aiBestMove(board)
          board.drawMove(aiMove[0], aiMove[1], 2)
        end

        if Calculate.xWin?(board) == true
          failFlag = true
        end
      end

      if failFlag == true && numFails == 0
        numFails += 1
        puts "---X Won---"
        puts board.spaceContents(0,0)
        puts board.spaceContents(0,1)
        puts board.spaceContents(0,2)
        puts board.spaceContents(1,0)
        puts board.spaceContents(1,1)
        puts board.spaceContents(1,2)
        puts board.spaceContents(2,0)
        puts board.spaceContents(2,1)
        puts board.spaceContents(2,2)
      end

      numGames -= 1
      board.reset
    end

    failFlag.should == false
  end
end
