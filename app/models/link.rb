class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  
  validates :name, presence: true
  validates :url, url: true
end
