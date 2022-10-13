require './lib/board.rb'

describe Board do
  subject(:board) { described_class.new() }
  describe "#valid_input?" do
    context "When given a player input" do
      it "returns false when given a one letter input" do
        player_input = "a"
        expect(board.valid_input?(1, player_input)).to eq(false)
      end
    end

    context "When the board is at its initial condition" do
      it "returns true when white pawn moves two spaces" do
        player_input = "c4"
        expect(board.valid_input?(1, player_input)).to eq(true)
      end

      it "returns true when white pawn moves one space" do
        player_input = "d3"
        expect(board.valid_input?(1, player_input)).to eq(true)
      end

      it "returns true when black pawn moves two spaces" do
        player_input = "f5"
        expect(board.valid_input?(2, player_input)).to eq(true)
      end

      it "returns true when black pawn moves one spaces" do
        player_input = "f6"
        expect(board.valid_input?(2, player_input)).to eq(true)
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
        expect(board2.valid_input?(1, player_input)).to eq(true)
      end

      it "returns false when white captures with 'b3xc5'" do
        player_input = 'b3xc5'
        expect(board2.valid_input?(1, player_input)).to eq(false)
      end
      it "returns false when white captures with 'b4xc2'" do
        player_input = 'b4xc2'
        expect(board2.valid_input?(1, player_input)).to eq(false)
      end

      it "returns true when black captures with 'c5xb4'" do
        player_input = 'c5xb4'
        expect(board2.valid_input?(2, player_input)).to eq(true)
      end

      it "returns false when white captures with 'c5xb4'" do
        player_input = 'c5xb4'
        expect(board2.valid_input?(1, player_input)).to eq(false)
      end

      it "returns false when black captures with 'b4xc5'" do
        player_input = 'b4xc5'
        expect(board2.valid_input?(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'b4xxxxx'" do
        player_input = 'b4xxxxx'
        expect(board2.valid_input?(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'xxxxxc5'" do
        player_input = 'xxxxxc5'
        expect(board2.valid_input?(2, player_input)).to eq(false)
      end

      it "returns false when player input is 'b4xc5xb3xb4'" do
        player_input = 'b4xc5xb3xb4'
        expect(board2.valid_input?(1, player_input)).to eq(false)
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
        expect(board3.valid_input?(1, player_input)).to eq(true)
      end
    end
   

  end


end