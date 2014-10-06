require 'mongoid'
require './mongoid_specs'
require 'date'
require_relative '../../lib/controllers/results_processor'
require_relative '../../lib/controllers/jenkins'


Mongoid.load!('../../config/mongoid.yml', :development)


@j = Jenkins.new('ubuntu-jenkins.ngn-dev.ntch.co.uk')

json = @j.tests_running?

puts json

#result = TestRun.where(job: "Sun - Firefox Tests - Regression")
=begin
rp = ResultsProcessor.new('Sun - Chrome Tests - Regression')
#puts rp.get_total_manual_grouped('Sun - Chrome Tests - Regression', 'week').inspect
data = rp.get_total_manual_grouped_two('Sun - Chrome Tests - Regression','week')
puts data.inspect
=end

n = 1
retries = 5
while n < retries
  puts 'hello'
  n += 1
end