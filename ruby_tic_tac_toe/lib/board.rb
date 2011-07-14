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
    puts convertSpaceValToGraphic(@board[0][0]) + "|" + convertSpaceValToGraphic(@board[0][1]) + "|" + convertSpaceValToGraphic(@board[0][2])
    puts "-----"
    puts convertSpaceValToGraphic(@board[1][0]) + "|" + convertSpaceValToGraphic(@board[1][1]) + "|" + convertSpaceValToGraphic(@board[1][2])
    puts "-----"
    puts convertSpaceValToGraphic(@board[2][0]) + "|" + convertSpaceValToGraphic(@board[2][1]) + "|" + convertSpaceValToGraphic(@board[2][2])
  end


  def convertSpaceValToGraphic(team)
    if team == 1
      return "X"
    elsif team == 2
      return "O"
    else
      return " "
    end
  end
end
