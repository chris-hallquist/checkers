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
      if turn == :red 
        current_player = @red_player
      else
        current_player = black_player
      end
      begin
        move_sequence = current_player.get_move_sequence
      end
      turn == :red ? turn = :black : turn = :red
    end
  end
  
  
end

class HumanPlayer
  
end