require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    @word = params[:word].downcase.split(//)
    @grid = params[:grid].split(//)

    # Check if word is in grid
    @in_grid = is_in_grid?(@word, @grid)

    # Check if word is English
    @is_english = is_english?(params[:word])

    # Check if word is valid
    if @in_grid && @is_english
      @message = "Well done, #{@word.join.upcase} fits the grid and is English."
    elsif @in_grid == true && @is_english == false
      @message = "Sorry, #{@word.join.upcase} is not English."
    else
      @message = "Sorry, #{@word.join.upcase} can't be build from #{@grid.join(', ')}."
    end
  end

  private

  def generate_grid
    letters_array = ("a".."z").to_a * 3
    letters_array.sample(10)
  end

  def is_in_grid?(word, grid)
    @word == @word & @grid
  end

  def is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_attempt = JSON.parse(open(url).read)

    user_attempt['found'] == true ? true : false
  end

end
