require 'sinatra/base'
require 'yaml'



module Sinatra

  module EnvironmentConstantHelper


    def tag_project
      environment['tag_project']
    end

    def regression_tag
      environment['regression_tag']
    end


   private

    def environment
      environment = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../config/test_projects.yml'))
      @selected_environment = environment[ENV['TEST_PROJECT']]
    end

  end

  helpers EnvironmentConstantHelper

end

