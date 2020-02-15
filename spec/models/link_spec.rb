require 'rails_helper'
require 'rspec_matcher'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }

  it { should validate_url_of(:url) }

  describe 'gist link' do
    let!(:link) { create(:link, linkable: create(:question), name: 'Gist', url: 'https://gist.github.com/vesh95/14bc353767e214ce7fdf62659692b115') }
    it 'is gist' do
      expect(link).to be_gist
    end

  end

  describe '#gist_id' do
    let!(:gist_link) { build(:link, linkable: create(:question), name: 'Gist', url: 'https://gist.github.com/vesh95/14bc353767e214ce7fdf62659692b115') }
    let!(:link) { build(:link, linkable: create(:question), name: 'Gist', url: 'https://github.com/vesh95/14bc353767e214ce7fdf62659692b115') }

    it 'is gist link' do
      expect(gist_link.gist_id).to eq '14bc353767e214ce7fdf62659692b115'
    end

    it '#gist?' do
      expect(link.gist_id).to eq nil
    end
  end
end
