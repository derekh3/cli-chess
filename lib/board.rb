require "pry-byebug"

class Board
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

  def valid_input?(whose_turn, player_input)
    if player_input.length == 2
      if valid_pawn_move?(whose_turn, player_input)
        return true
      end
    end
    if player_input.include?("x")
      destination_alg = player_input.split("x")[1]
      origin_alg = player_input.split("x")[0]
      if player_input.split("x").length != 2
        return false
      end
      if pawns_that_can_capture(whose_turn, origin_alg, destination_alg)[0].length == 1 &&
          pawns_that_can_capture(whose_turn, origin_alg, destination_alg)[1].length == 1
        return true
      end
    end
    return false
  end

  def valid_pawn_move?(whose_turn, player_input)
    coordinates = convert_alg_to_coord(player_input)
    return false if coordinates == nil
    return true if pawns_that_move(whose_turn, coordinates).length > 0
  end
  
  def pawns_that_can_capture(whose_turn, origin_alg, destination_alg)
    pawns_there = []
    destination_coords = []
    direction2 = whose_turn == 1 ? @direction : -@direction
   
    if origin_alg.length == 1
      column = convert_alg_col_to_coord(origin_alg)
      return [[],[]] if column == nil
      pawns_there = whose_turn == 1 ? pieces_in_that_column("WP", column) :
                                      pieces_in_that_column("BP", column)
    elsif origin_alg.length == 2
      coords = convert_alg_to_coord(origin_alg)
      return [[],[]] if coords == nil
      if whose_turn == 1
        pawns_there << coords if @board[coords[0]][coords[1]] == "WP"
      else
        pawns_there << coords if @board[coords[0]][coords[1]] == "BP"
      end
    end

    if destination_alg.length == 2
      coords2 = convert_alg_to_coord(destination_alg)
      return [[],[]] if coords == nil
      if whose_turn == 1
        destination_coords << coords2 if @board[coords2[0]][coords2[1]][0] == "B"
      else
        destination_coords << coords2 if @board[coords2[0]][coords2[1]][0] == "W"
      end
    elsif destination_alg.length == 1
      destination_coords = whose_turn == 1 ? pieces_in_that_column("B", column) :
                                             pieces_in_that_column("W", column)
    end
    
    if destination_coords == []
      return [[],[]]
    end

    pawns_that_can_capture = []
    destinations_that_can_be_captured = []
    pawns_there.each do |p|
      destination_coords.each do |d|
        if [p[0]-direction2, p[1]+1] == d || [p[0]-direction2, p[1]-1] == d
          pawns_that_can_capture << p
          destinations_that_can_be_captured << d
        end 
      end
    end

    # binding.pry

    return [pawns_that_can_capture, destinations_that_can_be_captured]
  end

  def pieces_in_that_column(piece, col)
    
  end

  def convert_alg_col_to_coord(alg_column)
    hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    return hash[alg_column.downcase]
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

end