class QuestionSerializer < ActiveModel::Serializer
  attributes :title, :body, :created_at, :updated_at
  belongs_to :user
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
