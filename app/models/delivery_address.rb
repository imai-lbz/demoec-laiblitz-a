class DeliveryAddress < ApplicationRecord
  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :city
    validates :address1
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid. Input only number' }
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture


  belongs_to :order
end
