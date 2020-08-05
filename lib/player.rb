require 'securerandom'

# A simple class to represent a player in the game.
# Player units are kept ordered to speed up lookup operations.
class Player
  attr_accessor :gold
  attr_reader :id, :civilization, :units, :units_by_id

  # @param civilization [String]
  # @param units [Array<Unit>] a map of units indexed by its ids.
  def initialize(civilization, units = [])
    self.id = SecureRandom.uuid
    self.civilization = civilization
    self.gold = 0
    units && set_units(units)
  end

  def strength_points
    units.reduce(0) do |acc, unit|
      acc + unit.strength_points
    end
  end

  def delete_unit(unit)
    units.delete_if { |u| u.id == unit.id }
    units_by_id.delete(unit.id)
  end

  def update_unit(unit)
    raise 'This unit does not belong to this player' if units_by_id[unit.id].nil?

    self.units_by_id[unit.id] = unit
    index = units.find_index { |u| u.id == unit.id  }
    units[index] = unit
  end

  private

  def set_units(units)
    self.units = units.sort_by(&:strength_points)
    self.units_by_id = units.reduce({}) do |acc, unit|
      raise 'Duplicated unit' unless acc[unit.id].nil?
      acc[unit.id] = unit
      acc
    end
  end

  attr_writer :id, :civilization, :units, :units_by_id
end
