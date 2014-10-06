require 'jenkins_api_client'
require 'net/http'
require 'uri'

class Jenkins

  def initialize(hostname)
    @hostname = hostname
  end

  def get_latest_json_results(job, path, file_name)
    url = get_json_for_job(job, path, file_name)
    response_json = get_json(url)

    JSON.parse(response_json)
  end


  def tests_running?
    url = '/view/Running Tests/api/json'
    runnings_tests = get_json(url)
    json = JSON.parse(runnings_tests)
    !(json['jobs'].size == 0)
  end


  private

  def get_json_for_job(job, path, file_name)
    url = "/job/#{job}#{path}#{file_name}"
  end

  def get_json(url)
    url = URI.escape("http://#{@hostname}:8080#{url}")
    puts url
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth 'ni_test', 'ni_test'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    res.body
  end


end


