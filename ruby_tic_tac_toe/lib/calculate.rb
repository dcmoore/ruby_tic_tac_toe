require '../constants'

class Calculate
  class << self
    def isGameOver?(board)
      if draw?(board) == false && xWin?(board) == false && oWin?(board) == false
        return false
      end
      return true
    end


    def draw?(board)
      if xWin?(board) == true || oWin?(board) == true
        return false
      end
      return isBoardFull?(board)
    end


    def xWin?(board)
      if checkAllColsForWin(board) == X || checkAllRowsForWin(board) == X || checkForwardDiagForWin(board) == X || checkReverseDiagForWin(board) == X
        return true
      end
      return false
    end


    def oWin?(board)
      if checkAllColsForWin(board) == O || checkAllRowsForWin(board) == O || checkForwardDiagForWin(board) == O || checkReverseDiagForWin(board) == O
        return true
      end
      return false
    end


    def numMovesMade(board)
      count = 0

      board.dimRows.times { |row|
        board.dimCols.times { |col|
          if board.spaceContents(row,col) != EMPTY
            count += 1
          end
        }
      }

      return count
    end


    def currentTeam(board)
      currentTurn = numMovesMade(board)
      if currentTurn % 2 == 0
        return X
      else
        return O
      end
    end


    def aiBestMove(board)
      preCalculatedMove = preCalculatedMoves(board)
      if preCalculatedMove != -1
        return preCalculatedMove
      end

      wld = createWLDArray(board, currentTeam(board), currentTeam(board), 0)  # Create a win/loss/draw array
      calculatedMove = calculateBestMove(board, wld)

      return calculatedMove
    end


    private # The rest of the methods in this class are private

    def preCalculatedMoves(board)
      emptyWinner = findBestEmptyWinner(board, Calculate.currentTeam(board))
      if emptyWinner != -1
        return emptyWinner
      end

      hardCodedMove = hardCodedMoves(board)
      if hardCodedMove != -1
        return hardCodedMove
      end

      return -1
    end


    def findBestEmptyWinner(board, team)
      boardCopy = cloneBoard(board)
      emptyWinners = getEmptyWinnersArray(boardCopy)

      emptyWinners.length.times { |i|
        boardCopy.makeMove(emptyWinners[i][0], emptyWinners[i][1], team)
        if team == X
          if Calculate.xWin?(boardCopy) == true
            return emptyWinners[i]
          end
        else
          if Calculate.oWin?(boardCopy) == true
            return emptyWinners[i]
          end
        end
      }

      if emptyWinners.length != 0
        return emptyWinners[0]
      end
      return -1
    end


    def cloneBoard(board)
      boardCopy = Board.new(board.dimRows, board.dimCols)
      board.dimRows.times { |row|
        board.dimCols.times { |col|
          boardCopy.makeMove(row, col, board.spaceContents(row, col))
        }
      }

      return boardCopy
    end


    def getEmptyWinnersArray(board)
      emptyWinners = []

      emptyWinnersOnARow = checkAllRowsForEmptyWinner(board)
      emptyWinnersOnARow.length.times { |i|
        emptyWinners.push(emptyWinnersOnARow[i])
      }

      emptyWinnersOnACol = checkAllColsForEmptyWinner(board)
      emptyWinnersOnACol.length.times { |i|
        emptyWinners.push(emptyWinnersOnACol[i])
      }

      emptyWinnersOnAForwardDiag = checkForwardDiagForEmptyWinner(board)
      emptyWinnersOnAForwardDiag.length.times { |i|
        emptyWinners.push(emptyWinnersOnAForwardDiag[i])
      }

      emptyWinnersOnAReverseDiag = checkReverseDiagForEmptyWinner(board)
      emptyWinnersOnAReverseDiag.length.times { |i|
        emptyWinners.push(emptyWinnersOnAReverseDiag[i])
      }

      return emptyWinners
    end


    def checkAllRowsForEmptyWinner(board)
      emptyWinners = []
      board.dimRows.times { |row|
        groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(row,n)})
        if groupOfCells[0] == "EmptyWinner"
          emptyWinners.push([row,groupOfCells[1]])
        end
      }

      return emptyWinners
    end


    def checkAllColsForEmptyWinner(board)
      emptyWinners = []
      board.dimRows.times { |col|
        groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,col)})
        if groupOfCells[0] == "EmptyWinner"
          emptyWinners.push([groupOfCells[1],col])
        end
      }

      return emptyWinners
    end


    def checkForwardDiagForEmptyWinner(board)
      emptyWinners = []

      groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,n)})
      if groupOfCells[0] == "EmptyWinner"
        emptyWinners.push([groupOfCells[1],groupOfCells[1]])
      end

      return emptyWinners
    end


    def checkReverseDiagForEmptyWinner(board)
      emptyWinners = []

      groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,(board.dimCols-1) - n)})
      if groupOfCells[0] == "EmptyWinner"
        emptyWinners.push([groupOfCells[1],((board.dimCols-1)-groupOfCells[1])])
      end

      return emptyWinners
    end


    def hardCodedMoves(board)
      optimizedMove = optimizeTheAlgorithm(board)
      if optimizedMove != -1
        return optimizedMove
      end

      missedTrapMove = trapsThatTheAlgorithmDoesntPickUp(board)
      if missedTrapMove != -1
        return missedTrapMove
      end

      return -1
    end


    def optimizeTheAlgorithm(board)
      if board.spaceContents(1,1) == X && Calculate.numMovesMade(board) == 1  # To optimize speed
        return [0,0]
      end

      if board.spaceContents(1,1) == EMPTY  # To optimize speed
        return [1,1]
      end

      return -1
    end


    def createWLDArray(board, aiTeam, curTeam, depth)
      wld = Array.new(board.dimRows) {Array.new(board.dimRows) {Array.new(3,EMPTY)}}

      # Loop through empty spaces to fill the wld array out
      board.dimRows.times { |row|
        board.dimCols.times { |col|
          # Is this an empty space?
          if board.spaceContents(row, col) == 0
puts "Moved: " + row.to_s + " " + col.to_s + " " + Calculate.currentTeam(board).to_s + " depth: " + depth.to_s
            board.makeMove(row, col, currentTeam(board))  # Make a hypothetical move
board.drawBoard
puts

            if Calculate.isGameOver?(board) == true
puts "game over. depth: " + depth.to_s
              wld = updateWLD(row, col, aiTeam, board, wld)
              board.makeMove(row, col, 0)  # Take back hypothetical move
              next
            end

            tempArray = createWLDArray(board, aiTeam, currentTeam(board), depth+1)  # Recursively call aiBestMove at 1 more level of depth
puts "end recursive call. depth: " + depth.to_s
            wld = addRecursedWLDVals(tempArray, wld, board)  # Add return value (array) of recursive call to wld array
            board.makeMove(row, col, 0)  # Take back hypothetical move
          end
        }
      }

      return wld  # If the loop is over, return this depth's completed wld array
    end


    def updateWLD(row, col, aiTeam, board, wld)
      if Calculate.oWin?(board) == true
        if aiTeam == O
          wld = updateWins(wld, board, aiTeam, row, col)
        else
          wld = updateWins(wld, board, aiTeam, row, col)
        end
      end
      if Calculate.xWin?(board) == true
        if aiTeam == O
          wld = updateLosses(wld, board, aiTeam, row, col)
        else
          wld = updateWins(wld, board, aiTeam, row, col)
        end
      end
      if Calculate.draw?(board) == true
        wld[row][col][2] += 1
      end

      return wld
    end


    def updateWins(wld, board, aiTeam, row, col)
      wld[row][col][0] += 1

      if findBestEmptyWinner(board, aiTeam) != -1  # Heavily weighs traps
        wld[row][col][0] += 3
      end

      return wld
    end


    def updateLosses(wld, board, aiTeam, row, col)
      wld[row][col][1] += 1

      if (findBestEmptyWinner(board, X) != -1) || (findBestEmptyWinner(board, O) != -1)  # Heavily weighs traps
        wld[row][col][1] += 100000
      end

      return wld
    end


    def addRecursedWLDVals(tempArray, wld, board)
      board.dimRows.times { |r|
        board.dimCols.times { |c|
          wld[r][c][0] += tempArray[r][c][0]
          wld[r][c][1] += tempArray[r][c][1]
          wld[r][c][2] += tempArray[r][c][2]
        }
      }

      return wld
    end


    def calculateBestMove(board, wld)
      bestMove = [0, 0]
      board.dimRows.times { |row|
        board.dimCols.times { |col|
          wld[row][col][0] += 1
          wld[row][col][1] += 1
          wld[row][col][2] += 1
          if wld[row][col] != [1,1,1]  # Ensures that the spaces being evaluated are empty
            if bestMove == [0,0]
              bestMove = [row,col]  # Makes sure that best move by default equals an empty space on the board
            end

            tempScore = ((2*wld[row][col][0]) + wld[row][col][2]) / (3*wld[row][col][1])
            if tempScore > ((2*wld[bestMove[0]][bestMove[1]][0]) + wld[bestMove[0]][bestMove[1]][2]) / (3*wld[bestMove[0]][bestMove[1]][1])
              bestMove = [row, col]
            end
          end
        }
      }

      return bestMove
    end


    def isBoardFull?(board)
      board.dimRows.times { |row|
        board.dimCols.times { |col|
          if board.spaceContents(col, row) == EMPTY
            return false
          end
        }
      }

      return true
    end


    def checkAllRowsForWin(board)
      board.dimRows.times { |row|
        groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(row,n)})

        if groupOfCells[0] == "Win"
          return groupOfCells[1]
        end
      }

      return 0
    end


    def checkAllColsForWin(board)
      board.dimCols.times { |col|
        groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,col)})

        if groupOfCells[0] == "Win"
          return groupOfCells[1]
        end
      }

      return 0
    end


    def checkForwardDiagForWin(board)
      groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,n)})

      if groupOfCells[0] == "Win"
        return groupOfCells[1]
      end
      return 0
    end


    def checkReverseDiagForWin(board)
      groupOfCells = checkCellGroup(board, Proc.new {|n| board.spaceContents(n,(board.dimCols-1) - n)})

      if groupOfCells[0] == "Win"
        return groupOfCells[1]
      end
      return 0
    end


    #TODO - break this method into two methods with at max 10 lines
    def checkCellGroup(board, getSpaceFromGroup)
      numTeamsEncountered, emptySpacesEncountered, emptySpaceLocation, currentTeam = 0, 0, 0, EMPTY

      board.dimCols.times { |i|
        if getSpaceFromGroup.call(i) == EMPTY
          emptySpaceLocation = i
          emptySpacesEncountered += 1
        else
          if currentTeam == EMPTY
            currentTeam = getSpaceFromGroup.call(i)
            numTeamsEncountered = 1
          end
          if currentTeam != getSpaceFromGroup.call(i)
            numTeamsEncountered += 1
          end
        end
      }

      return analyzeCellGroupData(numTeamsEncountered, emptySpacesEncountered, currentTeam, emptySpaceLocation)
    end


    def analyzeCellGroupData(numTeamsEncountered, emptySpacesEncountered, currentTeam, emptySpaceLocation)
      if numTeamsEncountered == 1 && emptySpacesEncountered == 0
        return ["Win", currentTeam]
      elsif numTeamsEncountered == 1 && emptySpacesEncountered == 1
        return ["EmptyWinner", emptySpaceLocation]
      end

      return ["NothingInteresting", 0]
    end
  end
end
