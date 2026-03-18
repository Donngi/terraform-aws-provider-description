# aws_opensearch_application
# Amazon OpenSearch Application を管理するリソース
#
# OpenSearch Application は、OpenSearch のデータを操作し、
# OpenSearch リソースを管理するためのユーザーインターフェースを提供する
# OpenSearch Dashboards へのアクセスや、データソースの統合、
# IAM Identity Center によるユーザー認証の統合が可能
#
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_application
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。

#---------------------------------------
# aws_opensearch_application リソース定義
#---------------------------------------

resource "aws_opensearch_application" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: アプリケーション名（一意である必要がある）
  # 設定可能な値: 3〜30文字、英小文字で開始、英小文字・数字・ハイフンのみ使用可能
  # 省略時: 省略不可（必須）
  name = "example-app"

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  # 設定内容: データ暗号化に使用するKMSキーのARN
  # 設定可能な値: 有効なKMSキーのARN
  # 省略時: AWSマネージドキーを使用
  kms_key_arn = null

  # 設定内容: タグ
  # 設定可能な値: キーと値のペア
  # 省略時: タグなし
  tags = {
    Name        = "example-app"
    Environment = "production"
  }

  #---------------------------------------
  # アプリケーション構成設定
  #---------------------------------------

  # OpenSearch Dashboards の管理者ユーザー・グループを設定するブロック
  # 複数のapp_configブロックを指定可能

  app_config {
    # 設定内容: 設定項目のキー
    # 設定可能な値: "opensearchDashboards.dashboardAdmin.users",
    #               "opensearchDashboards.dashboardAdmin.groups"
    # 省略時: 設定なし
    key = "opensearchDashboards.dashboardAdmin.users"

    # 設定内容: 設定キーに対応する値（IAMユーザーARNやグループ名等）
    # 設定可能な値: 1〜4096文字の文字列
    # 省略時: 設定なし
    value = "admin-user"
  }

  # app_config {
  #   key   = "opensearchDashboards.dashboardAdmin.groups"
  #   value = "admin-group"
  # }

  #---------------------------------------
  # データソース設定
  #---------------------------------------

  # アプリケーションにリンクするOpenSearchドメインまたはコレクションを設定するブロック
  # 複数のdata_sourceブロックを指定可能

  data_source {
    # 設定内容: OpenSearchドメインまたはコレクションのARN
    # 設定可能な値: 20〜2048文字のARN文字列
    # 省略時: 設定なし
    data_source_arn = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain"

    # 設定内容: データソースの説明
    # 設定可能な値: 最大1000文字（英数字、アンダースコア、スペース、@#%*+=:?./!- が使用可能）
    # 省略時: 説明なし
    data_source_description = "Primary OpenSearch domain"
  }

  #---------------------------------------
  # IAM Identity Center統合設定
  #---------------------------------------

  # IAM Identity Center（旧AWS SSO）との統合を設定するブロック
  # Identity Center経由でのユーザー認証・認可を実現する

  iam_identity_center_options {
    # 設定内容: IAM Identity Center統合を有効化するか
    # 設定可能な値: true / false
    # 省略時: 設定なし
    enabled = false

    # 設定内容: IAM Identity CenterインスタンスのARN
    # 設定可能な値: 20〜2048文字のARN文字列
    # 省略時: 設定なし（enabled=true時に指定）
    # iam_identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-0123456789abcdef0"

    # 設定内容: Identity Centerアプリケーションに関連付けるIAMロールのARN
    # 設定可能な値: 20〜2048文字のIAMロールARN
    # 省略時: 設定なし（enabled=true時に指定）
    # iam_role_for_identity_center_application_arn = "arn:aws:iam::123456789012:role/opensearch-application-role"
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  timeouts {
    # 設定内容: リソース作成のタイムアウト
    # 設定可能な値: "30s", "5m", "1h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト値
    create = "30m"

    # 設定内容: リソース更新のタイムアウト
    # 設定可能な値: "30s", "5m", "1h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト値
    update = "30m"

    # 設定内容: リソース削除のタイムアウト
    # 設定可能な値: "30s", "5m", "1h" などのDuration文字列
    # 省略時: デフォルトのタイムアウト値
    delete = "30m"
  }
}

#---------------------------------------
# Attributes Reference（参照専用）
#---------------------------------------
# aws_opensearch_application.example.id                                                       - アプリケーションの一意識別子
# aws_opensearch_application.example.arn                                                      - アプリケーションのARN
# aws_opensearch_application.example.endpoint                                                 - アプリケーションのエンドポイントURL
# aws_opensearch_application.example.iam_identity_center_options[0].iam_identity_center_application_arn - Identity Centerアプリケーションの ARN
# aws_opensearch_application.example.tags_all                                                 - 継承タグ含むすべてのタグ
