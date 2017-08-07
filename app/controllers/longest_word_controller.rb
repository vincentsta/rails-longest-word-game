require 'open-uri'
require 'json'

class LongestWordController < ApplicationController
  def game
    @grid = generate_grid(9)
    @start_time = Time.now
    @usr_name = session[:usr_name]
    session[:grid] = @grid
  end

  def init
  end

  def usr_name
    session[:usr_name] = params[:usr_name]
    redirect_to game_url
  end

  def score
    @attempt = params[:usr_answer]
    @grid = session[:grid]
    start_time = params[:start_time].to_datetime
    end_time = Time.now
    @result = run_game(@attempt, @grid, start_time, end_time)
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
