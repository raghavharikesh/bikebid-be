# Bikebid seed data
puts "Seeding bike makes & sample data..."

admin = User.find_or_create_by!(email: "admin@bikebid.app") do |u|
  u.name = "Admin"; u.phone = "9999900000"; u.role = :admin
  u.password = "password123"
end

seller = User.find_or_create_by!(email: "seller@bikebid.app") do |u|
  u.name = "Test Seller"; u.phone = "9000000001"; u.role = :seller
  u.password = "password123"
end

buyer = User.find_or_create_by!(email: "buyer@bikebid.app") do |u|
  u.name = "Test Buyer"; u.phone = "9000000002"; u.role = :buyer
  u.password = "password123"
end

WalletService.new(buyer.wallet).credit!(50_000, reference: "SEED-BUYER-1")

samples = [
  { make: "Royal Enfield", model: "Classic 350", year: 2022, engine_cc: 349, bike_type: :cruiser,    fuel_type: :petrol, starting_price: 110_000 },
  { make: "Yamaha",        model: "R15 V4",      year: 2023, engine_cc: 155, bike_type: :sports,     fuel_type: :petrol, starting_price: 130_000 },
  { make: "Honda",         model: "Activa 6G",   year: 2021, engine_cc: 109, bike_type: :scooter,    fuel_type: :petrol, starting_price: 55_000 },
  { make: "Ola",           model: "S1 Pro",      year: 2023, engine_cc: 0,   bike_type: :electric,   fuel_type: :electric, starting_price: 95_000 },
  { make: "KTM",           model: "Duke 390",    year: 2022, engine_cc: 373, bike_type: :sports,     fuel_type: :petrol, starting_price: 220_000 },
  { make: "Hero",          model: "Splendor+",   year: 2020, engine_cc: 97,  bike_type: :commuter,   fuel_type: :petrol, starting_price: 35_000 },
]

samples.each do |attrs|
  Bike.create!(attrs.merge(
    seller: seller, status: :live, mileage_kmpl: 45.0, kms_driven: 8000,
    auction_starts_at: 1.day.ago, auction_ends_at: 2.days.from_now,
    registration_number: "MH#{rand(10..99)}AB#{rand(1000..9999)}", rc_state: "MH"
  ))
end

puts "✅ Done. Admin: admin@bikebid.app / password123"
