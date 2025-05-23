class Coupon < ApplicationRecord
  has_many :coupon_assignments, dependent: :destroy
  has_many :users, through: :coupon_assignments # 現時点ではクーポンが削除されることはない
  # todo: 期限切れのクーポンを自動的に削除する機能があると、dbが肥大化しないようになる

  validates :name, presence: true
  validates :discount_rate,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :expires_at, presence: true

  def assign_to_all_users
    User.find_each do |user|
      coupon_assignments.create(user: user)
    end
  end
end
