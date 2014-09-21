require 'mongoid'
require './mongoid_specs'
require 'date'
require_relative '../../lib/controllers/results_processor'


Mongoid.load!('../../config/mongoid.yml', :development)

#result = TestRun.where(job: "Sun - Firefox Tests - Regression")




data = TestRun.get_total_scenarios_grouped('Sun - Chrome Tests - Regression','week')

puts data.inspect


rp = ResultsProcessor.new('Sun - Chrome Tests - Regression')

original = rp.send(:get_column_chart_data_total_scenarios,'Sun - Chrome Tests - Regression')
puts rp.get_total_scenarios_grouped('Sun - Chrome Tests - Regression', 'month').inspect
puts original.inspect
=begin
puts new.first.inspect
puts new.last.inspect

sorted_data = {}
  new.first.each do |element|
    sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"] = {}
    sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"]['total_tests'] = element['total_tests']
  end

new.last.each do |element|
  sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"]['total_passed'] = element['total_passed']
end


puts sorted_data.inspect

=end


