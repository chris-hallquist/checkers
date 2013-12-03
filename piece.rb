require_relative "board"

class Piece
  attr_reader :board, :color
  attr_accessor :king, :position
  
  def initialize(board, color, position)
    @board = board
    @color = color
    @king = false
    @position = position
  end
  
  def dup(board)
    new_piece = Piece.new(board, @color, @position)
    new_piece.king = true if @king
    new_piece
  end
  
  def has_valid_moves?
    diffs = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1],
      [-2, -2],
      [-2, 2],
      [2, -2],
      [2, 2]
      ]
    diffs.each do |diff|
      possible_move = [@position[0] + diff[0], @position[1], diff[1]]
      return true if valid_move_seq?([possible_move])
    end
    false
  end
  def in_between(target)
    @board.grid[(@position[0] + target[0]) / 2][(@position[1] + target[1]) / 2]
  end
  
  def move_diffs
    return [[-1, -1], [-1, 1], [1, -1], [1, 1]] if @king
    return [[-1, -1], [-1, 1]] if @color == :red
    return [[1, -1], [1, 1]] if @color == :black
  end
  
  def on_board_and_empty?(target)
    return false if target.min < 0 || target.max > 7
    return false unless @board.grid[target[0]][target[1]] == nil
    true
  end
  
  def perform_jump(target)
    return false unless on_board_and_empty?(target)
        
    reachable = move_diffs.map do |diff|
      [diff[0] * 2 + @position[0], diff[1] * 2 + @position[1]]
    end
    
    return false unless reachable.include?(target)
    return false unless in_between(target)
    
    in_between(target).remove
    perform_move(target)
    true
  end
  
  def perform_move(target)
    @board.grid[@position[0]][@position[1]] = nil
    @board.grid[target[0]][target[1]] = self
    @position = target
    promote_me_maybe
  end
  
  def perform_moves(move_sequence)
    raise InvalidMoveError unless valid_move_seq?(move_sequence)
    perform_moves!(move_sequence)
  end
  
  def perform_moves!(move_sequence)
    unless move_sequence.length == 1 && perform_slide(move_sequence[0])
      move_sequence.each do |move| 
        raise InvalidMoveError unless perform_jump(move) 
      end
    end
  end
  
  def perform_slide(target)    
    return false unless on_board_and_empty?(target)
        
    reachable = move_diffs.map do |diff|
      [diff[0] + @position[0], diff[1] + @position[1]]
    end
    
    return false unless reachable.include?(target)
    perform_move(target)
    return true
  end
  
  def promote_me_maybe
    @king = true if (@color == :black && @position[0] == 7)
    @king = true if (@color == :red && @position[0] == 0)
  end
  
  # def to_s
  #   if color == :black
  #   @king ? return "♔" : return "♙"
  #   else
  #     @king ? return "♚" : return "♟"
  #   end
  # end
  
  def remove
    @board.grid[@position[0]][@position[1]] = nil
  end
  
  def simp_render
    render = @color.to_s[0]
    render.upcase! if @king
    render
  end
  
  def valid_move_seq?(move_sequence)
    test_board = @board.dup
    begin
      test_board.grid[@position[0]][@position[1]].perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    else
      return true
    end
  end
end

class InvalidMoveError < StandardError
end