#---------------------------------------------------------------
# MemoryDB User
#---------------------------------------------------------------
#
# Amazon MemoryDB for Redis のユーザーリソース。MemoryDB クラスターへの
# アクセス制御を実現するために使用されます。ユーザーは ACL (Access Control
# List) に関連付けられ、クラスターへのアクセス権限を制御します。
#
# AWS公式ドキュメント:
#   - Authenticating users with Access Control Lists (ACLs): https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_user
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_memorydb_user" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) ユーザーのアクセス権限を定義する文字列。
  # どのコマンドとキーにユーザーがアクセスできるかを指定します。
  #
  # 構文例:
  #   - "on ~* &* +@all" - 全てのキー、全てのチャンネル、全てのコマンドへのアクセス許可
  #   - "on ~app::* +@read" - app:: で始まるキーへの読み取り専用アクセス
  #   - "off ~* +@all" - ユーザーを無効化
  #
  # アクセス文字列の要素:
  #   - on/off: ユーザーの有効/無効化
  #   - ~<pattern>: キーパターンの指定（例: ~*, ~app::*, ~user:*）
  #   - &<pattern>: Pub/Sub チャンネルパターンの指定
  #   - +@<category>: コマンドカテゴリの許可（例: +@all, +@read, +@write）
  #   - +<command>: 個別コマンドの許可（例: +get, +set）
  #   - -@<category>: コマンドカテゴリの拒否
  #   - -<command>: 個別コマンドの拒否
  #
  # 詳細: https://docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html
  access_string = "on ~* &* +@all"

  # (Required) MemoryDB ユーザー名。最大40文字。
  # この名前は MemoryDB クラスターへの接続時に使用されます。
  #
  # 特別なユーザー名:
  #   - "default": MemoryDB は自動的に "default" ユーザーを作成します。
  #                このユーザーはパスワードなしで全てのコマンドへのアクセス権を持ちます。
  #                適切なアクセス制御を実装するには、カスタムユーザーを作成し
  #                ACL に追加することを推奨します。
  #
  # 注意: この属性を変更すると、リソースが再作成されます（Forces new resource）。
  user_name = "my-user"

  #---------------------------------------------------------------
  # Required Block - authentication_mode
  #---------------------------------------------------------------

  # (Required) ユーザーの認証設定を定義するブロック。
  # パスワード認証または IAM 認証を選択できます。
  authentication_mode {
    # (Required) 認証タイプ。
    # 有効な値:
    #   - "password": パスワード認証を使用
    #   - "iam": AWS IAM 認証を使用
    #
    # IAM認証の場合:
    #   - AWS IAM を使用してユーザーを認証します
    #   - パスワード管理が不要
    #   - IAM ポリシーを使用してきめ細かいアクセス制御が可能
    type = "password"

    # (Optional) パスワードのセット。type が "password" の場合に設定します。
    #
    # 制約:
    #   - 最大2つのパスワードを設定可能
    #   - パスワードの最小長: 16文字
    #
    # パスワードローテーション:
    #   - 2つのパスワードを設定することで、ダウンタイムなしでローテーション可能
    #   - 手順: 1) 2つ目のパスワード追加 → 2) クライアント更新 → 3) 古いパスワード削除
    #
    # セキュリティ警告:
    #   - パスワードは Terraform の state ファイルに平文で保存されます
    #   - 機密性の高い環境では、AWS Secrets Manager との統合を検討
    #   - 詳細: https://www.terraform.io/docs/state/sensitive-data.html
    passwords = ["YourStrongPassword123!"]
  }

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) このリソースが管理されるAWSリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 使用例:
  #   - マルチリージョン構成で特定のリージョンにリソースを作成する場合
  #   - プロバイダーのデフォルトリージョンと異なるリージョンを指定する場合
  #
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # (Optional) リソースに付与するタグのマップ。
  # キーと値のペアでリソースを分類・管理できます。
  #
  # ベストプラクティス:
  #   - 環境識別（Environment, Stage）
  #   - コスト配分（CostCenter, Project）
  #   - 所有者情報（Owner, Team）
  #   - 自動化（Terraform = "true"）
  #
  # 注意: tags_all は computed 属性であり、設定不要です。
  #       tags_all には、ここで指定したタグとプロバイダーレベルの
  #       default_tags が統合されて含まれます。
  tags = {
    Name        = "example-memorydb-user"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースからエクスポートされる属性（computed属性）:
#
# - id: user_name と同じ値。
#
# - arn: 作成された MemoryDB ユーザーの Amazon Resource Name (ARN)。
#        形式: arn:aws:memorydb:region:account-id:user/user-name
#        他のリソースでこのユーザーを参照する際に使用します。
#
# - minimum_engine_version: このユーザーがサポートされる最小エンジンバージョン。
#
# - authentication_mode.password_count: type が "password" の場合、
#                                       ユーザーに属するパスワードの数。
#
# 使用例:
#   output "user_arn" {
#     value = aws_memorydb_user.example.arn
#   }
#
#   output "user_minimum_engine_version" {
#     value = aws_memorydb_user.example.minimum_engine_version
#   }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存の MemoryDB ユーザーをインポートする場合:
#
# terraform import aws_memorydb_user.example user-name
#
# 例:
# terraform import aws_memorydb_user.example my-user
#---------------------------------------------------------------
