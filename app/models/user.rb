class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, :kanji_family_name, :kanji_given_name, :katakana_family_name,
            :katakana_given_name, :birthday, presence: true

  validates :kanji_family_name, :kanji_given_name, format: { with: /\A[ぁ-んァ-ン一-龥々ー]+\z/ }
  validates :katakana_family_name, :katakana_given_name, format: { with: /\A[ァ-ヶー]+\z/ }

  # 半角英数字混合チェック
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates :password, format: { with: VALID_PASSWORD_REGEX }

  has_many :orders,             dependent: :destroy
  has_many :coupon_assignments, dependent: :destroy
  has_many :coupons,            through: :coupon_assignments
  has_many :favorites,          dependent: :destroy

  def admin?
    admin_flag
  end

  def unexpired_coupon_assignments
    coupon_assignments.joins(:coupon).where('coupons.expires_at >= ?', Time.current)
  end
end
