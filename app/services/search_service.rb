class SearchService
  AVAILABLE_SCOPES = %w[All Question Answer Comment User]
  def self.call(search_model)
    @query = search_model.query
    @resource = search_model.scope

    @resource == 'All' ? ThinkingSphinx.search(@query) : @resource.constantize.search(@query)
  end
end
