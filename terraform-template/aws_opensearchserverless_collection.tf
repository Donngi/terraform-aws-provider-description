#---------------------------------------------------------------
# Amazon OpenSearch Serverless Collection
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessコレクションを作成します。
# コレクションは、1つまたは複数のインデックスをグループ化した論理的な単位で、
# 分析ワークロードを表します。OpenSearch Serverlessは自動的にコレクションを
# 管理・調整するため、手動での設定は最小限で済みます。
#
# コレクションタイプ:
# - SEARCH: 全文検索、ファセット検索などの一般的な検索ワークロードに使用
# - TIMESERIES: ログ分析、メトリクス分析などの時系列データに最適化
# - VECTORSEARCH: ベクトル検索、セマンティック検索、機械学習アプリケーションに使用
#
# 重要な前提条件:
# - コレクション作成前に暗号化セキュリティポリシーの作成が必須
# - データアクセスにはネットワークセキュリティポリシーの設定が必須
# - 実際のデータアクセスにはデータアクセスポリシーの設定が必須
#
# AWS公式ドキュメント:
#   - OpenSearch Serverlessコレクションの管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-manage.html
#   - コレクションの作成: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-create.html
#   - CreateCollection API: https://docs.aws.amazon.com/opensearch-service/latest/ServerlessAPIReference/API_CreateCollection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/opensearchserverless_collection
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_collection" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # コレクション名
  # - 一意である必要があります
  # - 英数字とハイフンのみ使用可能
  # - 3〜28文字の長さである必要があります
  name = "example-collection"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # コレクションの説明
  # - コレクションの用途や目的を記載します
  # - 最大1000文字まで設定可能
  description = "Example OpenSearch Serverless collection"

  # コレクションタイプ
  # - SEARCH: 全文検索やファセット検索などの検索ワークロード用
  # - TIMESERIES: ログ分析やメトリクス分析などの時系列データ用（デフォルト）
  # - VECTORSEARCH: ベクトル検索やセマンティック検索、機械学習アプリケーション用
  # - 作成後は変更できません
  # - デフォルト値: TIMESERIES
  type = "TIMESERIES"

  # スタンバイレプリカの有効化
  # - ENABLED: 高可用性のためにスタンバイレプリカを使用（デフォルト）
  # - DISABLED: スタンバイレプリカを無効化してコストを削減
  # - スタンバイレプリカはフェイルオーバー時の可用性を向上させます
  # - デフォルト値: ENABLED
  standby_replicas = "ENABLED"

  # リージョン
  # - このリソースが管理されるAWSリージョンを指定
  # - 指定しない場合はプロバイダー設定のリージョンが使用されます
  # - リージョナルエンドポイントについては以下を参照:
  #   https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  # タグ
  # - リソースの識別、管理、コスト配分に使用
  # - キーと値のペアで指定
  # - provider default_tagsと統合されます
  tags = {
    Environment = "development"
    Project     = "example-project"
    ManagedBy   = "terraform"
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  timeouts {
    # コレクション作成のタイムアウト
    # - 大規模な構成では作成に時間がかかる場合があります
    # - 形式: "30s", "10m", "1h" など
    # - デフォルト: "20m"
    create = "20m"

    # コレクション削除のタイムアウト
    # - コレクション内のデータ量によって時間がかかる場合があります
    # - 形式: "30s", "10m", "1h" など
    # - デフォルト: "20m"
    delete = "20m"
  }

  #---------------------------------------------------------------
  # 依存関係
  #---------------------------------------------------------------

  # 暗号化セキュリティポリシーへの依存関係
  # - コレクション作成前に暗号化ポリシーが必要です
  # - ポリシーのリソースパターンはコレクション名と一致する必要があります
  # 例:
  # depends_on = [
  #   aws_opensearchserverless_security_policy.encryption
  # ]
}

#---------------------------------------------------------------
# Attributes Reference（参照専用の属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（入力不可）:
#
# - arn
#   コレクションのAmazon Resource Name (ARN)
#
# - id
#   コレクションの一意の識別子
#
# - collection_endpoint
#   インデックス作成、検索、データアップロードリクエストを送信するための
#   コレクション固有のエンドポイント
#   例: https://abc123.us-east-1.aoss.amazonaws.com
#
# - dashboard_endpoint
#   OpenSearch Dashboardsにアクセスするためのコレクション固有のエンドポイント
#   例: https://abc123.us-east-1.aoss.amazonaws.com/_dashboards
#
# - kms_key_arn
#   コレクションの暗号化に使用されるAWS KMSキーのARN
#   暗号化セキュリティポリシーで指定されたキーが使用されます
#
# - tags_all
#   プロバイダーのdefault_tagsを含む、リソースに割り当てられた全てのタグ
#
#---------------------------------------------------------------
