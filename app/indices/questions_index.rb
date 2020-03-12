ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes body
  indexes user.email, as: :author, sortable: true

  has user_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
