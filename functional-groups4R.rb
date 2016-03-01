require 'csv'
csv = []
exclude = [
  %{Acetal},
  "Anion",
  %r{_bond},
  %{_carbon},
  "Charged",
  %{Hetero_},
  %{_rings},
  "Kation",
  %{NOS},
  "Salt",
  "Spiro",
  %{Sugar}
]
CSV.foreach("data/functional-groups.csv") do |row|
  keep = true
  exclude.each do |patt|
    keep = false if row[0].match(patt)
  end
  if keep and [row[1].to_i,row[2].to_i].max >= 25
    csv << [row[0].gsub('_',' '),row[1].to_i,"Mazzatorta"]
    csv << [row[0].gsub('_',' '),row[2].to_i,"Swiss Federal Office"]
  else
    p row
  end
end

File.open("data/functional-groups-reduced4R.csv","w+"){|f| f.puts csv.collect{|r| r.join ", "}.join("\n")}
