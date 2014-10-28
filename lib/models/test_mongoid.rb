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

results = rp.get_grouped_tagged('Sun - Chrome Tests - Regression')

results.each do |result|
  puts result
end

