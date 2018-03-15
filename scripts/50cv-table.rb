#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

table = {}
table["close"] = { "rmse" => [], "r_squared" => [], "nr_predicted" => [] }
table["distant"] = { "rmse" => [], "r_squared" => [], "nr_predicted" => [] }
table["all"] = { "rmse" => [], "r_squared" => [], "nr_predicted" => [] }

File.open(ARGV[0]).each_line do |id|
  cv = Validation::RegressionCrossValidation.find id.chomp
  rmse = {"close" => 0, "distant" => 0, "all" => 0}
  x = {"close" => [], "distant" => [], "all" => []}
  y = {"close" => [], "distant" => [], "all" => []}
  cv.predictions.each do |cid,pred|
    warnings = false
    warnings = true if pred["warnings"] and !pred["warnings"].empty?
    if pred[:value] #and pred[:measurements] 
      if warnings
        x["distant"] << pred[:measurements].median
        y["distant"] << pred[:value]
      else
        x["close"] << pred[:measurements].median
        y["close"] << pred[:value]
      end
      x["all"] << pred[:measurements].median
      y["all"] << pred[:value]
    end
  end
  ["close","distant","all"].each do |cat|
    R.assign "measurement", x[cat]
    R.assign "prediction", y[cat]
    R.eval "r <- cor(measurement,prediction,use='pairwise')"
    R.eval "rmse <- sqrt(mean((prediction - measurement)^2))"
    table[cat]["r_squared"] << R.eval("r").to_ruby**2
    table[cat]["rmse"] << R.eval("rmse").to_ruby
    table[cat]["nr_predicted"] << y[cat].size
  end
end

File.open("data/50cv.csv","w+") do |f|
  f.puts("AD,Param,Mean,SD")
  table.each do |dist,data|
    data.each do |name,values|
      R.assign "x", values
      R.eval "sd <- sd(x)"
      f.puts "#{dist},#{name},#{values.mean},#{R.eval("sd").to_ruby}"
    end
  end
end

