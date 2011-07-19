require 'constants'
require 'space'

class Calculate
  class << self
    def is_game_over?(board)
      if draw?(board) == false && win?(board, X) == false && win?(board, O) == false
        return false
      end
      return true
    end


    def draw?(board)
      if win?(board, X) == true || win?(board, O) == true
        return false
      end
      return board.is_board_full?
    end


    def win?(board, mark)
      if check_board_for_win(board) == mark 
        return true
      end
      return false
    end


    def current_team(board)
      current_turn = board.num_moves_made
      if current_turn % 2 == 0
        return X
      else
        return O
      end
    end


    def ai_best_move(board)
      pre_calculated_move = pre_calculated_moves(board)
      if pre_calculated_move != -1
        return pre_calculated_move
      end

      wld = create_wld_array(board, current_team(board), current_team(board), 0)  # Create a win/loss/draw array
      calculated_move = calculate_best_move(board, wld)

      return calculated_move
    end


    private # The rest of the methods in this class are private

    def pre_calculated_moves(board)
      empty_winner = find_best_empty_winner(board, current_team(board))
      if empty_winner != -1
        return empty_winner
      end

      optimized_move = optimize_the_algorithm(board)
      if optimized_move != -1
        return optimized_move
      end

      return -1
    end


    def find_best_empty_winner(board, team)
      board_copy = board.clone_board
      empty_winners = get_empty_winners_array(board_copy)

      winner = find_first_winning_empty_winner(empty_winners, board_copy, team)
      return winner if winner

      if empty_winners.length != 0
        return empty_winners[0]
      end
      return -1
    end


    #QUESTION - would this function be considered feature envy?
    def get_empty_winners_array(board)
      group_of_cells = inspect_all_rows_cols_and_diags(board)
      return return_value_of_check_for_empty_winner_method(group_of_cells)
    end


    def inspect_all_rows_cols_and_diags(board)
      group_of_cells = []

      board.dim_rows.times do |i|
        group_of_cells.push(check_cell_group(board, lambda {|n| Space.new(i, n, board.space_contents(i,n))}))
        group_of_cells.push(check_cell_group(board, lambda {|n| Space.new(n, i, board.space_contents(n,i))}))
      end
      group_of_cells.push(check_cell_group(board, lambda {|n| Space.new(n, n, board.space_contents(n,n))}))
      group_of_cells.push(check_cell_group(board, lambda {|n| Space.new(n,(board.dim_cols-1) - n, board.space_contents(n,(board.dim_cols-1) - n))}))

      return group_of_cells
    end


    def return_value_of_check_for_empty_winner_method(group_of_cells)
      winners = []
      group_of_cells.length.times do |i|
        if group_of_cells[i][0] == "empty_winner"
          winners.push(group_of_cells[i][1])
        end
      end

      if winners.length != 0
        return winners
      end
      return []
    end


    def find_first_winning_empty_winner(empty_winners, board, team)
      empty_winners.length.times do |i|
        board.make_move(empty_winners[i][0], empty_winners[i][1], team)
        if team == X
          return empty_winners[i] if win?(board, X) == true
        else
          return empty_winners[i] if win?(board, O) == true
        end
        board.make_move(empty_winners[i][0], empty_winners[i][1], 0)
      end
      return nil
    end


    def optimize_the_algorithm(board)
      if board.space_contents(1,1) == X && board.num_moves_made == 1
        return [0,0]
      end

      if board.space_contents(1,1) == EMPTY
        return [1,1]
      end

      return -1
    end


    def create_wld_array(board, ai_team, cur_team, depth)
      wld = Array.new(board.dim_rows) {Array.new(board.dim_rows) {Array.new(3,EMPTY)}}

      board.spaces.each do |space|
        if board.space_contents(space.row, space.col) == 0  # Is this an empty space?
          wld, board = fill_out_wld_array(wld, board, space.row, space.col, ai_team, cur_team, depth)
        end
      end

      return wld  # If the loop is over, return this depth's completed wld array
    end


    #TODO - break up into smaller method
    def fill_out_wld_array(wld, board, row, col, ai_team, cur_team, depth)
      board.make_move(row, col, current_team(board))  # Make a hypothetical move

      if is_game_over?(board) == true
        wld = update_wld(row, col, ai_team, board, wld)
        board.make_move(row, col, 0)  # Take back hypothetical move
        return [wld, board]
      end

      temp_array = create_wld_array(board, ai_team, current_team(board), depth+1)  # Recursively call ai_best_move at 1 more level of depth
      wld = add_recursed_wld_vals(temp_array, wld, board, row, col)  # Add return value (array) of recursive call to wld array
      board.make_move(row, col, 0)  # Take back hypothetical move

      return [wld, board]
    end


    def update_wld(row, col, ai_team, board, wld)
      wld = update_wld_when_o_wins(row, col, ai_team, board, wld)
      wld = update_wld_when_x_wins(row, col, ai_team, board, wld)
      wld = update_wld_when_draw(row, col, ai_team, board, wld)

      return wld
    end


    def update_wld_when_o_wins(row, col, ai_team, board, wld)
      if win?(board, O) == true
        if ai_team == O
          wld = update_wins(wld, board, ai_team, row, col)
        else
          wld = update_losses(wld, board, ai_team, row, col)
        end
      end

      return wld
    end


    def update_wld_when_x_wins(row, col, ai_team, board, wld)
      if win?(board, X) == true
        if ai_team == O
          wld = update_losses(wld, board, ai_team, row, col)
        else
          wld = update_wins(wld, board, ai_team, row, col)
        end
      end

      return wld
    end


    def update_wld_when_draw(row, col, ai_team, board, wld)
      if draw?(board) == true
        wld[row][col][2] += 1
      end

      return wld
    end


    def update_wins(wld, board, ai_team, row, col)
      wld[row][col][0] += 1

      if find_best_empty_winner(board, ai_team) != -1  # Heavily weighs traps
        wld[row][col][0] += 4
      end

      return wld
    end


    def update_losses(wld, board, ai_team, row, col)
      wld[row][col][1] += 1

      if find_best_empty_winner(board, ai_team) != -1  # Heavily weighs traps
        wld[row][col][1] += 12
      end

      return wld
    end


    def add_recursed_wld_vals(temp_array, wld, board, r, c)
      board.spaces.each do |space|
        wld[r][c][0] += temp_array[space.row][space.col][0]
        wld[r][c][1] += temp_array[space.row][space.col][1]
        wld[r][c][2] += temp_array[space.row][space.col][2]
      end

      return wld
    end


    def calculate_best_move(board, wld)
      best_move = [0, 0]
      board.spaces.each do |space|
        wld = add_one_so_you_dont_divide_by_zero(wld, space.row, space.col)
        if wld[space.row][space.col] != [1,1,1]  # Ensures that the spaces being evaluated are empty spaces on the board
          best_move = set_a_default_value_if_it_hasnt_already_been_set(best_move, space.row, space.col)
          best_move = find_a_move_better_than_the_default(wld, best_move, space.row, space.col)
        end
      end

      return best_move
    end


    def add_one_so_you_dont_divide_by_zero(wld, row, col)
      wld[row][col][0] += 1
      wld[row][col][1] += 1
      wld[row][col][2] += 1

      return wld
    end


    def set_a_default_value_if_it_hasnt_already_been_set(best_move, row, col)
      if best_move == [0,0]
        best_move = [row,col]  # Makes sure that best move by default equals an empty space on the board
      end

      return best_move
    end


    def find_a_move_better_than_the_default(wld, best_move, row, col)
      temp_score = (wld[row][col][0] - wld[row][col][1])
      if temp_score > (wld[best_move[0]][best_move[1]][0] - wld[best_move[0]][best_move[1]][1])
        best_move = [row, col]
      end

      return best_move
    end


    #QUESTION - would this function be considered feature envy?
    def check_board_for_win(board)
      group_of_cells = inspect_all_rows_cols_and_diags(board)
      return return_value_of_check_for_win_method(group_of_cells)
    end


    def return_value_of_check_for_win_method(group_of_cells)
      group_of_cells.length.times do |i|
        if group_of_cells[i][0] == "win"
          return group_of_cells[i][1]
        end
      end
      return 0
    end


    #TODO - split into smaller methods
    #QUESTION - would this function be considered feature envy?
    def check_cell_group(board, prc)
      num_teams_encountered, empty_spaces_encountered, empty_space_location, current_team, space = 0, 0, 0, EMPTY, []

      board.dim_cols.times do |i|
        space.push(prc.call(i))
        if space[i].val == EMPTY
          empty_space_location = i
          empty_spaces_encountered += 1
        else
          if current_team == EMPTY
            current_team = space[i].val
            num_teams_encountered = 1
          end
          if current_team != space[i].val
            num_teams_encountered += 1
          end
        end
      end

      return analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team, empty_space_location, space)
    end


    def analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team, empty_space_location, space)
      if num_teams_encountered == 1 && empty_spaces_encountered == 0
        return ["win", current_team]
      elsif num_teams_encountered == 1 && empty_spaces_encountered == 1
        return ["empty_winner", [space[empty_space_location].row, space[empty_space_location].col]]
      end

      return ["nothing_interesting", 0]
    end
  end
end
