
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
    birthday: Date.new(2000, 1, 1)
  )
  puts 'テスト管理者アカウントを作成しました: test@admin.com'
end