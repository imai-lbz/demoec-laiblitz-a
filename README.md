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

## Items テーブル（商品情報）
| カラム名            | 型       | オプション              | 説明              |
| --------------- | ------- | ------------------ | --------------- |
| id              | integer | primary key        | 商品ID            |
| category\_id   | integer | null: false        | 外部キー   |
| name            | string  | null: false        | 商品名             |
| price           | integer | null: false        | 価格              |
| condition\_id  | integer | null: false        | 商品状態    |
| description     | text    | null: false        | 商品説明            |

## Orders テーブル（購入情報）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id              | integer | primary key        | 注文ID                |
| user        | integer | null:false | 購入者ID（users.id）     |
| item        | integer | null:false | 購入された商品ID（items.id） |


## Delivery_adress テーブル（購入情報）
| カラム名            | 型       | オプション              | 説明                  |
| --------------- | ------- | ------------------ | ------------------- |
| id    | integer | primary key        | 配送ID                |
| order    | integer | primary key        |外部キー                |
| postal\_code  | string | null: false | 郵便番号          |
| prefecture_id    | integer | null: false | 都道府県 |
| city          | string | null: false | 市区町村          |
| address1      | string | null: false | 番地            |
| building      | string |             | 建物名（任意）       |
| phone\_number | string | null: false | 電話番号          |


## アソシエーション
### Users テーブル
* has_many :items
* has_many :orders

### Items テーブル
* belongs_to :user
* has_many :orders

### Orders テーブル
* belongs_to :user
* belongs_to :item
* has_one :delivery_adress

### Delivery_adress テーブル
* belongs_to :order