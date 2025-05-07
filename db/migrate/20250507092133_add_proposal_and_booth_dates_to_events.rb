class AddProposalAndBoothDatesToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :proposal_submission_due, :date
    add_column :events, :booth_registration_due, :date
  end
end
