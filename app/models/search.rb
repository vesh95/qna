class Search
  include ActiveModel::Model

  attr_accessor :q, :resource

  validates :resource, inclusion: SearchService::RESOUCES
end
