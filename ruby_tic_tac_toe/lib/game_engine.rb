#X|O|X
#-----
#O|X|O
#-----
#X|O|X

require 'board'
require 'calculate'
require 'player'
require '../constants'


class GameEngine
  def initialize()
    @board = createBoard
    @player1, @player2 = createPlayers
  end

  def createBoard
    puts "size of @board will be 3 rows by 3 columns"
    rows = 3
    cols = rows
    @board = Board.new(rows, cols)
    return @board
  end


  def createPlayers
    numPlayers = getNumPlayers

    if numPlayers == 1
      input = getHumanPlayersTeam

      if input == "X" || input == "x"
        p1 = Player.new("Human")
        p2 = Player.new("Computer")
      else
        p1 = Player.new("Computer")
        p2 = Player.new("Human")
      end
    else
      p1 = Player.new("Human")
      p2 = Player.new("Human")
    end

    return [p1, p2]
  end


  def getNumPlayers
    numPlayers = 0
    while numPlayers != 1 && numPlayers != 2
      puts "Number of players. 1 or 2?"
      numPlayers = gets.chomp.to_i
    end

    return numPlayers
  end


  def getHumanPlayersTeam
    input = ""
    while input != "X" && input != "x" && input != "O" && input != "o"
      puts "What team do you want to be on? X or O?"
      input = gets.chomp
    end

    return input
  end


  def runGame
    while Calculate.isGameOver?(@board) == false
      if Calculate.currentTeam(@board) == X
        runXsTurn
      else
        runOsTurn
      end

      @board.drawBoard
    end
  end


  def runXsTurn
    if @player1.type == "Human"
      runHumansTurn(X)
    else
      runComputersTurn(X)
    end
  end


  def runOsTurn
    if @player2.type == "Human"
      runHumansTurn(O)
    else
      runComputersTurn(O)
    end
  end


  def runComputersTurn(team)
    puts "Please wait, computer thinking of next move..."
    aiMove = Calculate.aiBestMove(@board)
    row = aiMove[0]
    col = aiMove[1]

    if @board.spaceContents(row, col) == EMPTY
      @board.makeMove(row, col, team)
      puts "Computer moved to space: "
      puts row
      puts col
    end
  end


  def runHumansTurn(team)
    move = getHumanPlayersMove
    row, col = move

    if @board.spaceContents(row, col) == EMPTY
      @board.makeMove(row, col, team)
      puts "Move successfully made"
    else
      puts "Cannot move to a space that is already full"
    end
  end


  def getHumanPlayersMove
    puts "type location of next move Ex. '01' for row 0 and column 1"
    move = gets.chomp

    row = move[0,1].to_i
    col = move[1,1].to_i

    return [row, col]
  end


  def gameOver
    if Calculate.xWin?(@board) == true
      puts "X wins!"
    elsif Calculate.oWin?(@board) == true
      puts "O wins!"
    elsif Calculate.draw?(@board) == true
      puts "Draw"
    end
  end
end


#--------------------------------------------
game1 = GameEngine.new
game1.runGame
game1.gameOver
