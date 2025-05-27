class Quest < ApplicationRecord
  validates :name, presence: true
  validates :status, inclusion: { in: [ true, false ] }

  scope :active, -> { where(status: true) }
  scope :inactive, -> { where(status: false) }
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  def active?
    status == true
  end

  def inactive?
    status == false
  end

  def status_text
    active? ? "Active" : "Inactive"
  end

  def toggle_status!
    update!(status: !status)
  end
end
