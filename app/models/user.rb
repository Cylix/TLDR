class User < ApplicationRecord

  # devise configuration
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
         # :confirmable,
         # :lockable,
         # :timeoutable,
         # :omniauthable

  # validations
  validates :first_name,  presence: true
  validates :last_name,   presence: true

  def to_s
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

end
