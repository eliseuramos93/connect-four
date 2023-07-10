# frozen_string_literal: false

require_relative './printable.rb'

class Player
  include Printable

  attr_reader :token, :player_id

  def initialize(id)
    @player_id = id
    @token = set_player_token
  end

  def ask_player_input
    input = nil
    
    loop do
      puts message(:ask_player_input)
      input = gets.chomp.to_i
      break if valid?(input)
    end

    input
  end

  protected

  def set_player_token
    return @token = player_token(:one) if @player_id == 1

    @token = player_token(:two)
  end

  def valid?(input)
    return true if input.between?(1, 7)

    puts message(:invalid_player_input)
    false
  end
end
