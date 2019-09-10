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
    puts "Welcome to Mastermind! Input (M) to play as the code maker or (B) to play as the code breaker."
    getRole == "M" ? @maker.player = true : @breaker.player = true
    puts "Selecting Secret Pattern"
    @maker.player ? @maker.pattern = getPattern : generateSecret
    while @turn <= 12
      #puts "Pattern: #{@maker.pattern}"
      puts "Code goes here #{@maker.showPattern}"  #for testing
      @board.show
      hints = [0,0]
      hints = hint if @turn > 1
      puts "Please input guess"
      @breaker.player ? @breaker.pattern = getPattern : generateGuess(hints)
      @board.draw(@breaker.pattern.dup, @turn)
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

  def getRole
    input = gets.strip.upcase
    until input.match(/[MB]/)
      puts "Please input either M or B and press enter."
      input = gets.strip.upcase
    end
    input
  end

  def generateGuess(hints)
    correct = hints[0]
    color = hints[1]
    indexes = [0, 1, 2, 3]
    positions = indexes.sample(correct)
    puts "Positions: #{positions}"

    @breaker.pattern = [0, 0, 0, 0] if @breaker.pattern == []
    @breaker.pattern.map!.with_index { |x, i|
      positions.include?(i) ? x : x = rand(5)
    }

    
    puts @breaker.showPattern
  end

  def generateSecret
    4.times { @maker.pattern << rand(5) }
    #puts "Secret Code: #{@maker.showPattern}" #for testing
  end

  def getPattern
    pattern = formatPattern
    until pattern.length == 4
      puts "Please input four numbers from 0-5. Ex: 0254"
      pattern = formatPattern
    end
    pattern
  end

  def formatPattern
    pattern = gets
    output = pattern.scan /[0-5]/
    output.map { |x| x.to_i }
  end

  def win?
    puts "Breaker: #{@breaker.pattern}"
    #puts "Maker: #{@maker.pattern}"
    #puts "Win?: #{@breaker.pattern == @maker.pattern}"
    @breaker.pattern == @maker.pattern ? true : false
  end

  def hint
    output = compare([@maker.pattern, @breaker.pattern])
    puts "#{output[0]} are correct. #{output[1]} correct numbers but in the wrong position."
    output
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
    #puts "Maker after compare: #{@maker.pattern}"
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
