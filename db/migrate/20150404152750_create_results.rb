class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :adwords_right, default: 0
      t.integer :adwords_top, default: 0
      t.integer :total_adwords, default: 0
      t.integer :non_adwords_links, default: 0
      t.text :adwords_right_urls, array: true, default: []
      t.text :adwords_top_urls, array: true, default: []
      t.text :non_adwords_urls, array: true, default: []
      t.integer :total_links, default: 0
      t.integer :total_results, default: 0
      t.text :page_html

      t.belongs_to :keyword
      t.timestamps null: false
    end
  end
end
