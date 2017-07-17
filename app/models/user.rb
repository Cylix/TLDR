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

  # associations
  has_many :sources,    dependent: :destroy
  has_many :contents,   dependent: :destroy
  has_many :categories, dependent: :destroy

  # validations
  validates :first_name,  length: { minimum: 2 }, presence: true
  validates :last_name,   length: { minimum: 2 }, presence: true
  validates :email,       format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  def to_s
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

end
