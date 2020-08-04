# Encapsulates common behavior for command objects
# related to units
class Game::UnitAction
  def initialize(game, player, unit)
    raise 'The player does not belong to this game' if !game.players[player.id]
    raise 'This unit is to upgradable' if unit.upgrades_to.nil?
    raise 'This unit does not belong to this player' if player.units_by_id[unit.id].nil?

    self.game = game
    self.player = player
    self.unit = unit
  end

  def perform
    raise NotImplementedError
  end

  private

  attr_accessor :game, :player, :unit
end
