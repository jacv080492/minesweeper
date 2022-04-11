require_relative './board_cell'
require_relative './mine'

class Board
    attr_reader :rows, :columns, :mines_quantity, :mines, :cells

    def initialize(rows, columns, mines_quantity, model_cells)
        if model_cells == nil
            @rows = rows
            @columns = columns
            @mines_quantity = mines_quantity
            @mines = []
            @cells = []

            spawn_mines
            spawn_cells
        else
            @cells = []            
            model_cells.each do |mc|
                cell = BoardCell.new(mc.x_axis, mc.y_axis, mc.is_mined)
                cell.is_exposed = mc.is_exposed
                cell.is_flagged = mc.is_flagged
                @cells.push(cell)
            end
            @rows = model_cells.max { |c| c.x_axis }.x_axis + 1
            @columns = model_cells.max { |c| c.y_axis }.y_axis + 1
            @mines = []
            @cells.each do |c|
                if c.is_mined
                    @mines.push(Mine.new(c.x_axis, c.y_axis))
                end
            end
            @mines_quantity = @mines.count
            @cells.each do |c|
                adyacent_locations.each { |al| assing_adyacent_cell(c, al[0], al[1]) }
            end
        end
    end
    
    def show_cell(cell, additional_message = "", game_over = false)
        mine_icon = "*"
        flag_icon = "!"
        unknown_icon = "?"

        if cell.is_exposed || game_over
            print "#{ additional_message } (#{ cell.x_axis },#{ cell.y_axis }): #{ (cell.is_mined ? mine_icon : cell.adyacent_cells.find_all { |ac| ac.is_mined }.count) } |"
        else
            print "#{ additional_message } (#{ cell.x_axis },#{ cell.y_axis }): #{ (cell.is_flagged ? flag_icon : unknown_icon) } |"
        end
    end

    def get_mine(x, y)
        @mines.find { |m| m.x_axis == x && m.y_axis == y }
    end

    def get_cell(x, y)
        @cells.find { |c| c.x_axis == x && c.y_axis == y }
    end

    def flag_cell(cell)
        cell.is_flagged = cell.is_flagged ? false : true
    end

    def expose_cell(cell)
        cell.is_exposed = false
        if !cell.is_mined
            expose_cells_recursive(cell)
            return false
        else
            cell.is_exposed = true
            return true
        end
    end

    private
    def expose_cells_recursive(cell)
        if !cell.is_exposed
            cell.is_exposed = true
            if cell.adyacent_cells.find_all { |ac| ac.is_mined }.count == 0
                cell.adyacent_cells.each { |ac| expose_cells_recursive(ac) }
            end
        end
    end

    private
    def spawn_mines
        while @mines.length < @mines_quantity
            x = rand(1...@rows)
            y = rand(1...@columns)
            if get_mine(x, y) == nil
                @mines.push(Mine.new(x, y))
            end
        end
    end

    private
    def spawn_cells
        x = 0
        while x < @rows
            y = 0
            while y < @columns
                cell = get_cell(x, y)
                if cell == nil
                    cell = BoardCell.new(x, y, get_mine(x, y) != nil)
                    @cells.push(cell)
                end
                adyacent_locations.each { |al| spawn_adyacent_cell(cell, al[0], al[1]) }
                y += 1
            end
            puts ""
            x += 1
        end
    end

    private
    def spawn_adyacent_cell(cell, alx, aly)
        acx = cell.x_axis + alx
        acy = cell.y_axis + aly
        if correct_location?(acx, acy)
            adyacent_cell = get_cell(acx, acy)

            if adyacent_cell == nil
                adyacent_cell = BoardCell.new(acx, acy, get_mine(acx, acy) != nil)
                @cells.push(adyacent_cell)
            end
            if cell.adyacent_cells.find_all { |ac| ac.x_axis == acx && ac.y_axis == acy }.count == 0
                cell.add_adyacent(adyacent_cell)
            end
        end
    end

    private
    def assing_adyacent_cell(cell, alx, aly)
        acx = cell.x_axis + alx
        acy = cell.y_axis + aly
        if correct_location?(acx, acy)
            adyacent_cell = get_cell(acx, acy)
            if cell.adyacent_cells.find_all { |ac| ac.x_axis == acx && ac.y_axis == acy }.count == 0
                cell.add_adyacent(adyacent_cell)
            end
        end
    end
    
    private
    def adyacent_locations
        cvs = [ [-1, -1], [-1, 0], [0, -1], [+1, -1], [+1, 0], [+1, +1], [0, +1], [-1, +1] ]
    end

    private
    def correct_location?(x, y)
        if x >= 0 && x < @rows
            if y >= 0 && y < @columns
                return true
            end
        end
        return false
    end
  end