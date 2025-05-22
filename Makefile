.PHONY: all test clean

test:
	bundle exec rspec spec/requests/quests_spec.rb

e2e:
	bundle exec rspec spec/features/quest_management_spec.rb

help:
	@echo "Available targets:"
	@echo "  all         - Default target, runs test"
	@echo "  test        - Runs the quests spec tests"
	@echo "  quest-test  - Alias for test"
	@echo "  clean       - Cleans temporary files"
	@echo "  help        - Shows this help message"
