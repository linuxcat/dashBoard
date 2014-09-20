require 'mongoid'
require './mongoid_specs'


Mongoid.load!('../../config/mongoid.yml', :development)

result = TestRun.where(job: "Sun - Firefox Tests - Regression")


grouped = TestRun.group_failed_scenarios('Sun - Chrome Tests - Regression')

grouped.each do |result|
  puts result
end
#failure = TestRunFailure.new(:failed => grouped, :test_run => 'Sun - Firefox Tests - Regression' )

#failure.save!
#puts grouped.inspect

puts TestRun.failures_in_latest_run("Sun - Chrome Tests - Regression").length

results = TestRunFailure.grouped_failures("Sun - Chrome Tests - Regression")

results.each do |result|
  puts result['_id']['failure']
end
