
class TestRun
  include Mongoid::Document
  include Mongoid::Timestamps

  field :job, type: String
  field :scenarios, type: Array



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

end


class DryRun
  include Mongoid::Document
  include Mongoid::Timestamps

  field :job, type: String
  field :scenarios, type: Array



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
        {'$group' => {_id: { failure: "$failed._id.feature", steps: "$failed._id.step"}, count: {'$sum' => 1}, last_failure: {'$max' => "created_at"}   }}
    )
  end

end


