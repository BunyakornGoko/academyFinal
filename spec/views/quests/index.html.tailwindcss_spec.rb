require 'rails_helper'

RSpec.describe "quests/index", type: :view do
  context "with quests" do
    before(:each) do
      @quests = [
        Quest.create!(
          name: "Complete Project",
          status: false,
          created_at: 2.days.ago,
          updated_at: 1.day.ago
        ),
        Quest.create!(
          name: "Learn Rails",
          status: true,
          created_at: 3.days.ago,
          updated_at: 2.days.ago
        )
      ]
      assign(:quests, @quests)
    end

    it "renders the main container and profile section" do
      render
      assert_select "[data-testid='quests-container']"
      assert_select "h2", text: "Bunyakorn Pornsombatpaibool (Goko)"
      assert_select "p", text: "@ Odds"
    end

    it "renders navigation links" do
      render
      assert_select "[data-testid='brags-link']", text: "My Brags"
      assert_select "[data-testid='new-quest-link']", text: "New quest"
    end

    it "renders quest cards with correct information" do
      render

      assert_select "[data-testid='quests-list']" do
        # First quest (incomplete)
        assert_select "[data-testid='quest-card-#{@quests[0].id}']" do
          assert_select "[data-testid='quest-card-name']", text: "Complete Project"
          assert_select "[data-testid='quest-card-status']", text: "In Progress"
          assert_select "[data-testid='quest-delete-button-#{@quests[0].id}']"
          assert_select "input[type=checkbox][checked=checked]", count: 0
        end

        # Second quest (complete)
        assert_select "[data-testid='quest-card-#{@quests[1].id}']" do
          assert_select "[data-testid='quest-card-name']", text: "Learn Rails"
          assert_select "[data-testid='quest-card-status']", text: "Completed"
          assert_select "[data-testid='quest-delete-button-#{@quests[1].id}']"
          assert_select "input[type=checkbox][checked=checked]"
        end

        # Verify timestamps are present
        assert_select "div", /Updated .* ago/
      end
    end
  end

  context "without quests" do
    before(:each) do
      assign(:quests, [])
    end

    it "displays the empty state message" do
      render
      assert_select "[data-testid='no-quests-message']" do
        assert_select "p", text: "No quests found."
        assert_select "p", text: "Click \"New quest\" to create your first quest!"
      end
    end
  end
end
