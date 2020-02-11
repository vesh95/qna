require 'rails_helper'
require 'rspec_matcher'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }

  it { should validate_url_of(:url) }
end
