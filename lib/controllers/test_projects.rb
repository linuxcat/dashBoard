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
    regression_tag = get_project_tag(params[:id])
    rp = ResultsProcessor.new(params[:id])
    @tag_groups = rp.get_grouped_tagged(params[:id])
    @summary = rp.get_summary_data(params[:id],regression_tag)

    erb :summary
  end

  get '/:id/detailed_view' do

    regression_tag = get_project_tag(params[:id])
    rp = ResultsProcessor.new(params[:id])
    @total_scenarios = rp.get_total_scenarios_breakdown(params[:id], params[:sortby], regression_tag)
    @summary = rp.get_summary_data(params[:id],regression_tag)
    @pass_percentage = rp.get_pass_percentage(params[:id], params[:sortby])
    @total_manual = rp.get_grouped(params[:id], params[:sortby], 'manual')
    erb :detailed
  end

  get '/tag-report' do
    rp = ResultsProcessor.new(params[:id])
    @tag_groups = rp.get_grouped_tagged(params[:id])
    erb :tag_report
  end





end