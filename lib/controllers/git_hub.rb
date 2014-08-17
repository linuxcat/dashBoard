require 'octokit'
class GitHubApi

  def initialize
    @git = Octokit::Client.new(:access_token => 'adccff6c50815d0a808d56f80350b003da44c9b1')
  end

  def get_last_three_commits_by_user(user)
    @git.commits('newsinternational/NMQA',"master", :author => user)[0..2]
  end





end



