require 'securerandom'

# @abstract
class Unit
  attr_accessor :strength_points
  attr_reader :id

  def initialize
    self.id = SecureRandom.uuid
    self.strength_points = initial_strength_points
  end

  # @return Integer
  def initial_strength_points
    raise NotImplementedError
  end

  # @return Integer
  def training_cost
    raise NotImplementedError
  end

  # @return Integer
  def training_benefit
    raise NotImplementedError
  end

  # @return Unit
  def upgrade_cost
    raise NotImplementedError
  end

  # @return Unit
  def upgrades_to
    raise NotImplementedError
  end

  private

  attr_writer :id

  class Pikeman < self
    def initial_strength_points() 5 end
    def training_cost() 10 end
    def training_benefit() 3 end
    def upgrade_cost() 30 end
    def upgrades_to() Archer end
  end

  class Archer < self
    def initial_strength_points() 5 end
    def training_cost() 20 end
    def training_benefit() 40 end
    def upgrades_to() Knight end
  end

  class Knight < self
    def initial_strength_points() 20 end
    def training_cost() 30 end
    def training_benefit() 10 end
    def upgrades_cost() nil end
    def upgrades_to() nil end
  end
end
