class Person < ApplicationRecord
  # ========== Uploaders ==========
  include ImageUploader::Attachment(:image)
  include ImageUploader::Attachment(:headshot)
  include ImageUploader::Attachment(:certification)
  include ImageUploader::Attachment(:resume)

  # ========== Associations ==========
  has_many :event_participants, dependent: :destroy
  has_many :events, through: :event_participants

  has_many :frequent_flyer_numbers, dependent: :destroy
  accepts_nested_attributes_for :frequent_flyer_numbers, allow_destroy: true

  # ========== Scopes ==========
  scope :ordered, -> { order(first_name: :asc) }
  scope :active,   -> { where(status: "Active") }
  scope :inactive, -> { where(status: "Inactive") }
  scope :active_trainers_and_ambassadors, -> {
    where(role: ["Trainer", "Ambassador"], status: "Active").order(:educator_role, :last_name)
  }

  # ========== Validations ==========
  validates :role, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false },
            allow_blank: true

  # ========== Instance Methods ==========
  def full_name
    "#{first_name} #{last_name}"
  end

  def role_full_name
    "#{role} - #{last_name}, #{first_name}"
  end

  def role_full_name_city_state
    [
      educator_role.presence || role,
      full_name,
      self.location.presence,
      #self.state.presence
    ].compact.join(" – ")
  end
end
