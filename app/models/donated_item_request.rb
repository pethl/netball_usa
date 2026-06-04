class DonatedItemRequest < ApplicationRecord
  belongs_to :donated_item

  belongs_to :requested_by,
             class_name: "User"

  belongs_to :approved_by,
             class_name: "User",
             optional: true

  validates :purpose, presence: true
  validates :recipient_name, presence: true
  validates :recipient_phone, presence: true
  validates :delivery_method, presence: true
  validates :date_needed_by, presence: true
  validates :status, presence: true

  validates :delivery_email,
          presence: {
            message: "can't be blank if delivery type is Email"
          },
          if: -> { delivery_method == "Email" }

validates :delivery_name,
          presence: {
            message: "can't be blank if delivery type is Mail"
          },
          if: -> { delivery_method == "Mail/Courier" }

validates :delivery_address,
          presence: {
            message: "can't be blank if delivery type is Mail"
          },
          if: -> { delivery_method == "Mail/Courier" }

end
