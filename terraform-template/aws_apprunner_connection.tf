#---------------------------------------------------------------
# AWS App Runner Connection
#---------------------------------------------------------------
#
# AWS App Runnerのコネクションリソースをプロビジョニングします。
# コネクションはGitHubやBitbucketなどのソースコードリポジトリへの接続を
# 表すリソースで、App Runnerサービスがプライベートリポジトリにアクセスする
# 際に必要となります。複数のサービス間で共有することが可能です。
#
# 重要: コネクション作成後、App Runnerコンソールで認証ハンドシェイクを
#       完了する必要があります。
#
# AWS公式ドキュメント:
#   - App Runnerコネクション管理: https://docs.aws.amazon.com/apprunner/latest/dg/manage-connections.html
#   - ソースコードベースのサービス: https://docs.aws.amazon.com/apprunner/latest/dg/service-source-code.html
#   - CreateConnection API: https://docs.aws.amazon.com/apprunner/latest/api/API_CreateConnection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_connection
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apprunner_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # connection_name (Required)
  # 設定内容: コネクションの名前を指定します。
  # 設定可能な値: 4〜32文字の文字列（英数字、ハイフン、アンダースコアのみ使用可能）
  connection_name = "example-connection"

  # provider_type (Required)
  # 設定内容: ソースリポジトリプロバイダーの種類を指定します。
  # 設定可能な値:
  #   - "GITHUB": GitHubリポジトリに接続
  #   - "BITBUCKET": Bitbucketリポジトリに接続
  # 関連機能: App Runner ソースコードリポジトリプロバイダー
  #   App RunnerはGitHubとBitbucketからのソースコードデプロイをサポートしています。
  #   リポジトリの変更を自動的に検出し、新しいバージョンをデプロイできます。
  #   - https://docs.aws.amazon.com/apprunner/latest/dg/service-source-code.html
  provider_type = "GITHUB"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-apprunner-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コネクションのAmazon Resource Name (ARN)
#
# - status: App Runnerコネクションの現在の状態
#   - "PENDING_HANDSHAKE": 認証ハンドシェイク待ち
#   - "AVAILABLE": 利用可能（この状態でaws_apprunner_serviceリソースの作成に使用可能）
#   - "ERROR": エラー状態
#   - "DELETED": 削除済み
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
