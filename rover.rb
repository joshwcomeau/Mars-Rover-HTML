require 'sinatra'

class Rover
  DIRECTIONS = ["N","E","S","W"]
  MOVEMENT = {
    N: [0, 75],
    E: [75, 0],
    S: [0, -75],
    W: [-75, 0]
  }
  
  @@counter = 0

  attr_reader :id, :x, :y, :d

  def initialize(x, y, d)
    @x, @y, @d = x, y, d
    @d_angle = convert_direction_to_angles(d)
  end

  def turn(direction) 
    old_index = DIRECTIONS.index(@d)

    if direction == "R"
      @d = DIRECTIONS.rotate(1)[old_index] 
      @d_angle += 90
    elsif direction == "L"
      @d = DIRECTIONS.rotate(-1)[old_index]
      @d_angle -= 90
    end
  end

  def move
    move_x, move_y = MOVEMENT[@d.to_sym][0], MOVEMENT[@d.to_sym][1]
    @x += move_x
    @y -= move_y
  end

  def output
    [@d_angle, @x, @y]
  end

end


def convert_direction_to_angles(heading)
  case heading
  when "N"
    return 0
  when "E"
    return 90
  when "S"
    return 180
  when "W"
    return -90
  end
end

def convert_grid_to_css(gridno)
  ( gridno.to_i - 1 ) * 75
end

get "/" do

  if params.empty?
    @instructions = false
    @move_instructions = [""] # Because we iterate over this when instructions are sent, we're assigning this variable to an empty array to avoid error.
  else 
    @instructions = true

    @start_string = "#{params[:x_pos]}, #{params[:y_pos]}. Facing #{params[:heading]}."

    @start_x = convert_grid_to_css( params[:x_pos] )
    @start_y = convert_grid_to_css( params[:y_pos] )
    @heading = params[:heading]
    @start_angle = convert_direction_to_angles( params[:heading] )

    
    rover = Rover.new(@start_x, @start_y, @heading)

    @start = [@start_angle, @start_x, @start_y]
    @route = []
    @route << @start


    @move_instructions = [ 
      params[:cs_1].upcase, 
      params[:cs_2].upcase,
      params[:cs_3].upcase,
      params[:cs_4].upcase,
      params[:cs_5].upcase,
      params[:cs_6].upcase,
      params[:cs_7].upcase,
      params[:cs_8].upcase,
      params[:cs_9].upcase 
    ]

    @move_instructions.each do | v |
      if v == 'M'
        rover.move
        @route << rover.output
      elsif v == 'L' || v == 'R'
        rover.turn(v)
        @route << rover.output
      end
    end

    p @route


  end
  
  @length = 9
  @height = 5
  erb :index
end