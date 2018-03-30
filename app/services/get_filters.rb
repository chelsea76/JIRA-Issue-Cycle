class GetFilters

  BASE_URL = "https://coupadev.atlassian.net".freeze

  def call
    url = BASE_URL + "/rest/api/2/filter"
    result = RestClient.get(url, headers)
    result = JSON.parse(result)
    result.inject([]) {|res, i| res << { label: i["name"], value: i["id"]}; res}
  end

  private

  def headers
    { "Authorization" => "Basic ZGlwZXNoLnByYWphcGF0aUBjb3VwYS5jb206UXFHQUZoRmhGTUhRV2JNZW1NbEkwQ0Qz" }
  end
end