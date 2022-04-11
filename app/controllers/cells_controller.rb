class CellsController < ApplicationController
    before_action :set_cell, only: %i[ show update]

    def index
        @cells = Cell.all
        render json: @cells
    end

    def show
        render json: @cell
    end

    def create
        @cell = Cell.new(cell_params)
        if @cell.save
          render json: @cell, status: :created, location: @cell
        else
          render json: @cell.errors, status: :unprocessable_entity
        end
    end

    def update
        if @cell.update(cell_params)
          render json: @cell
        else
          render json: @cell.errors, status: :unprocessable_entity
        end
    end

    private
    def set_cell
      @cell = Cell.find(params[:id])
    end

    private
    def cell_params
      params.require(:cell).permit(:game_id, :x_axis, :y_axis, :is_mined, :is_exposed, :is_flagged)
    end
end
