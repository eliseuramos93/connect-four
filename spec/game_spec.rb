# frozen_string_literal: true

require_relative '../lib/game.rb'

describe Game do
  subject(:game) { described_class.new }

  describe '#player_turn' do
    before do
      allow(game.players[0]).to receive(:ask_player_input).and_return(2)
      allow(game.board).to receive(:insert_token).with(2, "\u25EF").and_return("\u25EF")
    end 

    it 'sends message to ask player for input' do
      player1 = game.instance_variable_get(:@players)[0]
      expect(player1).to receive(:ask_player_input)
      game.player_turn
    end

    it 'sends message to insert player token into the board' do
      board = game.instance_variable_get(:@board)
      expect(board).to receive(:insert_token)
      game.player_turn
    end

    context 'when the player makes a correct input into a column with empty spaces' do
      it 'returns the token' do
        token = "\u25EF"
        expect(game.board).to receive(:insert_token).with(2, token).and_return(token)
        game.player_turn
      end
    end
  end
end
