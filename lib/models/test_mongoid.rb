require 'mongoid'
require './mongoid_specs'
require 'date'


Mongoid.load!('../../config/mongoid.yml', :development)

#result = TestRun.where(job: "Sun - Firefox Tests - Regression")


percentage_pass = TestRun.get_percentage_pass('Sun - Chrome Tests - Regression', 'month')


sorted_data = {}
percentage_pass.each do |key, value|
    value.each do |element|
      if key.to_s == 'total_tests'
        sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"] = {}
        sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"]['total_tests'] = element['total_tests']
      end
        sorted_data["#{Date.ordinal(element['_id']['year'],element['_id']['date'])}"]['total_passed'] = element['total_passed']
    end
  end

  final_data = {}
  sorted_data.each do |key, element|
    final_data[key] = (element['total_passed'].fdiv(element['total_tests'])) * 100
  end
puts final_data.inspect



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


