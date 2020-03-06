class QuestionSerializer < ActiveModel::Serializer
  attributes :title, :body, :created_at, :updated_at
  belongs_to :user
  has_many :comments
  has_many :files
  has_many :links

  def files
    object.files.map do |file|
      { url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end
end
