class Location
    attr_reader :x_axis, :y_axis

    def initialize(x_axis, y_axis)
      @x_axis = x_axis
      @y_axis = y_axis
    end
  
    def to_s
      "(#{x_axis}, #{y_axis})"
    end
end