class Mastermind
  COLORS = %w[Red Blue Green Yellow Orange Purple]

  def initialize
    puts "Welcome to Mastermind!"
    @mode = choose_mode
    @turns = 12
    @player_is_guesser = @mode == '1'

    if @player_is_guesser
      @code = generate_code
      player_guesses
    else
      @code = player_sets_code
      computer_guesses
    end
  end

  private

  def choose_mode
    puts "Choose mode:"
    puts "1 - You guess the secret code"
    puts "2 - Computer guesses your secret code"
    loop do
      print "Enter 1 or 2: "
      choice = gets.chomp
      return choice if %w[1 2].include?(choice)
      puts "Invalid choice! Please enter 1 or 2."
    end
  end

  def generate_code
    Array.new(4) { COLORS.sample }
  end

  def player_sets_code
    puts "Enter your secret code (4 colors, separated by spaces). Choices: #{COLORS.join(', ')}"
    loop do
      print "Your code: "
      input = gets.chomp.split.map(&:capitalize)
      return input if valid_guess?(input)
      puts "Invalid input! Please enter 4 valid colors."
    end
  end

  def player_guesses
    puts "Try to guess the secret code! Available colors: #{COLORS.join(', ')}"
    @turns.times do |turn|
      guess = get_player_guess
      feedback = provide_feedback(guess)

      puts "Turn #{turn + 1}: #{guess.join(', ')} -> Feedback: #{feedback}"

      if guess == @code
        puts "Congratulations! You guessed the code!"
        return
      end
    end
    puts "Game over! The correct code was #{@code.join(', ')}."
  end

  def get_player_guess
    loop do
      print "Enter your guess (4 colors, separated by spaces): "
      input = gets.chomp.split.map(&:capitalize)
      return input if valid_guess?(input)
      puts "Invalid input! Enter exactly 4 valid colors."
    end
  end

  def valid_guess?(input)
    input.length == 4 && input.all? { |color| COLORS.include?(color) }
  end

  def provide_feedback(guess)
    temp_code = @code.dup
    temp_guess = guess.dup
    black_pegs = 0
    white_pegs = 0

    # Check for exact matches first (black pegs)
    temp_guess.each_with_index do |color, idx|
      if color == temp_code[idx]
        black_pegs += 1
        temp_code[idx] = temp_guess[idx] = nil
      end
    end

    # Check for correct colors in the wrong position (white pegs)
    temp_guess.compact.each do |color|
      if (index = temp_code.index(color))
        white_pegs += 1
        temp_code[index] = nil
      end
    end

    "●" * black_pegs + "○" * white_pegs
  end

  def computer_guesses
    possible_colors = COLORS.repeated_permutation(4).to_a
    guess = Array.new(4) { COLORS.sample }
    previous_feedback = ""

    @turns.times do |turn|
      puts "Turn #{turn + 1}: Computer guesses: #{guess.join(', ')}"
      feedback = provide_feedback(guess)
      puts "Feedback: #{feedback}"

      if guess == @code
        puts "The computer guessed your code!"
        return
      end

      possible_colors.select! { |combo| provide_feedba ck(combo, guess) == feedback }
      guess = possible_colors.sample
    end

    puts "Computer failed to guess! Your secret code was #{@code.join(', ')}."
  end
  def exit_game
    puts "Thanks for playing Mastermind! Goodbye!"
    exit
  end
end

Mastermind.new
