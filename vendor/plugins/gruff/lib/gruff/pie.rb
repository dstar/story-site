
require File.dirname(__FILE__) + '/base'

class Gruff::Pie < Gruff::Base

  def draw
    @hide_line_markers = true
    
    super

    return unless @has_data

    diameter = @graph_height
    radius = [@graph_width, @graph_height].min / 2.0 
    top_x = @graph_left + (@graph_width - diameter) / 2.0
    center_x = @graph_left + (@graph_width / 2.0)
    center_y = @graph_top + (@graph_height / 2.0) - 10 # Move graph up a bit
    total_sum = sums_for_pie()
    prev_degrees = 0.0

    # Use full data since we can easily calculate percentages
    @data.each do |data_row|
      if data_row[1][0] > 0
        @d = @d.stroke data_row[DATA_COLOR_INDEX]
        @d = @d.fill 'transparent'
        @d.stroke_width(radius) # stroke width should be equal to radius. we'll draw centered on (radius / 2)

        current_degrees = (data_row[1][0] / total_sum) * 360.0 

        # ellipse will draw the the stroke centered on the first two parameters offset by the second two.
        # therefore, in order to draw a circle of the proper diameter we must center the stroke at
        # half the radius for both x and y
        @d = @d.ellipse(center_x, center_y, 
                  radius / 2.0, radius / 2.0,
                  prev_degrees, prev_degrees + current_degrees + 0.5) # <= +0.5 'fudge factor' gets rid of the ugly gaps
                  
        half_angle = prev_degrees + ((prev_degrees + current_degrees) - prev_degrees) / 2
      

        @d = draw_label(center_x,center_y, 
                    half_angle, 
                    radius, 
                    ((data_row[1][0] / total_sum) * 100).round.to_s + '%     ')
      
        prev_degrees += current_degrees
      end
    end

    @d.draw(@base_image)
  end

private

  def draw_label(center_x, center_y, angle, radius, amount)
    r_offset = 30      # The distance out from the center of the pie to get point
    x_offset = center_x + 15 # The label points need to be tweaked slightly
    y_offset = center_y + 0  # This one doesn't though
    x = x_offset + ((radius + r_offset) * Math.cos(angle.deg2rad))
    y = y_offset + ((radius + r_offset) * Math.sin(angle.deg2rad))
    
    # Draw label
    @d.fill = @marker_color
    @d.font = @font if @font
    @d.pointsize = scale_fontsize(20)
    @d.stroke = 'transparent'
    @d.font_weight = BoldWeight
    @d.gravity = CenterGravity
    @d.annotate_scaled( @base_image, 
                      0, 0,
                      x, y, 
                      amount, @scale)
  end

  def sums_for_pie
    total_sum = 0.0
    @data.collect {|data_row| total_sum += data_row[1][0] }
    total_sum
  end

end


class Float
  # Used for degree => radian conversions
  def deg2rad
    self * (Math::PI/180.0)
  end
end
