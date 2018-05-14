# frozen_string_literal: true

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
    @in_grid = in_grid?

    # Check if word is English
    @is_english = english?(params[:word])

    # Check if word is valid
    @valid = valid

    # Compute score
    @round_score = params[:word].length * 3
    @score = compute_score(@round_score)
  end
  def reset
    session.delete(:score)
    redirect_to new_path
  end

  private

  def generate_grid
    letters_array = ('a'..'z').to_a * 3
    letters_array.sample(10)
  end

  def in_grid?
    @word == @word & @grid
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_attempt = JSON.parse(open(url).read)

    user_attempt['found'] == true
  end

  def compute_score(score)
    if session[:score].nil?
      session[:score] = score
    else
      session[:score] += score
    end
    @grand_total = session[:score]
  end

  def valid
    if @in_grid && @is_english
      @message = "Well done, #{@word.join.upcase} fits the grid and is English."
    elsif @in_grid == true && @is_english == false
      @message = "Sorry, #{@word.join.upcase} is not English."
    else
      @message = "Sorry, #{@word.join.upcase} can't be build from #{@grid.join(', ')}."
    end
  end

end
