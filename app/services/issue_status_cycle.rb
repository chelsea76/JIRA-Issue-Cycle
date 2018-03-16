class IssueStatusCycle < Dry::Struct
  attribute :issue_id, Types::String

  BASE_URL = ENV["ATLASSIAN_HOST"].freeze

  def call
    url = BASE_URL + "/rest/api/2/issue/#{issue_id}?expand=changelog"
    result = RestClient.get(url, headers)
    result = JSON.parse(result)
    build_status_tracker(result)
  end

  def build_status_tracker(result)
    issue_status = result["fields"]["status"]["name"]
    issue_created = result["fields"]["created"]
    status_history = []
    result["changelog"]["histories"].each do |his|
      if his["items"].map{|i| i["field"]}.include?("status")
        status_history << his
      end
    end
    if status_history.blank?
      [ { from: result["fields"]["status"]["name"], delta: calculate_delta(Time.now.to_s, issue_created) } ]
    else
      result = status_history.reverse.inject([]) do |res, his|
        status_his = his["items"].select{|i| i["field"] == "status"}
        res << { from: status_his.first["fromString"], to: status_his.first["toString"], date: his["created"]}
      end
      result.each_with_index do |res, i|
        res[:delta] = i == 0 ? calculate_delta(res[:date], issue_created) : calculate_delta(res[:date], result[i-1][:date])
      end
      result << { from: issue_status, delta: calculate_delta(Time.now.to_s, result.last[:date]) }
    end
  end

  def calculate_delta(from_time, to_time)
    delta = (Time.parse(from_time) - Time.parse(to_time))/3600
    if delta > 24.to_f
      time = delta / 24
      "#{time.to_i} Days #{((time - time.to_i)*24).round} Hrs"
    else
      (delta < 1 ? "#{(delta*60).round} Mins" : "#{delta.round} Hrs")
    end
  end

  private

  def headers
    { "Authorization" => "Basic #{ENV["API_TOKEN"]}" }
  end

end