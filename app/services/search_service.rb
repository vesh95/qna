class SearchService
  RESOUCES = %w[All Question Answer Comment User]
  def self.call(search_model)
    @query = search_model.q
    @resource = search_model.resource

    @resource == 'All' ? ThinkingSphinx.search(@query) : @resource.constantize.search(@query)
  end
end
