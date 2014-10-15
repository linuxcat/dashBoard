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

results = DryRun.get_total_group_tags("iOS_7_Ipad_Regression_build_nightly")

  values ={}
  results.each do |outer_hash|
    values[outer_hash['_id']["tag"]] = outer_hash['count']
  end

 puts values.to_a.inspect