class Game
    require_relative "board.rb"
    require_relative "player.rb"
    
    def initialize(game)
        @maker = Player.new("maker")
        @breaker = Player.new("breaker")
        @board = Board.new(game)
        @turn = 1
    end

    def play
        puts "Selecting Secret Pattern"
        generateSecret
        while @turn <= 12
            @board.show
            puts hint if @turn > 1
            puts "Please input guess"
            getGuess
            @board.draw(@breaker.pattern)
            if win?
                @board.show
                puts "Nice! The breaker got it!"
                return
            else
                @turn += 1
            end
        end
        puts "Better luck next time, breaker. The maker wins!"
    end

    private

    def generateSecret
        @maker.pattern.map! {|x|
          x = rand(6)
        }
    end

    def getGuess
        guess = formatGuess
        until guess.length == 4
            puts "Please input four numbers from 0-5. Ex: 0254"
            guess = formatGuess
        end
        @breaker.pattern = guess
    end

    def formatGuess
        guess = gets
        output = guess.scan /[0-5]/
        output
    end

    def win?
        @breaker.pattern == @maker.pattern ? true : false
    end

    def hint



    




            
       
        

            





end