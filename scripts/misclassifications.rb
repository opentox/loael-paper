#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin) 
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
end

experimental = {}
CSV.foreach(File.join("data","test_log10.csv")) do |row|
  experimental[row[0]] ||= []
  experimental[row[0]] << row[1].to_f
end

predictions = {}
CSV.foreach(File.join("data","training-test-predictions.csv"),:headers => true) do |row|
  predictions[row[0]] = [row[2].to_f,row[3].to_f.abs]
end

outside_experimental_values = 0
within_experimental_values = 0
out = []
predictions.each do |smi,pred|
  exp = experimental[smi].uniq
  # https://en.wikipedia.org/wiki/Prediction_interval
  min = pred[0]-1.96*pred[1]
  max = pred[0]+1.96*pred[1]
  pred = predictions[smi][0]
  ci = predictions[smi][1]
  err = nil
  if (min..max) & (exp.min..exp.max)
    within_experimental_values += 1
  else
    outside_experimental_values += 1
    if exp.min < min
      err = exp.min - min
    elsif exp.max > max
      err = exp.max - max
    end
  end
  if err
    out << {
      :smi => smi,
      :experimental => exp, 
      :min => min,
      :max => max,
      :prediction => predictions[smi][0],
      :ci => predictions[smi][1],
      :error => err
    }
  end
end


out.sort!{|a,b| b[:error].abs <=> a[:error].abs}
csv = [["SMILES","Distance"]] + out.collect{|o| [o[:smi], o[:error]]}
File.open("data/misclassifications.csv","w+"){|f| f.puts csv.collect{|r| r.join ", "}.join("\n")}

#File.open("correct-predictions.R","w+"){|f| f.puts "correct_predictions = #{within_experimental_values}"}
