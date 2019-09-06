class Player
  attr_accessor :win, :pattern
  attr_reader :role

  def initialize(role)
    @role = role
    @pattern = []
    @win = false
  end
end
