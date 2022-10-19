require './lib/board.rb'

describe Board do
  describe "#check?" do
    context "When the board puts the WK in check by a pawn" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,'WK','WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "returns true for WK" do
        expect(board4.check?("WK",board4.board)).to eq(true)
      end
      it "returns false for BK" do
        expect(board4.check?("BK",board4.board)).to eq(false)
      end
    end

    context "When the board puts the BK in check by a pawn" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP','BK',nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "returns true" do
        expect(board4.check?("BK",board4.board)).to eq(true)
      end

    end

    context "When the board puts the WK in check by a knight" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, 'WK', nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "returns true" do
        expect(board4.check?("WK",board4.board)).to eq(true)
      end
    end
    context "When the board puts the WK in safety (no checks)" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,nil,'BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ','WK','WB','WN','WR']] ) }
      it "returns false" do
        expect(board4.check?("WK",board4.board)).to eq(false)
        expect(board4.check?("BK",board4.board)).to eq(false)

      end
    end
    context "When the board puts the WK in check by a bishop" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', nil, 'BP',nil,'WK','BP',nil],
        [nil, nil, nil, 'WP',nil,nil,'WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "returns true" do
        expect(board4.check?("WK",board4.board)).to eq(true)
      end
    end

    context "When the board allows WK to walk into check" do
      subject(:board4) { described_class.new( 
        [[nil,nil,'BB','BQ','BK','BB','BN',nil],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', 'BR', nil,nil,nil,'BP',nil],
        [nil, nil, nil, nil,nil,'WK','WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "does not allow WK to walk into check" do
        expect(board4.make_move(1,"Kf5")).to eq(false)
      end
    end

    context "When the board allows BK to walk into check" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WR', 'BR', nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,nil,'WK','WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "does not allow BK to walk into check" do
        expect(board4.make_move(2,"Ka3")).to eq(false)
      end
    end

    context "When the board allows WK to be exposed to check" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, 'BR', nil,'WR','WK','WP',nil],
        [nil, nil,'WN', nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        [nil, nil,'WB','WQ',nil,'WB','WN','WR']] ) }
      it "does not allow WK to be exposed to check" do
        expect(board4.make_move(2,"Rg5")).to eq(false)
      end
    end

    context "When the board puts WK in checkmate" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,'WR',nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,'BR',nil,'WB','WN','WR']] ) }
      it "does not allow WN to capture WP" do
        player_input = "Ng1xe2"
        expect(board4.make_move(1,player_input)).to eq(false)
      end
      it "says that WK is in checkmate" do
        expect(board4.checkmate?("WK",board4.board)).to eq(true)
      end
    end

    context "When the board puts WK in check with possibility of blocking" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, 'WR', nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP','WP',nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,'BR',nil,'WB','WN','WR']] ) }
  
      it "says that WK is not in checkmate" do
        expect(board4.checkmate?("WK",board4.board)).to eq(false)
      end
    end

    context "When white pawn is about to be promoted" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP','WP','BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, 'WR', nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,nil,nil,'WB','WN','WR']] ) }
      
      before do
        allow(board4).to receive(:gets).and_return("Q")
      end
      it "allows promotion to Q to occur" do
        expected_board = 
        [['BR','WQ','BB','BQ',nil,'BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, 'WR', nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,nil,nil,'WB','WN','WR']] 
        board4.make_move(1, "b8")
        expect(board4.board).to eq(expected_board)
      end
    end

    context "When black pawn is about to be promoted" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,'BP',nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,nil,nil,'WB','WN','WR']] ) }
      
      before do
        allow(board4).to receive(:gets).and_return("N")
      end
      it "allows promotion to N to occur" do
        expected_board = 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,'BN',nil,nil,'WB','WN','WR']] 
        board4.make_move(2, "c1")
        expect(board4.board).to eq(expected_board)
      end
    end

    context "When black pawn moves such as to allow en passant by white" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, 'WP', nil, nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,nil,nil,'WB','WN','WR']] ) }
      
      before do
        board4.make_move(2, "a5")
      end
      it "allows white to capture black's pawn en passant" do
        expected_board = 
        [['BR',nil,'BB','BQ',nil,'BB','BN','BR'],
        [nil,nil,'BP',nil,'BP','BP',nil,'BP'],
        ['WP', nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        ['BK', nil, nil, nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        ["WK", nil,nil,nil,nil,'WB','WN','WR']] 
        board4.make_move(1, "b5xa6")
        expect(board4.board).to eq(expected_board)
      end
    end
    
    context "When white pawn moves such as to allow en passant by black" do
      subject(:board4) { described_class.new( 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        [nil, 'BP', nil, nil,nil,nil,'WP',nil],
        [nil, nil,nil, nil, nil,nil,nil,nil],
        ['WP',nil,nil,nil,'WP','WP',nil,'WP'],
        [nil, nil,nil,nil,'WK','WB','WN','WR']] ) }
      before do
        board4.make_move(1, "a4")
      end
      it "allows black to capture white's pawn en passant" do
        expected_board = 
        [['BR',nil,'BB','BQ','BK','BB','BN','BR'],
        ['BP',nil,'BP',nil,'BP','BP',nil,'BP'],
        [nil, nil, 'BN', nil,nil,nil,nil,nil],
        [nil, nil, nil, nil,nil,nil,'BP',nil],
        [nil, nil, nil, nil,nil,nil,'WP',nil],
        ['BP', nil,nil, nil, nil,nil,nil,nil],
        [nil,nil,nil,nil,'WP','WP',nil,'WP'],
        [nil, nil,nil,nil,'WK','WB','WN','WR']]
        board4.make_move(2, 'b4xa3')
        expect(board4.board).to eq(expected_board)
      end
    end

    context "When the board allows for castling" do
      subject(:board4) { described_class.new( 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        ['WR',nil,nil,nil,'WK',nil,nil,'WR']] ) }
      
      it "allows white to castle kingside" do
        expected_board = 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        ['WR',nil,nil,nil,nil,'WR','WK',nil]]
        player_input = "O-O"
        board4.make_move(1, player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "allows white to castle queenside" do
        expected_board = 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,'WN',nil,nil,nil,nil,nil],
        ['WP','WP','WP',nil,'WP','WP','WP','WP'],
        [nil,nil,'WK','WR',nil,nil,nil,'WR']]
        player_input = "O-O-O"
        board4.make_move(1, player_input)
        expect(board4.board).to eq(expected_board)
      end

      it "does not allow white to move king and then castle" do
        board4.make_move(1, "Kd1")
        board4.make_move(1, "Ke1")
        expect(board4.make_move(1,"O-O")).to eq(false)
      end

      it "does not allow black to move king and then castle" do
        board4.make_move(2, "Kd8")
        board4.make_move(2, "Ke8")
        expect(board4.make_move(2,"O-O")).to eq(false)
      end

      it "does not allow white to move rook and then castle" do
        board4.make_move(1, "Rg1")
        board4.make_move(1, "Rh1")
        expect(board4.make_move(1,"O-O")).to eq(false)
      end

      it "does not allow black to move king and then castle" do
        board4.make_move(2, "Rg8")
        board4.make_move(2, "Rh8")
        expect(board4.make_move(2,"O-O")).to eq(false)
      end
    end

    context "When the board does not allow for castling" do
      subject(:board4) { described_class.new( 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        ['BP','BP','BP',nil,'BP','BP',nil,'BP'],
        [nil,nil,'WN',nil,nil,nil,'WR',nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,'BN',nil,nil,'BR',nil,nil],
        ['WP','WP','WP',nil,'WP',nil,'WP','WP'],
        ['WR',nil,nil,nil,'WK',nil,nil,'WR']] ) }
      
      it "does not allow white to castle kingside" do
        expect(board4.make_move(1,"O-O")).to eq(false)
      end

      it "does not allow black to castle kingside" do
        expect(board4.make_move(2,"O-O")).to eq(false)
      end

      it "does not allow white to castle queenside" do
        expect(board4.make_move(1,"O-O-O")).to eq(false)
      end

      it "does not allow black to castle queenside" do
        expect(board4.make_move(2,"O-O-O")).to eq(false)
      end
    end

    context "When the board is new" do
      subject(:board4) { described_class.new() }
      
      it "does not allow white to castle kingside" do
        expect(board4.make_move(1,"O-O")).to eq(false)
      end

      it "does not allow black to castle kingside" do
        expect(board4.make_move(2,"O-O")).to eq(false)
      end

      it "does not allow white to castle queenside" do
        expect(board4.make_move(1,"O-O-O")).to eq(false)
      end

      it "does not allow black to castle queenside" do
        expect(board4.make_move(2,"O-O-O")).to eq(false)
      end
    end

    context "When the board puts white in stalemate" do
      subject(:board4) { described_class.new( 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        ['BP','BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,nil,nil,'BB',nil,nil,nil],
        ['BR',nil,nil,nil,'BP',nil,nil,nil],
        [nil,nil,nil,nil,'WK',nil,nil,nil]] ) }
      
      it "declares stalemate for white king due to no possible moves" do
        expect(board4.stalemate_no_moves?("WK", board4.board)).to eq(true)
      end
    end

    context "When the board allows for stalemate by repetition" do
      subject(:board4) { described_class.new( 
        [['BR',nil,nil,nil,'BK',nil,nil,'BR'],
        [nil,'BP','BP',nil,'BP','BP','BP','BP'],
        [nil,nil,'BN',nil,nil,nil,nil,nil],
        [nil,nil,nil,'BP',nil,nil,nil,nil],
        [nil,nil,nil,'WP',nil,nil,nil,nil],
        [nil,nil,nil,nil,'BB',nil,nil,nil],
        [nil,nil,nil,nil,nil,nil,nil,nil],
        [nil,nil,nil,nil,'WK',nil,nil,nil]] ) }

      before do
        board4.make_move(1, "Kd1")
        board4.make_move(2, "Ra7")
        board4.make_move(1, "Ke1")
        board4.make_move(2, "Ra8")

        board4.make_move(1, "Kd1")
        board4.make_move(2, "Ra7")
        board4.make_move(1, "Ke1")
        board4.make_move(2, "Ra8")

        board4.make_move(1, "Kd1")
        board4.make_move(2, "Ra7")
        board4.make_move(1, "Ke1")
        board4.make_move(2, "Ra8")        
      end
      it "declares draw by repetition" do
        expect(board4.stalemate_repetition?(1)).to eq(true)
      end
    end
  end 

end