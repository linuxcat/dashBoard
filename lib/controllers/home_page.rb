require 'mongoid'


class HomePage < AppBase

  get '/tag-report' do
    rp = ResultsProcessor.new(params[:id])
    @summary = rp.menu_items
    @tag_groups = rp.get_grouped_tagged(tag_project)
    erb :tag_report
  end

end