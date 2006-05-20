
require File.dirname(__FILE__) + '/base'

class Gruff::StackedBar < Gruff::Base

    # Draws a bar graph, but multiple sets are stacked on top of each other.
    def draw
      get_maximum_by_stack
      super
      return unless @has_data

      # Setup spacing.
      #
      # Columns sit stacked.
      spacing_factor = 0.9
      @bar_width = @graph_width / @column_count.to_f
    
      @d = @d.stroke_opacity 0.0
      
      height = Array.new(@column_count, 0)
    
      @norm_data.each_with_index do |data_row, row_index|
        @d = @d.fill data_row[DATA_COLOR_INDEX]
      
        data_row[1].each_with_index do |data_point, point_index|
          # Use incremented x and scaled y
          left_x = @graph_left + (@bar_width * point_index)
          left_y = @graph_top + (@graph_height -
                                 data_point * @graph_height - 
                                 height[point_index]) + 1
          right_x = left_x + @bar_width * spacing_factor
          right_y = @graph_top + @graph_height - height[point_index] - 1
          
          # update the total height of the current stacked bar
          height[point_index] += (data_point * @graph_height - 2)
          
          @d = @d.rectangle(left_x, left_y, right_x, right_y)
          
          # Calculate center based on bar_width and current row
          label_center = @graph_left + (@bar_width * point_index) + (@bar_width * spacing_factor / 2.0)
          draw_label(label_center, point_index)
        end

      end
    
      @d.draw(@base_image)    
    end

end
