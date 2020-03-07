class AnswerSerializer < ActiveModel::Serializer
  attributes :body, :created_at, :updated_at, :question_id
  belongs_to :user
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
