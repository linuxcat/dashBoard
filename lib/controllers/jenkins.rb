require 'jenkins_api_client'
require 'net/http'
require 'uri'

class Jenkins

  def initialize(server, username, password)
    @client = JenkinsApi::Client.new(:server_ip => server, :username => username, :password => password)
  end

  def get_all_jobs
    @client.job.list_all
  end

  def get_current_job_status(job)
    details = @client.job.list_details(job,'ios-ipad-sanity.json')
    if details['color'] == 'red'
      'Failed'
    else
      'Passed'
    end
  end

  def get_pass_fail(job, file)
    json_results = get_latest_json_results(job,"#{file}.json")
    results = {}
    results[:passed] = []
    results[:failed] = []

    json_results.each do |feature|
      feature['elements'].each do |result|
        result['steps'].each do |r|
          case r['result']['status']
            when 'passed'
              results[:passed] << r['result']['status']
            when 'failed'
              results[:failed] << r['result']['status']
          end
        end
      end
    end
    results
  end

  private
  def get_latest_json_results(job, file_name)
    uri = URI("http://10.198.10.235:8080/job/#{job}/ws/NMQA/features/#{file_name}")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth 'ni_test', 'ni_test'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    JSON.parse(res.body)
  end


  def get_latest_json_results_wt(job, path, file_name)
    url = URI.escape("http://10.198.10.3:8080/job/#{job}#{path}#{file_name}")
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


