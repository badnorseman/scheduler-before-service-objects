class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  before_validation :normalize_name

  # Validate attributes
  validates :name, presence: true, length: { maximum: 50 }
  validates :uniquable_name, uniqueness: true

  private

  def normalize_name
    if name_changed?
      self.uniquable_name = name.underscore.gsub(/[^0-9a-z\\s]/i, "").singularize
    end
  end
end
