require 'space'

class Board
  attr_reader :dim_rows, :dim_cols, :spaces

  def initialize(rows, cols)
    @dim_rows = rows
    @dim_cols = cols
    initialize_spaces
  end


  def reset
    initialize_spaces
  end


  def space_contents(row, col)
    @spaces.each do |space|
      if space.row == row && space.col == col
        return space.val
      end
    end
  end


  def make_move(row, col, team)
    @spaces.each do |space|
      if space.row == row && space.col == col
        space.val = team
      end
    end
  end


  def draw_board
    displayBlock = ""

    @spaces.each do |space|
      displayBlock += "|" + convert_space_val_to_graphic(space_contents(space.row, space.col))
      if space.col == (@dim_cols - 1)
        displayBlock += "|\n"
      end
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

    @spaces.each do |space|
        board_copy.make_move(space.row, space.col, space_contents(space.row, space.col))
    end

    return board_copy
  end


  def num_moves_made
    count = 0

    @spaces.each do |space|
      if space_contents(space.row, space.col) != EMPTY
        count += 1
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
