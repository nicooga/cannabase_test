require_relative '../../../lib/game'
require_relative '../../../lib/game/add_player'
require_relative '../../../lib/player'
require_relative '../../../lib/unit'

describe Game::AddPlayer do
  let(:game) { Game.new }
  let(:civilization) { 'Chinese empire'}
  let(:units) do
    [
      Unit::Archer.new,
      Unit::Pikeman.new,
      Unit::Knight.new
    ]
  end
  let(:player) { instance_double(Player, id: 'abc123') }

  it 'adds a new player to the game' do
    allow(Player)
      .to receive(:new).with(civilization, units)
      .and_return(player)

    returned_player =
      described_class.new(
        game,
        civilization: civilization,
        units: units
      ).perform

    expect(game.players.length).to eq(1)

    id, actual_player = game.players.first

    expect(id).to eq('abc123')
    expect(actual_player).to be(player)
    expect(actual_player).to be(returned_player)
  end
end
