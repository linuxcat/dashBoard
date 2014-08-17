require 'rubygems'
require 'mongoid'


require_relative 'lib/controllers/jenkins'
require_relative 'lib/models/mongoid_specs'
Mongoid.load!(File.expand_path(File.join('config', 'mongoid.yml')), :development)

#	ios-ipad-sanity.json
#io7_ipad_regression.json

desc 'load jenkins feature file jason report into mongo'
task :load_json_results_file_from_jenkins_app_team, [:job,:file] do |t, args|
  @jenkins = Jenkins.new('10.198.10.235','ni_test', 'ni_test')
  results = @jenkins.send(:get_latest_json_results,args[:job], args[:file])
  project_run = []
  results.each do |feature|
    feature['elements'].each do |scenario|
      project_run << scenario
    end
  end
  test_run = TestRun.new(:job => args[:job], :scenarios => project_run)
  test_run.save

end


desc 'load jenkins feature file json report for the webteam'
task :load_json_results_file_from_jenkins_web_team, [:job,:path,:file] do |t, args|
  @jenkins = Jenkins.new('10.198.10.3','ni_test', 'ni_test')
  results = @jenkins.send(:get_latest_json_results_wt,args[:job], args[:path], args[:file])
  project_run = []
  results.each do |feature|
    feature['elements'].each do |scenario|
      project_run << scenario
    end
  end
  test_run = TestRun.new(:job => args[:job], :scenarios => project_run)
  test_run.save
 #/job/Sun - IE Tests - Regression/ws/sol-automation/sun-online/src/test/resources/report/
end

desc 'load jenkins dry run report'
task :load_json_dry_run_results_file_from_jenkins_web_team, [:job,:path] do |t, args|
  @jenkins = Jenkins.new('10.198.10.3','ni_test', 'ni_test')
  results = @jenkins.send(:get_latest_json_results_wt,args[:job], args[:path], "dry_run.json")
  project_run = []
  results.each do |feature|
    feature['elements'].each do |scenario|
      project_run << scenario
    end
  end
  test_run = DryRun.new(:job => args[:job], :scenarios => project_run)
  test_run.save
  #/job/Sun - IE Tests - Regression/ws/sol-automation/sun-online/src/test/resources/report/
end





desc 'test'
task :test, [:job] do |t, args|
  puts "args where #{args[:job]}"

end


