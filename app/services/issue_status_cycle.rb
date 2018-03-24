class IssueStatusCycle < Dry::Struct
  constructor_type :schema

  attribute :issue, Types::Class

  BASE_URL = ENV["ATLASSIAN_HOST"].freeze

  def call
    url = BASE_URL + "/rest/api/2/issue/#{issue.id}?expand=changelog"
    result = RestClient.get(url, headers)
    result = JSON.parse(result)
    build_issue(result)
  end

  def build_issue(result)
    issue.subtasks = result["fields"]["subtasks"].inject([]){|res, st| res << st["key"]; res}
    issue.cycle = GetTransition.new(changelog: result["changelog"], status: result["fields"]["status"]["name"], created: result["fields"]["created"]).call#build_status_tracker(result["changelog"], result["fields"]["status"]["name"], result["fields"]["created"])
    issue
  end

  private

  def headers
    { "Authorization" => "Basic #{ENV["API_TOKEN"]}" }
  end

end