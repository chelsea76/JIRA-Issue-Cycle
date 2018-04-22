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
    result = JSON.parse(result)
    total = result["total"]
    if total < 100
      result["issues"]
    else
      result = result["issues"]
      (0..(total/100)).to_a.each do |i|
        next if i == 0
        result << pagination(i*100)
      end
      result.flatten
    end
  end

  def pagination(start_at)
    url = BASE_URL + SEARCH_URL
    result = RestClient::Request.execute(
      method:  :post,
      url:     url,
      headers: headers,
      payload: search_payload(start_at)
    )
    result = JSON.parse(result)
    result["issues"]
  end

  def search_payload(start_at=0)
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
    params.merge!("expand" => ["changelog"], "maxResults" => '100', "startAt" => start_at).to_json
  end

  private

  def headers
    { "Authorization" => "Basic #{ENV["API_TOKEN"]}",
      'Content-Type'  => 'application/json'
    }
  end

end