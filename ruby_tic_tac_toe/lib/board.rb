class Board
  attr_reader :dim_rows, :dim_cols

  def initialize(rows, cols)
    @dim_rows = rows
    @dim_cols = cols
    @board = Array.new(rows) {Array.new(cols,0)}
  end


  def reset
    @board = Array.new(@dim_rows) {Array.new(@dim_cols,0)}
    @board
  end


  def space_contents(row, col)
    @board[row][col]
  end


  def make_move(row, col, team)
    @board[row][col] = team
    @board
  end


  def draw_board
    displayBlock = ""
    @dim_rows.times do |row|
      @dim_cols.times do |col|
        displayBlock += "|" + convert_space_val_to_graphic(@board[row][col])
      end
      displayBlock += "|\n"
    end

    puts displayBlock
  end


  def convert_space_val_to_graphic(team)
    if team == 1
      return "X"
    elsif team == 2
      return "O"
    else
      return " "
    end
  end
end
