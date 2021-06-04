# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SbClientDecorator do
  let(:sb_client) { SbClient.new.extend SbClientDecorator }
  subject { sb_client }
  it { should be_a SbClient }
end
