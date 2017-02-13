#!/usr/bin/env ruby
# www.smartsview.de/smartsview/auto/<image-format>/<visualization-modus>/<legend-option>/<SMARTS>
# syntax rules
# image-format:             pdf, png or svg 
# visualization modus:      1 or 2 (1 = Complete Visualization, 2 = Element Symbols)
# legend option:            both, none, static, dynamic
# SMARTS:                   All special symbols used in SMARTS can be used except '#', which has to be escaped with %23

require 'uri'
SERVICE_URI = "http://www.smartsview.de/smartsview/auto/pdf/2/both/"


inFile = File.join("data","functional-groups-smarts.csv")
hash = {}
File.readlines(inFile).each do |line|
  columns = line.split(",",2)
  group = columns[0].strip
  smarts = columns[1].sub(/^'|'$/,"").strip.sub(/^'|'$/,"").strip
  hash[group] = smarts
end

hash.each do |group,smarts|
  `wget '#{URI.escape(SERVICE_URI+smarts)}' -O "#{File.join("figures",group+'.pdf')}"`
end


