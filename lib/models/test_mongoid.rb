require 'mongoid'
require './mongoid_specs'
require 'date'
require_relative '../../lib/controllers/results_processor'


Mongoid.load!('../../config/mongoid.yml', :development)

#result = TestRun.where(job: "Sun - Firefox Tests - Regression")

rp = ResultsProcessor.new('Sun - Chrome Tests - Regression')
#puts rp.get_total_manual_grouped('Sun - Chrome Tests - Regression', 'week').inspect
data = rp.get_total_manual_grouped_two('Sun - Chrome Tests - Regression','week')
puts data.inspect

