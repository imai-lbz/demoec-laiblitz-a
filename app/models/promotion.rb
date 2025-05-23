class Promotion < ApplicationRecord
  has_one_attached :image

  validates :title,   presence: true
  validates :content, presence: true
  validate  :image_attached

  private

  def image_attached
    errors.add(:image, 'を選択してください') unless image.attached?
  end
end
