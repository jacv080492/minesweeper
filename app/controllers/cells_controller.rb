class CellsController < ApplicationController
    before_action :set_cell, only: %i[ show update]

    def index
        @cells = Cell.all
        render json: @cells
    end

    def show
        render json: @cell
    end

    def update
        cell_is_not_exposed = !@cell.is_exposed
        if @cell.update(cell_params)
            puts cell_params[:is_exposed] 
            puts !@cell.is_exposed
            if cell_params[:is_exposed] && cell_is_not_exposed
                puts "An expose-action was identified"
                expose_board_cell
            end
            if cell_params[:is_flagged] && !@cell.is_flagged
                puts "An flag action was identify"
            end
            redirect_to controller: 'cells', action: 'index'
            # render json: @cell
        else      
            render json: @cell.errors, status: :unprocessable_entity
        end
    end

    private
    def cell_params
      params.require(:cell).permit(:game_id, :x_axis, :y_axis, :is_mined, :is_exposed, :is_flagged)
    end
    
    private
    def set_cell
      @cell = Cell.find(params[:id])
    end

    private
    def expose_board_cell
        puts "Cell Data => x: #{ @cell.x_axis }, y: #{ @cell.y_axis }, is_mined: #{ @cell.is_mined }, is_exposed: #{ @cell.is_exposed }, is_flagged: #{ @cell.is_flagged }"
        puts "Game cells: #{ Cell.all.count }"
        
        board = Board.new(0, 0, 0, Cell.all)
        is_mined = board.expose_cell(board.get_cell(@cell.x_axis, @cell.y_axis))
        if is_mined
          puts "Ups! Mined Cell - Game Over"
          Cell.Game.update(is_winner = false) # game_over = true ?
        else
          board.cells.each do |bc|
            cell = Cell.find_by(x_axis: bc.x_axis, y_axis: bc.y_axis)
            cell.update(is_exposed: bc.is_exposed)
          end        
          if board.is_winner
            puts "Felicidades!! haz completado el juego :D"
            Cell.last.game.update(is_winner: true) # game_over = true ?
          end
        end
    end
end
