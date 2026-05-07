class BikeSerializer
  include JSONAPI::Serializer

  attributes :id, :make, :model, :year, :engine_cc, :bike_type, :fuel_type,
             :transmission, :status, :mileage_kmpl, :kms_driven,
             :starting_price, :min_increment, :auction_starts_at,
             :auction_ends_at, :description, :registration_number,
             :rc_state, :created_at

  attribute :current_bid do |bike|
    bike.current_price
  end

  attribute :bids_count do |bike|
    bike.bids.count
  end

  attribute :seller do |bike|
    {
      id: bike.seller_id,
      name: bike.seller.name,
      email: bike.seller.email
    }
  end

  attribute :images do |bike|
    if bike.photos.attached?
      bike.photos.map { |p| Rails.application.routes.url_helpers.rails_blob_url(p, only_path: true) }
    else
      []
    end
  end

  attribute :inspection_report do |bike|
    next nil unless bike.inspection

    {
      id: bike.inspection.id,
      status: bike.inspection.status,
      scheduled_at: bike.inspection.scheduled_at,
      reports: bike.inspection.inspection_reports.map do |r|
        { category: r.category, severity: r.severity, remarks: r.remarks }
      end
    }
  end
end
