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

    nokogiri_html = Nokogiri::HTML.parse(search_results.content)

    keyword_search_result = keyword.build_search_result
    total_adwords_links_present_on_page = search_results.links
                                            .select  { |link| link.href.start_with?('/aclk') }
                                            .collect { |link| make_link(link.text, link.href) }

    # We might not get the right hand side results, we will be obtaining all the special
    # links first and then deducting those on right hand side.
    keyword_search_result.adwords_right_urls = Array(nokogiri_html.at_css('div#rhs_block')
                                                    .try(:children).try(:css, 'h3 a')).collect do |link|
                                                      make_link(link.text, link.attributes['href'].value)
                                                    end

    keyword_search_result.adwords_top_urls = total_adwords_links_present_on_page - keyword_search_result.adwords_right_urls

    keyword_search_result.adwords_right = keyword_search_result.adwords_right_urls.size
    keyword_search_result.adwords_top = keyword_search_result.adwords_top_urls.size
    keyword_search_result.total_adwords = keyword_search_result.adwords_top + keyword_search_result.adwords_right
    keyword_search_result.non_adwords_urls = search_results.links
                                            .select  { |link| link.href.start_with?('/url') }
                                            .collect { |link| make_link(link.text, link.href) }
    keyword_search_result.non_adwords_links = keyword_search_result.non_adwords_urls.size
    keyword_search_result.total_results = nokogiri_html.at_css('#resultStats').text
                                            .gsub("About ", "").gsub(" results", "")
                                            .gsub(",", "_").to_i
    keyword_search_result.total_links = search_results.links.count
    keyword_search_result.page_html = search_results.content
    keyword_search_result.save
  end

  private
    def make_link(link_text, link_url)
      "<a href=#{ URI.unescape(link_url) }> #{ link_text } </a>".html_safe
    end
end
