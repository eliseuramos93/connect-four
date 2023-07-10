# frozen_string_literal: true

require_relative '../lib/board.rb'

describe Board do
  subject(:game_board) { described_class.new }     # => create a new game board

  describe '#initialize' do
    # Does not need testing
  end

  describe '#column_full?' do
    context 'all columns are filled with empty strings (empty columns)' do
      it 'returns false for the first column' do
        column_input = 1
        expect(game_board.column_full?(column_input)).to eql(false)
      end

      it 'returns false for the second column' do
        column_input = 2
        expect(game_board.column_full?(column_input)).to eql(false)
      end

      it 'returns false for the sixth column' do
        column_input = 6
        expect(game_board.column_full?(column_input)).to eql(false)
      end
    end

    context 'columns 2 and 4 are full, columns 1 and 3 are partially filled' do
      before do
        game_board.instance_variable_set(:@board, [
          ['X', 'X', ' ', ' ', ' ', ' '],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ['O', ' ', ' ', ' ', ' ', ' '],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          [' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns false for the first column' do
        column_input = 1
        expect(game_board.column_full?(column_input)).to eql(false)
      end

      it 'returns true for the second column' do
        column_input = 2
        expect(game_board.column_full?(column_input)).to eql(true)
      end

      it 'returns false for the third column' do
        column_input = 3
        expect(game_board.column_full?(column_input)).to eql(false)
      end

      it 'returns true for the fourth column' do
        column_input = 4
        expect(game_board.column_full?(column_input)).to eql(true)
      end
    end
  end

  describe '#board_full?' do
    context 'the board is empty' do
      it 'returns false' do
        expect(game_board.board_full?).to eql(false)
      end
    end

    context 'the board is partially filled' do
      before do
        game_board.instance_variable_set(:@board, [
          ['X', 'X', ' ', ' ', ' ', ' '],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ['O', ' ', ' ', ' ', ' ', ' '],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          [' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' '],
          [' ', ' ', ' ', ' ', ' ', ' ']
        ])
      end

      it 'returns false' do
        expect(game_board.board_full?).to eql(false)
      end
    end

    context 'the board is full' do
      before do
        game_board.instance_variable_set(:@board, [
          ['O', 'X', 'O', 'X', 'O', 'X'],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ['O', 'X', 'O', 'X', 'O', 'X'],
          ['O', 'X', 'O', 'X', 'O', 'X'],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ['X', 'O', 'X', 'O', 'X', 'O'],
          ])
      end

      it 'returns true' do
        expect(game_board.board_full?).to eql(true)
      end
    end
  end

  describe '#insert_token' do
    before do  
      game_board.instance_variable_set(:@board, [
        ['X', 'X', ' ', ' ', ' ', ' '],
        ['X', 'O', 'X', 'O', 'X', 'O'],
        ['O', ' ', ' ', ' ', ' ', ' '],
        ['X', 'O', 'X', 'O', 'X', 'O'],
        [' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ']
      ])
    end

    context 'insert one token into empty column' do
      matcher :have_one_token do 
        match { |column| column.one? { |space| space != ' ' } }
      end

      it "makes the column's token count go from 0 to 1" do
        column_num = 5
        game_board.insert_token(column_num, 'X')
        fifth_column = game_board.instance_variable_get(:@board)[4]
        expect(fifth_column).to have_one_token
      end

      it 'returns the token' do
        column_num = 5
        token = 'X'
        expect(game_board.insert_token(column_num, token)).to eq(token)
      end
    end

    context 'insert one token into a column with two tokens' do
      matcher :have_three_tokens do 
        match { |column| column.count { |elem| elem != ' ' } == 3 }
      end

      it "makes the column's token count go from 2 to 3" do
        column_num = 1
        game_board.insert_token(column_num, 'O')
        first_column = game_board.instance_variable_get(:@board)[column_num - 1]
        expect(first_column).to have_three_tokens
      end

      it 'returns the token' do
        column_num = 1
        token = 'O'
        expect(game_board.insert_token(column_num, token)).to eq(token)
      end
    end

    context 'tries to insert token into filled column' do
      before do
        allow(game_board).to receive(:puts)
      end
      it 'returns an error message' do
        column_num = 2
        error_message = 'The selected column is full. Please choose another column'
        expect(game_board).to receive(:puts).with(error_message)
        game_board.insert_token(column_num, 'X')
      end

      it 'does not change the column' do
        column_num = 2
        before = game_board.instance_variable_get(:@board)[column_num - 1]
        game_board.insert_token(column_num, 'O')
        after = game_board.instance_variable_get(:@board)[column_num - 1]
        expect(before).to eq(after)
      end

      it 'returns nil' do
        column_num = 2
        expect(game_board.insert_token(column_num, 'X')).to be_nil
      end
    end
  end

  describe '#connect_four?' do
    context 'when the connect4 is at the bottom of the column' do
      before do
        game_board.instance_variable_set(:@board, [
          ['O', 'O', 'O', 'O', '', ''],
          ['', '', '', '', '', ''], 
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('O')).to eq(true)
      end
    end

    context 'when the connect4 is at the middle of the column' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['', '', '', '', '', ''],
          ['', 'O', 'O', 'O', 'O', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('O')).to eq(true)
      end
    end

    context 'when the connect4 is at the top of the column' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', 'X', 'X', 'X', 'X'],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('X')).to eq(true)
      end
    end

    context 'when the connect4 is at the corner of a row' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['', '', '', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', 'X'],
          ['', '', '', '', '', 'X'],
          ['', '', '', '', '', 'X'],
          ['', '', '', '', '', 'X']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('X')).to eq(true)
      end
    end

    context 'when the connect4 is at the middle of a row' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''],
          ['', '', 'O', '', '', ''],
          ['', '', 'O', '', '', ''],
          ['', '', 'O', '', '', ''],
          ['', '', 'O', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('O')).to eq(true)
      end
    end

    context 'when the connect4 is in an upward diagonal' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['', 'O', '', '', '', ''],
          ['', '', 'O', '', '', ''],
          ['', '', '', 'O', '', ''],
          ['', '', '', '', 'O', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('O')).to eq(true)
      end
    end

    context 'when the connect4 is in a downward diagonal' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['', '', '', '', '', 'X'],
          ['', '', '', '', 'X', ''],
          ['', '', '', 'X', '', ''],
          ['', '', 'X', '', '', ''],
          ['', '', '', '', '', ''],
          ['', '', '', '', '', '']
        ])
      end

      it 'returns true' do
        expect(game_board.connect_four?('X')).to eq(true)
      end
    end

    context 'when the board is empty' do
      it 'returns false' do
        expect(game_board.connect_four?('X')).to eq(false)
      end
    end

    context 'the board is not empty but no connect four has been made' do
      before do
        game_board.instance_variable_set(:@board, [
          ['', '', '', '', '', ''], 
          ['O', 'X', '', '', '', ''],
          ['X', 'O', '', '', '', ''],
          ['O', 'X', 'O', '', '', ''],
          ['O', 'X', '', '', '', ''],
          ['O', '', '', '', '', ''],
          ['X', '', '', '', '', '']
        ])
      end

      it 'returns false' do
        expect(game_board.connect_four?('O')).to eq(false)
      end
    end
  end

  describe '#display_board' do
    # Script method that only calls puts - no tests needed
  end
end
