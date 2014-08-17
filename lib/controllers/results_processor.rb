require 'mongoid'
require_relative '..//models/mongoid_specs'
#Mongoid.load!(File.expand_path(File.join('../../config', 'mongoid.yml')), :development)


class ResultsProcessor

  def initialize(job)
    @job = job
    @end_day = 100
  end



  def get_column_chart_data_total_scenarios
    graph_data = {}

    results = TestRun.where(job: @job ,:created_at.gte => (Date.today - @end_day)).asc(:created_at)
    results.each do |job|
      date = Date.parse(job.created_at.to_s)
      day = date.strftime("%b")
      month = date.strftime("%e")
      graph_data["#{day} #{month}"] = job.scenarios.count

    end
    graph_data.to_a
  end


end
