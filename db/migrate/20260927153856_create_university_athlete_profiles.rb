class CreateUniversityAthleteProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :university_athlete_profiles do |t|
      t.references :person,
                   null: false,
                   foreign_key: true,
                   index: { unique: true }

      t.date :registered_at
      t.boolean :american
      t.string :usa_college
      t.string :final_eligibility

      t.decimal :trial_fee_paid,
                precision: 10,
                scale: 2
      t.decimal :platform_fee,
                precision: 10,
                scale: 2

      t.decimal :net_fee,
                precision: 10,
                scale: 2

      t.boolean :netball_america_experience
      t.text :previous_netball_america_involvement

      t.text :netball_pathway_experience
      t.string :first_position
      t.string :second_position

      t.string :trial_format
      t.string :virtual_trial_footage
      t.text :trial_footage_explanation

      t.text :fast5_experience
      t.string :international_health_insurance
      t.text :emergency_contact

      t.timestamps
    end
  end
end
