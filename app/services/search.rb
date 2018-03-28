class Search < Dry::Struct
  constructor_type :schema

  attribute :payload, Types::Hash

  BASE_URL = ENV["ATLASSIAN_HOST"].freeze
  FILTER_URL = "/rest/api/2/filter/".freeze
  SEARCH_URL = "/rest/api/2/search".freeze

  def call
    results
  end

  def results
    url = BASE_URL + SEARCH_URL
    result = RestClient::Request.execute(
      method:  :post,
      url:     url,
      headers: headers,
      payload: search_payload
    )
    JSON.parse(result)
  end

  def search_payload
    if self.payload[:filter_id].present?
      url = BASE_URL + FILTER_URL + self.payload[:filter_id]
      result = RestClient.get(url, headers)
      result = JSON.parse(result)
      search_url = result["searchUrl"]
      uri    = URI.parse(search_url)
      params  = CGI.parse(uri.query)
      params["jql"] = params["jql"].first
    elsif self.payload[:issue_id].present?
      params = {}
      params["jql"] = "issue = '#{self.payload[:issue_id]}'"
    end
    params.merge!("expand" => ["changelog"], "maxResults" => '150').to_json
  end

  private

  def headers
    { "Authorization" => "Basic #{ENV["API_TOKEN"]}",
      'Content-Type'  => 'application/json'
    }
  end

end