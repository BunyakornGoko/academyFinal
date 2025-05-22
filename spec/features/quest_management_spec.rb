require 'rails_helper'

RSpec.describe 'Quest Management', type: :feature, js: true do
  describe 'Quest CRUD operations' do
    it 'allows user to create a new quest' do
      visit new_quest_path
      
      fill_in 'Name', with: 'Epic Adventure Quest'
      check 'Mark as completed'
      
      click_button 'Create Quest'
      
      expect(page).to have_content('Quest was successfully created')
      expect(page).to have_content('Epic Adventure Quest')
    end

    it 'displays quest details' do
      quest = create(:quest, name: 'Existing Quest', status: true)
      
      visit quest_path(quest)
      
      expect(page).to have_content('Existing Quest')
      expect(page).to have_content('Completed')
      expect(page).to have_content('This quest is currently completed')
    end

    it 'allows user to edit a quest' do
      quest = create(:quest, name: 'Old Name', status: false)
      
      visit edit_quest_path(quest)
      
      fill_in 'Name', with: 'Updated Quest Name'
      check 'Mark as completed'
      click_button 'Update Quest'
      
      expect(page).to have_content('Quest was successfully updated')
      expect(page).to have_content('Updated Quest Name')
      expect(page).to have_content('Completed')
    end

    it 'allows user to delete a quest' do
      quest = create(:quest, name: 'Quest to Delete')
      
      visit quest_path(quest)
      
      # Handle the Turbo confirm dialog and delete the quest
      accept_confirm do
        click_button 'Delete quest'
      end
      
      # Verify we're redirected to the index page with success message
      expect(page).to have_current_path(quests_path)
      expect(page).to have_content('Quest was successfully destroyed')
      expect(page).to have_content('No quests found')
    end
  end
end
