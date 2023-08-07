# frozen_string_literal: true

require 'English'

# main game class
class Hangman
  def initialize
    @word = random_word
  end

  # this assumes the file is 10000 lines long!!
  def random_word
    word_dict = File.open('google-10000-english-no-swears.txt')
    rand(10_000).times { word_dict.gets }
    $LAST_READ_LINE
  end
end

Hangman.new
