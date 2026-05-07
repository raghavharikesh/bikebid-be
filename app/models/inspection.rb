class Inspection < ApplicationRecord
  belongs_to :bike
  belongs_to :technician, class_name: "User", optional: true
  has_many   :inspection_reports, dependent: :destroy

  enum :status, { scheduled: 0, in_progress: 1, completed: 2, cancelled: 3 }

  validates :scheduled_at, presence: true
end
