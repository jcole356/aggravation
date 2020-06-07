class User < ApplicationRecord
  # Include default devise modules. Others inlucde :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
end
