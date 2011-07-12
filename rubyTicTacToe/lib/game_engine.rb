#X|O|X
#-----
#O|X|O
#-----
#X|O|X

require 'ticTacToe'

puts "size of board will be 3 rows by 3 columns"
rows = 3
cols = rows
board = Board.new(rows, cols)

numPlayers = 0
while numPlayers != 1 && numPlayers != 2
  puts "Number of players. 1 or 2?"
  numPlayers = gets.chomp.to_i
end

if numPlayers == 1
  input = ""
  while input != "X" && input != "x" && input != "O" && input != "o"
    puts "What team do you want to be on? X or O?"
    input = gets.chomp
  end

  if input == "X" || input == "x"
    player1 = Player.new(1, "Human")
    player2 = Player.new(2, "Computer")
  else
    player1 = Player.new(1, "Computer")
    player2 = Player.new(2, "Human")
  end
else
  player1 = Player.new(1, "Human")
  player2 = Player.new(2, "Human")
end


while Calculate.isGameOver?(board) == false
  if Calculate.currentTeam(board) == 1
    if player1.type == "Human"
      puts "type location of next move Ex. '01' for row 0 and column 1"
      move = gets.chomp

      row = move[0,1].to_i
      col = move[1,1].to_i
      if board.spaceContents(row, col) == 0
        board.makeMove(row, col, 1)
        puts "Move successfully made"
      else
        puts "Cannot move to a space that is already full"
      end
    else
      puts "Please wait, computer thinking of next move..."
      aiMove = Calculate.aiBestMove(board)
      row = aiMove[0]
      col = aiMove[1]

      if board.spaceContents(row, col) == 0
        board.makeMove(row, col, 1)
        puts "Computer moved to space: "
        puts row
        puts col
      end
    end
  else
    if player2.type == "Human"
      puts "type location of next move Ex. '01' for row 0 and column 1"
      move = gets.chomp

      row = move[0,1].to_i
      col = move[1,1].to_i
      if board.spaceContents(row, col) == 0
        board.makeMove(row, col, 2)
        puts "Move successfully made"
      else
        puts "Cannot move to a space that is already full"
      end
    else
      puts "Please wait, computer thinking of next move..."
      aiMove = Calculate.aiBestMove(board)
      row = aiMove[0]
      col = aiMove[1]

      if board.spaceContents(row, col) == 0
        board.makeMove(row, col, 2)
        puts "Computer moved to space: "
        puts row
        puts col
      end
    end      
  end
end

if Calculate.xWin?(board) == true
  puts "X wins!"
elsif Calculate.oWin?(board) == true
  puts "O wins!"
elsif Calculate.draw?(board) == true
  puts "Draw"
end
