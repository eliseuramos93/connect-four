# frozen_string_literal: false
require_relative './board.rb'
require_relative './player.rb'
require_relative './printable.rb'

class Game
  attr_reader :board, :players
  include Printable 

  def initialize
    @board = Board.new
    @players = [Player.new(2), Player.new(1)]       # => We will switch the order at the beginning of the game
  end

  def player_turn(player = @players[0], board = @board)
    break_loop = false
    until break_loop
      column = player.ask_player_input
      insert = board.insert_token(column, player.token)
      break_loop = !insert.nil?
    end
  end

  def change_turns
    @players = @players.reverse
  end

  def play
    ask_players_name
    game_over = false
    winner = []
    until game_over
      change_turns
      board.display_board
      player_turn
      winner << players[0] if board.connect_four?(players[0].token)
      game_over = board.board_full? || board.connect_four?(players[0].token)
    end
    print_results(winner)
  end

  def print_results(winner_arr)
    if winner_arr.empty?
      puts message(:tie_game)
    elsif winner_arr[0].player_id == 1
      puts @player1_name.concat(message(:player_wins))
    else 
      puts @player2_name.concat(message(:player_wins))
    end
  end

  def ask_players_name
    puts message(:ask_player1_name)
    @player1_name = gets.chomp
    puts message(:ask_player2_name)
    @player2_name = gets.chomp
  end 
  
end