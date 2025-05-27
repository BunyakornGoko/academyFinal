require 'rails_helper'

RSpec.describe 'Quest Management', type: :feature, js: true do
  describe 'Quest operations' do
    it 'displays empty state when no quests exist' do
      visit quests_path

      expect(page).to have_content('Track my journey and achievements through these quests!')
      expect(page).to have_link('New quest')
    end

    it 'allows user to create a new quest' do
      visit quests_path
      click_link 'New quest'

      fill_in 'Quest Name', with: 'Epic Adventure Quest'
      check 'Mark as completed'

      click_button 'Create Quest'

      expect(page).to have_content('Quest was successfully created')
      expect(page).to have_content('Epic Adventure Quest')
    end

    it 'displays quest in the list' do
      quest = create(:quest, name: 'Existing Quest', status: false)

      visit quests_path

      within("[data-testid='quest-card-#{quest.id}']") do
        expect(page).to have_content('Existing Quest')
        expect(page).to have_css("input[type='checkbox']", visible: true)
      end
    end

    it 'allows toggling quest status', js: true do
      quest = create(:quest, name: 'Toggle Quest', status: false)

      visit quests_path

      within("[data-testid='quest-card-#{quest.id}']") do
        expect(page).not_to have_css('.line-through')
        check('status')
        # Wait for Turbo Stream to complete
        sleep 0.5
        expect(page).to have_css('.line-through')
      end
    end

    it 'allows user to delete a quest', js: true do
      quest = create(:quest, name: 'Quest to Delete')

      visit quests_path

      # Verify quest exists before deletion
      expect(page).to have_content('Quest to Delete')

      # Find and click delete button
      find("button[data-testid='quest-delete-button-#{quest.id}']").click

      # Accept the confirmation dialog
      page.accept_confirm

      # Verify quest is removed
      expect(page).not_to have_content('Quest to Delete')
    end

    it 'validates quest creation' do
      visit quests_path
      click_link 'New quest'

      # Try to create quest without a name
      fill_in 'Quest Name', with: ''
      click_button 'Create Quest'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
