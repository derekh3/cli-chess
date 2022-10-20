require "pry-byebug"
require "./lib/piece_icons.rb"
class Board
  include PieceIcons

  attr_reader :board
  attr_reader :whose_turn

  def initialize(board = [['BR','BN','BB','BQ','BK','BB','BN','BR'],
                          ['BP','BP','BP','BP','BP','BP','BP','BP'],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          [nil,nil,nil,nil,nil,nil,nil,nil],
                          ['WP','WP','WP','WP','WP','WP','WP','WP'],
                          ['WR','WN','WB','WQ','WK','WB','WN','WR']], 
                direction = 1, en_passant_square_white = [], en_passant_square_black = [],
              en_passant_square_candidate = [], white_O_O = true, white_O_O_O = true,  black_O_O = true, black_O_O_O = true,
            whose_turn = 1, history = [])
    @board = board
    @direction = direction
    @en_passant_square_white = en_passant_square_white
    @en_passant_square_black = en_passant_square_black
    @en_passant_square_candidate = en_passant_square_candidate
    @white_O_O = white_O_O
    @white_O_O_O = white_O_O_O
    @black_O_O = black_O_O
    @black_O_O_O = black_O_O_O
    @whose_turn = whose_turn
    @history = history
  end


  def self.from_yaml(string)
    data = YAML.load string
    self.new(data[:board], data[:direction], data[:en_passant_square_white], data[:en_passant_square_black], data[:en_passant_square_candidate], 
      data[:white_O_O], data[:white_O_O_O], data[:black_O_O], data[:black_O_O_O], data[:whose_turn], data[:history])
  end

  def to_yaml
    YAML.dump({
      :board => @board,
      :direction => @direction,
      :en_passant_square_white  => @en_passant_square_white ,
      :en_passant_square_black => @en_passant_square_black,
      :en_passant_square_candidate => @en_passant_square_candidate,
      :white_O_O => @white_O_O,
      :white_O_O_O => @white_O_O_O,
      :black_O_O => @black_O_O,
      :black_O_O_O => @black_O_O_O,
      :whose_turn => @whose_turn,
      :history => @history
    })
  end

  
  def display
    puts letter_coords + draw_grid + letter_coords
  end
  
  def letter_coords
    %(    A  B  C  D  E  F  G  H\n).green
  end

  def map_bg_colours
    @board.each_with_index.map do |line, idx|
      black_cell = idx.even? ? true : false
      line.map do |cell|
        res = black_cell ? to_string(cell).bg_cyan : to_string(cell).bg_grayer
        black_cell = black_cell ? false : true
        res
      end
    end
  end

  def draw_grid
    counter = 8
    final = map_bg_colours.map do |line|
      res = " #{counter} ".green + line.join + " #{counter} ".green + "\n"
      counter -= 1
      res
    end
    final.join
  end

  def to_string(piece)
    case piece
    when "WP"
      white_pawn
    when "BP"
      black_pawn
    when "WR"
      white_rook
    when "BR"
      black_rook
    when "WB"
      white_bishop
    when "BB"
      black_bishop
    when "WN"
      white_knight
    when "BN"
      black_knight
    when "WQ"
      white_queen
    when "BQ"
      black_queen
    when "WK"
      white_king
    when "BK"
      black_king
    else
      "   "
    end
  end

  def make_move(whose_turn, player_input)
    @history << [@board, whose_turn]
    if player_input != "O-O" && player_input != "O-O-O" && player_input != "0-0" && player_input != "0-0-0"
      destination_coord = convert_alg_to_coord(player_input[-2..-1])
      return false if destination_coord == nil

      if player_input.include?("x")
        destination_alg = player_input.split("x")[1]
        origin_alg = player_input.split("x")[0]
        capture_mode = true
        return false if player_input.split("x").length != 2
      else
        destination_alg = player_input[-2..-1]
        if destination_alg.length < 2
          return false
        end
        origin_alg = player_input[0..-3]
        capture_mode = false
      end
      if player_input[0] == "B"
        # binding.pry
      end
      if player_input[0] == "N" || player_input[0] == "B" || player_input[0] == "R" || player_input[0] == "Q" || player_input[0] == "K"
        origin_alg = origin_alg[1..-1]
        function_output = pieces_that_can_capture(player_input[0], whose_turn, origin_alg, destination_alg, @board, capture_mode)
      else
        function_output = pieces_that_can_capture("P", whose_turn, origin_alg, destination_alg, @board, capture_mode)
      end
      piece_that_captures = function_output[0]
      destination_to_be_captured = function_output[1]
      which_king = whose_turn == 1 ? "WK" : "BK"

      if piece_that_captures.length == 1 && destination_to_be_captured.length == 1     
        candidate_board = move_piece(piece_that_captures[0], destination_to_be_captured[0], @board)
        if destination_to_be_captured[0] == @en_passant_square_black
          candidate_board = delete_piece([destination_to_be_captured[0][0]+1, destination_to_be_captured[0][1]], candidate_board)
        elsif destination_to_be_captured[0] == @en_passant_square_white
          candidate_board = delete_piece([destination_to_be_captured[0][0]-1, destination_to_be_captured[0][1]], candidate_board)
        end
        return false if check?(which_king, candidate_board)
        @board = Marshal.load( Marshal.dump(candidate_board) )
        update_castling_vars_piece(piece_that_captures[0])
        pawn_to_promote = pawn_to_promote(whose_turn, @board)
        if pawn_to_promote.length >= 1
          promote_pawn(whose_turn, pawn_to_promote)
        end
        update_en_passant(whose_turn)
        @whose_turn = @whose_turn == 1 ? 2 : 1
        return true
      end
    else
      made_castle_move = make_castle_move(whose_turn, player_input)
      if made_castle_move
        update_castling_vars_castle(whose_turn, player_input)
        update_en_passant(whose_turn)
        @whose_turn = @whose_turn == 1 ? 2 : 1
        return true
      end
    end
    return false
  end

  def make_castle_move(whose_turn, player_input)
    row = whose_turn == 1 ? 7 : 0
    which_king = whose_turn == 1 ? "WK" : "BK"
    if player_input == "O-O" || player_input == "0-0"
      return false if whose_turn == 1 && @white_O_O == false
      return false if whose_turn == 2 && @black_O_O == false
      return false if @board[row][5] != nil || @board[row][6] != nil
      candidate_board1 = move_piece([row, 4], [row, 5], @board)
      candidate_board2 = move_piece([row, 4], [row, 6], @board)
      return false if check?(which_king, candidate_board1) || check?(which_king, candidate_board2)
      final_board = move_piece([row, 7], [row, 5], candidate_board2)
      @board = Marshal.load( Marshal.dump(final_board) )
      return true
    elsif player_input == "O-O-O" || player_input == "0-0-0"
      return false if whose_turn == 1 && @white_O_O_O == false
      return false if whose_turn == 2 && @black_O_O_O == false
      return false if @board[row][1] != nil || @board[row][2] != nil || @board[row][3] != nil
      candidate_board1 = move_piece([row, 4], [row, 3], @board)
      candidate_board2 = move_piece([row, 4], [row, 2], @board)
      return false if check?(which_king, candidate_board1) || check?(which_king, candidate_board2)
      final_board = move_piece([row, 0], [row, 3], candidate_board2)
      @board = Marshal.load( Marshal.dump(final_board) )
      return true
    else
      return false
    end
  end

  def update_en_passant(whose_turn)
    if whose_turn == 1
      @en_passant_square_white = @en_passant_square_candidate
      @en_passant_square_candidate = []
    else
      @en_passant_square_black = @en_passant_square_candidate
      @en_passant_square_candidate = []
    end
  end

  def update_castling_vars_piece(piece_that_moves)
    @white_O_O = false if piece_that_moves == [7,4] || piece_that_moves == [7,7]
    @white_O_O_O = false if piece_that_moves == [7,4] || piece_that_moves == [7,0]
    @black_O_O = false if piece_that_moves == [0,4] || piece_that_moves == [0,7]
    @black_O_O_O = false if piece_that_moves == [0,4] || piece_that_moves == [0,0]
  end

  def update_castling_vars_castle(whose_turn, player_input)
    @white_O_O = false if whose_turn == 1 && (player_input == "O-O" || player_input == "0-0")
    @white_O_O_O = false if whose_turn == 1 && (player_input == "O-O-O" || player_input == "0-0-0")
    @black_O_O = false if whose_turn == 2 && (player_input == "O-O" || player_input == "0-0")
    @black_O_O_O = false if whose_turn == 2 && (player_input == "O-O-O" || player_input == "0-0-0")
  end

  def delete_piece(coords, board=@board)
    new_board = Marshal.load( Marshal.dump(board) )
    new_board[coords[0]][coords[1]] = nil
    return new_board
  end

  def pawn_to_promote(whose_turn, board=@board)
    if whose_turn == 1
      board[0].each_with_index do |x, col| 
        return [0, col] if x == "WP" 
      end
    else
      board[7].each_with_index { |x, col| return [7, col] if x == "BP" }
    end
    return []
  end

  def promote_pawn(whose_turn, coords)
    loop do
      puts "Promote your pawn (N, B, R, or Q):"
      user_input = gets.chomp
      if user_input == "N" || user_input == "B" || user_input == "R" || user_input == "Q"
        @board[coords[0]][coords[1]] = whose_turn == 1 ? "W"+user_input : "B" + user_input
        break
      end
    end
  end

  def check?(which_king, board = @board)
    king_coords = coord_list_of_piece(which_king, board)[0]
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

  def checkmate?(which_king, board = @board)
    return false if !check?(which_king, board)
    checkmate = true
    whose_turn = which_king == "WK" ? 1 : 2
    board_clone = board.clone
    board_clone.each_with_index do |r, row|
      r.each_with_index do |square, col|
        if square != nil && square[0] == which_king[0]
          origin_coord = [row, col]
          
          destination_coords = generate_piece_moves(square[1], origin_coord, whose_turn, true, board_clone)
          if destination_coords != nil
            destination_coords.each do |d|
              candidate_board1 = move_piece(origin_coord, d, board_clone)
              if !check?(which_king, candidate_board1)
                return false
              end
            end
          end
        end
      end
    end
    return checkmate
  end

  def stalemate_no_moves?(which_king, board=@board)
    return false if check?(which_king, board)
    stalemate = true
    whose_turn = which_king == "WK" ? 1 : 2
    board.each_with_index do |r, row|
      r.each_with_index do |square, col|
        if square != nil && square[0] == which_king[0]
          origin_coord = [row, col]
          destination_coords = generate_piece_moves(square[1], origin_coord, whose_turn, true, board)
          if destination_coords != nil
            destination_coords.each do |d|
              candidate_board = move_piece(origin_coord, d, board)
              if !check?(which_king, candidate_board)
                return false
              end
            end
          end
        end
      end
    end
    return stalemate
  end

  def stalemate_repetition?(whose_turn)
    indices = @history.each_index.select {|i| @history[i] == [@board, whose_turn]}
    if indices.length >= 3
      return true
    else
      return false
    end
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
    new_board = Marshal.load( Marshal.dump(board) )
    piece = new_board[starting_coord[0]][starting_coord[1]]
    new_board[starting_coord[0]][starting_coord[1]] = nil
    new_board[ending_coord[0]][ending_coord[1]] = piece
    return new_board
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
      @en_passant_square_candidate = [coordinates[0]+direction2, coordinates[1]]
    end
    return pawn_list
  end

  def pieces_that_can_capture(piece, whose_turn, origin_alg, destination_alg, board= @board, capture_mode= true)
    pieces_there = []
    destination_coords = []
    direction2 = whose_turn == 1 ? @direction : -@direction
    opposite_ep_square = whose_turn == 1 ? @en_passant_square_black : @en_passant_square_white

    if origin_alg == nil || origin_alg.length == 0
      colored_piece = whose_turn == 1 ? "W"+piece : "B"+piece
      pieces_there = coord_list_of_piece(colored_piece, board)
    end
    if origin_alg.length == 1
      # column = convert_alg_col_to_coord(origin_alg)
      # return [[],[]] if column == nil
      pieces_there = whose_turn == 1 ? pieces_in_that_row_or_column("W"+piece, origin_alg, board) :
                                      pieces_in_that_row_or_column("B"+piece, origin_alg, board)
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
        #account for en passant
        if piece == "P"
          destination_coords << coords2 if coords2 == opposite_ep_square
        end
      else
        destination_coords << coords2 if board[coords2[0]][coords2[1]] == nil
      end
    elsif destination_alg.length == 1
      destination_coords = whose_turn == 1 ? pieces_in_that_row_or_column("B"+piece, destination_alg, board) :
                                             pieces_in_that_row_or_column("W"+piece, destination_alg, board)
    end
    
    if destination_coords == []
      return [[],[]]
    end

    pieces_that_can_capture = []
    destinations_that_can_be_captured = []
    if capture_mode == false && piece == "P"
      pawn_candidates = pawns_that_move(whose_turn, destination_coords[0])
      if pawn_candidates.length == 1
        pieces_that_can_capture = pawn_candidates
        destinations_that_can_be_captured = destination_coords
      end
    end


    pieces_there.each do |p|
      destination_coords.each do |d|
        if piece == "P"
          if capture_mode == true
            if [p[0]-direction2, p[1]+1] == d || [p[0]-direction2, p[1]-1] == d
              pieces_that_can_capture << p
              destinations_that_can_be_captured << d
            end
          end
        else
          if generate_piece_moves(piece, p, whose_turn, capture_mode, board).include?(d)
            pieces_that_can_capture << p
            destinations_that_can_be_captured << d
          end
        end
      end
    end
    return [pieces_that_can_capture.uniq, destinations_that_can_be_captured.uniq]
  end

  def pieces_in_that_row_or_column(piece, row_or_col, board)
    pieces_there = []
    if row_or_col == "1" || row_or_col == "2" || row_or_col == "3" || row_or_col == "4" || row_or_col == "5" || 
      row_or_col == "6" || row_or_col == "7" || row_or_col == "8"
      row = row_or_col.to_i
      board[convert_alg_row_to_coord(row)].each_with_index do |square, col|
        pieces_there << [convert_alg_row_to_coord(row), col] if square == piece
      end
    elsif row_or_col == "a" || row_or_col == "b" || row_or_col == "c" || row_or_col == "d" || row_or_col == "e" || 
      row_or_col == "f" || row_or_col == "g" || row_or_col == "h"
      col = convert_alg_col_to_coord(row_or_col)
      board.each_with_index do |line, r|
        line.each_with_index do |square, c|
          pieces_there << [r, col] if square == piece && c == col
        end
      end
    end
    return pieces_there
  end

  def convert_alg_col_to_coord(alg_column)
    hash = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    return hash[alg_column.downcase]
  end

  def convert_alg_row_to_coord(alg_row)
    return 8 - alg_row.to_i
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