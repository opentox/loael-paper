require_relative '../lazar/lib/lazar'
include OpenTox
$mongo.database.drop
$gridfs = $mongo.database.fs # recreate GridFS indexes
#=begin
[
  "Rat_TD50.csv",
  "Mouse_TD50.csv",
  "LOAEL-rat-combined.csv"
  #"LOAEL_mmol_corrected_smiles.csv",
  #"swissMouse_chron_LOAEL_mmol.csv",
  #"swissMultigen_LOAEL_mmol.csv",
  #"swissRat_chron_LOAEL_mmol.csv",
].each do |file|
  file = File.join(File.dirname(__FILE__),"regression",file)
  Model::Prediction.from_csv_file file
end
#=end
`mongodump -h 127.0.0.1 -d production`
#`mongorestore --host 127.0.0.1`
