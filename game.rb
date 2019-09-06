class Game
    require_relative "board.rb"
    require_relative "player.rb"
    
    def initialize(game)
        @maker = Player.new("maker")
        @breaker = Player.new("breaker")
        @board = Board.new(game)

        


end