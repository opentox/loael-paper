require 'csv'
csv = []
CSV.foreach("functional-groups-reduced.csv") do |row|
  csv << [row[0],row[1].to_i,"Mazzatorta"]
  csv << [row[0],row[2].to_i,"Swiss Federal Office"]
end

#File.open("functional-groups-reduced4R.csv","w+"){|f| f.puts csv.to_csv}
puts csv.collect{|r| r.join ", "}.join("\n")
