class TestProjects < AppBase

  get '/' do
    projects = TestRun.distinct("job")
    json projects
  end


  get '/:id' do
    test_project = TestRun.where(job: params[:id] )
    json test_project
  end



end


class TestRunFailures < AppBase

  get '/:id' do
    failures = TestRunFailure.grouped_failures(params[:id])
    json failures
  end
end