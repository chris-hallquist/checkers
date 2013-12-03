require_relative "board"
require_relative "piece"

class Game
  def initialize(red_player, black_player)
    @red_player = red_player
    @black_player = black_player
    @board = Board.new
    @board.setup
  end
  
  def play
    turn = :red
    
    while true
      @board.simp_display
      
      if turn == :red 
        current_player = @red_player
      else
        current_player = @black_player
      end
      
      begin
        start, move_sequence = current_player.get_move_sequence
        raise InvalidMoveError if @board.grid[start[0]][start[1]] == nil
        raise InvalidMoveError if @board.grid[start[0]][start[1]].color != turn
        @board.grid[start[0]][start[1]].perform_moves(move_sequence)
      rescue InvalidMoveError
        retry
      end
      
      turn == :red ? turn = :black : turn = :red
      
      unless has_valid_moves?(turn)
        puts "#{(turn == :red ? turn = :black : turn = :red).capitalize} wins!"
        break
      end
    end
  end
  
  def has_valid_moves?(color)
    @board.grid.each do |row, row_i|
      row.each do |square, col_i|
        next if square == nil
        next unless square.color == color
        return true if square.has_valid_moves?
      end
    end
    false
  end
  
end

class HumanPlayer
  def get_move_sequence
    puts "Enter location of piece to move"
    start = parse_input(gets)
    puts "Enter location to move to"
    move_sequence = [parse_input(gets)]
    while true
      puts "Enter next location to move to, or enter \"x\" to end"
      input = gets.chomp
      break if input.downcase == "x"
      move_sequence << parse_input(input)
    end
    [start, move_sequence]
  end
  
  def parse_input(input)
    input.gsub(/\s/, '').split(',').map(&:to_i)
  end
end

class InvalidMoveError < StandardError
end