require_relative '../../lib/game'
require_relative '../../lib/game/add_player'
require_relative '../../lib/game/attack'
require_relative '../../lib/game/train_unit'
require_relative '../../lib/game/upgrade_unit'
require_relative '../../lib/player'
require_relative '../../lib/unit'

describe 'Game integration' do
  let(:game) { Game.new }

  let(:player_1_units) do
    [
      Unit::Archer.new, # 10
      Unit::Knight.new, # 20
      Unit::Knight.new, # 20
      Unit::Archer.new, # 10
      Unit::Pikeman.new, # 5
      Unit::Knight.new, # 20
      Unit::Pikeman.new # 5
    ] # total strengh points = 90
  end
  let(:player_1_sorted_units) { player_1_units.sort_by(&:strength_points) }
  let(:player_1) { Game::AddPlayer.new(game, civilization: 'Chinese Empire', units: player_1_units).perform }

  let(:player_2_units)  do
    [
      Unit::Archer.new, # 10
      Unit::Knight.new, # 20
      Unit::Pikeman.new, # 5
      Unit::Pikeman.new, # 5
      Unit::Knight.new, # 20
      Unit::Knight.new, # 20
      Unit::Pikeman.new, # 5
      Unit::Pikeman.new, # 5
      Unit::Pikeman.new, # 5
      Unit::Pikeman.new # 5
    ]
  end
  let(:player_2_sorted_units) { player_2_units.sort_by(&:strength_points) }
  let(:player_2) { Game::AddPlayer.new(game, civilization: 'Byzantine Empire', units: player_2_units).perform }

  it 'initializes the game, sorting player units and assigning default gold' do
    expect(game.players).to eq(player_1.id => player_1, player_2.id => player_2)

    expect(game.players[player_1.id]).to have_attributes(
      id: be_a(String),
      civilization: 'Chinese Empire',
      units: player_1_sorted_units,
      gold: 0,
      strength_points: 90
    )

    expect(game.players[player_2.id]).to have_attributes(
      id: be_a(String),
      civilization: 'Byzantine Empire',
      units: player_2_sorted_units,
      gold: 0,
      strength_points: 100
    )
  end

  describe 'attacking' do
    subject { Game::Attack.new(game, player_1, player_2).perform }
        
    describe 'when there\'s a winner' do
      it 'kills the loser\'s two strongest units and gives the winner 100 gold' do
        subject

        expect(game.players[player_1.id]).to have_attributes(
          gold: 0,
          units: player_1_sorted_units - player_1_sorted_units.last(2)
        )

        expect(game.players[player_2.id]).to have_attributes(
          gold: 100,
          units: player_2_sorted_units
        )
      end
    end

    describe 'when there is a tie' do
      let(:player_2_units) do
        [
          Unit::Archer.new, # 10
          Unit::Knight.new, # 20
          Unit::Knight.new, # 20
          Unit::Archer.new, # 10
          Unit::Pikeman.new, # 5
          Unit::Knight.new, # 20
          Unit::Pikeman.new # 5
        ] # total strengh points = 90
      end
      let(:player_2) { Game::AddPlayer.new(game, civilization: 'Otoman Empire', units: player_2_units).perform }

      it 'kills a random number of units for each player' do
        subject

        expect(game.players[player_1.id].units.length).to be < player_1_units.length
        expect(game.players[player_2.id].units.length).to be < player_2_units.length
      end
    end
  end

  describe 'training' do
    subject { Game::TrainUnit.new(game, player_2, unit_to_train).perform }
    let(:unit_to_train) { player_2.units.last }

    describe 'when player does not have enough gold' do
      it 'raises an error' do
        expect { subject }.to raise_error(RuntimeError, 'Not enough gold')
      end
    end

    describe 'when player has enough gold' do
      before { player_2.gold += 100 }

      it 'strengthens the unit' do
        subject
        expect(game.players[player_2.id].units_by_id[unit_to_train.id].strength_points).to eq(30)
        expect(game.players[player_2.id].gold).to eq(70)
      end
    end
  end

  describe 'upgrading' do
    subject { Game::UpgradeUnit.new(game, player_1, player_1_units.first).perform }

    describe 'when player does not have enough gold' do
      it 'raises an error' do
        expect { subject }.to raise_error(RuntimeError, 'Not enough gold')
      end
    end

    describe 'when player has enough gold' do
      before { player_2.gold += 100 }

      it 'upgrades the unit' do

        unit_to_upgrade = player_2.units.first

        expect(unit_to_upgrade).to be_a(Unit::Pikeman)

        Game::UpgradeUnit.new(game, player_2, unit_to_upgrade).perform

        expect(game.players[player_2.id].gold).to eq(70)
        expect(game.players[player_2.id].units.find { |u| u.id == unit_to_upgrade.id }).to be_a(Unit::Archer)
        expect(game.players[player_2.id].units_by_id[unit_to_upgrade.id]).to be_a(Unit::Archer)

        expect(player_2.units.last).to be_a(Unit::Knight)
      end
    end
  end
end
