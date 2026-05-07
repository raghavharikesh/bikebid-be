class InspectionSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :scheduled_at, :notes, :created_at

  attribute :inspection_number do |inspection|
    "INS-#{inspection.id.to_s.rjust(6, '0')}"
  end

  attribute :bike do |inspection|
    {
      id: inspection.bike_id,
      make: inspection.bike.make,
      model: inspection.bike.model,
      year: inspection.bike.year,
      registration_number: inspection.bike.registration_number
    }
  end

  attribute :technician do |inspection|
    next nil unless inspection.technician

    {
      id: inspection.technician_id,
      name: inspection.technician.name,
      email: inspection.technician.email,
      phone: inspection.technician.phone
    }
  end

  attribute :reports do |inspection|
    inspection.inspection_reports.map do |r|
      {
        id: r.id,
        category: r.category,
        severity: r.severity,
        remarks: r.remarks
      }
    end
  end
end
