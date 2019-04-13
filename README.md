# RaView

## 概要

Instagram のような写真投稿型 SNS を目指して制作しました.

元々は画像や動画によってラーメンの見た目や味を想像・判断し, ぜひ行きたいと思わせるような SNS にしたいと考えていたので, 

Ramen + View ということで, RaView と名付けました.

## デモ

![demo](https://github.com/hayabit/RaView/blob/images/demo.gif)

### Home

![home](https://github.com/hayabit/RaView/blob/images/demo_home.PNG)

- ホームでは Firebase に投稿されているデータを一覧として表示します.
- ハッシュタグを検出して色を変えています.
- スクロールビューを用いて多数の投稿を見られるようにしています.

### Search

![search](https://github.com/hayabit/RaView/blob/images/demo_search.PNG)


実行結果
```
matched documentID : AVIUzoO2064AGe1887nB
caption: フグ #水 #吐く
url: images/20190331003532.jpg
likes: 0
```


- テキストフィールドに入力した単語に対してハッシュタグのデータベースから投稿を検索します.


### Post

![post](https://github.com/hayabit/RaView/blob/images/demo_post.PNG)

- 画面に遷移した際にカメラロールを起動し, 画像を選択することができます.
- 選択後に投稿のためのキャプションを書き投稿することでデータベースに保存します.

## 使用した技術

- Swift(4.2)
- Firestore
- SnapKit
- FontAwesome_swift
- UITextView_Placeholder
- SwiftyAttributedString

## 今後の課題

### Home

- AutoLayout に対応させる
    - 現在の状態では Bottom が決められないためエラーが出てしまうことから, UITableView を用いて Post ごとにセルの大きさを決定することで AutoLayout に対応できるのではないかと考えました.
    - しかし, コードでは UILabel や UITextVIew の画面上の大きさを取得することが思ったより難しく, やはり Storyboard での実装が一番の近道だと考えました.
    - 今回のポートフォリオを作る過程では, 他にもやるべきことがあると考えたので断念したのですが, 今後 Storyboard による実装を行っていきたいと考えています.

- 「いいね」のカウント
  - 現状では「いいね」のボタンだけ設置されており, 押すたびに内部状態が 1 足されるようになっています.
  - これを利用して, 足されるたびに View 上の「いいね」の数を変更したり, データベースのアップデートを行うことも可能だと考えています.

- 画面の更新をする
  - View の最上部で下に引き下げることでデータベースの更新, 画面の更新ができるようにしようと考えています.
  - これは, UIRefreshControll を用いることで可能になるのではないかと考えています.

### Search

- AND 検索ができるようにする
  - Firestore のクエリでは AND 検索をすることができないので, 他の API を使用してできるようにしたいと考えています.

- 検索した後に一致した投稿一覧を表示する
  - Search から Home に値を投げて描画し直すか,
  - そもそも別の View を作成して表示するか悩んでいます.

- オススメのハッシュタグを表示する
  - データベース内のハッシュタグ一覧を取得.
  - それから同一のハッシュタグをカウントし, 多く使われているハッシュタグをオススメとして表示する方法が良いと考えています.

### Post

- 他の View に行こうとした時に下書きを保存できるようにする
  - 下書き用の View もしくはポップアップを作成し, データベースに保存するのが良さそうだと考えています.

- データベースおよびストレージの認証を変更する
  - 開発用でザルのような認証になっていてセキュリティが全く守られていないといっても過言ではないため, Firestore の Firebase Auth, Swift の UserDefaults を使用して認証ができるような仕組みにしたいと考えています.

## 感想

大学の講義, 実習などで数多くプログラミングを行ってきました. しかし, Swift のようなモバイルアプリケーションは初挑戦だったので, 苦戦はしましたが UI 部品がすごく豊富でコードで書いたものが形としてすぐに現れるので, 楽しく制作することができました.

Swift の基本的な動作や Firestore などのモバイル向きと言われている NoSQL の勉強ができたとはいえ, 実際に使うとなると不十分なところが数多くあったり, 触れられていない, 学びきれていない技術がまだまだあるので, さらにブラッシュアップしていきたいと考えています.

## 制作者

南山 駿人
