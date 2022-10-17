require "pry-byebug"

class Board
  attr_reader :board

  def initialize(board = [['BR','BN','BB','BQ','BK','BB','BN','BR'],
                          ['BP','BP','BP','BP','BP','BP','BP','BP'],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          ['WP','WP','WP','WP','WP','WP','WP','WP'],
                          ['WR','WN','WB','WQ','WK','WB','WN','WR']], 
                direction = 1)
    @board = board
    @direction = direction
  end

  def display
    @board.each {|row| p row}
  end

  def make_move(whose_turn, player_input)
    destination_coord = convert_alg_to_coord(player_input[-2..-1])
    return false if destination_coord == nil

    if player_input.length == 2
      pawn_candidates = pawns_that_move(whose_turn, destination_coord)
      if pawn_candidates.length == 1
        @board = move_piece(pawn_candidates[0], destination_coord, @board)
        return true
      end
    end

    if player_input.include?("x")
      destination_alg = player_input.split("x")[1]
      origin_alg = player_input.split("x")[0]
      capture_mode = true
      if player_input.split("x").length != 2
        return false
      end
    else
      destination_alg = player_input[-2..-1]
      if destination_alg.length < 2
        return false
      end
      origin_alg = player_input[0..-3]
      capture_mode = false
    end

    if player_input[0] == "N" || player_input[0] == "B" || player_input[0] == "R" || player_input[0] == "Q" || player_input[0] == "K"
      origin_alg = origin_alg[1..-1]
      function_output = pieces_that_can_capture(player_input[0], whose_turn, origin_alg, destination_alg, @board, capture_mode)
    else
      function_output = pieces_that_can_capture("P", whose_turn, origin_alg, destination_alg, @board, capture_mode)
    end
    piece_that_captures = function_output[0]
    destination_to_be_captured = function_output[1]

    # binding.pry 

    which_king = whose_turn == 1 ? "WK" : "BK"

    if piece_that_captures.length == 1 && destination_to_be_captured.length == 1       
      @board = move_piece(piece_that_captures[0], destination_to_be_captured[0], @board)
      return true
    end
  return false
  end

  def check?(which_king, board = @board)
    king_coords = coord_list_of_piece(which_king)[0]
    king_alg = convert_coord_to_alg(king_coords)
    whose_turn = which_king[0] == "W" ? 2 : 1
    piece_list = ["P", "N", "B", "R", "Q", "K"]
    check = false
    piece_list.each do |piece|
      pieces_and_destinations = pieces_that_can_capture(piece, whose_turn, "", king_alg, board, true)
      if pieces_and_destinations[0].length >= 1
        check = true
        break
      end
    end
    return check
  end

  def coord_list_of_piece(piece, board = @board)
    coord_list = []
    board.each_with_index do |x, row|
      x.each_with_index do |y, col|
        if y == piece
          coord_list << [row, col]
        end
      end
    end
    return coord_list
  end

  def move_piece(starting_coord, ending_coord, board = @board)
    new_board = board
    piece = new_board[starting_coord[0]][starting_coord[1]]
    new_board[starting_coord[0]][starting_coord[1]] = nil
    new_board[ending_coord[0]][ending_coord[1]] = piece
    return new_board
  end

  def valid_pawn_move?(whose_turn, player_input, board = @board)
    destination_coord = convert_alg_to_coord(player_input)
    return false if destination_coord == nil
    pawn_candidates = pawns_that_move(whose_turn, destination_coord)
    if pawn_candidates.length == 1
      return true
    end
    return false
  end

  def generate_piece_moves(piece, pos, whose_turn, capture_mode, board = @board)
    if piece == "N"
      list = [[pos[0]+2, pos[1]+1], [pos[0]+2, pos[1]-1], 
              [pos[0]+1, pos[1]+2], [pos[0]+1, pos[1]-2], 
              [pos[0]-1, pos[1]-2], [pos[0]-1, pos[1]+2],
              [pos[0]-2, pos[1]-1], [pos[0]-2, pos[1]+1]]
      list2 = []
      list.each do |p|
        if p[0].between?(0,7) && p[1].between?(0,7)
          list2 << p
        end
      end
      return list2
    end

    if piece == "B"
      list = []
      deltas = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
      deltas.each do |d|
        list = list + gen_moves_through_extension(pos, d, whose_turn, capture_mode, board)
      end
      return list
    end

    if piece == "R"
      list = []
      deltas = [[-1,0],[1,0],[0,-1],[0,1]]
      deltas.each do |d|
        list = list + gen_moves_through_extension(pos, d, whose_turn, capture_mode, board)
      end
      return list
    end

    if piece == "Q"
      list = []
      deltas = [[-1,0],[1,0],[0,-1],[0,1],[-1, -1], [-1, 1], [1, 1], [1, -1]]
      deltas.each do |d|
        list = list + gen_moves_through_extension(pos, d, whose_turn, capture_mode, board)
      end
      return list
    end

    if piece == "K"
      list = []
      deltas = [[-1,0],[1,0],[0,-1],[0,1],[-1, -1], [-1, 1], [1, 1], [1, -1]]
      deltas.each do |d|
        list = list + gen_moves_extend_once(pos, d, whose_turn, capture_mode, board)
      end
      return list
    end
  end

  def gen_moves_extend_once(pos, delta, whose_turn, capture_mode, board=@board)
    possible_moves = []
    current = pos.clone
    opposite_side = whose_turn == 1 ? "B" : "W"
    if (current[0]+delta[0]).between?(0,7) && (current[1]+delta[1]).between?(0,7) 
      if board[current[0]+delta[0]][current[1]+delta[1]] != nil
        if capture_mode == true && board[current[0]+delta[0]][current[1]+delta[1]][0] == opposite_side
          possible_moves << [current[0]+delta[0], current[1]+delta[1]]
        end
      else
        possible_moves << [current[0]+delta[0], current[1]+delta[1]]
      end
    end
    return possible_moves
  end

  def gen_moves_through_extension(pos, delta, whose_turn, capture_mode, board=@board)
    possible_moves = []
    current = pos.clone
    opposite_side = whose_turn == 1 ? "B" : "W"
    while (current[0]+delta[0]).between?(0,7) && (current[1]+delta[1]).between?(0,7) 
      if board[current[0]+delta[0]][current[1]+delta[1]] != nil
        if capture_mode == true && board[current[0]+delta[0]][current[1]+delta[1]][0] == opposite_side
          possible_moves << [current[0]+delta[0], current[1]+delta[1]]
        end
        break
      end
      possible_moves << [current[0]+delta[0], current[1]+delta[1]]
      current[0] = current[0] + delta[0]
      current[1] = current[1] + delta[1]
    end
    return possible_moves
  end

  def pawns_that_move(whose_turn, coordinates)
    #if white's turn
    if whose_turn == 1
      direction2 = @direction
      initial_row = @direction == 1 ? 6 : 1
      pawn = "WP"
    else #if black's turn
      direction2 = -@direction
      initial_row = @direction == 1 ? 1 : 6
      pawn = "BP"
    end
    pawn_list = []
    #if there's a pawn one space away with no pieces blocking
    if @board[coordinates[0]+direction2][coordinates[1]] == pawn && @board[coordinates[0]][coordinates[1]] == nil
      pawn_list << [coordinates[0]+direction2, coordinates[1]]
    #else if there's an initial position pawn two spaces away with no pieces blocking
    elsif coordinates[0]+2*direction2 == initial_row && @board[coordinates[0]+2*direction2][coordinates[1]] == pawn && 
          @board[coordinates[0]][coordinates[1]] == nil && @board[coordinates[0]+direction2][coordinates[1]] == nil
      pawn_list << [coordinates[0]+2*direction2, coordinates[1]]
    end
    return pawn_list
  end

  def pieces_that_can_capture(piece, whose_turn, origin_alg, destination_alg, board= @board, capture_mode= true)
    pieces_there = []
    destination_coords = []
    direction2 = whose_turn == 1 ? @direction : -@direction
   
    if origin_alg == nil || origin_alg.length == 0
      colored_piece = whose_turn == 1 ? "W"+piece : "B"+piece
      pieces_there = coord_list_of_piece(colored_piece, board)

      # binding.pry

      puts pieces_there
    end
    if origin_alg.length == 1
      column = convert_alg_col_to_coord(origin_alg)
      return [[],[]] if column == nil
      pieces_there = whose_turn == 1 ? pieces_in_that_column("W"+piece, column) :
                                      pieces_in_that_column("B"+piece, column)
    elsif origin_alg.length == 2
      coords = convert_alg_to_coord(origin_alg)
      return [[],[]] if coords == nil
      if whose_turn == 1
        pieces_there << coords if board[coords[0]][coords[1]] == "W"+piece
      else
        pieces_there << coords if board[coords[0]][coords[1]] == "B"+piece
      end
    end

    if destination_alg.length == 2
      coords2 = convert_alg_to_coord(destination_alg)
      return [[],[]] if coords2 == nil
      if capture_mode == true
        if whose_turn == 1
          destination_coords << coords2 if board[coords2[0]][coords2[1]] != nil && board[coords2[0]][coords2[1]][0] == "B"
        else
          destination_coords << coords2 if board[coords2[0]][coords2[1]] != nil && board[coords2[0]][coords2[1]][0] == "W"
        end
      else
        destination_coords << coords2 if board[coords2[0]][coords2[1]] == nil
      end
    elsif destination_alg.length == 1
      destination_coords = whose_turn == 1 ? pieces_in_that_column("B", column) :
                                             pieces_in_that_column("W", column)
    end
    
    if destination_coords == []
      return [[],[]]
    end

    # binding.pry 

    pieces_that_can_capture = []
    destinations_that_can_be_captured = []
    pieces_there.each do |p|
      destination_coords.each do |d|
        if piece == "P"
          if [p[0]-direction2, p[1]+1] == d || [p[0]-direction2, p[1]-1] == d
            pieces_that_can_capture << p
            destinations_that_can_be_captured << d
          end
        else

          # binding.pry 


          if generate_piece_moves(piece, p, whose_turn, capture_mode, board).include?(d)
            pieces_that_can_capture << p
            destinations_that_can_be_captured << d
          end
        end
      end
    end
    return [pieces_that_can_capture, destinations_that_can_be_captured]
  end

  def pieces_in_that_column(piece, col)
    
  end

  def convert_alg_col_to_coord(alg_column)
    hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    return hash[alg_column.downcase]
  end

  def convert_coord_to_alg(coord)
    array = ["a", "b", "c", "d", "e", "f", "g", "h"]
    if coord == nil || coord[0] == nil || coord[1] == nil
      return nil
    end
    algebraic1 = array[coord[1]]
    algebraic2 = (8 - coord[0]).to_s
    return algebraic1 + algebraic2
  end

  def convert_alg_to_coord(algebraic)
    hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    if algebraic == nil || algebraic[0] == nil || algebraic[1] == nil
      return nil
    end
    coord2 = hash[algebraic[0].downcase]
    coord1 = algebraic[1].to_i.to_s == algebraic[1] ? 8 - algebraic[1].to_i : nil
    if coord1 == nil || coord2 == nil
      return nil
    else
      return [coord1, coord2]
    end
  end
end