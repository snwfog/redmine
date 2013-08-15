class Tag < ActiveRecord::Base
  unloadable

  default_scope { includes(:tag_descriptor) }

  belongs_to :issue
  belongs_to :tag_descriptor

  validates :tag_descriptor_id, uniqueness: { scope: [:issue_id, :severity] }

  def description
    self.tag_descriptor.description
  end

  def to_s
    self.tag_descriptor.description if self.tag_descriptor
  end
end

