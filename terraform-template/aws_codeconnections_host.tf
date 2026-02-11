# ==============================================================================
# AWS CodeConnections Host - 全プロパティ解説付きテンプレート
# ==============================================================================
# 生成日: 2026-01-19
# Provider version: hashicorp/aws 6.28.0
#
# 注意:
#   - このテンプレートは生成時点(2026-01-19)の情報に基づいています
#   - 最新の仕様や詳細は公式ドキュメントを必ず確認してください
#   - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_host
#   - AWS CodeConnections: https://docs.aws.amazon.com/codeconnections/latest/APIReference/Welcome.html
# ==============================================================================

# AWS CodeConnections Host を管理するTerraformリソース
#
# 概要:
#   - サードパーティプロバイダー(GitHub Enterprise Server、GitLab Self-Managed等)が
#     インストールされているインフラストラクチャを表すホストリソース
#   - 作成時のステータスは PENDING で、AWSコンソールでプロバイダーとの認証を完了する必要がある
#   - オンプレミスプロバイダーへの接続を作成する際に必須
#
# 重要:
#   - リソース作成後、AWS Console で認証設定を完了する必要があります
#   - 詳細: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-host-setup.html
#
resource "aws_codeconnections_host" "example" {

  # ==============================================================================
  # 必須パラメータ
  # ==============================================================================

  # name - ホスト名
  # 型: string
  # 必須: Yes
  #
  # 説明:
  #   - 作成するホストの名前
  #   - AWSアカウント内で一意である必要がある
  #
  # 参考: https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
  #
  name = "example-host"

  # provider_endpoint - プロバイダーエンドポイント
  # 型: string
  # 必須: Yes
  #
  # 説明:
  #   - ホスト作成後に表されるインフラストラクチャのエンドポイント
  #   - GitHub Enterprise Server や GitLab Self-Managed のエンドポイントURLを指定
  #   - 例: "https://github.example.com" または "https://gitlab.example.com"
  #
  # 参考: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create-gheserver-cli.html
  #
  provider_endpoint = "https://github.example.com"

  # provider_type - プロバイダータイプ
  # 型: string
  # 必須: Yes
  #
  # 説明:
  #   - サードパーティコードリポジトリが設定されている外部プロバイダーの名前
  #
  # 有効な値:
  #   - "GitHubEnterpriseServer" - GitHub Enterprise Server
  #   - "GitLabSelfManaged"      - GitLab Self-Managed
  #   - "Bitbucket"              - Bitbucket
  #   - "GitHub"                 - GitHub (クラウド版)
  #   - "GitLab"                 - GitLab (クラウド版)
  #   - "AzureDevOps"            - Azure DevOps
  #
  # 注意:
  #   - クラウドプロバイダー(Bitbucket、GitHub、GitLabクラウド版)の場合、ホストの作成は不要
  #   - オンプレミスプロバイダー(GitHubEnterpriseServer、GitLabSelfManaged)の場合に必須
  #
  # 参考: https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
  #
  provider_type = "GitHubEnterpriseServer"

  # ==============================================================================
  # オプションパラメータ
  # ==============================================================================

  # region - AWSリージョン
  # 型: string
  # デフォルト: プロバイダー設定のリージョン
  #
  # 説明:
  #   - このリソースが管理されるリージョン
  #   - 指定しない場合、プロバイダー設定のリージョンが使用される
  #
  # 参考:
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #
  # region = "us-east-1"

  # tags - リソースタグ
  # 型: map(string)
  #
  # 説明:
  #   - ホストに付与するタグのマップ
  #   - コスト管理、リソース整理、アクセス制御などに使用
  #
  # 注意:
  #   - tags_all は自動的に計算されるため設定不要(computed only)
  #   - プロバイダーレベルで設定されたdefault_tagsと自動的にマージされる
  #
  tags = {
    Environment = "production"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }

  # ==============================================================================
  # ネストブロック: vpc_configuration
  # ==============================================================================
  # VPC設定 (オプション)
  #
  # 説明:
  #   - ホスト用にプロビジョニングされるVPC設定
  #   - VPCを設定する必要があり、ホストによって表されるインフラストラクチャは
  #     既にVPCに接続されている必要がある
  #   - プライベートVPCを使用する場合に設定
  #
  # 参考: https://docs.aws.amazon.com/dtconsole/latest/userguide/welcome-hosts-workflow.html
  #
  # vpc_configuration {
  #   # vpc_id - VPC ID
  #   # 型: string
  #   # 必須: Yes (vpc_configurationブロック内)
  #   #
  #   # 説明:
  #   #   - プロバイダータイプがインストールされているインフラストラクチャに
  #   #     接続されているAmazon VPCのID
  #   #
  #   vpc_id = "vpc-12345678"
  #
  #   # subnet_ids - サブネットID
  #   # 型: set(string)
  #   # 必須: Yes (vpc_configurationブロック内)
  #   #
  #   # 説明:
  #   #   - プロバイダータイプがインストールされているインフラストラクチャに
  #   #     接続されているAmazon VPCに関連付けられたサブネットのID
  #   #
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # security_group_ids - セキュリティグループID
  #   # 型: set(string)
  #   # 必須: Yes (vpc_configurationブロック内)
  #   #
  #   # 説明:
  #   #   - プロバイダータイプがインストールされているインフラストラクチャに
  #   #     接続されているAmazon VPCに関連付けられたセキュリティグループのID
  #   #
  #   security_group_ids = ["sg-12345678"]
  #
  #   # tls_certificate - TLS証明書
  #   # 型: string
  #   # オプション
  #   #
  #   # 説明:
  #   #   - プロバイダータイプがインストールされているインフラストラクチャに
  #   #     関連付けられたTransport Layer Security (TLS)証明書の値
  #   #   - プライベートVPCとTLS証明書を使用する場合の制限事項に注意
  #   #
  #   # 参考: https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-ghes.html
  #   #
  #   # tls_certificate = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
  # }

  # ==============================================================================
  # Timeouts設定 (オプション)
  # ==============================================================================
  # リソース操作のタイムアウト設定
  #
  # timeouts {
  #   # create - 作成タイムアウト
  #   # 型: string
  #   #
  #   # 説明:
  #   #   - リソース作成操作のタイムアウト時間
  #   #   - 形式: "30s", "2h45m" など (s=秒, m=分, h=時間)
  #   #
  #   # 参考: https://pkg.go.dev/time#ParseDuration
  #   #
  #   # create = "30m"
  #
  #   # update - 更新タイムアウト
  #   # 型: string
  #   #
  #   # 説明:
  #   #   - リソース更新操作のタイムアウト時間
  #   #   - 形式: "30s", "2h45m" など (s=秒, m=分, h=時間)
  #   #
  #   # update = "30m"
  #
  #   # delete - 削除タイムアウト
  #   # 型: string
  #   #
  #   # 説明:
  #   #   - リソース削除操作のタイムアウト時間
  #   #   - 形式: "30s", "2h45m" など (s=秒, m=分, h=時間)
  #   #   - destroy操作の前に状態に変更が保存される場合にのみ適用される
  #   #
  #   # delete = "30m"
  # }
}

