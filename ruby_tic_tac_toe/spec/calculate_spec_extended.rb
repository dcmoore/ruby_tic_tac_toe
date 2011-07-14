# ---WARNING---
# This test makes a lot of computations and will
# take a while to execute. Please be patient.
# ---WARNING---

require File.dirname(__FILE__) + "/spec_helper"
require 'board'
require 'calculate'

#TODO - Run through every possible game outcome instead of using random numbers

puts "Really?"

describe Calculate do
  it "Testing the AI against random moves when the AI moves 1st" do
    failFlag = false
    numFails = 0
    board = Board.new(3,3)
    numGames = 5
    while numGames != 0
      while Calculate.is_game_over?(board) == false
        if Calculate.current_team(board) == 1
          aiMove = Calculate.ai_best_move(board)
          board.make_move(aiMove[0], aiMove[1], X)
        else
          row = rand(board.dim_rows)
          col = rand(board.dim_cols)
          while board.space_contents(row, col) != 0
            row = rand(board.dim_rows)
            col = rand(board.dim_cols)
          end

          board.make_move(row, col, O)
        end

        if Calculate.o_win?(board) == true
          failFlag = true
        end
      end

      if failFlag == true && numFails == 0
        numFails += 1
        puts "---O Won---"
        board.draw_board
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
    numGames = 15
    while numGames != 0
      while Calculate.is_game_over?(board) == false
        if Calculate.current_team(board) == 1
          row = rand(board.dim_rows)
          col = rand(board.dim_cols)
          while board.space_contents(row, col) != 0
            row = rand(board.dim_rows)
            col = rand(board.dim_cols)
          end

          board.make_move(row, col, X)
        else
          aiMove = Calculate.ai_best_move(board)
          board.make_move(aiMove[0], aiMove[1], O)
        end

        if Calculate.x_win?(board) == true
          failFlag = true
        end
      end

      if failFlag == true && numFails == 0
        numFails += 1
        puts "---X Won---"
        board.draw_board
      end

      numGames -= 1
      board.reset
    end

    failFlag.should == false
  end
end
