require_relative '../../lazar/lib/lazar'
include OpenTox

old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","LOAEL_mg_corrected_smiles_mmol.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","swissRat_chron_LOAEL_mmol.csv")

File.open("rmse.R","w+") do |result|

  names = {old => "mazzatorta",new  => "swiss"} 

  [old,new].each do |dataset|
    rmse = 0
    nr = 0
    dataset.compound_ids.each do |cid|
      c = Compound.find cid
      values = dataset.values(c,dataset.features.first)
      if values.size > 1
        median = -Math.log(values.mean) 
        values.each do |v|
          rmse += (-Math.log(v) - median)**2
          nr += 1
        end
      end
    end
    rmse = Math.sqrt(rmse/nr)
    result.puts "#{names[dataset]}.rmse <- #{rmse}"
  end

  rmse = 0
  nr = 0
  (old.compound_ids & new.compound_ids).each do |cid|
    c = Compound.find cid
    values = old.values(c,old.features.first) + new.values(c,new.features.first)
    if values.size > 1
      median = -Math.log(values.mean) 
      values.each do |v|
        rmse += (-Math.log(v) - median)**2
        nr += 1
      end
    end
  end
  rmse = Math.sqrt(rmse/nr)
  result.puts "common.rmse <- #{rmse}"

  rmse = 0
  nr = 0
  (old.compound_ids + new.compound_ids).uniq.each do |cid|
    c = Compound.find cid
    values = old.values(c,old.features.first) + new.values(c,new.features.first)
    if values.size > 1
      median = -Math.log(values.mean) 
      values.each do |v|
        rmse += (-Math.log(v) - median)**2
        nr += 1
      end
    end
  end
  rmse = Math.sqrt(rmse/nr)
  result.puts "combined.rmse <- #{rmse}"
end

#combined_rmse = Math.sqrt(combined_rmse/combined_nr)
#p "combined: #{combined_rmse}"