# Controls the rules about adding a player to the game.
# Units are sorted by strength to speed up lookup operations.
class Game::AddPlayer
  # @param game [Game]
  # @param id [String] a unique identifier for this player
  # @param civilization [String]
  # @param units [Array<Unit>]
  def initialize(game, civilization:, units:)
    raise 'Duplicated player' if game.players[id].present?

    self.game = game
    self.civilization = civilization
    self.units = units
  end

  def perform
    game.players[id] = Player.new(civilization, units)
  end

  private

  attr_accessor :game, :id, :civilization, :units
end
