class CommentSerializer < ActiveModel::Serializer
  attributes :text, :created_at, :updated_at, :user
  belongs_to :user
end
