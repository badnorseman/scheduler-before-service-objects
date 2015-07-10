class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  include Bookable
  before_create :skip_confirmation!

  has_and_belongs_to_many :roles

  def administrator?
    roles.exists?(uniquable_name: "administrator")
  end

  def coach?
    roles.exists?(uniquable_name: "coach")
  end

  def client?
    roles.exists?(uniquable_name: "client")
  end
end
