ActiveAdmin.register Result do
  index do
    id_column
    column :adwords_right
    column :adwords_top
    column :total_adwords
    column :non_adwords_links
    column :adwords_right_urls
    column :adwords_top_urls
    column :non_adwords_urls
    column :total_links
    column :total_results
    column :page_html do |html|
      truncate(html.page_html, omision: "...", length: 100)
    end
    column :keyword
    actions
  end
end
