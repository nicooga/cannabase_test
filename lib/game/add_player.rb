# Controls the rules about adding a player to the game.
class Game::AddPlayer
  # @param game [Game]
  # @param civilization [String]
  # @param units [Array<Unit>]
  def initialize(game, civilization:, units:)
    self.game = game
    self.civilization = civilization
    self.units = units
  end

  def perform
    player = Player.new(civilization, units)
    game.players[player.id] = player
  end

  private

  attr_accessor :game, :civilization, :units
end
