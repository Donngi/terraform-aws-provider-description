# ============================================================================
# AWS CodeStar Connections Host
# ============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
# 注意: このテンプレートは生成時点の情報です。
#       最新の仕様は公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_host
# ============================================================================

# CodeStar Connections Hostリソース
# GitHub Enterprise Server等のサードパーティプロバイダーのインフラを表すホストを作成
#
# 重要な注意事項:
# - ホストは作成後 PENDING 状態になります
# - AWS コンソールでホストプロバイダーとの認証を完了する必要があります
# - 詳細: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-host-setup.html
#
# 公式ドキュメント:
# - API リファレンス: https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
# - トラブルシューティング: https://docs.aws.amazon.com/dtconsole/latest/userguide/troubleshooting-connections.html
resource "aws_codestarconnections_host" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # ホスト名
  # 説明: 作成するホストの名前。AWS アカウント内で一意である必要があります
  # タイプ: string
  # 必須: はい
  name = "example-host"

  # プロバイダーエンドポイント
  # 説明: ホスト作成後に表されるインフラのエンドポイント (URL)
  # タイプ: string
  # 必須: はい
  # 例: "https://github.example.com" (GitHub Enterprise Server の場合)
  provider_endpoint = "https://example.com"

  # プロバイダータイプ
  # 説明: サードパーティのコードリポジトリが設定されている外部プロバイダーの名前
  # タイプ: string
  # 必須: はい
  # 有効な値: "GitHubEnterpriseServer", "GitLabSelfManaged", "Bitbucket"
  # 参考: https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
  provider_type = "GitHubEnterpriseServer"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # リソース管理リージョン
  # 説明: このリソースが管理されるリージョン
  # タイプ: string
  # デフォルト: プロバイダー設定のリージョン
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # ============================================================================
  # VPC設定 (オプション)
  # ============================================================================
  # ホスト用にプロビジョニングされるVPC設定
  # プロバイダータイプがインストールされているインフラがVPCに接続されている必要があります
  #
  # 重要な制約:
  # - 各VPCは一度に1つのホストにのみ関連付けられます
  # - VPCエンドポイント (PrivateLink) が webhook 用に自動作成されます
  # - VPCにはNATゲートウェイまたはアウトバウンドインターネットアクセスが必要です
  #
  # 参考:
  # - VPC エンドポイント: https://docs.aws.amazon.com/dtconsole/latest/userguide/vpc-interface-endpoints.html
  # - トラブルシューティング: https://docs.aws.amazon.com/dtconsole/latest/userguide/troubleshooting-connections.html

  vpc_configuration {
    # セキュリティグループID (必須)
    # 説明: プロバイダータイプがインストールされているインフラに接続された Amazon VPC に
    #       関連付けられているセキュリティグループの ID
    # タイプ: set of string
    # 必須: はい (vpc_configuration ブロック内)
    security_group_ids = ["sg-12345678"]

    # サブネットID (必須)
    # 説明: プロバイダータイプがインストールされているインフラに接続された Amazon VPC に
    #       関連付けられているサブネットの ID
    # タイプ: set of string
    # 必須: はい (vpc_configuration ブロック内)
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # VPC ID (必須)
    # 説明: プロバイダータイプがインストールされているインフラに接続された Amazon VPC の ID
    # タイプ: string
    # 必須: はい (vpc_configuration ブロック内)
    vpc_id = "vpc-12345678"

    # TLS証明書 (オプション)
    # 説明: プロバイダータイプがインストールされているインフラに関連付けられた
    #       Transport Layer Security (TLS) 証明書の値
    # タイプ: string
    # デフォルト: null
    # tls_certificate = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
  }

  # ============================================================================
  # タイムアウト設定 (オプション)
  # ============================================================================
  # リソース操作のタイムアウト時間を設定

  timeouts {
    # 作成タイムアウト
    # 説明: ホスト作成のタイムアウト時間
    # タイプ: string
    # デフォルト: デフォルト値が適用されます
    # 例: "30m" (30分)
    # create = "30m"

    # 更新タイムアウト
    # 説明: ホスト更新のタイムアウト時間
    # タイプ: string
    # デフォルト: デフォルト値が適用されます
    # 例: "30m" (30分)
    # update = "30m"

    # 削除タイムアウト
    # 説明: ホスト削除のタイムアウト時間
    # タイプ: string
    # デフォルト: デフォルト値が適用されます
    # 例: "30m" (30分)
    # delete = "30m"
  }
}

# ============================================================================
# 出力例
# ============================================================================
# このリソースは以下の属性を出力します (computed のみ、入力不可):

# output "host_id" {
#   description = "CodeStar Host ARN (リソース ID と同じ)"
#   value       = aws_codestarconnections_host.example.id
# }

# output "host_arn" {
#   description = "CodeStar Host の ARN"
#   value       = aws_codestarconnections_host.example.arn
# }

# output "host_status" {
#   description = "ホストのステータス (PENDING, AVAILABLE, VPC_CONFIG_DELETING, VPC_CONFIG_INITIALIZING, VPC_CONFIG_FAILED_INITIALIZATION)"
#   value       = aws_codestarconnections_host.example.status
# }

# ============================================================================
# 使用例: GitHub Enterprise Server ホスト (VPC設定あり)
# ============================================================================
# resource "aws_codestarconnections_host" "github_enterprise" {
#   name              = "github-enterprise-host"
#   provider_endpoint = "https://github.example.com"
#   provider_type     = "GitHubEnterpriseServer"
#
#   vpc_configuration {
#     security_group_ids = ["sg-0123456789abcdef0"]
#     subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
#     vpc_id             = "vpc-0123456789abcdef0"
#     tls_certificate    = file("${path.module}/certs/github-enterprise.crt")
#   }
# }

# ============================================================================
# 使用例: GitLab Self-Managed ホスト
# ============================================================================
# resource "aws_codestarconnections_host" "gitlab_selfmanaged" {
#   name              = "gitlab-host"
#   provider_endpoint = "https://gitlab.example.com"
#   provider_type     = "GitLabSelfManaged"
# }

# ============================================================================
# 注意事項とベストプラクティス
# ============================================================================
# 1. ホストは作成後に AWS コンソールで認証を完了する必要があります
# 2. 各 VPC は一度に1つのホストにのみ関連付けられます
# 3. エラー状態のホストと接続は復旧できず、再作成が必要です
# 4. VPC 設定を使用する場合、NAT ゲートウェイまたはアウトバウンドアクセスが必要です
# 5. 2020年11月24日以前に作成されたホストは VPC エンドポイント (PrivateLink) を
#    使用するために削除・再作成が必要な場合があります
