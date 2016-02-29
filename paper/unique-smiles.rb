require_relative "include.rb"

input = Dataset.from_csv_file File.join(ARGV[0])
outname = File.join(File.dirname(ARGV[0]),"#{ARGV[1]}.csv")

data = []
input.compounds.each_with_index do |cid,i|
  c = Compound.find cid
  # round to 5 significant digits in order to detect duplicates 
  v = input.data_entries[i].first.signif(5)
  data << [c.smiles,v,ARGV[1]]
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(outname,"w+") do |csv|
  csv << ["SMILES","LOAEL","Dataset"]
  data.each{|r| csv << r}
end
