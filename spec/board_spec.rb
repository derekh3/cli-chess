require './lib/board.rb'

describe Board do
  subject(:board) { described_class.new() }
  describe "#make_move" do
    context "When given a player input" do
      it "returns false when given a one letter input" do
        player_input = "a"
        expect(board.make_move(1, player_input)).to eq(false)
      end
    end

    context "When the board is at its initial condition" do
      it "returns true when white pawn moves two spaces" do
        player_input = "c4"
        expect(board.make_move(1, player_input)).to eq(true)
      end

      it "updates the board when white pawn moves two spaces" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP','BP','BP','BP','BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,'WP',nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        ['WP','WP',nil,'WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WQ','WK','WB','WN','WR']]
        player_input = "c4"
        board.make_move(1, player_input)
        expect(board.board).to eq(expected_board)
      end

      it "returns true when white pawn moves one space" do
        player_input = "d3"
        expect(board.make_move(1, player_input)).to eq(true)
      end

      it "updates the board when white pawn moves one space" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP','BP','BP','BP','BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        ['WR','WN','WB','WQ','WK','WB','WN','WR']]
        player_input = "d3"
        board.make_move(1, player_input)
        expect(board.board).to eq(expected_board)
      end

      it "returns true when black pawn moves two spaces" do
        player_input = "f5"
        expect(board.make_move(2, player_input)).to eq(true)
      end

      it "updates the board when black pawn moves two spaces" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP','BP','BP',nil,'BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,'BP',nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        ['WP','WP','WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WQ','WK','WB','WN','WR']]
        player_input = "f5"
        board.make_move(2, player_input)
        expect(board.board).to eq(expected_board)
      end

      it "returns true when black pawn moves one spaces" do
        player_input = "f6"
        expect(board.make_move(2, player_input)).to eq(true)
      end

      it "returns true when white knight moves to c3" do
        player_input = "Nc3"
        expect(board.make_move(1, player_input)).to eq(true)
      end

      it "updates the board when white knight moves to c3" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP','BP','BP','BP','BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP','WP','WP','WP','WP','WP'],
        ['WR',nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = "Nc3"
        board.make_move(1, player_input)
        expect(board.board).to eq(expected_board)
      end

    end

    context "When the board has moved a pair of knights out" do
      subject(:board2) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP','BP','BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP','WP','WP','WP','WP','WP'],
        ['WR',nil,'WB','WQ','WK','WB','WN','WR']] ) }

        it "treats moving WN to b1 as a valid move" do
          player_input = "Nb1"
          expect(board2.make_move(1, player_input)).to eq(true)
        end
    end

    context "When the board allows for unambiguous pawn capture" do
      subject(:board2) { described_class.new( [['BR','BN','BB','BQ','BK','BB','BN','BR'],
                                                ['BP','BP',nil,'BP','BP','BP','BP','BP'],
                                                [nil,nil,nil,nil,nil,nil,nil,nil],
                                                [nil,nil,"BP",nil,nil,nil,nil,nil],
                                                [nil,"WP",nil,nil,nil,nil,nil,nil],
                                                [nil,nil,nil,nil,nil,nil,nil,nil],
                                                ['WP',nil,'WP','WP','WP','WP','WP','WP'],
                                                ['WR','WN','WB','WQ','WK','WB','WN','WR']] ) }
      it "returns true when white captures with 'b4xc5" do
        player_input = 'b4xc5'
        expect(board2.make_move(1, player_input)).to eq(true)
      end

      it "updates the board when white captures with 'b4xc5" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP',nil,'BP','BP','BP','BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,'WP',nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        ['WP',nil,'WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WQ','WK','WB','WN','WR']]
        player_input = 'b4xc5'
        board2.make_move(1, player_input)
        expect(board2.board).to eq(expected_board)
      end

      it "returns false when white captures with 'b3xc5'" do
        player_input = 'b3xc5'
        expect(board2.make_move(1, player_input)).to eq(false)
      end
      it "returns false when white captures with 'b4xc2'" do
        player_input = 'b4xc2'
        expect(board2.make_move(1, player_input)).to eq(false)
      end

      it "returns true when black captures with 'c5xb4'" do
        player_input = 'c5xb4'
        expect(board2.make_move(2, player_input)).to eq(true)
      end

      it "updates the board when black captures with 'c5xb4'" do
        expected_board = 
        [['BR','BN','BB','BQ','BK','BB','BN','BR'],
        ['BP','BP',nil,'BP','BP','BP','BP','BP'],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,'BP',nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        ['WP',nil,'WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WQ','WK','WB','WN','WR']]
        player_input = 'c5xb4'
        board2.make_move(2, player_input)
        expect(board2.board).to eq(expected_board)
      end

      it "returns false when white captures with 'c5xb4'" do
        player_input = 'c5xb4'
        expect(board2.make_move(1, player_input)).to eq(false)
      end

      it "returns false when black captures with 'b4xc5'" do
        player_input = 'b4xc5'
        expect(board2.make_move(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'b4xxxxx'" do
        player_input = 'b4xxxxx'
        expect(board2.make_move(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'xxxxxc5'" do
        player_input = 'xxxxxc5'
        expect(board2.make_move(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'b4xc5xb3xb4'" do
        player_input = 'b4xc5xb3xb4'
        expect(board2.make_move(1, player_input)).to eq(false)
      end
    end

    context "When the board allows for ambiguous pawn capture" do
      subject(:board3) { described_class.new( [['BR','BN','BB','BQ','BK','BB','BN','BR'],
                                                [nil,'BP',nil,'BP','BP','BP','BP','BP'],
                                                [nil,nil,nil,nil,nil,nil,nil,nil],
                                                ["BP",nil,"BP",nil,nil,nil,nil,nil],
                                                [nil,"WP",nil,"WP",nil,nil,nil,nil],
                                                [nil,nil,nil,nil,nil,nil,nil,nil],
                                                ['WP',nil,'WP',nil,'WP','WP','WP','WP'],
                                                ['WR','WN','WB','WQ','WK','WB','WN','WR']] ) }
      
      it "returns true when white captures with 'b4xc5" do
        player_input = 'b4xc5'
        expect(board3.make_move(1, player_input)).to eq(true)
      end
    end
   
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

    context "When the board allows for bishops to move and capture" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ['WR', nil,'WB','WQ','WK','WB','WN','WR']] ) }
      
      it "updates the board when white bishop moves to f4" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,'WB','WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ['WR', nil,nil,'WQ','WK','WB','WN','WR']]
        player_input = 'Bf4'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when black bishop moves to f5" do
        expected_board = 
        [['BR',nil,nil,'BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,'BB','BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ['WR', nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Bf5'
        board4.make_move(2,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when black bishop captures g4" do
        expected_board = 
        [['BR',nil,nil,'BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'BB',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ['WR', nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Bxg4'
        board4.make_move(2,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when white bishop captures g5" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'WB',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ['WR', nil,nil,'WQ','WK','WB','WN','WR']]
        player_input = 'Bxg5'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "does not allow the bishop to pass through a friendly piece" do
        player_input = 'Bc1a3'
        expect(board4.make_move(1,player_input)).to eq(false)
      end

      it "fails when a capture is attempted without using 'x' in the input" do
        player_input = 'Bg4'
        expect(board4.make_move(2,player_input)).to eq(false)
      end
    end

    context "When the board allows for rooks to move and capture" do
      subject(:board4) { described_class.new( 
        [[nil,nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, 'BR', nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']] ) }
    
      it "updates the board when white rook captures b7" do
        expected_board =
        [[nil,nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','WR','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'BP',nil],
        [nil, 'BR', nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Rxb7'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when black rook captures b2" do
        expected_board =
        [[nil,nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','BR','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Rxb2'
        board4.make_move(2,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when white rook moves to b6" do
        expected_board =
        [[nil,nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, 'WR', 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, 'BP',nil,nil,'BP',nil],
        [nil, 'BR', nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Rb6'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "does not allow the rook to pass through an enemy piece" do
        player_input = 'Bb8'
        expect(board4.make_move(1,player_input)).to eq(false)
      end

    end

    context "When the board allows for queens to move and capture" do
      subject(:board4) { described_class.new( 
        [[nil,nil,'BB',nil,'BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', 'WQ', 'BP',nil,nil,'BP',nil],
        [nil, 'BR', 'BQ', 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB',nil,'WK','WB','WN','WR']] ) }
      
      it "updates the board when white queen captures a7" do
        expected_board =
        [[nil,nil,'BB',nil,'BK','BB','BN','BR'],
        ['WQ','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, 'BR', 'BQ', 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB',nil,'WK','WB','WN','WR']]
        player_input = 'Qxa7'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "updates the board when black queen moves to b3" do
        expected_board =
        [[nil,nil,'BB',nil,'BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', 'WQ', 'BP',nil,nil,'BP',nil],
        [nil, 'BR', nil, 'WP',nil,nil,'WP',nil],
        [nil, 'BQ','WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB',nil,'WK','WB','WN','WR']]
        player_input = 'Qb3'
        board4.make_move(2,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "prevents the white queen from moving through an enemy pawn" do
        player_input = 'Qe5'
        expect(board4.make_move(1,player_input)).to eq(false)
      end
    end

    context "When the board allows for kings to move and capture" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP','WK'],
        ['BK', nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']] ) }

      it "allows WK to capture black pawn at g5" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'WK',nil],
        ['BK', nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Kxg5'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "allows WK to move to d2" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP','WK'],
        ['BK', nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP','WK','WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']]
        player_input = 'Kd2'
        board4.make_move(1,player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "prevents the white king from moving through a friendly pawn" do
        player_input = 'Ke2'
        expect(board4.make_move(1,player_input)).to eq(false)
      end

      it "allows BK to capture to b5" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'BK', nil, 'BP',nil,nil,'BP','WK'],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']]
        player_input = 'Kxb5'
        board4.make_move(2,player_input)
        expect(board4.board).to eq(expected_board)
      end
    end

  end


end