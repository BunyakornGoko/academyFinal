require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'inherits from ActionMailer::Base' do
    expect(described_class.superclass).to eq(ActionMailer::Base)
  end

  it 'sets default from address' do
    expect(described_class.default[:from]).to eq('from@example.com')
  end

  it 'uses mailer layout' do
    expect(described_class._layout).to eq('mailer')
  end
end 