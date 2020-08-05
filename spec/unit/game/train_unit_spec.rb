require 'support/shared_examples/game_action'
require_relative '../../../lib/game/train_unit'

describe Game::TrainUnit do
  include_examples 'game unit action'

  it 'charges player gold and strengthens the unit' do
    expect(player).to receive(:gold=).with(90)
    expect(unit).to receive(:strength_points=).with(8)
    expect(player).to receive(:update_unit).with(unit)

    described_class.new(game, player, unit).perform
  end
end
