# frozen_string_literal: true

require_relative '../lib/player.rb'

describe Player do
  subject(:player1) { described_class.new(1) }
  subject(:player2) { described_class.new(2) }

  describe '#initialize' do
    context "when the player1 is initialized" do
      it 'has a empty circle as its token' do
        player1_token = player1.instance_variable_get(:@token)
        expect(player1_token).to eq("\u25EF")
      end
    end

    context "when player2 is initialized" do
      it 'has a filled circle as its token' do
        player2_token = player2.instance_variable_get(:@token)
        expect(player2_token).to eq("\u25CF")
      end
    end
  end

  describe '#ask_player_input' do
    context 'when the player inputs correctly in the first try' do
      before do
        allow(player1).to receive(:puts)
        allow(player1).to receive(:gets).and_return('2')
      end 

      it 'returns the input' do
        expect(player1).to receive(:ask_player_input).and_return(2)
        player1.ask_player_input
      end

      it 'does not trigger the alert message' do
        alert_message = 'Invalid input. Please input a number from one to seven'
        expect(player1).not_to receive(:puts).with(alert_message)
        player1.ask_player_input
      end
    end

    context 'when the player needs three attempts to input correctly' do
      before do
        allow(player2).to receive(:puts).with('Please select a column from one to seven')
        wrong_number = '8'
        letter = 'd'
        valid = '2'
        allow(player2).to receive(:gets).and_return(wrong_number, letter, valid)
      end 

      it 'triggers the alert message twice' do
        expect(player2).to receive(:puts).with('Invalid input. Please input a number from one to seven').twice
        player2.ask_player_input
      end
    end
  end
end
