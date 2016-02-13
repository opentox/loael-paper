require_relative '../../lazar/lib/lazar'
include OpenTox

dir = File.join(File.dirname(__FILE__),"..","regression")
test = Dataset.from_csv_file(File.join(dir,"common-test.csv"))
[
  "LOAEL_mg_corrected_smiles_mmol.csv",
  "swissRat_chron_LOAEL_mmol.csv",
  "LOAEL-rat-combined.csv"
].each do |train|
  file = File.join(dir,train)
  params = {
    :prediction_algorithm => "OpenTox::Algorithm::Regression.local_pls_regression",
  }
  dataset = Dataset.from_csv_file file
  model = Model::LazarRegression.create dataset, params
  validation = Validation.create model, dataset, test
  puts "#{train}: #{validation.id.to_s}"
end
