class GamesController < ApplicationController
  GRID_SIZE = 9

  def new
    @letters = []
    GRID_SIZE.times { @letters << ('A'..'Z').to_a[rand(26)] }
  end

  def score
  end
end
