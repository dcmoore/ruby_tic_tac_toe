class Board
  attr_reader :dimRows, :dimCols

  def initialize(rows, cols)
    @dimRows = rows
    @dimCols = cols
    @board = Array.new(rows) {Array.new(cols,0)}
  end


  def reset
    @board = Array.new(@dimRows) {Array.new(@dimCols,0)}
    @board
  end


  def spaceContents(row, col)
    @board[row][col]
  end


  def makeMove(row, col, team)
    @board[row][col] = team
    @board
  end


  def drawBoard
    puts @board[0][0].to_s + "|" + @board[0][1].to_s + "|" + @board[0][2].to_s
    puts "------"
    puts @board[1][0].to_s + "|" + @board[1][1].to_s + "|" + @board[1][2].to_s
    puts "------"
    puts @board[2][0].to_s + "|" + @board[2][1].to_s + "|" + @board[2][2].to_s
  end
end
