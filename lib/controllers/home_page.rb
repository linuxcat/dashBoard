require 'mongoid'


class HomePage < AppBase

  get '/tag-report' do
    rp = ResultsProcessor.new(params[:id])
    @summary = rp.get_summary_data(tag_project)
    @tag_groups = rp.get_grouped_tagged(tag_project)
    erb :tag_report
  end

end