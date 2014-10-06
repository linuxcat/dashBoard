class TestRun
  include Mongoid::Document
  include Mongoid::Timestamps

  field :job, type: String
  field :scenarios, type: Array

  def self.group_failed_scenarios(job)
    self.collection.aggregate(
        {'$match' => {job: job}},
        {'$sort' => {created_at: -1}},
        {'$limit' => 1},
        {'$unwind' => '$scenarios'},
        {'$match' =>{ 'scenarios.steps.result.status' => 'failed'}},
        {'$group' => {_id: {feature: "$scenarios.name", step: "$scenarios.steps"}}}
    )
  end

  def self.group_by_status(job)
    self.collection.aggregate(
        { '$match' => {job: job}},
        { '$sort' => {created_at: -1}},
        { '$limit' => 1},
        { '$unwind' => "$scenarios"},
        { '$project' => {"scenarios.steps.result.status" => 1, "_id" => 0}},
        { '$unwind' => "$scenarios.steps"},
        { '$group' => {_id: {status: "$scenarios.steps.result.status"}, count: {'$sum' => 1}}},
        { '$sort' => {count: 1}}

    )
  end


  def self.group_by(field, format = 'day')
    key_op = [['year', '$year'], ['month', '$month'], ['day', '$dayOfMonth']]
    key_op = key_op.take(1 + key_op.find_index { |key, op| format == key })
    project_date_fields = Hash[*key_op.collect { |key, op| [key, {op => "$#{field}"}] }.flatten]
    group_id_fields = Hash[*key_op.collect { |key, op| [key, "$#{key}"] }.flatten]
    pipeline = [
        {"$project" => {"name" => 1, field => 1}.merge(project_date_fields)},
        {"$group" => {"_id" => group_id_fields, "count" => {"$sum" => 1}}},
        {"$sort" => {"count" => -1}}
    ]
    collection.aggregate(pipeline)
  end

  def self.failures_in_latest_run(job)
    self.collection.aggregate(
        { '$match' => {job: job}},
        { '$sort' => {created_at: -1}},
        { '$limit' => 1},
        { '$unwind' => '$scenarios' },
        { '$project' => {'scenarios.steps.result.status' => 1, '_id'  => 0}},
        { '$unwind' => '$scenarios.steps' },
        { '$match' => {'scenarios.steps.result.status' => 'failed'}}
    )
  end


  def self.get_percentage_pass(job, sortby)
    sorting_options = {'week' => '$week', 'month' => '$month', 'day' => '$dayOfYear'}

    sort = sorting_options[sortby]
    percentage_pass = {}
    percentage_pass[:total_tests] = self.collection.aggregate(
        {'$match' => {job: job}},
        {'$sort'=> {created_at: -1}},
        {'$unwind' => '$scenarios'},
        {'$project' => {'scenarios.steps.result.status' => 1,created_at: 1, '_id' => 0}},
        {'$unwind' => '$scenarios.steps'},
        {'$project' => {'scenarios.steps' => 1, created_at:1, '_id' => 0}},
        {'$group' =>{ _id: {'date' => {sort => '$created_at'}, 'year' =>{'$year' => '$created_at'}}, total_tests:{ '$sum' => 1}}}
    )
    percentage_pass[:total_passed] = self.collection.aggregate(
        {'$match' => {job: job}},
        {'$sort'=> {created_at: -1}},
        {'$unwind' => '$scenarios'},
        {'$project' => {'scenarios.steps.result.status' => 1,created_at: 1, '_id' => 0}},
        {'$unwind' => '$scenarios.steps'},
        {'$match' => {'scenarios.steps.result.status' => 'passed'}},
        {'$group' =>{ _id: {'date' => {sort => '$created_at'}, 'year' =>{'$year' => '$created_at'}}, total_passed:{ '$sum' => 1}}}
    )
    return percentage_pass
  end

  def self.get_total_scenarios_grouped(job, sortby)
    sorting_options = {'week' => '$week', 'month' => '$month', 'day' => '$dayOfYear'}
    sort = sorting_options[sortby]

    scenarios = self.collection.aggregate(
      {'$match' => {job: job}},
      {'$sort'=> {created_at: -1}},
      {'$unwind' => '$scenarios'},
      {'$group' =>{ _id: {'date' => {sort => '$created_at'}, 'year' =>{'$year' => '$created_at'}}, total_scenarios:{ '$sum' => 1}}}
    )

    scenarios
  end


  def self.get_data_group_dates(job, sort_by)
    sorting_options = {'week' => '$week', 'month' => '$month', 'day' => '$dayOfYear'}
    sort = sorting_options[sort_by]

    dates = self.collection.aggregate(
        { '$match' => {job: job}},
        { '$sort' => {created_at: -1}},
        { '$group' => { '_id' => {'date' => {sort => '$created_at'}, 'year' => {'$year' => '$created_at'}}}}
    )
    dates
  end


  def self.get_by_date(date, job)
    start_timestamp = date
    end_timestamp = date+1
    day_count = self.collection.aggregate(
        { '$match' => {job: job, created_at: {'$gte' => start_timestamp.mongoize, '$lt' => end_timestamp.mongoize}}},
        { '$limit' => 1},
        { '$unwind' => '$scenarios'},
        { '$group' =>{ '_id' => {'date' => {'$dayOfYear' => '$created_at'}, 'year' => {'$year' => '$created_at'}}, 'total_scenarios' => { '$sum' => 1}}}
    )
    day_count
  end

