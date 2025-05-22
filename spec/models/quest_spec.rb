require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should allow_value(true).for(:status) }
    it { should allow_value(false).for(:status) }
  end

  describe 'scopes' do
    let!(:active_quest) { create(:quest, name: 'Active Quest', status: true) }
    let!(:inactive_quest) { create(:quest, name: 'Inactive Quest', status: false) }

    describe '.active' do
      it 'returns only active quests' do
        expect(Quest.active).to include(active_quest)
        expect(Quest.active).not_to include(inactive_quest)
      end
    end

    describe '.inactive' do
      it 'returns only inactive quests' do
        expect(Quest.inactive).to include(inactive_quest)
        expect(Quest.inactive).not_to include(active_quest)
      end
    end

    describe '.by_name' do
      it 'returns quests matching the name pattern' do
        expect(Quest.by_name('Active')).to include(active_quest)
        expect(Quest.by_name('active')).to include(active_quest)  # Case insensitive
        expect(Quest.by_name('Inactive')).not_to include(active_quest)
      end
    end
  end

  describe 'instance methods' do
    let(:active_quest) { create(:quest, status: true) }
    let(:inactive_quest) { create(:quest, status: false) }

    describe '#active?' do
      it 'returns true for active quests' do
        expect(active_quest.active?).to be true
      end

      it 'returns false for inactive quests' do
        expect(inactive_quest.active?).to be false
      end
    end

    describe '#inactive?' do
      it 'returns true for inactive quests' do
        expect(inactive_quest.inactive?).to be true
      end

      it 'returns false for active quests' do
        expect(active_quest.inactive?).to be false
      end
    end

    describe '#status_text' do
      it 'returns "Active" for active quests' do
        expect(active_quest.status_text).to eq('Active')
      end

      it 'returns "Inactive" for inactive quests' do
        expect(inactive_quest.status_text).to eq('Inactive')
      end
    end

    describe '#toggle_status!' do
      it 'toggles status from false to true' do
        quest = create(:quest, status: false)
        expect { quest.toggle_status! }.to change { quest.status }.from(false).to(true)
      end

      it 'toggles status from true to false' do
        quest = create(:quest, status: true)
        expect { quest.toggle_status! }.to change { quest.status }.from(true).to(false)
      end
    end
  end
end
