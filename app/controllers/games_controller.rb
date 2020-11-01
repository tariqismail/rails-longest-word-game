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
      # 2. the word is valid according to the grid but is not an english word
      if word_valid?(@answer)
        @result = :valid_word
        # 3. the word is valid according to the grid and is an english word
        # @result = "<strong>Congratulations!</strong> #{answer.upcase} is a valid English word!"
        # @result = "#{content_tag(:strong, 'Congratulations!')} #{answer.upcase} is a valid English word!"
      else
        @result = :invalid_word
        # @result = "Sorry but <strong>#{answer.upcase}</strong> does not seem to be a valid English word..."
      end
    else
      @result = :invalid_letters
      # @result = "Sorry but <strong>#{answer.upcase}</strong> can't be built out of #{@letters.join(', ')}"
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
