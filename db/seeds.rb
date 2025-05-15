# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

unless User.exists?(email: 'test@admin.com')
  User.create!(
    email: 'test@admin.com',
    password: 'passw0rd',
    password_confirmation: 'passw0rd',
    nickname: 'Admin1',
    kanji_family_name: '山田',
    kanji_given_name: '太郎',
    katakana_family_name: 'ヤマダ',
    katakana_given_name: 'タロウ',
    birthday: Date.new(2000, 1, 1),
    admin_flag: true
  )
  puts 'テスト管理者アカウントを作成しました: test@admin.com'
end


# ./seeds/items.rb を読み込む
require_relative './seeds/items.rb'