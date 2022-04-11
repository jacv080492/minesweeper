require_relative '../logic/board_cell'

class GamesController < ApplicationController
    before_action :set_game, only: %i[ show update ]

    def index
        @games = Game.all
        render json: @games
    end

    def show
        render json: @game
    end

    def create
        @game = Game.new(game_params)
        if @game.save
            spawn_board_cells
          render json: @game, status: :created, location: @game
        else
          render json: @game.errors, status: :unprocessable_entity
        end
    end

    def update
        if @game.update(game_params)
          render json: @game
        else
          render json: @game.errors, status: :unprocessable_entity
        end
    end

    private
    def game_params
        params.require(:game).permit(:player_name, :mines, :rows, :columns, :is_winner, :is_game_over)
    end

    private
    def set_game
        @game = Game.find(params[:id])
    end

    private
    def spawn_board_cells
        board = Board.new(@game.rows, @game.columns, @game.mines, nil)
        board.cells.each do |cell|
            puts "llegué hasta cells each"
          new_cell = Cell.new(x_axis: cell.x_axis, y_axis: cell.y_axis, is_mined: cell.is_mined, is_exposed: cell.is_exposed, is_flagged: cell.is_flagged, game: @game)
          if new_cell.save
            puts "Cell Saved => #{new_cell.x_axis}, #{new_cell.y_axis}, #{new_cell.is_mined}, #{new_cell.is_exposed}"
          else
            puts "Cell NOT Saved => #{new_cell.x_axis}, #{new_cell.y_axis}, #{new_cell.is_mined}, #{new_cell.is_exposed} : #{new_cell.errors}"
          end
        end
      end
end
