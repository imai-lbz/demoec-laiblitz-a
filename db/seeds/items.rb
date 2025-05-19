# condition_id: 1~6
# category_id: 1~10

# ids         = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110]
condition_ids = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4]
category_ids  = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
prices      = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]

# 画像は1ファイルを使いまわす
image_path = File.join(File.dirname(__FILE__), 'test_item.png')

10.times do |index|
  item = Item.new(
    name:           "テスト商品A_#{index}",
    price:          prices[index],
    category_id:    category_ids[index],
    condition_id:   condition_ids[index],
    description:    "これはテスト用のテスト商品A_#{index}です。"
  )
  # Active Storage を使って画像を添付
  begin
    file = File.open(image_path, 'rb')
    item.image.attach(io: file, filename: 'test_item.png', content_type: 'image/png')
    item.save!
    file.close

    puts "Created Item: テスト商品A_#{index} with image"
  rescue Errno::ENOENT => e
    puts "Error: Image file not found at #{image_path}"
    puts e.message
  rescue StandardError => e
    puts "Error attaching image to Item #{index}"
    puts e.message
  end
end