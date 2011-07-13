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

      wld = createWLDArray(board, currentTeam(board), currentTeam(board), 0)  # Create win/loss/draw array
      calculatedMove = calculateBestMove(board, wld)

      return calculatedMove
    end


    private # The rest of the methods in this class are private

    def preCalculatedMoves(board)
      emptyWinner = findEmptyWinners(board)
      if emptyWinner != -1
        return emptyWinner
      end

      hardCodedMove = hardCodedMoves(board)
      if hardCodedMove != -1
        return hardCodedMove
      end

      return -1
    end


    def hardCodedMoves(board)
      if board.dimRows == 3  # To avoid double corner trap that the algorithm doesn't pick up on
        if (board.spaceContents(1,2) == X && board.spaceContents(2,1) == X && board.spaceContents(2,2) == EMPTY) || (board.spaceContents(1,2) == O && board.spaceContents(2,1) == O && board.spaceContents(2,2) == EMPTY)
          return [2,2]
        end

        if (board.spaceContents(0,1) == X && board.spaceContents(1,0) == X && board.spaceContents(0,0) == EMPTY) || (board.spaceContents(0,1) == O && board.spaceContents(1,0) == O && board.spaceContents(0,0) == EMPTY)
          return [0,0]
        end

        if (board.spaceContents(1,0) == X && board.spaceContents(2,1) == X && board.spaceContents(2,0) == EMPTY) || (board.spaceContents(1,0) == O && board.spaceContents(2,1) == O && board.spaceContents(2,0) == EMPTY)
          return [2,0]
        end

        if (board.spaceContents(0,1) == X && board.spaceContents(1,2) == X && board.spaceContents(0,2) == EMPTY) || (board.spaceContents(0,1) == O && board.spaceContents(1,2) == O && board.spaceContents(0,2) == EMPTY)
          return [0,2]
        end

        if board.spaceContents(1,1) == X && Calculate.numMovesMade(board) == 1  # To optimize speed
          return [0,0]
        end

        if board.spaceContents(1,1) == EMPTY  # To optimize speed
          return [1,1]
        end

        if (Calculate.numMovesMade(board) == 3 && board.spaceContents(1,1) != 0 && board.spaceContents(0,0) == 0) && (board.spaceContents(2,0) == 0 && board.spaceContents(0,2) == 0)
          return [0,0]
        end

        if Calculate.numMovesMade(board) == 3 && board.spaceContents(1,1) != 0 && board.spaceContents(2,2) == 0 && (board.spaceContents(2,0) == 0 && board.spaceContents(0,2) == 0)
          return [2,2]
        end
      end

      return -1
    end


    def findEmptyWinners(board)
      emptyWinnerArray = []

      #Checking Rows
      row = 0
      while row < board.dimRows
        col, numTeamsEncountered, emptySpacesEncountered, currentTeam = 0, 0, 0, 0
        emptySpaceLocation = []
        while col < board.dimCols
          if board.spaceContents(row, col) != 0
            if currentTeam == 0
              currentTeam = board.spaceContents(row, col)
              numTeamsEncountered = 1
            end
            if currentTeam != board.spaceContents(row, col)
              numTeamsEncountered += 1
            end
          else
            emptySpaceLocation = [row,col]
            emptySpacesEncountered += 1
          end

          col += 1
        end

        if numTeamsEncountered == 1 && emptySpacesEncountered == 1
          emptyWinnerArray.push(emptySpaceLocation)
        end

        row += 1
      end


      #Checking Columns
      col = 0
      while col < board.dimRows
        row, numTeamsEncountered, emptySpacesEncountered, currentTeam = 0, 0, 0, 0
        emptySpaceLocation = []
        while row < board.dimCols
          if board.spaceContents(row, col) != 0
            if currentTeam == 0
              currentTeam = board.spaceContents(row, col)
              numTeamsEncountered = 1
            end
            if currentTeam != board.spaceContents(row, col)
              numTeamsEncountered += 1
            end
          else
            emptySpaceLocation = [row,col]
            emptySpacesEncountered += 1
          end

          row += 1
        end

        if numTeamsEncountered == 1 && emptySpacesEncountered == 1
          emptyWinnerArray.push(emptySpaceLocation)
        end

        col += 1
      end


      #Checking Forward Diagonal
      n, numTeamsEncountered, emptySpacesEncountered, currentTeam = 0, 0, 0, 0
      emptySpaceLocation = []
      while n < board.dimCols
        if board.spaceContents(n, n) != 0
          if currentTeam == 0
            currentTeam = board.spaceContents(n, n)
            numTeamsEncountered = 1
          end
          if currentTeam != board.spaceContents(n, n)
            numTeamsEncountered += 1
          end
        else
          emptySpaceLocation = [n,n]
          emptySpacesEncountered += 1
        end

        n += 1
      end

      if numTeamsEncountered == 1 && emptySpacesEncountered == 1
        emptyWinnerArray.push(emptySpaceLocation)
      end

      #Checking Reverse Diagonal
      n, numTeamsEncountered, emptySpacesEncountered, currentTeam = 0, 0, 0, 0
      emptySpaceLocation = []
      while n < board.dimCols
        if board.spaceContents(n,(board.dimCols-1) - n) != 0
          if currentTeam == 0
            currentTeam = board.spaceContents(n,(board.dimCols-1) - n)
            numTeamsEncountered = 1
          end
          if currentTeam != board.spaceContents(n,(board.dimCols-1) - n)
            numTeamsEncountered += 1
          end
        else
          emptySpaceLocation = [n,(board.dimCols-1) - n]
          emptySpacesEncountered += 1
        end

        n += 1
      end

      if numTeamsEncountered == 1 && emptySpacesEncountered == 1
        emptyWinnerArray.push(emptySpaceLocation)
      end


      #TODO - Go through all empty winners and find the most beneficial one
      i = 0
      while i < emptyWinnerArray.length
        if Calculate.currentTeam(board) == 1
          board.makeMove(emptyWinnerArray[i][0], emptyWinnerArray[i][1], 1)
          if Calculate.xWin?(board) == true
            board.makeMove(emptyWinnerArray[i][0], emptyWinnerArray[i][1], 0)
            return emptyWinnerArray[i]
          end
          board.makeMove(emptyWinnerArray[i][0], emptyWinnerArray[i][1], 0)
        else
          return emptyWinnerArray[i]
        end

        i += 1
      end      

      return -1
    end


    def createWLDArray(board, aiTeam, curTeam, depth)
      wld = Array.new(board.dimRows) {Array.new(board.dimRows) {Array.new(3,0)}}

      # Loop through empty spaces to fill the wld array out
      row = 0
      while row < board.dimRows
        col = 0
        while col < board.dimCols
          # Is this an empty space?
          if board.spaceContents(row, col) == 0
            board.makeMove(row, col, currentTeam(board))  # Make a hypothetical move

            if Calculate.isGameOver?(board) == true
              wld = updateWLD(row, col, aiTeam, board, wld)
              board.makeMove(row, col, 0)  # Take back hypothetical move
              return wld
            end

            # Recursively call aiBestMove at 1 more level of depth
            tempArray = createWLDArray(board, aiTeam, currentTeam(board), depth+1)

            # Add return value (array) of recursive call to wld array
            r = 0
            while r < board.dimRows
              c = 0
              while c < board.dimCols
                wld[r][c][0] += tempArray[r][c][0]
                wld[r][c][1] += tempArray[r][c][1]
                wld[r][c][2] += tempArray[r][c][2]

                c += 1
              end
              r += 1
            end

            # Take back hypothetical move
            board.makeMove(row, col, 0)
          end

          col += 1
        end

        row += 1
      end

      # If the loop is over, return this depth's completed wld array
      return wld
    end


    def updateWLD(row, col, aiTeam, board, wld)
      if Calculate.oWin?(board) == true
        if aiTeam == 2
          wld[row][col][0] += 1

          if findEmptyWinners(board) != -1  # Heavily wieghs traps
            wld[row][col][0] += 3
          end
        else
          wld[row][col][1] += 1

          if findEmptyWinners(board) != -1  # Heavily wieghs traps
            wld[row][col][1] += 100000
          end
        end
      end
      if Calculate.xWin?(board) == true
        if aiTeam == 2
          wld[row][col][1] += 1

          if findEmptyWinners(board) != -1  # Heavily wieghs traps
            wld[row][col][1] += 100000
          end
        else
          wld[row][col][0] += 1

          if findEmptyWinners(board) != -1  # Heavily wieghs traps
            wld[row][col][0] += 3
          end
        end
      end
      if Calculate.draw?(board) == true
        wld[row][col][2] += 1
      end

      return wld
    end


    def calculateBestMove(board, wld)
      bestMove = [0, 0]
      row = 0
      while row < board.dimRows
        col = 0
        while col < board.dimCols
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

          col += 1
        end

        row += 1
      end
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


    def checkAllColsForWin(board)
      board.dimCols.times { |col|
        isThereAColWinner = checkCellGroupForWin(board, Proc.new {|n| board.spaceContents(n,col)})

        if isThereAColWinner != 0
          return isThereAColWinner
        end
      }

      return 0
    end


    def checkAllRowsForWin(board)
      board.dimRows.times { |row|
        isThereARowWinner = checkCellGroupForWin(board, Proc.new {|n| board.spaceContents(row,n)})

        if isThereARowWinner != 0
          return isThereARowWinner
        end
      }

      return 0
    end


    def checkForwardDiagForWin(board)
      return checkCellGroupForWin(board, Proc.new {|n| board.spaceContents(n,n)})
    end


    def checkReverseDiagForWin(board)
      return checkCellGroupForWin(board, Proc.new {|n| board.spaceContents(n,(board.dimCols-1) - n)})
    end


    #TODO - break this method into two methods with at max 10 lines
    def checkCellGroupForWin(board, getSpaceFromGroup)
      numTeamsEncountered, emptySpacesEncountered, currentTeam = 0, 0, EMPTY

      board.dimCols.times { |i|
        if getSpaceFromGroup.call(i) == EMPTY
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

      return analyzeCellGroupData(numTeamsEncountered, emptySpacesEncountered, currentTeam)
    end


    def analyzeCellGroupData(numTeamsEncountered, emptySpacesEncountered, currentTeam)
      if numTeamsEncountered == 1 && emptySpacesEncountered == 0
        return currentTeam
      end

      return 0
    end
  end
end
