ActiveAdmin.register Result do
  config.filters = false

  actions :all, except: [:destroy, :edit]

  index do
    id_column
    column :adwords_right
    column :adwords_top
    column :total_adwords
    column :non_adwords_links
    column :adwords_right_urls
    column :adwords_top_urls do |result|
      raw(result.adwords_top_urls.collect do |adwords_top_url|
        adwords_top_url
      end.join(', '))
    end
    column :non_adwords_urls do |result|
      raw(result.non_adwords_urls.collect do |non_adwords_url|
        non_adwords_url
      end.join(', '))
    end
    column :total_links
    column :total_results
    column :page_html do |html|
      truncate(html.page_html, omision: "...", length: 100)
    end
    column :keyword
  end

  show do |agent|
    attributes_table do
      row :id
      row :adwords_right
      row :total_adwords
      row :non_adwords_links
      row :adwords_right_urls
      row :adwords_top_urls do |result|
        raw(result.adwords_top_urls.collect do |adwords_top_url|
          adwords_top_url
        end.join('<br />'))
      end
      row :non_adwords_urls do |result|
        raw(result.non_adwords_urls.collect do |non_adwords_url|
          non_adwords_url
        end.join('<br />'))
      end
      row :total_links
      row :total_results
      row :page_html
    end
  end
end
