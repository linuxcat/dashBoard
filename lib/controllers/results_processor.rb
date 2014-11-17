require 'mongoid'
require_relative '../models/mongoid_specs'
require 'date'
#Mongoid.load!(File.expand_path(File.join('../../config', 'mongoid.yml')), :development)


class ResultsProcessor

  def initialize(job)
    @job = job
    @end_day = 365
  end

  def menu_items
    summary = {}
    summary[:menu_items] = TestRun.distinct("job")
    summary
  end

  #TODO all data should come from results processor not directly from the model.
  def get_summary_data(job, regression_tag)
    summary = {}
    summary[:menu_items] = TestRun.distinct("job")
    summary[:status_summary] = prepare_pass_fail_hash(job)
    summary[:failures] = get_failure_count(job)
    summary[:total_scenarios_grouped_by_day] = get_total_scenarios_ran_aggregated(job, 'day').sort
    summary[:total_tests] = DryRun.get_latest_total_scenarios(job, regression_tag).count
    summary[:current_job] = @job
    summary[:total_scenarios_in_run] =  TestRun.total_scenarios_in_run(job).first['count']
    summary[:total_manual_scenarios] = DryRun.get_total_manual_scenarios(job).first['count']
    summary
  end

  def get_pass_percentage(job, sortby)
    percentage_pass = TestRun.get_percentage_pass(job, sortby)
    sorted_data = {}
    percentage_pass.each do |key, value|
      value.each do |element|
        date_of_group = day_calculation(sortby, element)
        if key.to_s == 'total_tests'
          sorted_data[date_of_group] = {}
          sorted_data[date_of_group]['total_tests'] = element['total_tests']
        end
        sorted_data[date_of_group]['total_passed'] = element['total_passed']
      end
    end
    final_data = {}
    sorted_data.each do |key, element|
      if element['total_passed'].nil?
        element['total_passed'] = 0
      end
      final_data[key] = (element['total_passed'].fdiv(element['total_tests'])) * 100
    end

    (final_data.sort_by { |k, v|}.last 7).to_h
  end

  #TODO Refector to DRY
  def get_total_scenarios_grouped(job, sortby)
    total_scenarios = TestRun.get_total_scenarios_grouped(job, sortby)
    sorted_data = {}
    total_scenarios.each do |hash|
      date_of_group = day_calculation(sortby, hash).to_s
      sorted_data[date_of_group] = hash['total_scenarios']

    end

    sorted_data.to_a
  end

  #TODO Refector to DRY
  def get_total_manual_grouped(job, sortby)
    dates = TestRun.get_dates_for_test_runs(job,sortby)
    grouped_dates = {}
    dates.each do |date|
      date_of_group = day_calculation(sortby, date)
      data = DryRun.get_manual_by_date(date_of_group, job)
      case data.size
        when 0
          grouped_dates[date_of_group] = 0
        when 1
          grouped_dates[Date.ordinal(data.first['_id']['year'], data.first['_id']['date'])] = data.first['total_scenarios']
      end

    end
    grouped_dates.to_a

  end

  #TODO Refector to DRY
  def get_total_failed_grouped(job, sortby)
    dates = TestRun.get_dates_for_test_runs(job,sortby)
    grouped_dates = {}
    dates.each do |date|
      date_of_group = day_calculation(sortby, date)
      data = TestRun.get_failed_by_date(date_of_group, job)
      case data.size
        when 0
          grouped_dates[date_of_group] = 0
        when 1
          grouped_dates[Date.ordinal(data.first['_id']['year'], data.first['_id']['date'])] = data.first['total_scenarios']
      end

    end
    grouped_dates.to_a
  end

  def get_total_regression_grouped(job, sortby, regression_tag)
    dates = TestRun.get_dates_for_test_runs(job,sortby)
    grouped_dates = {}
    dates.each do |date|
      date_of_group = day_calculation(sortby, date)
      data = DryRun.get_regression_by_date(date_of_group, job, regression_tag)
      case data.size
        when 0
          grouped_dates[date_of_group] = 0
        when 1
          grouped_dates[Date.ordinal(data.first['_id']['year'], data.first['_id']['date'])] = data.first['total_scenarios']
      end

    end
    grouped_dates.to_a

  end

  def get_total_scenarios_ran_aggregated(job, sortby)
    dates = TestRun.get_dates_for_test_runs(job,sortby)
    grouped_dates = {}
    dates.each do |date|
      date_of_group = day_calculation(sortby, date)
      data = TestRun.get_scenarios_ran_by_date(date_of_group, job)
      case data.size
        when 0
          grouped_dates[date_of_group] = 0
        when 1
          grouped_dates[Date.ordinal(data.first['_id']['year'], data.first['_id']['date'])] = data.first['total_scenarios']
      end

    end
    grouped_dates.to_a


  end

  #TODO duplication of data all over this class, sort it out!!
  def get_grouped_tagged(job)
    results = DryRun.get_total_group_tags(job)
    puts results.inspect
    values ={}
    results.each do |outer_hash|
      values[outer_hash['_id']["tag"]] = outer_hash['count']
    end

    values.to_a
  end

  #TODO needs refector to DRY also write custom sort as this may break on date/month changes :-S
  def get_total_scenarios_breakdown(job, sortby, regression_tag)
    total_scenarios = get_total_scenarios_ran_aggregated(job,sortby)
    total_manual = get_total_manual_grouped(job, sortby)
    total_scenarios_failed = get_total_failed_grouped(job, sortby)
    total_regression = get_total_regression_grouped(job, sortby, regression_tag)

    manual = {}
    manual[:name] = 'Scenarios Manual'
    manual[:data] = total_manual.sort.last(7)

    scenarios_failed = {}
    scenarios_failed[:name] = 'Scenarios Failed'
    scenarios_failed[:data] = total_scenarios_failed.sort.last(7)


    scenarios_less_failed_scenarios ={}
    scenarios_less_failed_scenarios[:name] = 'Scenarios Passed'
    pass_less_fail = {}
    total_scenarios.to_h.each do |key, value|
        pass_less_fail[key] = value - total_scenarios_failed.to_h[key]
    end
    scenarios_less_failed_scenarios[:data] = pass_less_fail.to_a.sort.last(7)


    total_regression_scenarios = {}
    total_regression_scenarios[:name] = 'Remaining'
    total_regression_scenarios[:data] = total_regression.sort.last(7)


    remaining_tests = {}
    total_regression_scenarios[:data].to_h.each do |key, value|
      total_executable_tests =  total_scenarios.to_h[key] + total_manual.to_h[key]
      to_do = value - total_executable_tests

      remaining_tests[key] = to_do
    end



    total_regression_scenarios[:data] = remaining_tests.to_a

    stacked_data = []
    stacked_data << scenarios_less_failed_scenarios
    stacked_data << scenarios_failed
    stacked_data << manual
    stacked_data << total_regression_scenarios

    stacked_data


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



  def day_calculation(sortby, element)
    case sortby
      when 'day'
        day = element['_id']['date']
      when 'week'
        day = (element['_id']['date']*7)
      when 'month'
        day = Date.new(element['_id']['year'], element['_id']['date'], 1).yday
    end
    Date.ordinal(element['_id']['year'], day)
  end


end
