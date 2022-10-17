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
  end 

end