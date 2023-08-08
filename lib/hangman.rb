# frozen_string_literal: true

require 'English'
require 'json'

# main game class
class Hangman
  def initialize
    @word = valid_word
    @guesses = ['_'] * @word.length
    @victory = false
    @round = 1
    @max_rounds = 16
    game_loop
  end

  def game_loop
    until @victory || @round > @max_rounds
      input = user_input
      if input == 'save'
        p 'saving!'
      else
        guess(input)
        @round += 1
      end
      print "Guess #{@round} of #{@max_rounds} | #{@guesses.join(' ')}\n"
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
    until verify_input(input)
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

  def verify_input(input)
    input.match(/(^[a-z]{1}$)|(^save$)/)
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
end

Hangman.new
