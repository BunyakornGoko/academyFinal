FactoryBot.define do
  factory :quest do
    name { "Test Quest" }
    status { false }

    trait :active do
      status { true }
    end

    trait :inactive do
      status { false }
    end

    trait :with_long_name do
      name { "This is a very long quest name that might test text wrapping and display limits in the user interface" }
    end

    # Factory for creating multiple quests
    factory :quest_active, traits: [ :active ]
    factory :quest_inactive, traits: [ :inactive ]
  end
end
