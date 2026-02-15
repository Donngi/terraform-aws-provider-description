#----------------------------------------------------------------------
# AWS CodeStar Connections Host
#----------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-13
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/codestarconnections_host
#
# NOTE:
# サードパーティプロバイダーがインストールされているインフラストラクチャを表すホストリソース
# GitHub Enterprise Server、GitLab Self-Managed等の自己ホスト型プロバイダーへの接続時に使用
# ホストを作成後、接続リソース（aws_codestarconnections_connection）で参照可能
#
# 主な用途:
# - GitHub Enterprise ServerやGitLab Self-Managedへの接続基盤の構築
# - VPC内にホストされているプロバイダーへのプライベート接続
# - CodePipeline/CodeBuildからのセキュアなソースコード取得
#
# 制約事項:
# - 各VPCは同時に1つのホストにのみ関連付け可能
# - ホスト作成直後のステータスはPENDING（コンソールでのセットアップが必要）
# - エラー状態のホストは復旧不可能（再作成が必要）
#
# AWS公式ドキュメント:
# https://docs.aws.amazon.com/codeconnections/latest/APIReference/API_Host.html
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# 基本設定
#----------------------------------------------------------------------

resource "aws_codestarconnections_host" "example" {
  # ホスト名
  # 設定内容: CodeStar Connectionsホストの識別名
  # 用途: AWSコンソールやCLIでホストを識別する際に使用
  name = "example-host"

  # プロバイダータイプ
  # 設定内容: 接続先のソースコードプロバイダーの種類
  # 設定可能な値:
  #   - GitHubEnterpriseServer: GitHub Enterprise Serverインスタンス
  #   - GitLabSelfManaged: GitLab Self-Managedインスタンス
  #   - Bitbucket: Bitbucketサーバー
  # 用途: 接続先プロバイダーの種類を特定
  provider_type = "GitHubEnterpriseServer"

  # プロバイダーエンドポイント
  # 設定内容: プロバイダーインスタンスのURLまたはエンドポイント
  # 形式: https://ホスト名 の形式で指定
  # 例: https://github.example.com
  # 用途: CodeConnectionsがプロバイダーに接続する際の宛先URL
  provider_endpoint = "https://github.example.com"

  #-----------------------------------------------------------------------
  # VPC設定（オプション）
  #-----------------------------------------------------------------------
  # VPC内にホストされているプロバイダーへの接続設定
  # プライベートネットワーク内のGitHub Enterprise Server等に接続する場合に必要

  # vpc_configuration {
  #   # VPC ID
  #   # 設定内容: プロバイダーがホストされているVPCのID
  #   # 形式: vpc-で始まる12〜21文字の英数字
  #   # 用途: 接続先プロバイダーが配置されているVPCを指定
  #   vpc_id = "vpc-12345678"
  #
  #   # サブネットID
  #   # 設定内容: VPC内のサブネットIDのセット
  #   # 形式: subnet-で始まる15〜24文字の英数字（複数指定可能）
  #   # 用途: プロバイダーへの接続に使用するサブネットを指定
  #   # 推奨: 冗長性のため複数のアベイラビリティーゾーンにまたがるサブネットを指定
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # セキュリティグループID
  #   # 設定内容: VPC接続に関連付けるセキュリティグループIDのセット
  #   # 形式: sg-で始まる11〜20文字の英数字（複数指定可能）
  #   # 用途: プロバイダーへの通信を制御するファイアウォールルール
  #   # 推奨: プロバイダーへのHTTPS（443）通信を許可するルールを設定
  #   security_group_ids = ["sg-12345678"]
  #
  #   # TLS証明書（オプション）
  #   # 設定内容: インフラストラクチャに関連付けられるTLS証明書の内容
  #   # 形式: PEM形式の証明書文字列（1〜16384文字）
  #   # 用途: 自己署名証明書や内部CAで発行された証明書を使用する場合に指定
  #   # 注意: プロバイダーが自己署名証明書を使用している場合に必須
  #   # tls_certificate = file("path/to/certificate.pem")
  # }

  #-----------------------------------------------------------------------
  # リージョン設定（オプション）
  #-----------------------------------------------------------------------

  # リージョン
  # 設定内容: ホストリソースを管理するAWSリージョン
  # 省略時: プロバイダー設定で指定されたリージョンを使用
  # 用途: 特定のリージョンでホストを管理する場合に明示的に指定
  region = "us-west-2"

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # timeouts {
  #   # 作成タイムアウト
  #   # 設定内容: ホスト作成操作の最大待機時間
  #   # 形式: "30m"（分）、"1h"（時間）等
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # create = "30m"
  #
  #   # 更新タイムアウト
  #   # 設定内容: ホスト更新操作の最大待機時間
  #   # 形式: "30m"（分）、"1h"（時間）等
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # update = "30m"
  #
  #   # 削除タイムアウト
  #   # 設定内容: ホスト削除操作の最大待機時間
  #   # 形式: "30m"（分）、"1h"（時間）等
  #   # 省略時: デフォルトのタイムアウト値を使用
  #   # delete = "30m"
  # }
}

#----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#----------------------------------------------------------------------
# ホスト作成後、以下の属性を参照可能
#
# - arn: ホストのAmazon Resource Name（例: aws_codestarconnections_host.example.arn）
# - id: ホストの一意の識別子（ARNと同じ値）
# - status: ホストの現在のステータス
#   - PENDING: セットアップ待ち（コンソールでのセットアップが必要）
#   - AVAILABLE: 使用可能（接続の作成が可能）
#   - VPC_CONFIG_INITIALIZING: VPC設定の初期化中
#   - VPC_CONFIG_DELETING: VPC設定の削除中
#   - VPC_CONFIG_FAILED_INITIALIZATION: VPC設定の初期化失敗
#   - ERROR: エラー状態（復旧不可能、再作成が必要）
#
# 出力例:
# output "host_arn" {
#   value = aws_codestarconnections_host.example.arn
# }
# output "host_status" {
#   value = aws_codestarconnections_host.example.status
# }
