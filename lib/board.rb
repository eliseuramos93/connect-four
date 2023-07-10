# frozen_string_literal: false

require_relative './printable.rb'

class Board
  include Printable

  def initialize
    @board = Array.new(7) { Array.new(6) { "\u3010\s\u3011" } }
  end

  def column_full?(column_num)
    @board[column_num - 1].none? { |elem| elem.include?("\s") }
  end

  def board_full?
    @board.each_index.all? { |i| column_full?(i+1) }
  end

  def insert_token(column_num, token)
    return puts message(:column_full) if column_full?(column_num)

    index = @board[column_num - 1].index { |elem| elem.include?(' ')}
    @board[column_num - 1][index] = "\u3010#{token}\u3011"
    token
  end

  def connect_four?(token)
    vertical_connect4?(token) ||
      horizontal_connect4?(token) ||
      diagonal_connect4?(token)
  end

  def display_board
    display_column_numbers
    display_row(6)
    display_row(5)
    display_row(4)
    display_row(3)
    display_row(2)
    display_row(1)
  end

  private

  attr_accessor :board

  def vertical_connect4?(token)
    @board.any? do |column|
      column.slice(0, 4).all? { |elem| elem.include?(token) } ||
        column.slice(1, 4).all? { |elem| elem.include?(token) } ||
        column.slice(2, 4).all? { |elem| elem.include?(token) }
    end
  end

  def horizontal_connect4?(token)
    get_horizontals.any? { |line| line.all? { |elem| elem.include?(token) } }
  end

  def diagonal_connect4?(token)
    get_diagonals.any? { |diag| diag.all? { |elem| elem.include?(token) } }
  end

  def get_horizontals(lines = [], x_values = (0..3).to_a, y_values = (0..5).to_a)
    x_values.each do |x|
      y_values.each do |y|
        lines << [@board[x][y], @board[x+1][y], @board[x+2][y], @board[x+3][y]]
      end
    end
    lines
  end

  def get_diagonals(lines = [])
    return lines.concat(get_upward_diagonals, get_downward_diagonals)
  end

  def get_upward_diagonals(lines = [], x_values = (0..3).to_a, y_values = (0..2).to_a)
    x_values.each do |x|
      y_values.each do |y|
        lines << [@board[x][y], @board[x+1][y+1], @board[x+2][y+2], @board[x+3][y+3]]
      end 
    end 
    lines
  end

  def get_downward_diagonals(lines = [], x_values = (0..3).to_a, y_values = (3..5).to_a)
    x_values.each do |x|
      y_values.each do |y|
        lines << [@board[x][y], @board[x+1][y-1], @board[x+2][y-2], @board[x+3][y-3]]
      end 
    end 
    lines
  end

  def display_row(row)
    row = row - 1
    row_string = "#{@board[0][row]}" + "#{@board[1][row]}" + "#{@board[2][row]}" +
      "#{@board[3][row]}" + "#{@board[4][row]}" + "#{@board[5][row]}" + "#{@board[6][row]}"
    puts row_string
  end

  def display_column_numbers
    puts "\u30101\u3011\u30102\u3011\u30103\u3011\u30104\u3011\u30105\u3011\u30106\u3011\u30107\u3011", ""
  end
end