# ==============================================================================
# Computed Attributes (参照のみ、設定不可)
# ==============================================================================
# 以下の属性はTerraformによって自動的に計算されます。
# リソース作成後に参照可能ですが、直接設定することはできません。
#
# - arn
#     型: string
#     説明: CodeConnections ホストのARN
#     例: "arn:aws:codeconnections:us-east-1:123456789012:host/example-host-id"
#
# - id (非推奨)
#     型: string
#     説明: CodeConnections ホストのARN (arn と同じ値、非推奨)
#     注意: このフィールドは非推奨です。代わりに arn を使用してください
#
# - tags_all
#     型: map(string)
#     説明: プロバイダーのdefault_tagsと個別のtagsをマージした全タグ
#
# - status
#     型: string
#     説明: CodeConnections ホストのステータス
#     可能な値:
#       - "PENDING"                      - 保留中(認証待ち)
#       - "AVAILABLE"                    - 利用可能
#       - "VPC_CONFIG_DELETING"          - VPC設定削除中
#       - "VPC_CONFIG_INITIALIZING"      - VPC設定初期化中
#       - "VPC_CONFIG_FAILED_INITIALIZATION" - VPC設定初期化失敗
#
# 参考:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeconnections_host
#   - https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
# ==============================================================================

# ==============================================================================
# 使用例: 出力値の参照
# ==============================================================================
# output "host_arn" {
#   description = "CodeConnections ホストのARN"
#   value       = aws_codeconnections_host.example.arn
# }
#
# output "host_status" {
#   description = "CodeConnections ホストのステータス"
#   value       = aws_codeconnections_host.example.status
# }
# ==============================================================================
