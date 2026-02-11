# ============================================================
# Terraform Template: aws_connect_user
# ============================================================
# 生成日: 2026-01-19
# Provider: hashicorp/aws
# Provider Version: 6.28.0
#
# 注意: このテンプレートは生成時点の情報に基づいています。
# 最新の仕様については、必ず公式ドキュメントをご確認ください。
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_user
# ============================================================

# Amazon Connect User Resource
# Amazon Connectインスタンスにユーザーアカウントを作成します。
# ユーザーにはルーティングプロファイル、セキュリティプロファイル、電話設定などが必要です。
#
# 参考:
# - Amazon Connect Getting Started: https://docs.aws.amazon.com/connect/latest/adminguide/amazon-connect-get-started.html
# - User Management: https://docs.aws.amazon.com/connect/latest/adminguide/user-management.html
# - Security Profile Best Practices: https://docs.aws.amazon.com/connect/latest/adminguide/security-profile-best-practices.html

resource "aws_connect_user" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # instance_id (必須)
  # 説明: Amazon Connectインスタンスの識別子
  # タイプ: string
  # Amazon Connectユーザーをホストするインスタンスを指定します
  instance_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # name (必須)
  # 説明: ユーザーアカウントのユーザー名
  # タイプ: string
  # SAMLを使用していない場合: 最大20文字
  # SAMLを使用している場合: 最大64文字 ([a-zA-Z0-9_-.\\@]+)
  name = "example-user"

  # routing_profile_id (必須)
  # 説明: ユーザーのルーティングプロファイル識別子
  # タイプ: string
  # ルーティングプロファイルは、着信・発信コールのルーティング方法を決定します
  # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_RoutingProfile.html
  routing_profile_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # security_profile_ids (必須)
  # 説明: ユーザーのセキュリティプロファイルIDのリスト
  # タイプ: set(string)
  # 最小: 1個、最大: 10個のセキュリティプロファイルIDを指定
  # セキュリティプロファイルはユーザーの権限を定義します
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/assign-security-profile.html
  security_profile_ids = [
    "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  ]

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # directory_user_id (オプション)
  # 説明: IDマネジメントに使用されるディレクトリ内のユーザーアカウント識別子
  # タイプ: string
  # Amazon Connectがディレクトリにアクセスできない場合、この識別子を使用してユーザーを認証します
  # SAML認証を使用している場合にこのパラメータを含めるとエラーが返されます
  # directory_user_id = "directory-user-id"

  # hierarchy_group_id (オプション)
  # 説明: ユーザーの階層グループの識別子
  # タイプ: string
  # ユーザーを組織階層内の特定のグループに割り当てる際に使用
  # hierarchy_group_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # id (オプション)
  # 説明: Terraformリソース識別子
  # タイプ: string
  # 通常は自動生成されるため、明示的に指定する必要はありません
  # フォーマット: <instance_id>:<user_id>
  # id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # password (オプション)
  # 説明: ユーザーアカウントのパスワード
  # タイプ: string (sensitive)
  # Amazon Connect IDマネジメントを使用する場合は必須
  # 外部IDマネジメント（SAML等）を使用する場合は指定するとエラーになります
  # password = "SecurePassword123!"

  # region (オプション)
  # 説明: リソースが管理されるAWSリージョン
  # タイプ: string
  # デフォルト: プロバイダー設定で指定されたリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags (オプション)
  # 説明: ユーザーに適用するタグ
  # タイプ: map(string)
  # リソースの識別、整理、アクセス制御に使用
  # provider default_tagsとマージされます
  tags = {
    Name        = "example-user"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # tags_all (オプション)
  # 説明: すべてのタグ（provider default_tagsを含む）
  # タイプ: map(string)
  # 通常はTerraformによって自動的に管理されるため、明示的に指定する必要はありません
  # tags_all = {}

  # ============================================================
  # ネストブロック: identity_info
  # ============================================================
  # ユーザーのアイデンティティ情報を含むブロック（オプション）
  # 最大: 1ブロック

  identity_info {
    # email (オプション)
    # 説明: ユーザーのメールアドレス
    # タイプ: string
    # SAMLを使用している場合、このパラメータを含めるとエラーが返されます
    # emailの更新はサポートされていますが、セキュリティリスクがあるため、
    # UpdateUserIdentityInfo APIを呼び出せるユーザーを制限することを強く推奨します
    # 参考: https://docs.aws.amazon.com/connect/latest/APIReference/API_UpdateUserIdentityInfo.html
    email = "user@example.com"

    # first_name (オプション)
    # 説明: ユーザーの名（ファーストネーム）
    # タイプ: string
    # Amazon ConnectまたはSAMLを使用している場合は必須
    # 最小長: 1、最大長: 100
    first_name = "John"

    # last_name (オプション)
    # 説明: ユーザーの姓（ラストネーム）
    # タイプ: string
    # Amazon ConnectまたはSAMLを使用している場合は必須
    # 最小長: 1、最大長: 100
    last_name = "Doe"

    # secondary_email (オプション)
    # 説明: セカンダリメールアドレス
    # タイプ: string
    # 存在する場合、メール通知はプライマリメールではなくこのアドレスに送信されます
    # secondary_email = "secondary@example.com"
  }

  # ============================================================
  # ネストブロック: phone_config
  # ============================================================
  # ユーザーの電話設定を含むブロック（必須）
  # 最小: 1ブロック、最大: 1ブロック

  phone_config {
    # phone_type (必須)
    # 説明: 電話タイプ
    # タイプ: string
    # 有効な値: "DESK_PHONE" または "SOFT_PHONE"
    # - DESK_PHONE: 物理的なデスク電話を使用
    # - SOFT_PHONE: ソフトウェアベースの電話（CCP経由）を使用
    phone_type = "SOFT_PHONE"

    # after_contact_work_time_limit (オプション)
    # 説明: After Call Work (ACW) タイムアウト設定（秒単位）
    # タイプ: number
    # 最小値: 0
    # 通話終了後に自動的に次の通話を受け付けるまでの時間
    after_contact_work_time_limit = 60

    # auto_accept (オプション)
    # 説明: 自動応答コールの有効化
    # タイプ: bool
    # trueの場合、利用可能なエージェントは自動的にコンタクトに接続されます
    auto_accept = false

    # desk_phone_number (オプション)
    # 説明: ユーザーのデスク電話の電話番号
    # タイプ: string
    # phone_typeがDESK_PHONEに設定されている場合は必須
    # E.164形式（例: +81312345678）での指定を推奨
    # desk_phone_number = "+81312345678"
  }
}

# ============================================================
# Outputs (出力例)
# ============================================================

# output "user_arn" {
#   description = "Amazon Connect ユーザーのARN"
#   value       = aws_connect_user.example.arn
# }

# output "user_id" {
#   description = "ユーザーの識別子"
#   value       = aws_connect_user.example.user_id
# }

# output "user_full_id" {
#   description = "インスタンスIDとユーザーIDを含む完全な識別子"
#   value       = aws_connect_user.example.id
# }
