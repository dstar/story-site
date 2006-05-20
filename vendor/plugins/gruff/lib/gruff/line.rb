
require File.dirname(__FILE__) + '/base'

class Gruff::Line < Gruff::Base

  # Draw a dashed line at the given value
  attr_accessor :baseline_value
	
  # Color of the baseline
  attr_accessor :baseline_color
  
  # Hide parts of the graph to fit more datapoints, or for a different appearance.
  attr_accessor :hide_dots, :hide_lines

  # Call with target pixel width of graph (800, 400, 300), and/or 'false' to omit lines (points only).
  #
  #  g = Gruff::Line.new(400) # 400px wide with lines
  #
  #  g = Gruff::Line.new(400, false) # 400px wide, no lines (for backwards compatibility)
  #
  #  g = Gruff::Line.new(false) # Defaults to 800px wide, no lines (for backwards compatibility)
  # 
  # The preferred way is to call hide_dots or hide_lines instead.
  def initialize(*args)
    raise ArgumentError, "Wrong number of arguments" if args.length > 2
    if args.empty? or ((not Numeric === args.first) && (not String === args.first)) then
      super()
    else
      super args.shift
    end
    
    @hide_dots = @hide_lines = false
    @baseline_color = 'red'
  end

  def draw
    super

    return unless @has_data
      
    @x_increment = @graph_width / (@column_count - 1).to_f
    circle_radius = clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 2.5), 5.0)

    @d = @d.stroke_opacity 1.0
    @d = @d.stroke_width clip_value_if_greater_than(@columns / (@norm_data.first[1].size * 4), 5.0)
 
    if (defined?(@norm_baseline)) then
      level = @graph_top + (@graph_height - @norm_baseline * @graph_height)
      @d = @d.push
      @d.stroke_color @baseline_color
      @d.fill_opacity 0.0
      @d.stroke_dasharray(10, 20)
      @d.stroke_width 5
      @d.line(@graph_left, level, @graph_left + @graph_width, level)
      @d = @d.pop
    end

    @norm_data.each do |data_row|
      prev_x = prev_y = nil
      @d = @d.stroke data_row[DATA_COLOR_INDEX]
      @d = @d.fill data_row[DATA_COLOR_INDEX]

      data_row[1].each_with_index do |data_point, index|
        new_x = @graph_left + (@x_increment * index)
        next if data_point.nil?

        draw_label(new_x, index)

        new_y = @graph_top + (@graph_height - data_point * @graph_height)

        if !@hide_lines and !prev_x.nil? and !prev_y.nil? then
          @d = @d.line(prev_x, prev_y, new_x, new_y)
        end
        @d = @d.circle(new_x, new_y, new_x - circle_radius, new_y) unless @hide_dots

        prev_x = new_x
        prev_y = new_y
      end

    end

    @d.draw(@base_image)
  end

  def normalize
    @maximum_value = max(@maximum_value.to_f, @baseline_value.to_f)
    super
    @norm_baseline = (@baseline_value.to_f / @maximum_value.to_f) if @baseline_value
  end
  
  def max(a, b)
    (a < b ? b : a)
  end

end
