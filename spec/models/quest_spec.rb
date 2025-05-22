require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:status).in_array([true, false]) }
  end

  describe 'scopes' do
    let!(:active_quest) { create(:quest, status: true) }
    let!(:inactive_quest) { create(:quest, status: false) }

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
      let!(:quest1) { create(:quest, name: 'Learn Ruby') }
      let!(:quest2) { create(:quest, name: 'Learn Rails') }
      let!(:quest3) { create(:quest, name: 'Learn JavaScript') }

      it 'returns quests matching the name pattern' do
        expect(Quest.by_name('Learn')).to include(quest1, quest2, quest3)
        expect(Quest.by_name('Ruby')).to include(quest1)
        expect(Quest.by_name('Rails')).to include(quest2)
        expect(Quest.by_name('JavaScript')).to include(quest3)
      end

      it 'is case insensitive' do
        expect(Quest.by_name('ruby')).to include(quest1)
        expect(Quest.by_name('RAILS')).to include(quest2)
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
        expect {
          inactive_quest.toggle_status!
        }.to change { inactive_quest.status }.from(false).to(true)
      end

      it 'toggles status from true to false' do
        expect {
          active_quest.toggle_status!
        }.to change { active_quest.status }.from(true).to(false)
      end
    end
  end
end
