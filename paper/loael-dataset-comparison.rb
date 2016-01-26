require_relative '../../lazar/lib/lazar'
include OpenTox
#$mongo.database.drop
#$gridfs = $mongo.database.fs # recreate GridFS indexes
old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","LOAEL_mg_corrected_smiles_mmol.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"..","regression","swissRat_chron_LOAEL_mmol.csv")

combined_compounds = old.compound_ids & new.compound_ids

compound_vector = []
value_vector = []
dataset_vector = []

old_median = []
new_median = []

errors = []
combined_compounds.each do |cid|
  c = Compound.find cid
  old_values = old.values(c,old.features.first)
  old_median << -Math.log(old_values.mean) 
  old_values.each do |v|
    compound_vector << c.smiles
    value_vector << -Math.log(v.to_f)
    dataset_vector << old.name
  end
  new_values = new.values(c,new.features.first)
  new_median << -Math.log(new_values.mean)
  new_values.each do |v|
    compound_vector << c.smiles
    value_vector << -Math.log(v)
    dataset_vector << new.name
  end
end
old_median.each_index do |i|
  errors[i] = (old_median[i] - new_median[i]).abs unless old_median[i] == new_median[i]
end
rmse = 0
mae = 0
errors.compact.each do |e|
  rmse += e**2
  mae += e
end
rmse = Math.sqrt(rmse/errors.size)
mae = mae/errors.size

=begin
R.assign "smi", compound_vector
R.assign "values", value_vector
R.assign "dataset", dataset_vector
R.eval "df <- data.frame(factor(smi),values,factor(dataset))"
R.eval "df$smi <- reorder(df$factor.smi,df$values)"
R.eval "img <- ggplot(df, aes(smi,values,ymin = min(values), ymax=max(values),color=dataset))"
R.eval "img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())"
R.eval "img <- img + geom_point()"

R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael-dataset-comparison-mmol_kg_day.svg', plot=img,width=12, height=8)"
=end

R.assign "old", old_median
R.assign "new", new_median
=begin
R.eval "df <- data.frame(old,new)"
R.eval "img <- ggplot(df, aes(old,new))"
R.eval "img <- img + geom_point()"
#R.eval "img <- img + geom_smooth(method=lm) "
R.eval "img <- img + geom_abline(intercept=0.0) "
R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael-dataset-correlation.svg', plot=img,width=12, height=8)"
=end
puts "Correlation old/new:"
puts "\tr^2: #{R.eval("cor(old,new,use='complete')").to_f**2}"
puts "\tRMSE: #{rmse}"
puts "\tMAE: #{mae}"