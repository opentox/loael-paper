require_relative '../lazar/lib/lazar'
include OpenTox
#$mongo.database.drop
#$gridfs = $mongo.database.fs # recreate GridFS indexes
#=begin
[
  #"Rat_TD50.csv",
  #"Mouse_TD50.csv",
  #"LOAEL_mg_corrected_smiles_mmol.csv",
  #"swissRat_chron_LOAEL_mmol.csv",
  "LOAEL-rat-combined.csv"
  #"LOAEL_mmol_corrected_smiles.csv",
  #"swissMouse_chron_LOAEL_mmol.csv",
  #"swissMultigen_LOAEL_mmol.csv",
  #"swissRat_chron_LOAEL_mmol.csv",

].each do |file|
  file = File.join(File.dirname(__FILE__),"regression",file)
    params = {
      :prediction_algorithm => "OpenTox::Algorithm::Regression.local_pls_regression",
    }
    dataset = Dataset.from_csv_file file
    model = Model::LazarRegression.create dataset, params
    cv = RegressionCrossValidation.create model
    puts cv.to_yaml
  #Model::Prediction.from_csv_file file, params
    #model = Model::LazarRegression.create dataset, params
end
#=end
#`mongodump -h 127.0.0.1 -d production`
#`mongorestore --host 127.0.0.1`
