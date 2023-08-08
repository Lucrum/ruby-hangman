# frozen_string_literal: true

require 'English'

# main game class
class Hangman
  def initialize
    @word = valid_word
  end

  def valid_word
    word = random_word
    word = random_word until word.length >= 5 && word.length <= 12
    word
  end

  # this assumes the file is 10000 lines long!!
  def random_word
    File.open('google-10000-english-no-swears.txt', 'r') do |word_dict|
      rand(1..10_000).times { word_dict.gets }
      $LAST_READ_LINE.strip
    end
  end
end

Hangman.new
