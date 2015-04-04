class Keyword < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.import(file_path)
    CSV.foreach(file_path) do |row|
      create(name: row[0])
    end
  end
end
