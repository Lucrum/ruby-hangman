# frozen_string_literal: true

require 'English'
require 'json'

# main game class
class Hangman
  def initialize
    if File.exist?('save.json') && prompt_load
      load_save
    else
      new_game
    end
    game_loop
  end

  def new_game
    @word = valid_word
    @guesses = ['_'] * @word.length
    @victory = false
    @round = 1
    @max_rounds = 16
  end

  def prompt_load
    print 'Existing game detected. Would you like to resume? Y/N: '
    response = gets.strip.downcase
    response == 'y'
  end

  def game_loop
    until @victory || @round > @max_rounds
      print "Guess #{@round} of #{@max_rounds} | #{@guesses.join(' ')}\n"
      input = user_input
      if input == 'save'
        p 'saving!'
        save_game
      else
        guess(input)
        @round += 1
      end
    end
    game_end
  end

  # fills in the guess and checks for victory
  def guess(letter)
    @word.length.times do |ind|
      @guesses[ind] = letter if letter == @word[ind]
    end
    @victory = !@guesses.include?('_')
  end

  def user_input
    print 'Enter your guess, or save: '
    input = gets.downcase.strip
    until input.match(/(^[a-z]{1}$)|(^save$)/)
      print 'Invalid guess. Try again: '
      input = gets.downcase.strip
    end
    input
  end

  def game_end
    if @victory
      puts 'You win!'
    else
      puts "You lost! The word was [#{@word}]"
    end
  end

  def valid_word
    word = random_word
    word = random_word until word.length >= 5 && word.length <= 12
    word
  end

  # this assumes the file is 9894 lines long!
  # the file name LIES!!
  def random_word
    File.open('google-10000-english-no-swears.txt', 'r') do |word_dict|
      rand(1..9894).times { word_dict.gets }
      $LAST_READ_LINE.strip
    end
  end

  def to_json(*_args)
    hash = {}
    instance_variables.map do |var|
      hash[var] = instance_variable_get var
    end
    JSON.dump(hash)
  end

  def from_json!(save)
    data = JSON.parse save.read
    @word = data['@word']
    @guesses = data['@guesses']
    @victory = data['@victory']
    @round = data['@round']
    @max_rounds = data['@max_rounds']
  end

  def save_game
    File.open('save.json', 'w') do |save_file|
      save_file.puts(to_json)
    end
  end

  def load_save
    File.open('save.json', 'r') do |save_file|
      from_json! save_file
    end
  end
end

Hangman.new
