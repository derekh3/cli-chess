require './lib/board.rb'

describe Board do
  subject(:board) { described_class.new() }
  describe "#make_move" do
    # context "When given a player input" do
    #   it "returns false when given a one letter input" do
    #     player_input = "a"
    #     expect(board.make_move(1, player_input)).to eq(false)
    #   end
    # end

    # context "When the board is at its initial condition" do
    #   it "returns true when white pawn moves two spaces" do
    #     player_input = "c4"
    #     expect(board.make_move(1, player_input)).to eq(true)
    #   end

    #   it "updates the board when white pawn moves two spaces" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP','BP','BP','BP','BP','BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,'WP',nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     ['WP','WP',nil,'WP','WP','WP','WP','WP'],
    #     ['WR','WN','WB','WQ','WK','WB','WN','WR']]
    #     player_input = "c4"
    #     board.make_move(1, player_input)
    #     expect(board.board).to eq(expected_board)
    #   end

    #   it "returns true when white pawn moves one space" do
    #     player_input = "d3"
    #     expect(board.make_move(1, player_input)).to eq(true)
    #   end

    #   it "updates the board when white pawn moves one space" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP','BP','BP','BP','BP','BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,'WP',nil,nil,nil,nil],
    #     ['WP','WP','WP',nil,'WP','WP','WP','WP'],
    #     ['WR','WN','WB','WQ','WK','WB','WN','WR']]
    #     player_input = "d3"
    #     board.make_move(1, player_input)
    #     expect(board.board).to eq(expected_board)
    #   end

    #   it "returns true when black pawn moves two spaces" do
    #     player_input = "f5"
    #     expect(board.make_move(2, player_input)).to eq(true)
    #   end

    #   it "updates the board when black pawn moves two spaces" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP','BP','BP','BP',nil,'BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,'BP',nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     ['WP','WP','WP','WP','WP','WP','WP','WP'],
    #     ['WR','WN','WB','WQ','WK','WB','WN','WR']]
    #     player_input = "f5"
    #     board.make_move(2, player_input)
    #     expect(board.board).to eq(expected_board)
    #   end

    #   it "returns true when black pawn moves one spaces" do
    #     player_input = "f6"
    #     expect(board.make_move(2, player_input)).to eq(true)
    #   end

    #   it "returns true when white knight moves to c3" do
    #     player_input = "Nc3"
    #     expect(board.make_move(1, player_input)).to eq(true)
    #   end

    #   it "updates the board when white knight moves to c3" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP','BP','BP','BP','BP','BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,'WN',nil,nil,nil,nil,nil],
    #     ['WP','WP','WP','WP','WP','WP','WP','WP'],
    #     ['WR',nil,'WB','WQ','WK','WB','WN','WR']]
    #     player_input = "Nc3"
    #     board.make_move(1, player_input)
    #     expect(board.board).to eq(expected_board)
    #   end

    # end

    # context "When the board has moved a pair of knights out" do
    #   subject(:board2) { described_class.new( 
    #     [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP','BP','BP','BP','BP','BP','BP'],
    #     [nil,nil,'BN',nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,'WN',nil,nil,nil,nil,nil],
    #     ['WP','WP','WP','WP','WP','WP','WP','WP'],
    #     ['WR',nil,'WB','WQ','WK','WB','WN','WR']] ) }

    #     it "treats moving WN to b1 as a valid move" do
    #       player_input = "Nb1"
    #       expect(board2.make_move(1, player_input)).to eq(true)
    #     end
    # end

    # context "When the board allows for unambiguous pawn capture" do
    #   subject(:board2) { described_class.new( [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #                                             ['BP','BP',nil,'BP','BP','BP','BP','BP'],
    #                                             [nil,nil,nil,nil,nil,nil,nil,nil],
    #                                             [nil,nil,"BP",nil,nil,nil,nil,nil],
    #                                             [nil,"WP",nil,nil,nil,nil,nil,nil],
    #                                             [nil,nil,nil,nil,nil,nil,nil,nil],
    #                                             ['WP',nil,'WP','WP','WP','WP','WP','WP'],
    #                                             ['WR','WN','WB','WQ','WK','WB','WN','WR']] ) }
    #   it "returns true when white captures with 'b4xc5" do
    #     player_input = 'b4xc5'
    #     expect(board2.make_move(1, player_input)).to eq(true)
    #   end

    #   it "updates the board when white captures with 'b4xc5" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP',nil,'BP','BP','BP','BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,'WP',nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     ['WP',nil,'WP','WP','WP','WP','WP','WP'],
    #     ['WR','WN','WB','WQ','WK','WB','WN','WR']]
    #     player_input = 'b4xc5'
    #     board2.make_move(1, player_input)
    #     expect(board2.board).to eq(expected_board)
    #   end

    #   it "returns false when white captures with 'b3xc5'" do
    #     player_input = 'b3xc5'
    #     expect(board2.make_move(1, player_input)).to eq(false)
    #   end
    #   it "returns false when white captures with 'b4xc2'" do
    #     player_input = 'b4xc2'
    #     expect(board2.make_move(1, player_input)).to eq(false)
    #   end

    #   it "returns true when black captures with 'c5xb4'" do
    #     player_input = 'c5xb4'
    #     expect(board2.make_move(2, player_input)).to eq(true)
    #   end

    #   it "updates the board when black captures with 'c5xb4'" do
    #     expected_board = 
    #     [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #     ['BP','BP',nil,'BP','BP','BP','BP','BP'],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     [nil,'BP',nil,nil,nil,nil,nil,nil],
    #     [nil,nil,nil,nil,nil,nil,nil,nil],
    #     ['WP',nil,'WP','WP','WP','WP','WP','WP'],
    #     ['WR','WN','WB','WQ','WK','WB','WN','WR']]
    #     player_input = 'c5xb4'
    #     board2.make_move(2, player_input)
    #     expect(board2.board).to eq(expected_board)
    #   end

    #   it "returns false when white captures with 'c5xb4'" do
    #     player_input = 'c5xb4'
    #     expect(board2.make_move(1, player_input)).to eq(false)
    #   end

    #   it "returns false when black captures with 'b4xc5'" do
    #     player_input = 'b4xc5'
    #     expect(board2.make_move(2, player_input)).to eq(false)
    #   end

    #   it "returns false when player input is 'b4xxxxx'" do
    #     player_input = 'b4xxxxx'
    #     expect(board2.make_move(2, player_input)).to eq(false)
    #   end

    #   it "returns false when player input is 'xxxxxc5'" do
    #     player_input = 'xxxxxc5'
    #     expect(board2.make_move(2, player_input)).to eq(false)
    #   end

    #   it "returns false when player input is 'b4xc5xb3xb4'" do
    #     player_input = 'b4xc5xb3xb4'
    #     expect(board2.make_move(1, player_input)).to eq(false)
    #   end
    # end

    # context "When the board allows for ambiguous pawn capture" do
    #   subject(:board3) { described_class.new( [['BR','BN','BB','BQ','BK','BB','BN','BR'],
    #                                             [nil,'BP',nil,'BP','BP','BP','BP','BP'],
    #                                             [nil,nil,nil,nil,nil,nil,nil,nil],
    #                                             ["BP",nil,"BP",nil,nil,nil,nil,nil],
    #                                             [nil,"WP",nil,"WP",nil,nil,nil,nil],
    #                                             [nil,nil,nil,nil,nil,nil,nil,nil],
    #                                             ['WP',nil,'WP',nil,'WP','WP','WP','WP'],
    #                                             ['WR','WN','WB','WQ','WK','WB','WN','WR']] ) }
      
    #   it "returns true when white captures with 'b4xc5" do
    #     player_input = 'b4xc5'
    #     expect(board3.make_move(1, player_input)).to eq(true)
    #   end
    # end
   
    context "When the board allows for knights to capture" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        ['WR',nil,'WB','WQ','WK','WB','WN','WR']] ) }
        
      it "updates the board when white captures Nxd5" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'WN',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        ['WR',nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = "Nxd5"
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end
    end


  end


end