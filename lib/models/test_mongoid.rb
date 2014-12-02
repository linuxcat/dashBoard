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
=begin
total_test = DryRun.get_latest_total_scenarios('Sun - Firefox Tests - Regression', '@regression').count

day = Date.ordinal(2014,295)

puts day

total_test_day = DryRun.get_regression_by_date(day, 'Sun - Firefox Tests - Regression', '@regression')

puts total_test
puts total_test_day.inspect
=end

opts={:regression_tag => '@regression'}


puts !opts[:regression_tag].nil?
