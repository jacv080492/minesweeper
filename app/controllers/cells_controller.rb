class CellsController < ApplicationController
    def index
        @cells = Cell.all
        render json: @cells
    end
end
