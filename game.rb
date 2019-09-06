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
      hint if @turn > 1
      puts "Please input guess"
      getGuess
      @board.draw(@breaker.pattern)
      if win?
        @board.show
        puts "Nice! The breaker got it!"
        puts "The correct code is #{@maker.showPattern}"
        return
      else
        @turn += 1
      end
    end
    puts "Better luck next time, breaker. The maker wins!"
    puts "The correct code is #{@maker.showPattern}"
  end

  private

  def generateSecret
    @maker.pattern.map! { |x|
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
    ouput = compare([@maker.pattern, @breaker.pattern])
    puts "#{output[0]} are correct. #{output[1]} correct numbers but in the wrong position."
  end

  def compare(input)
    maker = input[0]
    breaker = input[1]
    output = [0, 0]
    maker.each_with_index { |x, i|
      if breaker[i] == x
        output[0] += 1
        maker[i] = nil
        breaker[i] = nil
      end
    }
    maker = maker.select { |x| x != nil }
    breaker = breaker.select { |x| x != nil }
    maker.each_with_index { |x, i|
      if breaker.include?(x)
        output[1] += 1
        breaker[breaker.index(x)] = nil
      end
    }
    output
  end
end
