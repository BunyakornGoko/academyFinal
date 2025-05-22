.PHONY: all test clean

rspec:
	bundle exec rspec 

unit:
	bundle exec rspec spec/models spec/controllers spec/helpers spec/mailers spec/jobs spec/routing

e2e:
	bundle exec rspec spec/features/quest_management_spec.rb

db-up:
	docker compose up -d

db-down:
	docker compose down

help:
	@echo "Available targets:"
	@echo "  all         - Default target, runs test"
	@echo "  test        - Runs the quests spec tests"
	@echo "  quest-test  - Alias for test"
	@echo "  clean       - Cleans temporary files"
	@echo "  help        - Shows this help message"
