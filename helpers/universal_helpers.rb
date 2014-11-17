require 'sinatra/base'
require 'yaml'



module Sinatra

  module EnvironmentConstantHelper


    def tag_project
      environment['tag_project']
    end

    def regression_tag
      environment['tags']['regression_tag']
    end

    def ios_tag
      environment['tags']['ios']
    end

    def android_tag
      environment['tags']['android']
    end


    def get_project_tag(project)
      if project.downcase.include?('ios')
        regression_tag = ios_tag
      elsif project.downcase.include?('android')
        regression_tag = android_tag
      else
        regression_tag = self.regression_tag
      end

      regression_tag
    end


   private

    def environment
      environment = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/test_projects.yml'))
      @selected_environment = environment[ENV['TEST_PROJECT']]
    end

  end

  helpers EnvironmentConstantHelper

end




