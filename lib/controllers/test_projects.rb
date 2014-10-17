class TestProjects < AppBase

  get '/' do
    projects = TestRun.distinct("job")
    json projects
  end


  get '/:id' do
    test_project = TestRun.where(job: params[:id] )
    json test_project
  end

  get '/:id/dry-run' do
    test_project = DryRun.where(job: params[:id] )
    json test_project
  end

  get '/:id/failed-tests' do
    failures = TestRunFailure.grouped_failures(params[:id])
    json failures
  end

  get '/:id/grouped-status' do
    grouped_status = TestRun.group_by_status(params[:id])
    json grouped_status
  end

  get '/:id/summary' do
    rp = ResultsProcessor.new(params[:id])
    @tag_groups = rp.get_grouped_tagged(params[:id])
    @summary = rp.get_summary_data(params[:id])

    erb :summary
  end

  get '/:id/detailed_view' do
    rp = ResultsProcessor.new(params[:id])
    @total_scenarios = rp.get_total_scenarios_manual(params[:id], params[:sortby], regression_tag)

    puts @total_scenarios
    @summary = rp.get_summary_data(params[:id])
    @pass_percentage = rp.get_pass_percentage(params[:id], params[:sortby])
    @total_manual = rp.get_total_manual_grouped(params[:id], params[:sortby])
    erb :detailed
  end

  get '/tag-report' do
    rp = ResultsProcessor.new(params[:id])
    @tag_groups = rp.get_grouped_tagged(params[:id])
    erb :tag_report
  end





end