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
      @maker.showPattern
      puts "Please input guess"
      getGuess
      @board.draw(@breaker.pattern, @turn)
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
    4.times { @maker.pattern << rand(5) }
    puts @maker.showPattern
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
    output.map { |x| x.to_i }
  end

  def win?
    puts "Breaker: #{@breaker.pattern}"
    puts "Maker: #{@maker.pattern}"
    puts "Win?: #{@breaker.pattern == @maker.pattern}"
    @breaker.pattern == @maker.pattern ? true : false
  end

  def hint
    output = compare([@maker.pattern, @breaker.pattern])
    puts "#{output[0]} are correct. #{output[1]} correct numbers but in the wrong position."
  end

  def compare(input) 
    code = input[0].dup #Arrays are not POD types, need to make a shallow copy to avoid changing original.
    guess = input[1].dup
    output = [0, 0]
    code.each_with_index { |x, i|
      if guess[i] == x
        output[0] += 1
        code[i] = nil
        guess[i] = nil
      end
    }
    puts "Maker after compare: #{@maker.pattern}"
    code = code.select { |x| x != nil }
    guess = guess.select { |x| x != nil }
    code.each_with_index { |x, i|
      if guess.include?(x)
        output[1] += 1
        guess[guess.index(x)] = nil
      end
    }
    output
  end
end
