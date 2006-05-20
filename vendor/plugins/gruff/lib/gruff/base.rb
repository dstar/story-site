#
# = Gruff. Graphs.
#
# Author:: Geoffrey Grosenbach boss@topfunky.com
#
# Originally Created:: October 23, 2005
#
# Extra thanks to Tim Hunter for writing RMagick, 
# and also contributions by
# Jarkko Laine, Mike Perham, Andreas Schwarz, 
# Alun Eyre, Guillaume Theoret, David Stokar, 
# Paul Rogers, Dave Woodward, Frank Oxener,
# Kevin Clark, Cies Breijs, Richard Cowin,
# and a cast of thousands.
#

require 'RMagick'

module Gruff
  
  VERSION = '0.1.2'
  
  class Base
  
    include Magick

    DATA_LABEL_INDEX = 0
    DATA_VALUES_INDEX = 1
    DATA_COLOR_INDEX = 2

    # A hash of names for the individual columns, where the key is the array index for the column this label represents.
    #
    # Not all columns need to be named.
    #
    # Example: 0 => 2005, 3 => 2006, 5 => 2007, 7 => 2008
    attr_accessor :labels

    # Get or set the list of colors that will be used to draw the bars or lines.
    attr_accessor :colors

    # The large title of the graph displayed at the top
    attr_accessor :title

    # Font used for titles, labels, etc. Works best if you provide the full path to the TTF font file.
    # RMagick must be built with the Freetype libraries for this to work properly.
    #
    # Tries to find Bitstream Vera (Vera.ttf) in the location specified by
    # ENV['MAGICK_FONT_PATH']. Uses default RMagick font otherwise.
    attr_accessor :font

    # Hide various elements
    attr_accessor :hide_line_markers, :hide_legend, :hide_title

    # Message shown when there is no data. Fits up to 20 characters. Defaults to "No Data."
    attr_accessor :no_data_message

    # Optionally set the size of the font. Based on an 800x600px graph. Default is 20.
    #
    # Will be scaled down if graph is smaller than 800px wide.
    attr_accessor :legend_font_size

    # The font size of the labels around the graph
    attr_accessor :marker_font_size
    
    # The color of the auxiliary labels and lines
    attr_accessor :marker_color
    
    # The font size of the large title at the top of the graph
    attr_accessor :title_font_size

    # You can manually set a minimum value instead of having the values guessed for you.
    #
    # Set it after you have given all your data to the graph object.
    attr_accessor :minimum_value

    # You can manually set a maximum value, such as a percentage-based graph that always goes to 100.
    #
    # If you use this, you must set it after you have given all your data to the graph object.
    attr_accessor :maximum_value
        
    # Experimental
    attr_accessor :additional_line_values
    
    # Experimental
    attr_accessor :stacked
    

    # If one numerical argument is given, the graph is drawn at 4/3 ratio according to the given width (800 results in 800x600, 400 gives 400x300, etc.).
    #
    # Or, send a geometry string for other ratios ('800x400', '400x225'). 
    #
    # Looks for Bitstream Vera as the default font. Expects an environment var of MAGICK_FONT_PATH to be set. (Uses RMagick's default font otherwise.)
    def initialize(target_width=800)

      if not Numeric === target_width
        geometric_width, geometric_height = target_width.split('x')
        @columns = geometric_width.to_f
        @rows = geometric_height.to_f
      else
        @columns = target_width.to_f
        @rows = target_width.to_f * 0.75        
      end

      # Internal for calculations
      @raw_columns = 800.0
      @raw_rows = 800.0 * (@rows/@columns)
      @column_count = 0
      @maximum_value = @minimum_value = nil
      @has_data = false
      @data = Array.new
      @labels = Hash.new
      @labels_seen = Hash.new
      @scale = @columns / @raw_columns

      vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
      @font = File.exists?(vera_font_path) ? vera_font_path : nil

      @marker_font_size = 21.0
      @legend_font_size = 20.0
      @title_font_size = 36.0

      @no_data_message = "No Data"

      @hide_line_markers = @hide_legend = @hide_title = false

      @additional_line_values = []      
      @additional_line_colors = []

      reset_themes()
      theme_keynote()
    end
    
    # Add a color to the list of available colors for lines.
    #
    # Example: 
    #  add_color('#c0e9d3')
    def add_color(colorname)
      @colors << colorname
    end

    # Replace the entire color list with a new array of colors. You need to have one more color
    # than the number of datasets you intend to draw. Also aliased as the colors= setter method.
    #
    # Example: 
    #  replace_colors('#cc99cc', '#d9e043', '#34d8a2')
    def replace_colors(color_list=[])
      @colors = color_list
    end

    # You can set a theme manually. Assign a hash to this method before you send your data.
    #
    #  graph.theme = {
    #    :colors => %w(orange purple green white red),
    #    :marker_color => 'blue',
    #    :background_colors => %w(black grey)
    #  }
    #
    # :background_image => 'squirrel.png' is also possible.
    #
    # (Or hopefully something better looking than that.)
    #
    def theme=(options)
      defaults = {
        :colors => ['black', 'white'],
        :additional_line_colors => ['grey'],
        :marker_color => 'white',
        :background_colors => nil,
        :background_image => nil
      }
      options = defaults.merge options

      reset_themes()

      @colors = options[:colors]
      @marker_color = options[:marker_color]
      @additional_line_colors = options[:additional_line_colors]
      if not options[:background_colors].nil?
        @base_image = render_gradiated_background *options[:background_colors]
      else
        @base_image = render_image_background *options[:background_image]
      end
    end

    # Add a color to the list of available colors for lines.
    #
    # Example: 
    #  add_color('#c0e9d3')
    def add_color(colorname)
      @colors << colorname
    end

    # Replace the entire color list with a new array of colors. You need to have one more color
    # than the number of datasets you intend to draw. Also aliased as the colors= setter method.
    #
    # Example: 
    #  replace_colors('#cc99cc', '#d9e043', '#34d8a2')
    def replace_colors(color_list=[])
      @colors = color_list
    end
    
    # A color scheme similar to the popular presentation software.
    def theme_keynote
      reset_themes()
      # Colors
      @blue = '#6886B4'
      @yellow = '#FDD84E'
      @green = '#72AE6E'
      @red = '#D1695E'
      @purple = '#8A6EAF'
      @orange = '#EFAA43'
      @white = 'white'
      @colors = [@yellow, @blue, @green, @red, @purple, @orange, @white]

      @marker_color = 'white'
      
      @base_image = render_gradiated_background('black', '#4a465a')      
    end
    
    # A color scheme plucked from the colors on the popular usability blog.
    def theme_37signals
      reset_themes()
      # Colors
      @green = '#339933'
      @purple = '#cc99cc'
      @blue = '#336699'
      @yellow = '#FFF804'
      @red = '#ff0000'
      @orange = '#cf5910'
      @black = 'black'
      @colors = [@yellow, @blue, @green, @red, @purple, @orange, @black]

      @marker_color = 'black'
      
      @base_image = render_gradiated_background('#d1edf5', 'white')
    end

    # A color scheme from the colors used on the 2005 Rails keynote presentation at RubyConf.
    def theme_rails_keynote
      reset_themes()
      # Colors
      @green = '#00ff00'
      @grey = '#333333'
      @orange = '#ff5d00'
      @red = '#f61100'
      @white = 'white'
      @light_grey = '#999999'
      @black = 'black'
      @colors = [@green, @grey, @orange, @red, @white, @light_grey, @black]

      @marker_color = 'white'
      
      @base_image = render_gradiated_background('#0083a3', '#0083a3')
    end

    # A color scheme similar to that used on the popular podcast site.
    def theme_odeo
      reset_themes()
      # Colors
      @grey = '#202020'
      @white = 'white'
      @dark_pink = '#a21764'
      @green = '#8ab438'
      @light_grey = '#999999'
      @dark_blue = '#3a5b87'
      @black = 'black'
      @colors = [@grey, @white, @dark_blue, @dark_pink, @green, @light_grey, @black]

      @marker_color = 'white'
      
      @base_image = render_gradiated_background('#ff47a4', '#ff1f81')
    end

    # Parameters are an array where the first element is the name of the dataset
    # and the value is an array of values to plot.
    #
    # Can be called multiple times with different datasets for a multi-valued graph.
    #
    # If the color argument is nil, the next color from the default theme will be used.
    #
    # NOTE: If you want to use a preset theme, you must set it before calling data().
    #
    # Example:
    #
    #  data("Bart S.", [95, 45, 78, 89, 88, 76], '#ffcc00')
    #
    def data(name, data_points=[], color=nil)
      @data << [name, data_points, color || increment_color]
      # Set column count if this is larger than previous counts
      @column_count = (data_points.length > @column_count) ? data_points.length : @column_count

      # Pre-normalize
      data_points.each_with_index do |data_point, index|
        next if data_point.nil?
        
        # Setup max/min so spread starts at the low end of the data points
        if @maximum_value.nil? && @minimum_value.nil?
          @maximum_value = @minimum_value = data_point
        end

        # TODO Doesn't work with stacked bar graphs
        #Original: @maximum_value = larger_than_max?(data_point, index) ? max(data_point, index) : @maximum_value
        @maximum_value = larger_than_max?(data_point) ? data_point : @maximum_value
        if @maximum_value > 0
          @has_data = true
        end
        @minimum_value = less_than_min?(data_point) ? data_point : @minimum_value
        if @minimum_value < 0
     	  @has_data = true
        end
      end
    end

    # Writes the graph to a file. Defaults to 'graph.png'
    #
    # Example: write('graphs/my_pretty_graph.png')
    def write(filename="graph.png")
      draw()
      @base_image.write(filename)
    end

    # Return the graph as a rendered binary blob.
    def to_blob(fileformat='PNG')
      draw()
      return @base_image.to_blob do
         self.format = fileformat
      end
    end

    def scale_measurements
      setup_graph_measurements
    end
    
    def total_height
      @rows + 10
    end
    
    def graph_top
      @graph_top * @scale
    end
    
    def graph_height
      @graph_height * @scale
    end
    
    def graph_left 
      @graph_left * @scale 
    end
    
    def graph_width
      @graph_width * @scale
    end


