# Bikebid 🏍️

A Rails 8 API backend for a **bike auction & bidding marketplace**. Supports petrol bikes, electric bikes (EV), scooters, sports bikes, cruisers, and more.

Inspired by Carbid's architecture — adapted entirely for two-wheelers.

---

## 🚀 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Rails 8 (API mode) |
| Database | PostgreSQL |
| Auth | Devise + JWT |
| Background Jobs | Solid Queue (no Redis required) |
| Cache | Solid Cache |
| Realtime (WebSocket) | Solid Cable / ActionCable |
| Storage | AWS S3 via Active Storage |
| Web Server | Puma + Thruster |
| Deploy | Docker + Kamal |

---

## 🏗️ Core Domain

### Bike Types Supported
- 🛵 **Scooter** (Activa, Jupiter, etc.)
- 🏍️ **Commuter** (Splendor, Platina)
- 🏁 **Sports** (R15, KTM Duke, Ninja)
- 🛤️ **Cruiser** (Royal Enfield, Avenger)
- ⚡ **Electric** (Ola S1, Ather 450, Ultraviolette)
- 🏔️ **Dirt Bike** (KTM EXC, Husqvarna)

### Models (19 core)
`User`, `Bike`, `BikeImage`, `BikeBundle`, `Bid`, `Auction`, `Inspection`, `InspectionReport`, `Wallet`, `Transaction`, `Order`, `Payment`, `Dispute`, `Address`, `Notification`, `Technician`, `AdminUser`, `RtoVerification`, `ServiceHistory`

---

## 💡 Key Features

### 🔨 Bidding Engine
- **10% wallet lock** on every bid (`amount * 0.1`)
- **Anti-snipe**: bid in last 5 min → auction extends by 30 min
- Real-time bid broadcast via ActionCable channel `bike:{id}:bids`
- Min increment validation per bike category

### 💰 Wallet System
Five operations on each transaction:
- `credit` – add funds
- `debit` – withdraw
- `lock` – reserve for active bid
- `unlock` – release when outbid
- `penalty` – forfeit for non-payment

Each transaction gets a unique reference `TRN-XXXXXXXX`.

### 🛒 Order Lifecycle
1. Auction ends → highest bidder becomes winner
2. Order auto-created with **3-day payment window**
3. `UnpurchasedBikeJob` runs daily — forfeits locked deposit as penalty if unpaid
4. On payment success → ownership transferred, seller credited

### 🔍 Inspection System
Bike-specific inspection categories with severity enum:
- `engine_condition`, `chain_sprocket`, `brake_pads`
- `tyre_front`, `tyre_rear`, `suspension`
- `battery_health` (EV only), `body_damage`, `electricals`

Severity: `good` | `minor_wear` | `needs_service` | `needs_replacement`

### 🛡️ Admin Moderation
- Approve/reject bike listings
- Approve withdrawal transactions
- Resolve disputes between buyer & seller
- Ban abusive users

---

## 📡 API Endpoints (overview)

```
POST   /api/v1/auth/sign_up
POST   /api/v1/auth/sign_in
DELETE /api/v1/auth/sign_out

GET    /api/v1/bikes                    # browse listings
POST   /api/v1/bikes                    # seller creates listing
GET    /api/v1/bikes/:id
POST   /api/v1/bikes/:id/bids           # place bid
GET    /api/v1/bikes/:id/bids

GET    /api/v1/wallet
POST   /api/v1/wallet/deposit
POST   /api/v1/wallet/withdraw

GET    /api/v1/orders
POST   /api/v1/orders/:id/pay

POST   /api/v1/inspections/:id/report   # technician submits

# Admin
GET    /api/v1/admin/bikes/pending
POST   /api/v1/admin/bikes/:id/approve
POST   /api/v1/admin/disputes/:id/resolve
```

---

## 🛠️ Setup

```bash
bundle install
rails db:create db:migrate db:seed
rails server
```

Background jobs:
```bash
bin/jobs   # runs Solid Queue worker
```

---

## 🔐 Environment Variables

```
DATABASE_URL=postgres://...
DEVISE_JWT_SECRET_KEY=...
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_BUCKET=bikebid-uploads
AWS_REGION=ap-south-1
```
