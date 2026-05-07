class InspectionReport < ApplicationRecord
  belongs_to :inspection

  enum :category, {
    engine_condition: 0, chain_sprocket: 1, brake_pads: 2,
    tyre_front: 3, tyre_rear: 4, suspension: 5,
    battery_health: 6, body_damage: 7, electricals: 8,
    exhaust: 9, clutch: 10, lights_indicators: 11
  }

  enum :severity, {
    good: 0, minor_wear: 1, needs_service: 2, needs_replacement: 3
  }

  validates :category, :severity, presence: true
end
