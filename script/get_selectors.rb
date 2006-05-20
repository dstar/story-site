class GetSelectors
  require 'rubygems'
  require 'html/xmltree'

  @seen_selectors = Hash.new

  ARGV.each do |f|
    filename = f.chomp
#    puts "#{filename}"
    parser = HTMLTree::XMLParser.new(false,false)
    parser.parse_file_named(filename)
#    puts "#{parser.inspect}"
    xml=parser.document
#    puts "xml is #{xml.inspect}"
    xml.root_node.each_recursive do |e| 
      if e.attributes["class"]
        @seen_selectors["#{e.fully_expanded_name}.#{e.attributes["class"]}"] = 1
      else
        @seen_selectors["#{e.fully_expanded_name}"] = 1
      end
    end
  end

  @seen_selectors.keys.each do |selector|
    puts "#{selector}\n"
  end
end
