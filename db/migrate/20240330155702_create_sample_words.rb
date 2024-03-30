class CreateSampleWords < ActiveRecord::Migration[7.0]
  def change
    create_table :sample_words do |t|
      t.string :category
      t.string :title
      t.text :desc

      t.timestamps
    end
  end
end
