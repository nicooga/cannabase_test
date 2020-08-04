require_relative './unit_action'

class Game::UpgradeUnit < Game::UnitAction
  def initialize(game, player, unit)
    raise 'Not enough gold' if unit.upgrade_cost > player.gold
    super(game, player, unit)
  end

  def perform
    upgraded_unit = unit.upgrades_to.new

    player.delete_unit(unit)
    player.add_unit(upgraded_unit)
    player.gold -= unit.upgrade_cost

    game.players[player.id] = player
  end
end
