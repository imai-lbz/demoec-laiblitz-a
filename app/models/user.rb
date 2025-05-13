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

  def is_admin?
    # admin_flag
    # TODO admin_flagカラムを追加したのちにコードを書き換える必要がある
    # 現時点では全員が管理者であるような挙動になる
    true
  end
end
