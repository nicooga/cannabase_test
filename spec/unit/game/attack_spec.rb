require_relative '../../../lib/game'
require_relative '../../../lib/game/attack'
require_relative '../../../lib/player'
require_relative '../../../lib/unit'

describe Game::Attack do
  let(:player_1) do
    instance_double(
      Player,
      id: 'asdf1234',
      strength_points: 35,
      gold: 0,
      units: [
        Unit::Pikeman.new,
        Unit::Archer.new,
        Unit::Knight.new
      ]
    )
  end

  let(:player_2) do
    instance_double(
      Player,
      id: 'qwer1234',
      strength_points: 45,
      gold: 0,
      units: [
        Unit::Pikeman.new,
        Unit::Archer.new,
        Unit::Archer.new,
        Unit::Knight.new
      ]
    )
  end

  let(:game) do
    Game.new.tap do |g|
      allow(g).to receive(:players).and_return({
        player_1.id => player_1,
        player_2.id => player_2
      })
    end
  end

  describe 'when the attacking player does not belong to the game' do
    it 'raises an error' do
      expect do
        described_class.new(game, player_1, Player.new('Some Empire'))
      end.to raise_error(RuntimeError, 'A player does not belong to this game')
    end
  end

  describe 'when the attacked player does not belong to the game' do
    it 'raises an error' do
      expect do
        described_class.new(game, Player.new('Some Empire'), player_2)
      end.to raise_error(RuntimeError, 'A player does not belong to this game')
    end
  end

  describe 'when there is a winner' do
    it 'gives 100 gold to the winner and kills the loser\'s two strongest units' do
      expect(player_1).to receive(:delete_unit).with(player_1.units[-1])
      expect(player_1).to receive(:delete_unit).with(player_1.units[-2])
      expect(player_2).to receive(:gold=).with(100)

      described_class.new(game, player_1, player_2).perform
    end
  end

  describe 'when there is a tie' do
    before do
      allow(player_1).to receive(:strength_points).and_return(10)
      allow(player_2).to receive(:strength_points).and_return(10)
    end

    it 'kills between 1 and 3 random units for each player' do
      allow_any_instance_of(Object).to receive(:rand).with(1..3).and_return(1)

      allow(player_1.units).to receive(:sample).and_return(player_1.units.first)
      allow(player_2.units).to receive(:sample).and_return(player_2.units.first)

      expect(player_1).to receive(:delete_unit).once.with(player_1.units.first)
      expect(player_2).to receive(:delete_unit).once.with(player_2.units.first)

      described_class.new(game, player_1, player_2).perform
    end
  end
end
