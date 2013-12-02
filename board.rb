require_relative "piece"
# require "colorize"

class Board
  attr_accessor :grid
  
  def initialize 
    @grid = Array.new(8) { Array.new(8) }
  end
  
  # def color_square(square, red_square)
  #   if red_square
  #     square = square.red.on_red
  #   else
  #     square = square.red.on_black
  #   end
  # end
  # 
  # def display
  #   display = ""
  #   red_square = true
  #   @grid.each_with_index do |row, index|
  #     display << "#{index} "
  #     row.each do |square|
  #       if square == nil
  #         display << "  "
  #       else
  #         display << "#{square.to_s} "
  #       end
  #       display[-2..-1] = color_square(display[-2..-1], red_square)
  #       red_square = !red_square
  #     end
  #     display << "\n"
  #     red_square = !red_square
  #   end
  #   puts display
  #   puts "  0 1 2 3 4 5 6 7 "
  # end
  
  def setup
    @grid.each_with_index do |row, row_i|
      row.each_with_index do |square, col_i|
        black_square = (row_i + col_i) % 2 != 0
        
        if black_square && row_i < 3
          @grid[row_i][col_i] = Piece.new(self, :black, [row_i, col_i]) 
        elsif black_square && row_i > 4
          @grid[row_i][col_i] = Piece.new(self, :red, [row_i, col_i])
        end
      end
    end 
  end
  
  def simple_display
    @grid.each do |row|
      p row.map { |square| square == nil ? "_" : square.color.to_s[0] }
    end
    nil
  end
end
