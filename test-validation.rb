require_relative "include.rb"

test = Dataset.from_csv_file(File.join(DATA,"test.csv"))

file = File.join(DATA,ARGV[0])
dataset = Dataset.from_csv_file file
model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_fingerprint_regression")
#model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_physchem_regression")
#model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_weighted_average")
validation = RegressionValidation.create model, dataset, test
csv_file = file.sub(".csv","-test-predictions.csv")
id_file = file.sub(".csv","-test-predictions.id")
File.open(id_file,"w+"){|f| f.puts validation.id}
name = File.basename(ARGV[0],".csv")

data = []
validation.predictions.each do |p|
  data << [Compound.find(p[0]).smiles, p[1].median, p[2], p[3],"#{name}-prediction"]
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(csv_file,"w+") do |csv|
  csv << ["SMILES","LOAEL_measured_median","LOAEL_predicted","RMSE","Dataset"]
  data.each{|r| csv << r}
end
