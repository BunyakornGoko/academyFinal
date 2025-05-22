require 'rails_helper'

RSpec.describe 'Quest Management', type: :feature, js: true do
  describe 'Quest CRUD operations' do
    it 'allows user to create a new quest' do
      visit new_quest_path
      
      fill_in 'Name', with: 'Epic Adventure Quest'
      check 'Status'
      
      click_button 'Create Quest'
      
      expect(page).to have_content('Quest was successfully created')
      expect(page).to have_content('Epic Adventure Quest')
    end

    it 'displays quest details' do
      quest = create(:quest, name: 'Existing Quest', status: true)
      
      visit quest_path(quest)
      
      expect(page).to have_content('Existing Quest')
      expect(page).to have_content('Status: Yes')
    end

    it 'allows user to edit a quest' do
      quest = create(:quest, name: 'Old Name', status: false)
      
      visit edit_quest_path(quest)
      
      fill_in 'Name', with: 'Updated Quest Name'
      check 'Status'
      click_button 'Update Quest'
      
      expect(page).to have_content('Quest was successfully updated')
      expect(page).to have_content('Updated Quest Name')
    end

    it 'allows user to delete a quest' do
      quest = create(:quest, name: 'Quest to Delete')
      
      visit quests_path
      
      within "#quest_#{quest.id}" do
        accept_confirm do
          click_link 'Delete'
        end
      end
      
      expect(page).to have_content('Quest was successfully deleted')
      expect(page).not_to have_content('Quest to Delete')
    end
  end
end
