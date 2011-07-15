require 'board'
require 'calculate'
require 'player'
require 'constants'


class GameEngine
  def initialize()
    @board = create_board
    create_players
  end


  def create_board
    $stdout.puts "size of @board will be 3 rows by 3 columns"
    rows = 3
    cols = rows
    @board = Board.new(rows, cols)
    return @board
  end


  def create_players
    num_players = get_num_players

    if num_players == 1
      initialize_with_one_player
    else
      player_factory("Human", "Human")
    end
  end


  def initialize_with_one_player
    input = get_human_players_team

    if input == "X" || input == "x"
      player_factory("Human", "Computer")
    else
      player_factory("Computer", "Human")
    end
  end


  def player_factory(p1, p2)
    @player1 = Player.new(p1)
    @player2 = Player.new(p2)
  end


  def get_num_players
    num_players = 0
    while num_players != 1 && num_players != 2
      $stdout.puts "Number of players. 1 or 2?"
      num_players = $stdin.gets.chomp.to_i
    end

    return num_players
  end


  def get_human_players_team
    input = ""
    while input != "X" && input != "x" && input != "O" && input != "o"
      $stdout.puts "What team do you want to be on? X or O?"
      input = $stdin.gets.chomp
    end

    return input
  end


  def runGame
    while Calculate.is_game_over?(@board) == false
      if Calculate.current_team(@board) == X
        run_xs_turn
      else
        run_os_turn
      end

      @board.draw_board
    end
  end


  def run_xs_turn
    if @player1.type == "Human"
      run_humans_turn(X)
    else
      run_computers_turn(X)
    end
  end


  def run_os_turn
    if @player2.type == "Human"
      run_humans_turn(O)
    else
      run_computers_turn(O)
    end
  end


  def run_computers_turn(team)
    $stdout.puts "Please wait, computer thinking of next move..."
    aiMove = Calculate.ai_best_move(@board)
    row = aiMove[0]
    col = aiMove[1]

    if @board.space_contents(row, col) == EMPTY
      @board.make_move(row, col, team)
      $stdout.puts "Computer moved to space: " + row.to_s + col.to_s
    end
  end


  def run_humans_turn(team)
    move = get_human_players_move
    row, col = move

    if @board.space_contents(row, col) == EMPTY
      @board.make_move(row, col, team)
      $stdout.puts "Move successfully made"
    else
      $stdout.puts "Cannot move to a space that is already full"
    end
  end


  def get_human_players_move
    $stdout.puts "type location of next move Ex. '01' for row 0 and column 1"
    move = $stdin.gets.chomp
    move = validate_move(move)

    row = move[0,1].to_i
    col = move[1,1].to_i

    return [row, col]
  end


  def validate_move(move)
    while !(move[0,1].to_i < @board.dim_rows && move[1,1].to_i < @board.dim_cols)
      $stdout.puts "Invalid Move"
      $stdout.puts "type location of next move Ex. '01' for row 0 and column 1"
      move = $stdin.gets.chomp
    end

    return move
  end


  def game_over
    if Calculate.x_win?(@board) == true
      $stdout.puts "X wins!"
    elsif Calculate.o_win?(@board) == true
      $stdout.puts "O wins!"
    elsif Calculate.draw?(@board) == true
      $stdout.puts "Draw"
    end
  end
end


# Run the game --------------------------------------------
if __FILE__ == $0
  game1 = GameEngine.new
  game1.runGame
  game1.game_over
end
