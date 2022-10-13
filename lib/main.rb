require './lib/board.rb'

board = Board.new()
whose_turn = 1
loop do
  player_input = gets.chomp
  while !board.valid_input?(whose_turn, player_input)
    puts "Please enter valid input:"
    player_input = gets.chomp
  end
  board.make_move(whose_turn, player_input)
  if board.check?
    puts "Check!"
  end
  if board.checkmate?
    puts "Checkmate! Player #{whose_turn} has won."
    break
  end
  if board.stalemate?
    puts "Stalemate!"
    break
  end
  whose_turn = whose_turn == 1 ? 2 : 1
end