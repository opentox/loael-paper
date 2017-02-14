require_relative '../../lazar/lib/lazar'
include OpenTox
old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","LOAEL_mg_corrected_smiles_mmol.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","swissRat_chron_LOAEL_mmol.csv")

functional_groups = {}
table = []
File.open("functional-groups.txt").each_line do |line|
  name, smarts = line.chomp.split ": "
  if smarts
    smarts_feature = Smarts.from_smarts smarts
    oldcount = 0
    old.compounds.each do |c|
      oldcount += Algorithm::Descriptor.smarts_match(c,smarts_feature).first.to_i
    end
    newcount = 0
    new.compounds.each do |c|
      newcount += Algorithm::Descriptor.smarts_match(c,smarts_feature).first.to_i
    end
    puts "#{name}, #{oldcount}, #{newcount}" if oldcount > 0 and newcount > 0
  else
    p name, smarts
  end
    #table << [name, oldcount, newcount]
end
