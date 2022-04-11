require_relative './location'

class Mine < Location
    attr_reader :x_axis, :y_axis

    def initialize(x_axis, y_axis)
        @x_axis = x_axis
        @y_axis = y_axis
    end
end