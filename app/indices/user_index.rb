ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email, sortable: true

  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
