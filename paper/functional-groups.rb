require_relative '../../lazar/lib/lazar'
include OpenTox
old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","LOAEL_mg_corrected_smiles_mmol.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","swissRat_chron_LOAEL_mmol.csv")

functional_groups = {}
#functional_groups[:old] = {}
#functional_groups[:new] = {}
table = []
#File.open("functional-groups.csv","w+") do |file|
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
      puts "#{name}, #{oldcount}, #{newcount}"
    else
      p name, smarts
    end
      #table << [name, oldcount, newcount]
  end
#end
#print table.to_csv
#old_fp = old.compounds.collect{|c| c.fingerprint("FP4")}
