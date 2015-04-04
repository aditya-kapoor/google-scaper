class ScraperWorker
  include Sidekiq::Worker

  def perform(keyword_id, count)
    keyword = Keyword.find(keyword_id)

    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get "http://www.google.com/"
    search_form = page.form_with name: "f"
    search_form.field_with(name: "q").value = keyword.name
    search_results = agent.submit search_form

    result = keyword.results.build

    nokogiri_template = Nokogiri::HTML.parse(search_results.content)

    result.adwords_top_urls = search_results.links
                         .select { |link| link.href.start_with?("/aclk") }
                         .collect(&:href)

    result.adwords_top = result.adwords_top_urls.size

    result.total_adwords = result.adwords_top + result.adwords_right

    result.non_adwords_urls = search_results.links
                                            .reject { |link| link.href.start_with?("/") }
                                            .collect(&:href)
    result.non_adwords_links = result.non_adwords_urls.size

    result.total_results = nokogiri_template
                           .at_css('#resultStats')
                           .text
                           .gsub("About ", "")
                           .gsub(" results", "")
                           .gsub(",", "_")
                           .to_i
    result.total_links = search_results.links.count
    result.page_html = search_results.content
    result.save
  end
end
