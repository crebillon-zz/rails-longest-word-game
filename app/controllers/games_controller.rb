require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer].upcase
    splited_answer = @answer.chars
    @letters = params[:letters]
    letters_splited = @letters.split(" ")
    # The word is valid according to the grid and is an English word
    if included?(splited_answer, letters_splited) == true && english_word?(@answer) == true
      @result = "Congratulations, #{@answer} is an English word!"
    # The word is valid according to the grid, but is not a valid English word
    elsif included?(splited_answer, letters_splited) == true && english_word?(@answer) == false
      @result = "Sorry, but #{@answer} is not an English word..."
    # The word can't be built out of the original grid
    else
      @result = "Sorry #{@answer} can't be build out of #{@letters}"
    end
  end

  def included?(guess, grid)
    # voit si tous les elements du tableau repondent as une condition
    guess.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
