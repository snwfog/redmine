class TagDescriptor < ActiveRecord::Base
  unloadable

  has_many :tags, dependent: :destroy
  has_many :issues, through: :tags

  validates :description, presence: true, uniqueness: true
  validates :description, format: { with: /^(([A-Za-z0-9]+)[\s]?)+$/, message: "Tag description only allows letters, digits, separated by spaces." }

  before_validation :strip_whitespace

  def strip_whitespace
    self.description = self.description.strip.capitalize
  end
end
