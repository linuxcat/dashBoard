require 'jenkins_api_client'
require 'net/http'
require 'uri'

class Jenkins

  def initialize(hostname)
    @hostname = hostname
  end

  def get_latest_json_results(job, path, file_name)
    url = URI.escape("http://#{@hostname}:8080/job/#{job}#{path}#{file_name}")
    puts url
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth 'ni_test', 'ni_test'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    JSON.parse(res.body)


  end


end


