# Holds the game state, but does not modify it.
# Modification of game state is encapsulated in command objects.
class Game
  attr_reader :players

  # @param players [Array<Player>] the initial players
  def initialize(players)
    self.players = {}
  end

  private

  attr_writer :players
end
