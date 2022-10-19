require './lib/board.rb'
require './lib/colour_patch.rb'
require './lib/piece_icons.rb'

dirname = "save-files"
Dir.mkdir(dirname) unless File.exists?dirname

board = Board.new()
whose_turn = 1
loop do
  board.display
  # if board.whose_turn == 1
  #   puts "White, please enter a move:"
  # else
  #   puts "Black, please enter a move:"
  # end
  # player_input = gets.chomp
  # while !board.make_move(whose_turn, player_input)
  #   puts "Please enter valid input:"
  #   player_input = gets.chomp
  # end
  loop do
    if board.whose_turn == 1
      puts "White, please enter a valid move:"
    else
      puts "Black, please enter a valid move:"
    end
    player_input = gets.chomp
    if player_input.downcase == "save"
      puts "Enter filename to save under: "
      fname = gets.chomp
      fname = "#{dirname}/#{fname}.txt"
      savefile = File.open(fname, "w")
      savefile.puts board.to_yaml
      savefile.close
      break
    elsif player_input.downcase == "load"
      puts Dir.glob("*", base: dirname)
      puts "Enter a filename to load: "
      fname = gets.chomp
      loadfile = File.open("#{dirname}/#{fname}")
      contents = loadfile.read
      board = Board.from_yaml(contents)
      break
    elsif player_input.downcase == "new"
      puts "Start a new game? Unsaved progress will be lost."
      reply = gets.chomp
      if reply.downcase == "y" || reply.downcase == "yes"
        board = Board.new()
      end
      break
    end
    made_move = board.make_move(board.whose_turn, player_input)
    if made_move == true
      break
    end
  end

  other_turn = board.whose_turn == 1 ? 2 : 1
  which_king = board.whose_turn == 1 ? "WK" : "BK"
  if board.check?(which_king, board.board)
    puts "Check!"
  end
  if board.checkmate?(which_king, board.board)
    puts "Checkmate! Player #{other_turn} has won."
    break
  end
  if board.stalemate_no_moves?(which_king) || board.stalemate_repetition?(board.whose_turn)
    puts "Stalemate!"
    break
  end
end