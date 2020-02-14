class Link < ApplicationRecord

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, url: true

  def gist?
    url.match?(%r{^https://gist\.github\.com/.*/.*})
  end

  def gist_id
    return unless gist?
    url.split('/').last
  end
end
