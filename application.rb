$:.unshift File.join(__FILE__, '../config')

require 'sinatra/base'
require 'sinatra/json'
require 'mongoid'
require 'bundler/setup'
require 'app_base'
require 'chartkick'
require 'groupdate'
require 'octokit'


require_relative 'lib/controllers/home_page'
require_relative 'lib/controllers/test_projects'


require_relative 'lib/controllers/jenkins'
require_relative 'lib/controllers/results_processor'
require_relative 'lib/controllers/git_hub'
require_relative 'lib/models/mongoid_specs'

#Chartkick.options[:html] = '<div id="%{id}" style="height: %{height};">Loading...</div>'
class SkeletonApp < Sinatra::Base
  set :app_file, __FILE__
  set :views, settings.root + '/views'
end