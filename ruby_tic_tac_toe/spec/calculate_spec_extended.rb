require 'rubygems'
require 'rspec'
require '../constants'
require '../lib/board'
require '../lib/calculate'

#TODO - Run through every possible game outcome instead of using random numbers

describe Calculate do
  it "Testing the AI against random moves when the AI moves 1st" do
    failFlag = false
    numFails = 0
    board = Board.new(3,3)
    numGames = 5
    while numGames != 0
      while Calculate.isGameOver?(board) == false
        if Calculate.currentTeam(board) == 1
          aiMove = Calculate.aiBestMove(board)
          board.makeMove(aiMove[0], aiMove[1], 1)
        else
          row = rand(board.dimRows)
          col = rand(board.dimCols)
          while board.spaceContents(row, col) != 0
            row = rand(board.dimRows)
            col = rand(board.dimCols)
          end

          board.makeMove(row, col, 2)
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
    numGames = 5
    while numGames != 0
      while Calculate.isGameOver?(board) == false
        if Calculate.currentTeam(board) == 1
          row = rand(board.dimRows)
          col = rand(board.dimCols)
          while board.spaceContents(row, col) != 0
            row = rand(board.dimRows)
            col = rand(board.dimCols)
          end

          board.makeMove(row, col, 1)
        else
          aiMove = Calculate.aiBestMove(board)
          board.makeMove(aiMove[0], aiMove[1], 2)
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
