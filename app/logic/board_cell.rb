require_relative './location'

class BoardCell < Location
    attr_reader :x_axis, :y_axis, :is_mined, :adyacent_cells
    attr_accessor :is_exposed, :is_flagged

    def initialize(x_axis, y_axis, is_mined)
        @x_axis = x_axis
        @y_axis = y_axis
        @is_mined = is_mined
        @is_exposed = false
        @is_flagged = false
        @adyacent_cells = []
    end

  public
  def add_adyacent(adyacent_cell)
    @adyacent_cells.push(adyacent_cell)
  end
end