require 'mongoid'

class HomePage < AppBase

  get '/' do
=begin
    puts params[:job]
    jenkins = Jenkins.new('10.198.10.235','ni_test', 'ni_test')
    @results = jenkins.get_pass_fail(params[:job], params[:results])
    rp = ResultsProcessor.new(params[:job])
    @graph_data = rp.get_column_chart_data_total_scenarios
    @git = GitHubApi.new()

    puts @graph_data.inspect
=end

    erb :homepage
  end


  get '/teams' do

  end


end