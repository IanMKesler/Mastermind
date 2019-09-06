class Player
  attr_accessor :pattern
  attr_reader :role

  def initialize(role)
    @role = role
    @pattern = []
  end
end
