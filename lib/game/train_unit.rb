require_relative './unit_action'

class Game::TrainUnit < Game::UnitAction
  def initialize(game, player, unit)
    raise 'Not enough gold' if unit.training_cost > player.gold
    super(game, player, unit)
  end

  def perform
    player.gold -= unit.training_cost
    unit.strength_points += unit
    player.update_unit(unit)
  end
end
