class QuestionsSerializer < ActiveModel::Serializer
  attributes :title, :body, :created_at, :updated_at, :user_id
end
