class CreateCoreSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string  :email,              null: false, default: ""
      t.string  :encrypted_password, null: false, default: ""
      t.string  :name,    null: false
      t.string  :phone,   null: false
      t.integer :role,    default: 0, null: false
      t.integer :status,  default: 0, null: false
      t.string  :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true

    create_table :jwt_denylists do |t|
      t.string   :jti, null: false
      t.datetime :exp, null: false
    end
    add_index :jwt_denylists, :jti

    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance,        precision: 12, scale: 2, default: 0
      t.decimal :locked_amount,  precision: 12, scale: 2, default: 0
      t.timestamps
    end

    create_table :transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.integer :kind,   null: false
      t.integer :status, default: 0
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string  :reference, null: false
      t.text    :note
      t.timestamps
    end
    add_index :transactions, :reference, unique: true

    create_table :bike_bundles do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.text   :description
      t.timestamps
    end

    create_table :bikes do |t|
      t.references :seller,      null: false, foreign_key: { to_table: :users }
      t.references :bike_bundle, foreign_key: true
      t.string  :make,  null: false
      t.string  :model, null: false
      t.integer :year,  null: false
      t.integer :engine_cc, null: false
      t.integer :bike_type,    default: 0
      t.integer :fuel_type,    default: 0
      t.integer :transmission, default: 0
      t.integer :status,       default: 0
      t.decimal :mileage_kmpl, precision: 5, scale: 2
      t.integer :kms_driven
      t.decimal :starting_price, precision: 12, scale: 2, null: false
      t.decimal :min_increment,  precision: 8,  scale: 2, default: 100
      t.datetime :auction_starts_at
      t.datetime :auction_ends_at
      t.text    :description
      t.string  :registration_number
      t.string  :rc_state
      t.string  :rejection_reason
      t.timestamps
    end
    add_index :bikes, [:status, :auction_ends_at]

    create_table :bike_images do |t|
      t.references :bike, null: false, foreign_key: true
      t.integer :angle, default: 6
      t.timestamps
    end

    create_table :bids do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bike, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.timestamps
    end
    add_index :bids, [:bike_id, :amount]

    create_table :inspections do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :technician, foreign_key: { to_table: :users }
      t.integer :status, default: 0
      t.datetime :scheduled_at
      t.text     :notes
      t.timestamps
    end

    create_table :inspection_reports do |t|
      t.references :inspection, null: false, foreign_key: true
      t.integer :category, null: false
      t.integer :severity, null: false
      t.text    :remarks
      t.timestamps
    end

    create_table :orders do |t|
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :bike,  null: false, foreign_key: true
      t.decimal  :total_amount, precision: 12, scale: 2, null: false
      t.integer  :status, default: 0
      t.datetime :payment_deadline
      t.timestamps
    end

    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string  :gateway
      t.string  :gateway_ref
      t.decimal :amount, precision: 12, scale: 2
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :line1, :line2, :city, :state, :pincode, :country
      t.timestamps
    end

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer  :kind, default: 0
      t.string   :message
      t.datetime :read_at
      t.timestamps
    end

    create_table :disputes do |t|
      t.references :user,  null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :status, default: 0
      t.text    :reason
      t.text    :resolution
      t.timestamps
    end

    create_table :rto_verifications do |t|
      t.references :bike, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string  :verified_owner
      t.text    :remarks
      t.timestamps
    end

    create_table :service_histories do |t|
      t.references :bike, null: false, foreign_key: true
      t.date   :service_date
      t.string :service_center
      t.text   :work_done
      t.timestamps
    end
  end
end
