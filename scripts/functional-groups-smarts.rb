#!/usr/bin/env ruby
require 'csv'

smarts = {}
File.open("../functional-groups.txt").each_line do |row|
  name,sma = row.chomp.split ": "
  smarts[name] = "'#{sma}'"
end

names = []
CSV.foreach("../data/functional-groups-reduced4R.csv") do |row|
  names << row[0].gsub(" ", "_")
end
names.uniq.each{|name| puts [name,smarts[name]].join ","}
