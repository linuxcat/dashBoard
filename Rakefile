require 'rubygems'
require 'mongoid'


require_relative 'lib/controllers/jenkins'
require_relative 'lib/models/mongoid_specs'
Mongoid.load!(File.expand_path(File.join('config', 'mongoid.yml')), :development)

#	ios-ipad-sanity.json
#io7_ipad_regression.json

desc 'load jenkins feature file jason report into mongo'
task :load_json_results_file_from_jenkins_app_team, [:job, :file] do |t, args|
  @jenkins = Jenkins.new('10.198.10.235', 'ni_test', 'ni_test')
  results = @jenkins.send(:get_latest_json_results, args[:job], args[:file])
  project_run = []
  results.each do |feature|
    feature['elements'].each do |scenario|
      project_run << scenario
    end
  end
  test_run = TestRun.new(:job => args[:job], :scenarios => project_run)
  test_run.save

end


#rake load_jenkins_data["Sun - Firefox Tests - Regression","/ws/sol-automation/sun-online/src/test/resources/report/"]
desc 'load web team test run into app'
task :load_jenkins_data, [:job, :path, :hostname] do |t, args|
  puts 'Beginning to Load Data......'
  @jenkins = Jenkins.new(args[:hostname])

  n = 0
  retries = 20
  while n < retries
    n += 1
    if @jenkins.tests_running?
      puts 'Tests are currently running, try again in 5 mins'
      sleep 300
    else
      puts "Loading Data for #{args[:job]}"
      files = {'DryRun' => 'dry_run.json', 'TestRun' => 'report.json'}
      files.each do |key, value|
        results = @jenkins.get_latest_json_results(args[:job], args[:path], value)
        project_run = []
        results.each do |feature|
          feature['elements'].each do |scenario|
            project_run << scenario
          end
        end
        class_name = Object.const_get(key, Class.new)
        test_run = class_name.new(:job => args[:job], :scenarios => project_run)
        test_run.save


      end
      grouped = TestRun.group_failed_scenarios(args[:job])

      if TestRun.failures_in_latest_run(args[:job]).length > 0
        failure = TestRunFailure.new(:failed => grouped, :test_run => args[:job])
        failure.save!
      end
      break
    end
  end

end


