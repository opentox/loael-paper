require_relative 'include.rb'

old = Dataset.from_csv_file File.join(DATA,"mazzatorta.csv")
new = Dataset.from_csv_file File.join(DATA,"swiss.csv")

common_compound_ids = (old.compound_ids & new.compound_ids).uniq

data = []
common_compound_ids.each do |cid|
  c = Compound.find cid
  old_values = old.values(c,old.features.first)
  new_values = new.values(c,new.features.first)
  identical = old_values & new_values
  unless identical.empty?
    old_values -= identical
    new_values -= identical
  end
  unless old_values.empty? or new_values.empty?
    data << [c.smiles,old_values.median,new_values.median]
  end
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(File.join(DATA,"median-correlation.csv"),"w+") do |csv|
  csv << ["SMILES","mazzatorta","swiss"]
  data.each{|r| csv << r}
end
