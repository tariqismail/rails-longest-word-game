require 'open-uri'
require 'json'

class GamesController < ApplicationController
  helper_method :exist_in_grid?, :word_valid?
  GRID_SIZE = 9

  def new
    @letters = []
    GRID_SIZE.times { @letters << ('A'..'Z').to_a[rand(26)] }
  end

  def score
    # 1. word can't be built out of original grid
    @letters = params[:letters].split(' ')
    @answer = params[:answer]
    if exist_in_grid?(@answer)
      @result = word_valid?(@answer) ? :valid_word : :invalid_word
    else
      @result = :invalid_letters
    end
  end

  private

  def exist_in_grid?(word)
    grid_hash = {}
    @letters.each { |letter| grid_hash.key?(letter.to_sym) ? grid_hash[letter.to_sym] += 1 : grid_hash[letter.to_sym] = 1 }
    answer_array = word.upcase.split('')
    answer_array.each { |letter| grid_hash.key?(letter.to_sym) ? grid_hash[letter.to_sym] -= 1 : grid_hash[letter.to_sym] = -1}
    grid_hash.all? { |_letter, count| count >= 0}
  end

  def word_valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    parsed = JSON.parse(response)
    parsed['found']
  end
end
