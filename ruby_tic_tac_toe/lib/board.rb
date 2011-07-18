require 'space'

class Board
  attr_reader :dim_rows, :dim_cols, :spaces

  def initialize(rows, cols)
    @dim_rows = rows
    @dim_cols = cols
#    @board = Array.new(rows) {Array.new(cols,0)}
    initialize_spaces
  end


  def reset
#    @board = Array.new(@dim_rows) {Array.new(@dim_cols,0)}
#    @board
    initialize_spaces
  end


  def space_contents(row, col)
#    @board[row][col]
    @spaces.each do |space|
      if space.row == row && space.col == col
        return space.val
      end
    end
  end


  def make_move(row, col, team)
#    @board[row][col] = team
#    @board
    @spaces.each do |space|
      if space.row == row && space.col == col
        space.val = team
      end
    end
  end


  def draw_board
    displayBlock = ""
    @dim_rows.times do |row|
      @dim_cols.times do |col|
        displayBlock += "|" + convert_space_val_to_graphic(space_contents(row, col))
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


  def clone_board
    board_copy = Board.new(@dim_rows, @dim_cols)
    @dim_rows.times do |row|
      @dim_cols.times do |col|
        board_copy.make_move(row, col, space_contents(row, col))
      end
    end

    return board_copy
  end


  def num_moves_made
    count = 0

    @dim_rows.times do |row|
      @dim_cols.times do |col|
        if space_contents(row,col) != EMPTY
          count += 1
        end
      end
    end

    return count
  end


  def is_board_full?
    if num_moves_made == (@dim_rows * @dim_cols)
      return true
    end

    return false
  end


  private

  def initialize_spaces
    @spaces = []

    @dim_rows.times do |row|
      @dim_cols.times do |col|
        @spaces.push(Space.new(row, col))
      end
    end
  end
end
