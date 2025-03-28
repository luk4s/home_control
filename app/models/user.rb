class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable, :timeoutable, :trackable,
         :recoverable, :rememberable, :validatable

  has_one :home, dependent: :destroy

end
