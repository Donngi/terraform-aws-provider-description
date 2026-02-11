#---------------------------------------------------------------
# ElastiCache User
#---------------------------------------------------------------
#
# ElastiCache ユーザーリソース。Redis または Valkey エンジン向けの
# Role-Based Access Control (RBAC) を実装するために使用されます。
# ユーザーごとにアクセス権限と認証方式を定義し、ユーザーグループに
# 割り当てることで、キャッシュへの細かいアクセス制御を実現します。
#
# AWS公式ドキュメント:
#   - Role-Based Access Control (RBAC): https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html
#   - Authentication and Authorization: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/auth-redis.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_user
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticache_user" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # (Required) ユーザーのアクセス権限を定義する文字列。
  # どのコマンドとキーにユーザーがアクセスできるかを指定します。
  #
  # 構文例:
  #   - "on ~* +@all" - 全てのキーと全てのコマンドへのアクセス許可（最も緩い設定）
  #   - "on ~app::* -@all +@read" - app:: で始まるキーへの読み取り専用アクセス
  #   - "on ~keys* +get +set +del" - keys で始まるキーに対する特定コマンドの許可
  #
  # アクセス文字列の要素:
  #   - on/off: ユーザーの有効/無効化
  #   - ~<pattern>: キーパターンの指定（例: ~*, ~app::*, ~user:*）
  #   - +@<category>: コマンドカテゴリの許可（例: +@all, +@read, +@write）
  #   - +<command>: 個別コマンドの許可（例: +get, +set）
  #   - -@<category>: コマンドカテゴリの拒否
  #   - -<command>: 個別コマンドの拒否
  #
  # Redis OSS 7.0以降/Valkey 7.2以降でサポートされる追加構文:
  #   - %R~<pattern>: 読み取り専用キーパターン
  #   - %W~<pattern>: 書き込み専用キーパターン
  #   - %RW~<pattern>: 読み書き可能キーパターン（~<pattern>のエイリアス）
  #   - (<rule list>): セレクターの作成（複数の権限セットを定義）
  #   - clearselectors: 全てのセレクターを削除
  #
  # 詳細: https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Clusters.RBAC.html#Access-string
  access_string = "on ~* +@all"

  # (Required) エンジンタイプ。大文字小文字は区別されません。
  # 有効な値: "redis", "valkey"
  #
  # Valkey エンジンの場合:
  #   - VALKEY エンジンタイプのユーザーは、パスワード認証またはIAM認証が必須
  #   - VALKEY ユーザーグループには VALKEY ユーザーと、パスワード/IAM認証を
  #     使用する Redis ユーザーのみを含めることができます
  #
  # Redis OSS エンジンの場合:
  #   - Redis OSS 6.0 から 7.2 がサポート対象
  #   - REDIS ユーザーグループには REDIS エンジンタイプのユーザーのみ使用可能
  engine = "redis"

  # (Required) ユーザーのID。このIDはユーザーを一意に識別します。
  # user_name とは異なり、user_id は AWS リソースの識別子として使用されます。
  #
  # 注意:
  #   - user_id は AWS API で使用される識別子
  #   - user_name は Redis/Valkey エンジンに渡される実際のユーザー名
  #   - 両者を同じ値にすることも、異なる値にすることも可能
  user_id = "example-user-id"

  # (Required) ユーザー名。Redis/Valkey エンジンに渡される実際のユーザー名です。
  #
  # 特別なユーザー名:
  #   - "default": デフォルトユーザー。ElastiCache は自動的に "default" という
  #                ユーザーを作成し、全てのユーザーグループに追加します。
  #                デフォルトユーザーは全てのコマンドと全てのキーへのアクセス権を持ちます。
  #                適切なアクセス制御を実装するには、カスタムの "default" ユーザーを
  #                作成して元のデフォルトユーザーを置き換える必要があります。
  user_name = "example-user-name"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # (Optional) ユーザーの認証モード設定。パスワード認証、パスワード不要、
  # またはIAM認証を設定できます。
  #
  # このブロックを使用しない場合は、トップレベルの passwords または
  # no_password_required 属性を使用します。
  #
  # 注意: authentication_mode ブロックを使用する場合は、トップレベルの
  #       passwords や no_password_required は使用しないでください。
  #       認証設定は authentication_mode ブロック内で完結させます。
  authentication_mode {
    # (Required) 認証タイプ。
    # 有効な値:
    #   - "password": パスワード認証を使用
    #   - "no-password-required": パスワード不要（認証なし）
    #   - "iam": AWS IAM 認証を使用
    #
    # IAM認証の場合:
    #   - ElastiCache for Redis OSS 6.x以降、Valkey 7.2以降でサポート
    #   - IAM ポリシーを使用してきめ細かいアクセス制御が可能
    #   - パスワード管理が不要
    type = "password"

    # (Optional) パスワードのリスト。type が "password" の場合に設定します。
    #
    # 制約:
    #   - 最大2つのパスワードを設定可能
    #   - パスワード長は 16〜128 文字
    #   - 印字可能文字のみ使用可能
    #   - 使用できない文字: , " / @
    #
    # ベストプラクティス:
    #   - 強力なパスワードを使用
    #   - 定期的にパスワードをローテーション
    #   - 2つのパスワードを設定することで、ダウンタイムなしでローテーション可能
    #   - パスワード変更時も既存の接続は維持されます
    #
    # 注意: パスワードは Terraform の state ファイルに平文で保存されます。
    #       機密性の高い環境では、AWS Secrets Manager との統合を検討してください。
    passwords = ["password1", "password2"]
  }

  # (Optional) このユーザーにパスワードが不要であることを示すフラグ。
  # true に設定すると、パスワードなしで認証が可能になります。
  #
  # セキュリティ上の注意:
  #   - 本番環境では使用を避けるべき設定
  #   - テスト環境や開発環境でのみ使用を推奨
  #   - authentication_mode ブロックを使用する場合は、このフィールドではなく
  #     authentication_mode.type = "no-password-required" を使用してください
  #
  # 注意: authentication_mode ブロックと同時に使用することはできません。
  no_password_required = false

  # (Optional) このユーザーに使用するパスワードのリスト。
  # 最大2つのパスワードを設定できます。
  #
  # 制約:
  #   - パスワード長は 16〜128 文字
  #   - 印字可能文字のみ使用可能
  #   - 使用できない文字: , " / @
  #
  # パスワードローテーション:
  #   - 2つのパスワードを設定することで、ダウンタイムなしでローテーション可能
  #   - 手順: 1) 2つ目のパスワード追加 → 2) クライアント更新 → 3) 古いパスワード削除
  #   - パスワード変更時も既存の接続は維持されます
  #
  # セキュリティ:
  #   - パスワードは Terraform の state ファイルに平文で保存されます
  #   - 機密性の高い環境では、AWS Secrets Manager との統合を検討
  #   - 詳細: https://www.terraform.io/docs/state/sensitive-data.html
  #
  # 注意: authentication_mode ブロックと同時に使用することはできません。
  #       どちらか一方を使用してください。
  passwords = ["password123456789"]

  # (Optional) このリソースが管理されるAWSリージョン。
  # 指定しない場合は、プロバイダー設定のリージョンが使用されます。
  #
  # 使用例:
  #   - マルチリージョン構成で特定のリージョンにリソースを作成する場合
  #   - プロバイダーのデフォルトリージョンと異なるリージョンを指定する場合
  #
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

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
    Name        = "example-elasticache-user"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # (Optional) タイムアウト設定。リソース操作のタイムアウト時間を指定します。
  timeouts {
    # (Optional) ユーザー作成のタイムアウト時間。
    # デフォルト: 5分
    # 形式: "60s", "5m", "1h"
    create = "5m"

    # (Optional) ユーザー削除のタイムアウト時間。
    # デフォルト: 5分
    delete = "5m"

    # (Optional) ユーザー情報読み取りのタイムアウト時間。
    # デフォルト: 5分
    read = "5m"

    # (Optional) ユーザー更新のタイムアウト時間。
    # デフォルト: 5分
    update = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースからエクスポートされる属性（computed属性）:
#
# - arn: 作成された ElastiCache ユーザーの Amazon Resource Name (ARN)。
#        形式: arn:aws:elasticache:region:account-id:user:user-id
#        他のリソースでこのユーザーを参照する際に使用します。
#
# 使用例:
#   output "user_arn" {
#     value = aws_elasticache_user.example.arn
#   }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存の ElastiCache ユーザーをインポートする場合:
#
# terraform import aws_elasticache_user.example userId
#
# 例:
# terraform import aws_elasticache_user.example my-user-id
#---------------------------------------------------------------
