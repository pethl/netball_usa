class AddFeedbackToNetballEducator < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :feedback, :text
  end
end