end





class DryRun
  include Mongoid::Document
  include Mongoid::Timestamps

  field :job, type: String
  field :scenarios, type: Array

  def self.return_latest_dry_run(job)
    self.collection.aggregate(
        {'$match' => {job: job}},
        { '$sort' => {created_at: -1}},
        { '$limit' => 1}
    )

  end

  def self.get_total_manual_grouped(job, sortby)
    sorting_options = {'week' => '$week', 'month' => '$month', 'day' => '$dayOfYear'}
    sort = sorting_options[sortby]
    scenarios = self.collection.aggregate(
        { '$match' => {job: job}},
        { '$unwind' => '$scenarios'},
        { '$match' => {'scenarios.tags.name' => '@manual'}},
        { '$project' => { 'scenarios.tags.name' =>1, 'created_at' => 1}},
        { '$group' => { '_id' => {'date' => {sort => '$created_at'}, 'year' => { '$year' => '$created_at' }}, 'total_scenarios' =>{ '$sum' => 1}}}
    )

    scenarios
  end

  def self.get_manual_by_date(date, job)
    start_timestamp = date
    end_timestamp = date+1
    day_count = self.collection.aggregate(
        { '$match' => {job: job, created_at: {'$gte' => start_timestamp.mongoize, '$lt' => end_timestamp.mongoize}}},
        { '$limit' => 1},
        { '$unwind' => '$scenarios'},
        { '$match' => {'scenarios.tags.name' => '@manual'}},
        { '$group' =>{ '_id' => {'date' => {'$dayOfYear' => '$created_at'}, 'year' => {'$year' => '$created_at'}}, 'total_scenarios' => { '$sum' => 1}}}
    )
    day_count
  end





end

class TestRunFailure
  include Mongoid::Document
  include Mongoid::Timestamps

  field :test_run, type: String
  field :failure, type: Array

  def self.grouped_failures(job)
    grouped = self.collection.aggregate(
        {'$unwind' => '$failed'},
        {'$match' => {test_run: job}},
        {'$group' => {_id: {failure: "$failed._id.feature"}, count: {'$sum' => 1}, last_failure: {'$max' => "$created_at"}}},
        { '$sort' => {last_failure: -1}}

    )
    grouped
  end

  def self.get_last_failure_date(job, feature)
    last_failed = self.collection.aggregate(
        { '$unwind' => '$failed'},
        { '$match' => {test_run: job }},
        { '$match' => {'failed._id.feature' => feature}},
        { '$group' => {_id: {status: '$failed._id.feature'}, last_failed: {'$max' => '$created_at'}}}
    )
    last_failed

  end

end


