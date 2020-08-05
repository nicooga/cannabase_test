# A command object that allows a player to attack another one.
class Game::Attack
  # @param game [Game]
  # @param player_a [Player]
  # @param player_b [Player]
  def initialize(game, player_a, player_b)
    if (!game.players[player_a.id] || !game.players[player_b.id])
      raise 'A player does not belong to this game'
    end

    self.game = game
    self.player_a = player_a
    self.player_b = player_b
  end

  def perform
    if draw?
      kill_random_units(player_a)
      kill_random_units(player_b)
      return
    end

    loser, winner = [player_a, player_b].sort_by(&:strength_points)

    kill_strongest_units(loser)
    winner.gold += 100

    game.players[loser.id] = loser
    game.players[winner.id] = winner
  end

  private

  attr_accessor :game, :player_a, :player_b

  def draw?
    player_a.strength_points == player_b.strength_points
  end

  # Player units are guarenteed to be sorted by strength ASC
  # each time a player or a unit is added to the game,
  # so we can just remove the last 2 units.
  def kill_strongest_units(player)
    player.units.last(2).each { |u| player.delete_unit(u) }
  end

  def kill_random_units(player)
    rand(1..3).times do
      unit = player.units.sample
      player.delete_unit(unit)
    end
  end
end
