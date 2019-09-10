class Player
  attr_accessor :pattern, :player
  attr_reader :role

  def initialize(role)
    @role = role
    @pattern = []
    @player = false
  end

  def showPattern
    @pattern.join("")
  end
end
