require 'mongoid'
require './mongoid_specs'


Mongoid.load!('../../config/mongoid.yml', :development)

result = TestRun.where(job: "Sun - Firefox Tests - Regression")


grouped = TestRun.collection.aggregate(
    { '$unwind' => '$scenarios' },
    { '$match' => { job:'Sun - Firefox Tests - Regression', 'scenarios.steps.result.status' => 'failed'} },
    { '$group' => {_id: {feature: "$scenarios.name", step: "$scenarios.steps" }} }
)


failure = TestRunFailure.new(:failed => grouped, :test_run => 'Sun - Firefox Tests - Regression' )

failure.save!
puts grouped.inspect


results = TestRunFailure.grouped_failures("Sun - Firefox Tests - Regression")

results.each do |result|
  puts result['_id']['failure']
  puts result['count']
end