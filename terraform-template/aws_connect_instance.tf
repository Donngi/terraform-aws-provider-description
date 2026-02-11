# ================================================================================
# AWS Connect Instance - Annotated Template
# ================================================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_instance
# ================================================================================

resource "aws_connect_instance" "example" {
  # ================================================================================
  # Required Attributes
  # ================================================================================

  # identity_management_type (string, required)
  # インスタンスに紐づけるID管理タイプを指定します。
  # 指定可能な値:
  #   - SAML: SAML 2.0ベースの認証を使用（既存のネットワークIDプロバイダーと連携）
  #   - CONNECT_MANAGED: Amazon Connect内でユーザーを管理
  #   - EXISTING_DIRECTORY: 既存のActive Directoryを使用
  # 注意: インスタンス作成後にID管理タイプは変更できません。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/connect-identity-management.html
  identity_management_type = "CONNECT_MANAGED"

  # inbound_calls_enabled (bool, required)
  # インバウンドコール（受信通話）の有効/無効を指定します。
  # true: インバウンドコールを有効化
  # false: インバウンドコールを無効化
  inbound_calls_enabled = true

  # outbound_calls_enabled (bool, required)
  # アウトバウンドコール（発信通話）の有効/無効を指定します。
  # true: アウトバウンドコールを有効化
  # false: アウトバウンドコールを無効化
  # 注意: アウトバウンドコールを有効化すると、デフォルトで特定の国へ発信可能です。
  #       他の国へ発信する場合はAWSサポートに連絡して許可リストに追加する必要があります。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-outbound-calls.html
  outbound_calls_enabled = true

  # ================================================================================
  # Optional Attributes
  # ================================================================================

  # auto_resolve_best_voices_enabled (bool, optional)
  # 自動ベストボイス解決機能の有効/無効を指定します。
  # デフォルト値: true
  # true: 最適な音声を自動的に選択
  # false: 自動選択を無効化
  auto_resolve_best_voices_enabled = true

  # contact_flow_logs_enabled (bool, optional)
  # コンタクトフローログの有効/無効を指定します。
  # デフォルト値: false
  # true: コンタクトフローのログをCloudWatch Logsに記録
  # false: ログ記録を無効化
  # 注意: ログを有効化するとCloudWatch Logsの料金が発生します。
  contact_flow_logs_enabled = false

  # contact_lens_enabled (bool, optional)
  # Contact Lens（コンタクト分析機能）の有効/無効を指定します。
  # デフォルト値: true
  # true: Contact Lensを有効化（通話・チャット分析、センチメント分析など）
  # false: Contact Lensを無効化
  # 注意: Contact Lensを使用するには、フロー内で「Set recording and analytics behavior」
  #       ブロックを設定する必要があります。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-analytics.html
  contact_lens_enabled = true

  # directory_id (string, optional)
  # 既存ディレクトリのIDを指定します。
  # identity_management_type が EXISTING_DIRECTORY の場合に必要です。
  # AWS Directory Serviceで作成されたディレクトリIDを指定します。
  # 注意: ディレクトリはインスタンスと同じリージョンに存在し、アクティブである必要があります。
  # 例: "d-1234567890"
  # directory_id = "d-1234567890"

  # early_media_enabled (bool, optional)
  # アウトバウンドコールのアーリーメディア（接続前の音声）の有効/無効を指定します。
  # デフォルト値: outbound_calls_enabled が true の場合は true
  # true: エージェントが接続前の音声（呼び出し音、話中音など）を聞ける
  # false: アーリーメディアを無効化
  # 注意: この機能を有効化すると、エージェントは通話接続前の音声フィードバックを受け取れます。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/enable-outbound-calls.html
  early_media_enabled = true

  # id (string, optional, computed)
  # インスタンスのID。
  # 通常は指定不要です（自動生成されます）。
  # id = "example-instance-id"

  # instance_alias (string, optional)
  # インスタンスのエイリアス（わかりやすい名前）を指定します。
  # directory_id を指定しない場合は必須です。
  # 注意: エイリアスは一意である必要があり、グローバルに一意なアクセスURLを生成します。
  #       形式: https://{instance_alias}.my.connect.aws/
  # 例: "my-contact-center"
  instance_alias = "example-connect-instance"

  # multi_party_conference_enabled (bool, optional)
  # マルチパーティ通話/会議機能の有効/無効を指定します。
  # デフォルト値: false
  # true: 複数の参加者（最大6名）が同じ通話セッションに参加可能
  # false: マルチパーティ通話を無効化
  # 注意: この機能を有効化すると、エージェントとカスタマーが複数人で通話に参加できます。
  # 参考: https://docs.aws.amazon.com/connect/latest/adminguide/update-instance-settings.html
  multi_party_conference_enabled = false

  # region (string, optional, computed)
  # このリソースが管理されるリージョンを指定します。
  # デフォルト値: プロバイダー設定のリージョン
  # 通常は指定不要です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # tags (map of strings, optional)
  # インスタンスに適用するタグを指定します。
  # プロバイダーの default_tags と組み合わせて使用できます。
  # 同じキーを持つタグは、リソースレベルのタグがプロバイダーレベルのタグを上書きします。
  tags = {
    Name        = "example-connect-instance"
    Environment = "production"
  }

  # tags_all (map of strings, optional, computed)
  # リソースに割り当てられた全てのタグのマップ。
  # プロバイダーの default_tags から継承されたタグを含みます。
  # 通常は指定不要です（自動的に計算されます）。
  # tags_all = {}

  # ================================================================================
  # Nested Blocks
  # ================================================================================

  # timeouts
  # リソースの作成・削除のタイムアウト設定。
  timeouts {
    # create (string, optional)
    # インスタンス作成のタイムアウト時間。
    # デフォルト値: 5m（5分）
    # 形式: "5m", "30s", "1h" など
    create = "5m"

    # delete (string, optional)
    # インスタンス削除のタイムアウト時間。
    # デフォルト値: 5m（5分）
    # 形式: "5m", "30s", "1h" など
    delete = "5m"
  }
}

# ================================================================================
# Computed-only Attributes (読み取り専用 - 出力として利用可能)
# ================================================================================
# これらの属性はTerraformで自動的に計算され、リソース作成後に参照できます。
# リソース定義内では指定できません。
#
# - arn (string)
#   インスタンスのAmazon Resource Name (ARN)
#   例: arn:aws:connect:us-east-1:123456789012:instance/12345678-1234-1234-1234-123456789012
#
# - created_time (string)
#   インスタンスが作成された日時
#   例: 2024-01-15T10:30:00Z
#
# - service_role (string)
#   インスタンスのサービスロール
#
# - status (string)
#   インスタンスの状態
#   可能な値: CREATION_IN_PROGRESS, ACTIVE, CREATION_FAILED
# ================================================================================

# 使用例（出力として参照）:
# output "connect_instance_arn" {
#   value = aws_connect_instance.example.arn
# }
#
# output "connect_instance_id" {
#   value = aws_connect_instance.example.id
# }
#
# output "connect_instance_status" {
#   value = aws_connect_instance.example.status
# }
