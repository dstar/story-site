 require 'rexml/document'
 xml = REXML::Document.new(File.open("filename"))
 xml.elements.each { |e| @hash["#{e}.#{c.attributes["class"]}"] = 1}
