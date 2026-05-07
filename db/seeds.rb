puts "Seeding..."

# Admin
admin = User.find_or_create_by!(email: "admin@bikebid.com") do |u|
  u.name     = "Admin User"
  u.phone    = "9000000000"
  u.password = "password123"
  u.role     = :admin
end
puts "Admin: admin@bikebid.com / password123"

# Technician
tech = User.find_or_create_by!(email: "tech@bikebid.com") do |u|
  u.name     = "Ravi Technician"
  u.phone    = "9000000001"
  u.password = "password123"
  u.role     = :technician
end

# Seller
seller = User.find_or_create_by!(email: "seller@bikebid.com") do |u|
  u.name     = "Raj Seller"
  u.phone    = "9000000002"
  u.password = "password123"
  u.role     = :seller
end

# Buyer
buyer = User.find_or_create_by!(email: "buyer@bikebid.com") do |u|
  u.name     = "Priya Buyer"
  u.phone    = "9000000003"
  u.password = "password123"
  u.role     = :buyer
end

puts "Seeded: seller@bikebid.com, buyer@bikebid.com, tech@bikebid.com (all: password123)"

# Add wallet funds
[seller, buyer].each do |user|
  if user.wallet.balance == 0
    WalletService.new(user.wallet).credit!(50_000, reference: "SEED-#{SecureRandom.hex(4).upcase}")
  end
end

# Sample bikes
if Bike.count == 0
  [
    { make: "Royal Enfield", model: "Classic 350",  year: 2022, engine_cc: 349,  bike_type: :cruiser,  fuel_type: :petrol,   starting_price: 150_000 },
    { make: "Honda",         model: "CB Hornet 2.0",year: 2023, engine_cc: 184,  bike_type: :commuter, fuel_type: :petrol,   starting_price: 120_000 },
    { make: "KTM",           model: "Duke 390",     year: 2023, engine_cc: 373,  bike_type: :sports,   fuel_type: :petrol,   starting_price: 280_000 },
    { make: "Ola",           model: "S1 Pro",       year: 2023, engine_cc: 0,    bike_type: :scooter,  fuel_type: :electric, starting_price: 110_000 },
    { make: "Bajaj",         model: "Pulsar NS200",  year: 2021, engine_cc: 199,  bike_type: :sports,   fuel_type: :petrol,   starting_price: 100_000 },
  ].each do |attrs|
    Bike.create!(
      seller: seller,
      make: attrs[:make], model: attrs[:model], year: attrs[:year],
      engine_cc: attrs[:engine_cc], bike_type: attrs[:bike_type],
      fuel_type: attrs[:fuel_type], transmission: :manual,
      starting_price: attrs[:starting_price], min_increment: 1000,
      auction_starts_at: Time.current,
      auction_ends_at: 7.days.from_now,
      status: :live,
      description: "Well maintained #{attrs[:make]} #{attrs[:model]}",
      registration_number: "KA01#{SecureRandom.hex(2).upcase}"
    )
  end
  puts "Created #{Bike.count} sample bikes"
end

puts "Seed complete!"
