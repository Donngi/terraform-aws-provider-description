#-------
# aws_connect_user
#-------
# 用途: Amazon Connectインスタンス内でユーザーアカウントを作成・管理するリソース
# 補足: エージェントやマネージャーなどのユーザーを定義し、セキュリティプロファイルやルーティングプロファイルを割り当てます
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/connect_user
# Generated: 2026-02-13
# AWS Provider Version: 6.28.0
# NOTE: このテンプレートはAWS Provider 6.28.0のスキーマから生成されています

#-------
# 基本設定
#-------

resource "aws_connect_user" "example" {
  # 設定内容: Amazon Connectインスタンスの一意識別子
  # 補足: ユーザーが作成されるConnectインスタンスを指定します
  instance_id = "aaaaaaaa-bbbb-cccc-dddd-111111111111"

  # 設定内容: ユーザーのログイン名（一意識別子）
  # 補足: Connectインスタンス内で一意である必要があります
  name = "example-user"

  # 設定内容: ルーティングプロファイルの一意識別子
  # 補足: ユーザーがどのキューや通話ルーティングルールを使用するかを定義します
  routing_profile_id = "12345678-1234-1234-1234-123456789012"

  # 設定内容: セキュリティプロファイルIDのセット
  # 補足: ユーザーに割り当てる権限セットを指定します（複数指定可能）
  security_profile_ids = [
    "12345678-abcd-abcd-abcd-123456789012",
    # "87654321-dcba-dcba-dcba-210987654321", # 複数のセキュリティプロファイルを割り当て可能
  ]

  #-------
  # 電話設定（必須ブロック）
  #-------

  phone_config {
    # 設定内容: 電話デバイスのタイプ
    # 設定可能な値: SOFT_PHONE（ブラウザベースの電話）、DESK_PHONE（物理デスク電話）
    phone_type = "SOFT_PHONE"

    # 設定内容: 通話後の作業時間制限（秒単位）
    # 補足: 通話終了後にエージェントが後処理作業を行う時間を設定します
    # 省略時: 制限なし
    # after_contact_work_time_limit = 60

    # 設定内容: 着信の自動応答を有効化するかどうか
    # 設定可能な値: true（自動応答）、false（手動応答）
    # 省略時: false
    # auto_accept = false

    # 設定内容: デスク電話の電話番号
    # 補足: phone_typeがDESK_PHONEの場合に必要です（E.164形式を推奨）
    # 省略時: 未設定
    # desk_phone_number = "+819012345678"
  }

  #-------
  # ユーザー認証・階層設定
  #-------

  # 設定内容: ディレクトリサービス内のユーザーID
  # 補足: AWS Directory ServiceやSAML統合を使用する場合に指定します
  # 省略時: 未設定（Connect内部認証を使用）
  directory_user_id = null

  # 設定内容: ユーザーの階層グループID
  # 補足: 組織階層内での位置を定義します（レポート作成や管理用）
  # 省略時: 階層未割り当て
  hierarchy_group_id = null

  # 設定内容: ユーザーのパスワード
  # 補足: Connect内部認証を使用する場合に必要です（外部認証では不要）
  # 省略時: パスワード未設定（外部認証またはリセット必要）
  password = null

  # 設定内容: リソースが管理されるAWSリージョン
  # 補足: 省略時はプロバイダー設定のリージョンが使用されます
  # 省略時: プロバイダー設定のリージョン
  region = null

  #-------
  # 個人情報設定
  #-------

  identity_info {
    # 設定内容: ユーザーの名
    # 補足: Connectコンソールや通話履歴に表示される名前です
    # 省略時: 未設定
    # first_name = "太郎"

    # 設定内容: ユーザーの姓
    # 補足: Connectコンソールや通話履歴に表示される名前です
    # 省略時: 未設定
    # last_name = "山田"

    # 設定内容: ユーザーのメールアドレス
    # 補足: 通知やレポート送信先として使用されます
    # 省略時: 未設定
    # email = "yamada.taro@example.com"

    # 設定内容: セカンダリメールアドレス
    # 補足: 副次的な連絡先として使用可能です
    # 省略時: 未設定
    # secondary_email = "yamada.taro.backup@example.com"
  }

  #-------
  # タグ設定
  #-------

  # 設定内容: リソースに付与するタグ
  # 補足: コスト管理や組織分類に使用します
  # 省略時: タグなし
  tags = {
    Name        = "example-connect-user"
    Environment = "production"
    Team        = "customer-support"
    ManagedBy   = "terraform"
  }
}

#-------
# Attributes Reference（参照可能な属性）
#-------
# このリソースは作成後に以下の属性を参照できます:
#
# - arn: ユーザーのARN（Amazon Resource Name）
#   例: arn:aws:connect:ap-northeast-1:123456789012:instance/aaaaaaaa-bbbb-cccc-dddd-111111111111/agent/user-12345678
#
# - user_id: Connectが生成するユーザーの一意識別子
#   例: 12345678-abcd-1234-abcd-123456789012
#
# - id: Terraformリソース識別子（instance_id:user_id形式）
#   例: aaaaaaaa-bbbb-cccc-dddd-111111111111:12345678-abcd-1234-abcd-123456789012
#
# - tags_all: すべてのタグ（プロバイダーレベルのdefault_tagsとマージされたもの）
#
# 参照方法:
#   aws_connect_user.example.arn
#   aws_connect_user.example.user_id
