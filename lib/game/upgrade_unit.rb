require_relative './unit_action'

class Game::UpgradeUnit < Game::UnitAction
  def initialize(game, player, unit)
    raise 'This unit is not upgradable' if unit.upgrades_to.nil?
    raise 'Not enough gold' if unit.upgrade_cost > player.gold
    super(game, player, unit)
  end

  def perform
    upgraded_unit = unit.upgrades_to.new(id: unit.id)

    player.update_unit(upgraded_unit)
    player.gold -= unit.upgrade_cost

    game.players[player.id] = player
  end
end
