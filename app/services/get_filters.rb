class GetFilters

  BASE_URL = ENV["ATLASSIAN_HOST"].freeze

  def call
    url = BASE_URL + "/rest/api/2/filter"
    result = RestClient.get(url, headers)
    result = JSON.parse(result)
    result.inject([]) {|res, i| res << { label: i["name"], value: i["id"]}; res}
  end

  private

  def headers
    { "Authorization" => "Basic #{ENV["API_TOKEN"]}" }
  end
end