# README

## Users テーブル（ユーザー情報）
| カラム名                   | 型       | オプション                     | 説明               |
| ---------------------- | ------- | ------------------------- | ---------------- |
| id                     | integer | primary key               | ユーザーID           |
| nickname               | string  | null: false               | ニックネーム           |
| email                  | string  | null: false, unique\:true | メールアドレス          |
| encrypted\_password    | string  | null: false               | パスワード（devise用）   |
| kanji\_family\_name    | string  | null: false               | 姓（漢字）            |
| kanji\_given\_name     | string  | null: false               | 名（漢字）            |
| katakana\_family\_name | string  | null: false               | 姓（カタカナ）          |
| katakana\_given\_name  | string  | null: false               | 名（カタカナ）          |
| birthday               | date    | null: false               | 生年月日             |
| admin\_flag            | boolean | default: 0                | 管理者フラグ（1\:admin） |
| point                  | integer | null: false, default: 0   | 所持ポイント |

### 📝 注意（2025年5月20日 追記）
ユーザーの所持ポイントを管理するため、`point` カラム（integer）を追加しました。

## Items テーブル（商品情報）
| カラム名            | 型       | オプション              | 説明              |
| --------------- | ------- | ------------------ | --------------- |
| id              | integer | primary key        | 商品ID            |
| category\_id   | integer | null: false        | カテゴリー   |
| name            | string  | null: false        | 商品名             |
| price           | integer | null: false        | 価格              |
| condition\_id  | integer | null: false        | 商品状態    |
| description     | text    | null: false        | 商品説明            |

## Orders テーブル（購入情報）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id              | integer | primary key        | 注文ID                |
| user        | references | null: false, foreign_key: true | 購入者ID（users.id）     |
| item        | references | null: false, foreign_key: true | 購入された商品ID（items.id） |
| used_point | integer | null: false, default: 0 | 購入時に使用されたポイント |
| coupon_assignment | references | **null: true**, foreign_key: true | 購入時に使用されたポイント |

### 📝 注意（2025年5月20日 追記）

- ユーザーが商品購入時に **ポイントを使用できる機能**を追加したことに伴い、`Orders` テーブルに `used_point` カラム（`integer`, `null: false`, `default: 0`）を追加しました。
- これにより、各注文ごとに「使用されたポイント数」を記録できるようになります。

- ユーザーが商品購入時に **クーポンを使用できる機能**を追加したことに伴い、`Orders` テーブルに `coupon_assignment` カラム（`references`, `null: true`）を追加しました。
- ※ nullの場合はクーポンを適用していないということを表す。



## Delivery_adress テーブル（配送先情報）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id    | integer | primary key        | 配送ID                |
| order    | references | null: false, foreign_key: true |  購入情報(order.id)              |
| postal\_code  | string | null: false | 郵便番号          |
| prefecture_id    | integer | null: false | 都道府県 |
| city          | string | null: false | 市区町村          |
| address1      | string | null: false | 番地            |
| building      | string |             | 建物名（任意）       |
| phone\_number | string | null: false | 電話番号          |

# 以下は追加実装するテーブルである(2025/5/20 追記)

## Favorites テーブル（お気に入り登録）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id              | integer | primary key        | お気に入りID                |
| user        | references | null: false, foreign_key: true | お気に入り登録者ID（users.id）     |
| item        | references | null: false, foreign_key: true | お気に入りされた商品ID（items.id） |

### 🔒 ユニーク制約

以下のコードをマイグレーションファイルに追加することで、同一ユーザーによる同一商品の重複登録を防ぐことができます。

```ruby
add_index :favorites, [:user_id, :item_id], unique: true
```

## Notice テーブル（お知らせ）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id              | integer | primary key        | お知らせID                |
| title           | string  | null: false,       | タイトル     |
| content         | text    | null: false,       | 内容 |

## Promotion テーブル（お知らせ）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id              | integer | primary key        | プロモーションID                |
| title           | string  | null: false,       | タイトル     |
| content         | text    | null: false,       | 内容 |
| image           |  ActiveStorage |   ---     | バナー画像 |

※画像は ActiveStorage により別テーブルで管理されるため、カラムとしては含まれません。モデル側で `has_one_attached :image` を定義します。


## Coupon テーブル（クーポン情報）

| カラム名        | 型       | オプション               | 説明                                |
|---------------|----------|--------------------------|-------------------------------------|
| id            | integer  | primary key              | クーポンID                          |
| name          | string   | null: false              | クーポン名                          |
| discount_rate | integer  | null: false              | 割引率（10 → 10%割引）              |
| expires_at    | datetime | null: false              | 有効期限（この日時を過ぎると無効）  |

### 📝 注意

- `discount_rate` は整数型で管理し、`10` とすれば「10%割引」を意味します。
- `expires_at` によって有効期限を設定し、過ぎたクーポンは無効として扱います。
- datetime型は秒数まで扱うことができるが、今回は日付のみの実装とする。


## Coupon_assignment テーブル（ユーザーへのクーポン配布）

| カラム名     | 型         | オプション                          | 説明                                 |
|------------|------------|-----------------------------------|--------------------------------------|
| id         | integer    | primary key                       | 割り当てID                            |
| user       | references | null: false, foreign_key: true    | クーポンを受け取ったユーザー（users.id） |
| coupon     | references | null: false, foreign_key: true    | 割り当てられたクーポン（coupons.id）   |

### 📝 注意

- このテーブルは `users` と `coupons` の **中間テーブル**として機能します。
- クーポンは登録時に全ユーザーに一括で配布されます。
- クーポンが「使用されたかどうか」は `orders` テーブルの `coupon_assignment_id` を参照して判定します。
- `used` フラグ等のカラムは設けず、常に `orders` 経由で計算・判定できる。(使用されたときにそのレコードを消すほうがよい)
- 同じクーポンを同じユーザーに重複登録しないように、次のユニーク制約を加えると安全です：

```ruby
add_index :coupon_assignments, [:user_id, :coupon_id], unique: true
```



# アソシエーションが間違えている可能性がある以下のように修正すべきである(2025/5/20 追記)
## アソシエーション
### Users テーブル
* ~~has_many :items~~
* has_many :orders

### Items テーブル
* ~~belongs_to :user~~
* ~~has_many :orders~~
* has_one :orders

### Orders テーブル
* belongs_to :user
* belongs_to :item
* has_one :delivery_adress

### Delivery_adress テーブル
* belongs_to :order