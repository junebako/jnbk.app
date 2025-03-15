require "hashie/mash"

class Nikki
  def initialize(project_name)
    @project_name = project_name
    @scrapbox = Scrapbox.new(project_name)
  end

  def find_by(date: nil)
    title_pattern = Regexp.compile("^#{date} \\w{3} : ")
    pages = @scrapbox.pages(date)
    page = pages.relatedPages&.links1hop&.find { _1.title.match?(title_pattern) }

    raise Nikki::NotFound if page.nil?

    page.url = "https://scrapbox.io/#{@project_name}/" + URI.encode_uri_component(page.title)
    page
  end

  class Scrapbox
    def initialize(project_name)
      @api_base_url = "https://scrapbox.io/api/pages/#{project_name}"
    end

    def pages(query)
      url = @api_base_url + "/#{query}"
      response = Faraday.get(url)
      Hashie::Mash.new(JSON.parse(response.body))
    end
  end

  class NotFound < StandardError; end
end
