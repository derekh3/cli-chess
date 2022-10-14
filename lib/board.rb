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

    if player_input[0] == "N" && !player_input.include?("x")
      knight_candidates = knights_that_move(whose_turn, destination_coord, board)
      if knight_candidates.length == 1
        @board = move_piece(knight_candidates[0], destination_coord, @board)
        return true
      end
    end

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
      if player_input.split("x").length != 2
        return false
      end
      if player_input[0] == "N" || player_input[0] == "B" || player_input[0] == "R" || player_input[0] == "Q" || player_input[0] == "K"
        origin_alg = origin_alg[1..-1]
        function_output = pieces_that_can_capture(player_input[0], whose_turn, origin_alg, destination_alg)
      else
        function_output = pieces_that_can_capture("P", whose_turn, origin_alg, destination_alg)
      end
      piece_that_captures = function_output[0]
      destination_to_be_captured = function_output[1]

      # pawn_that_captures = pieces_that_can_capture("P", whose_turn, origin_alg, destination_alg)[0]
      # destination_to_be_captured = pieces_that_can_capture("P", whose_turn, origin_alg, destination_alg)[1]
      # binding.pry
      if piece_that_captures.length == 1 && destination_to_be_captured.length == 1
        
        # binding.pry
        
        @board = move_piece(piece_that_captures[0], destination_to_be_captured[0], @board)
        display
        # binding.pry 

        return true
      end
    end
    return false
  end

  def check?(which_king, board = @board)
    king_coords = coord_list_of_piece(which_king)[0]
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

  def valid_knight_move?(whose_turn, player_input, board = @board)
    destination_coord = convert_alg_to_coord(player_input[-2..-1])
    return false if destination_coord == nil
    knight_candidates = knights_that_move(whose_turn, destination_coord, board)
    if knight_candidates.length == 1
      return true
    end
    return false
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
  
  def knights_that_move(whose_turn, coordinates, board)
    knight = whose_turn == 1 ? "WN" : "BN"
    knight_list = []
    knight_moves = generate_piece_moves("N", coordinates)

    # binding.pry

    generate_piece_moves("N", coordinates).each do |pos|
      if board[pos[0]][pos[1]] == knight
        knight_list << pos
      end
    end
    
    # binding.pry

    return knight_list
  end

  def generate_piece_moves(piece, pos)
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

  def pieces_that_can_capture(piece, whose_turn, origin_alg, destination_alg, board= @board)
    pieces_there = []
    destination_coords = []
    direction2 = whose_turn == 1 ? @direction : -@direction
   
    if origin_alg == nil || origin_alg.length == 0
      colored_piece = whose_turn == 1 ? "W"+piece : "B"+piece
      pieces_there = coord_list_of_piece(colored_piece, board)
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
      if whose_turn == 1
        destination_coords << coords2 if board[coords2[0]][coords2[1]] != nil && @board[coords2[0]][coords2[1]][0] == "B"
      else
        destination_coords << coords2 if board[coords2[0]][coords2[1]][0] == "W"
      end
    elsif destination_alg.length == 1
      destination_coords = whose_turn == 1 ? pieces_in_that_column("B", column) :
                                             pieces_in_that_column("W", column)
    end
    
    if destination_coords == []
      return [[],[]]
    end

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

          if generate_piece_moves(piece, p).include?(d)


            pieces_that_can_capture << p
            destinations_that_can_be_captured << d
          end
        end
      end
    end

    # binding.pry

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