class SearchService
  AVAILABLE_SCOPES = %w[All Question Answer Comment User]
  def self.call(search_model)
    query = search_model.query
    scope = search_model.scope
    klass = AVAILABLE_SCOPES[1..-1].include?(scope) ? scope.constantize : ThinkingSphinx

    klass.search(ThinkingSphinx::Query.escape(query))
  end
end
