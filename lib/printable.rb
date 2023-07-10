# frozen_string_literal: freeze

module Printable
  def player_token(player)
    {
      one: "\u25EF",
      two: "\u25CF"
    }[player]
  end

  def message(text)
    {
      ask_player_input: 'Please select a column from one to seven',
      invalid_player_input: 'Invalid input. Please input a number from one to seven',
      column_full: 'The selected column is full. Please choose another column',
      player_wins: ', congratulations! You won the match!',
      tie_game: 'The board is complete, so this game ends up in a tie!',
      ask_player1_name: "Please input Player 1's name: ",
      ask_player2_name: "Please input Player 2's name: "
    }[text]
  end
end
