require 'mongoid'
require_relative '../models/mongoid_specs'
#Mongoid.load!(File.expand_path(File.join('../../config', 'mongoid.yml')), :development)


class ResultsProcessor

  def initialize(job)
    @job = job
    @end_day = 100
  end


  def get_summary_data(job)
    summary = {}
    summary[:menu_items] = TestRun.distinct("job")
    summary[:status_summary] = prepare_pass_fail_hash(job)
    summary[:failures] = get_failure_count(job)
    summary[:total_steps_grouped_by_date] = get_column_chart_data_total_scenarios(job)
    summary[:total_tests] = get_dry_run_total_scenarios(job)
    summary
  end



private
  def get_column_chart_data_total_scenarios(job)
    graph_data = {}

    results = TestRun.where(job: job ,:created_at.gte => (Date.today - @end_day)).asc(:created_at)
    results.each do |job|
      date = Date.parse(job.created_at.to_s)
      day = date.strftime("%b")
      month = date.strftime("%e")
      graph_data["#{day} #{month}"] = job.scenarios.count

    end
    graph_data.to_a
  end

  def get_dry_run_total_scenarios(job)
    total_tests = DryRun.return_latest_dry_run(job)
    total_tests.first['scenarios'].count
  end


  def prepare_pass_fail_hash(job)
    status_hash = {}
    statuses = TestRun.group_by_status(job)
    statuses.each do |status|
      status_hash[status['_id']['status']] = status['count']
    end

    expected_statuses = ["passed", "skipped", "undefined", "failed"]
    expected_statuses.each do |exp|
      status_hash[exp] ? status_hash[exp] : status_hash[exp] = 0
    end

    status_hash

  end

  def get_failure_count(job)
    results = TestRunFailure.grouped_failures(job)

    failure_summary = {}
    results.each do |result|
      failure_summary[result['_id']['failure']] = Hash.new
      failure_summary[result['_id']['failure']]['failure_count'] = result['count']
      failure_summary[result['_id']['failure']]['last_failed_date'] = TestRunFailure.get_last_failure_date(job,result['_id']['failure']).first['last_failed']
    end
    failure_summary
  end


end
