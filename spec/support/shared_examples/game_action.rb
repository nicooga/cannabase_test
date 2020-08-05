require_relative '../../../lib/game'
require_relative '../../../lib/player'
require_relative '../../../lib/unit'

RSpec.shared_examples 'game unit action' do
  def build_player(id:)
    units = [
      Unit::Pikeman.new,
      Unit::Archer.new,
      Unit::Knight.new
    ]

    instance_double(
      Player,
      id: id,
      strength_points: 35,
      gold: 100,
      units: units,
      units_by_id: units.reduce({}) { |acc, u| acc[u.id] = u; acc }
    )
  end

  let(:player) { build_player(id: 'asdf1234') }
  let(:unit) { player.units.first }

  let(:game) { Game.new }

  before do
    allow(game).to receive(:players).and_return({ player.id => player })
    allow(player.units)
  end

  describe 'when the player does not belong to the game' do
    let(:another_player) { build_player(id: 'qwer1234') }

    it 'raises an error' do
      expect { described_class.new(game, another_player, unit).perform }
        .to raise_error(RuntimeError, 'The player does not belong to this game')
    end
  end

  describe 'when the unit does not belong to this player' do
    before { allow(player).to receive(:units_by_id).and_return({}) }

    it 'raises an error' do
      expect { described_class.new(game, player, unit).perform }
        .to raise_error(RuntimeError, 'This unit does not belong to this player')
    end
  end
end
