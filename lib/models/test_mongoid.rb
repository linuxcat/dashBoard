require 'mongoid'
require './mongoid_specs'
require 'date'
require_relative '../../lib/controllers/results_processor'
require_relative '../../lib/controllers/jenkins'


Mongoid.load!('../../config/mongoid.yml', :development)



#result = TestRun.where(job: "Sun - Firefox Tests - Regression")
=begin
rp = ResultsProcessor.new('Sun - Chrome Tests - Regression')
#puts rp.get_total_manual_grouped('Sun - Chrome Tests - Regression', 'week').inspect
data = rp.get_total_manual_grouped_two('Sun - Chrome Tests - Regression','week')
puts data.inspect
=end

rp = ResultsProcessor.new('Sun - Firefox Tests - Regression')

results = rp.get_pass_percentage('Sun - Chrome Tests - Regression', 'day')

puts results
h = (results.sort_by { |k, v|}.last 7).to_h

puts h.inspect
