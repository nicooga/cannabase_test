require 'support/shared_examples/game_action'
require_relative '../../../lib/game/upgrade_unit'

describe Game::UpgradeUnit do
  include_examples 'game unit action'

  describe 'when the unit is not upgradable' do
    before { allow(unit).to receive(:upgrades_to).and_return(nil) }

    it 'raises an error' do
      expect { described_class.new(game, player, unit).perform }
        .to raise_error(RuntimeError, 'This unit is not upgradable')
    end
  end

  it 'charges player gold and strengthens the unit' do
    upgraded_unit = instance_double(unit.upgrades_to)

    allow(unit.upgrades_to).to receive(:new).with(id: unit.id).and_return(upgraded_unit)

    expect(player).to receive(:update_unit).with(upgraded_unit)
    expect(player).to receive(:gold=).with(70)

    expect(game.players).to receive(:[]=).with(player.id, player)

    described_class.new(game, player, unit).perform
  end
end
