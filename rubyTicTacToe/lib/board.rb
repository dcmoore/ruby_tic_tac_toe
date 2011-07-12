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

  def isEmpty?(row, col)
    if @board[row][col] == 0
      return true
    end
    false
  end
end
