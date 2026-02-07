class CreateFilings < ActiveRecord::Migration[7.1]
  def change
    create_table :filings do |t|
      t.string  :corporate_name, null: false
      t.string  :filing_type
      t.string  :frequency, null: false     # Monthly / Quarterly / Annually
      t.date   :start_date, null: false
      t.date   :paused_at, :date
    
      # recurrence rules
      t.integer :day_of_month               # 1–31 (monthly + annual)
      t.integer :month_of_year              # 1–12 (annual only)
    
      t.decimal :cost, precision: 10, scale: 2, default: 0
    
      # external system details (stored once)
      t.string  :website
      t.string  :site_user_id
      t.string  :site_password
      t.string  :site_email
    
      t.boolean :active, default: true
    
      t.text    :notes
     
    
      t.references :created_by, null: false, foreign_key: { to_table: :users }
    
      t.timestamps
    end
    
  end
end

