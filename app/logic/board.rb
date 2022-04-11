require './cell.rb'
require './mine.rb'

class Board
    attr_reader :rows, :columns, :mines_quantity, :mines, :cells

    def initialize(rows, columns, mines_quantity)
        @rows = rows
        @columns = columns
        @mines_quantity = mines_quantity
        @mines = []
        @cells = []

        spawn_mines
        spawn_cells
        unfold_board
    end
    
    def unfold_board(game_over = false)
        x = 0
        while x < @rows
            y = 0
            while y < @columns
                cell = get_cell(x, y)
                show_cell(cell, "", game_over)
                y +=1
            end
                puts ""
                puts ""
                x += 1
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
                    cell = Cell.new(x, y, get_mine(x, y) != nil)
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
                adyacent_cell = Cell.new(acx, acy, get_mine(acx, acy) != nil)
                @cells.push(adyacent_cell)
            end
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

  rows = 4
  columns = 4
  mines_quantity = 2
  safe_area = (rows * columns) - mines_quantity
  game_over = false

 board = Board.new(rows, columns, mines_quantity)

 while !game_over
    puts ""
    puts "Ayuda ?? Minas en:"
    board.mines.each { |m| puts m.to_s }
    
    puts ""
    puts "Coordenada X: "
    x = gets.chomp.to_i
    puts "Coordenada Y: "
    y = gets.chomp.to_i

    cell = board.get_cell(x, y)
    
    puts "Destapar/Banderear?(d/b)"
    action = gets.chomp

    if action == "d"
        is_mined = board.expose_cell(cell)
        board.show_cell(cell, "Destapaste: =>")
        puts ""
        if is_mined
            game_over = true
        end
        if safe_area == board.cells.find_all { |c| c.is_exposed }.count
            puts "Felicidades!! haz completado el juego :D"
            game_over = true
        end
    elsif action == "b"
        board.flag_cell(cell)
        board.show_cell(cell, "Bandereaste: =>")
        puts ""
    else
        puts "Comado no reconocido, ingrese d: para descubrir o b: para banderear"
    end
    
    puts ""
    board.unfold_board(game_over);
 end

 puts "El juego ha terminado"