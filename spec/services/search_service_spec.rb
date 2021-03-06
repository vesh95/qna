require 'rails_helper'

RSpec.describe SearchService do
  context 'calls .search for all resources' do
    let(:search) { Search.new(query: 'Find', scope: 'All') }

    it 'all resources' do
      expect(ThinkingSphinx).to receive(:search).with('Find')

      SearchService.call(search)
    end
  end

  context 'calls .search for other resources' do
    %w[Question Answer Comment User].each do |resource|

      it "#{resource} model" do
        search = Search.new(query: 'query', scope: resource)
        expect(resource.constantize).to receive(:search).with('query')

        SearchService.call(search)
      end
    end
  end
end
