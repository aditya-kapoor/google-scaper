class Keyword < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :results, dependent: :destroy

  def self.import(file_path)
    CSV.foreach(file_path) do |row|
      keyword = create!(name: row[0])
      ScraperWorker.perform_async(keyword.id, 10)
    end
  end
end
