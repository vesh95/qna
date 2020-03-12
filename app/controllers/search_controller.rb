class SearchController < ApplicationController
  def index
    @search = Search.new(search_params)
    @resources = SearchService.call(@search)
  end

  private

  def search_params
    params.require(:search).permit(:q, :resource)
  end
end