protected


    def make_stacked
      stacked_values = Array.new(@column_count, 0)
      @data.each do |value_set|
        value_set[1].each_with_index do |value, index|
          stacked_values[index] += value
        end
        value_set[1] = stacked_values.dup
      end
    end


    # Overridden by subclasses to do the actual plotting of the graph.
    #
    # Subclasses should start by calling super() for this method.
    def draw
      make_stacked if @stacked
      setup_drawing()
  
      # Subclasses will do some drawing here...
      #@d.draw(@base_image)
    end

    # Draws the decorations.
    # - line markers
    # - legend
    # - title
    def setup_drawing
      # Maybe should be done in one of the following functions for more granularity.
      unless @has_data
        draw_no_data()
        return
      end
      
      normalize()
      setup_graph_measurements()
      sort_norm_data() # Sort norm_data with avg largest values set first (for display)
      
      draw_legend()
      setup_graph_height()
      draw_line_markers()
      draw_title
    end

    # Make copy of data with values scaled between 0-100
    def normalize
      if @norm_data.nil?
        @norm_data = []
        return unless @has_data
        @spread = @maximum_value.to_f - @minimum_value.to_f
        @spread = 20.0 if @spread == 0.0 # Protect from divide by zero
        min_val = @minimum_value.to_f
        @data.each do |data_row|
          norm_data_points = []
          data_row[DATA_VALUES_INDEX].each do |data_point|
            if data_point.nil?
              norm_data_points << nil
            else
              norm_data_points << ((data_point.to_f - min_val ) / @spread)
            end
          end
          @norm_data << [data_row[DATA_LABEL_INDEX], norm_data_points, data_row[DATA_COLOR_INDEX]]
        end
      end
    end

    def setup_graph_height
      @graph_height = @graph_bottom - @graph_top
    end

    def setup_graph_measurements
      # TODO Separate horizontal lines from line number labels so they can be shown or hidden independently
      # TODO Get width of longest left-hand vertical text label and space left margin accordingly
      unless @hide_line_markers
        @graph_left = 130.0 # TODO Calculate based on string width of labels
        @graph_right_margin = 80.0 # TODO see previous line
        @graph_bottom_margin = 80.0
      else
        @graph_left = @graph_right_margin = @graph_bottom_margin =  40
      end

      @graph_right = @raw_columns - @graph_right_margin

      @graph_width = @raw_columns - @graph_left - @graph_right_margin

      @graph_top = 150.0
      @graph_bottom = @raw_rows - @graph_bottom_margin
      setup_graph_height()
    end

    # Draws horizontal background lines and labels
    def draw_line_markers
      return if @hide_line_markers
            
      # Draw horizontal line markers and annotate with numbers
      @d = @d.stroke(@marker_color)
      @d = @d.stroke_width 1
      number_of_lines = 4

      # TODO Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
      spread = @maximum_value.to_f - @minimum_value.to_f
      spread = spread > 0 ? spread : 1
      increment = (spread > 0) ? significant(spread / number_of_lines) : 1
      inc_graph = @graph_height.to_f / (spread / increment)

      (0..number_of_lines).each do |index|
        y = @graph_top + @graph_height - index.to_f * inc_graph
        @d = @d.line(@graph_left, y, @graph_right, y)

        marker_label = index * increment + @minimum_value.to_f

        @d.fill = @marker_color
        @d.font = @font if @font
        @d.stroke = 'transparent'
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = EastGravity
        
        @d = @d.annotate_scaled( @base_image, 
                          100, 20,
                          -10, y - (@marker_font_size/2.0), 
                          marker_label.to_s, @scale)
      end
      i = 0
      @additional_line_values.each do |value|
        inc_graph = @graph_height.to_f / (@maximum_value.to_f / value)
        
        y = @graph_top + @graph_height - inc_graph
        
        @d = @d.stroke(@additional_line_colors[i])
        @d = @d.line(@graph_left, y, @graph_right, y)


        @d.fill = @additional_line_colors[i]
        @d.font = @font if @font
        @d.stroke = 'transparent'
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = EastGravity
        @d = @d.annotate_scaled( @base_image, 
                          100, 20,
                          -10, y - (@marker_font_size/2.0), 
                          "", @scale)
        i += 1   
      end
    end

    # Draws a legend with the names of the datasets matched to the colors used to draw them.
    def draw_legend
      return if @hide_legend

      @legend_labels = @data.collect {|item| item[DATA_LABEL_INDEX] }

      legend_square_width = 20 # small square with color of this item

      # May fix legend drawing problem at small sizes
      @d.font = @font if @font
      @d.pointsize = @legend_font_size

      metrics = @d.get_type_metrics(@base_image, @legend_labels.join(''))
      legend_text_width = metrics.width
      legend_width = legend_text_width + (@legend_labels.length * legend_square_width * 2.7)
      legend_left = (@raw_columns - legend_width) / 2
      legend_increment = legend_width / @legend_labels.length.to_f

      current_x_offset = legend_left
      @legend_labels.each_with_index do |legend_label, index|        
        # Draw label
        @d.fill = @marker_color
        @d.font = @font if @font
        @d.pointsize = scale_fontsize(@legend_font_size)
        @d.stroke = 'transparent'
        @d.font_weight = NormalWeight
        @d.gravity = WestGravity
        @d = @d.annotate_scaled( @base_image, 
                          @raw_columns, 24,
                          current_x_offset + (legend_square_width * 1.7), 70, 
                          legend_label.to_s, @scale)
        
        # Now draw box with color of this dataset
        legend_box_y_offset = 2 # Move box down slightly to center
        @d = @d.stroke 'transparent'
        @d = @d.fill @data[index][DATA_COLOR_INDEX]
        @d = @d.rectangle(current_x_offset, 70 + legend_box_y_offset, 
                          current_x_offset + legend_square_width, 70 + legend_square_width + legend_box_y_offset)

        @d.pointsize = @legend_font_size
        metrics = @d.get_type_metrics(@base_image, legend_label.to_s)
        current_string_offset = metrics.width + (legend_square_width * 2.7)
        current_x_offset += current_string_offset
      end
      @color_index = 0
    end

    def draw_title
      return if (@hide_title || @title.nil?)
      
      @d.fill = @marker_color
      @d.font = @font if @font
      @d.stroke = 'transparent'
      @d.pointsize = scale_fontsize(@title_font_size)
      @d.font_weight = BoldWeight
      @d.gravity = CenterGravity
      @d = @d.annotate_scaled( @base_image, 
                        @raw_columns, 50,
                        0, 10, 
                        @title, @scale)
    end

    ##
    # Draws column labels below graph, centered over x_offset
    def draw_label(x_offset, index)
      return if @hide_line_markers

      if !@labels[index].nil? && @labels_seen[index].nil?
        @d.fill = @marker_color
        @d.font = @font if @font
        @d.stroke = 'transparent'
        @d.font_weight = NormalWeight
        @d.pointsize = scale_fontsize(@marker_font_size)
        @d.gravity = CenterGravity
        @d = @d.annotate_scaled(@base_image,
                                1, 1,
                                x_offset, @raw_rows - (@graph_bottom_margin - 30),
                                @labels[index], @scale)
        @labels_seen[index] = 1
      end
    end

    def draw_no_data
        @d.fill = @marker_color
        @d.font = @font if @font
        @d.stroke = 'transparent'
        @d.font_weight = NormalWeight
        @d.pointsize = scale_fontsize(80)
        @d.gravity = CenterGravity
        @d = @d.annotate_scaled( @base_image, 
                        @raw_columns, @raw_rows/2.0,
                        0, 10, 
                        @no_data_message, @scale)
    end

    # Use with a theme definition method to draw a gradiated (or solid color) background.
    def render_gradiated_background(top_color, bottom_color)
      Image.new(@columns, @rows, 
          GradientFill.new(0, 0, 100, 0, top_color, bottom_color))
    end

    # Use with a theme to use an image (800x600 original) background.
    def render_image_background(image_path)
      image = Image.read(image_path)
      if @scale != 1.0
        image[0].resize!(@scale) # TODO Resize with new scale (crop if necessary for wide graph)
      end
      image[0]
    end
    
    # Use with a theme to make a transparent background
    def render_transparent_background
      Image.new(@columns, @rows) do
        self.background_color = 'transparent'
      end
    end

    def reset_themes
      @color_index = 0
      @labels_seen = Hash.new
      
      @d = Draw.new
      # Scale down from 800x600 used to calculate drawing.
      # NOTE: Font annotation is now affected and has to be done manually.
      @d = @d.scale(@scale, @scale)
    end

    def scale(value)
      value * @scale
    end
    
    def scale_fontsize(value)
      new_fontsize = value * @scale
      #return 10 if new_fontsize < 10
      return new_fontsize
    end

    def clip_value_if_greater_than(value, max_value)
      (value > max_value) ? max_value : value
    end

    # Overridden by subclasses such as stacked bar.
    def larger_than_max?(data_point, index=0)
      data_point > @maximum_value
    end

	  def less_than_min?(data_point, index=0)
      data_point < @minimum_value
    end

    def max(data_point, index)
      data_point
    end

	  def min(data_point, index)
      data_point
    end
   
    def significant(inc)
      return 1.0 if inc == 0 # Keep from going into infinite loop
      factor = 1.0
      while (inc < 10)
        inc *= 10
        factor /= 10
      end

      while (inc > 100)
        inc /= 10
        factor *= 10
      end

      res = inc.floor * factor
      if (res.to_i.to_f == res)
        res.to_i
      else
        res
      end
    end

    # Sort with largest overall summed value at front of array 
    # so it shows up correctly in the drawn graph.
    def sort_norm_data
      @norm_data.sort! { |a,b| sums(b[1]) <=> sums(a[1]) }
    end

    def sums(data_set)
      total_sum = 0
      data_set.collect {|num| total_sum += num.to_f }
      total_sum
    end

    def get_maximum_by_stack
      # Get sum of each stack
      max_hash = {}
      @data.each do |data_set|
        data_set[DATA_VALUES_INDEX].each_with_index do |data_point, i|
          max_hash[i] = 0.0 unless max_hash[i]
          max_hash[i] += data_point.to_f
        end
      end

      @maximum_value = 0
      max_hash.keys.each do |key|
        @maximum_value = max_hash[key] if max_hash[key] > @maximum_value
      end
      @minimum_value = 0
    end


private
    
    def increment_color
      if @color_index == 0
        @color_index += 1
        return @colors[0]
      else
        if @color_index < @colors.length
          @color_index += 1
          return @colors[@color_index - 1]
        else
          # Start over
          @color_index = 0
          return @colors[-1]
          #raise(ColorlistExhaustedException, "There are no more colors left to use.")
        end
      end
    end

  end
  
  class ColorlistExhaustedException < StandardError; end
      
end


module Magick
  class Draw
    
    # Additional method since Draw.scale doesn't affect annotations.
    def annotate_scaled(img, width, height, x, y, text, scale)
      scaled_width = (width * scale) >= 1 ? (width * scale) : 1
      scaled_height = (height * scale) >= 1 ? (height * scale) : 1
      
      self.annotate( img, 
                      scaled_width, scaled_height,
                      x * scale, y * scale,
                      text)
    end
    
  end
end
