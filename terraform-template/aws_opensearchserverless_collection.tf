#---------------------------------------------------------------
# Amazon OpenSearch Serverless Collection
#---------------------------------------------------------------
#
# Amazon OpenSearch Serverlessのコレクションをプロビジョニングするリソースです。
# コレクションは特定のワークロードをサポートする1つ以上のインデックスの
# 論理的なグループであり、OpenSearch Serverlessによって自動的に管理・チューニングされます。
#
# 注意: コレクションを作成する前に、暗号化セキュリティポリシー
# (aws_opensearchserverless_security_policy) が必要です。depends_on
# メタ引数を使用して依存関係を定義してください。また、コレクションへの
# アクセスにはネットワークセキュリティポリシーとデータアクセスポリシーも必要です。
#
# AWS公式ドキュメント:
#   - Amazon OpenSearch Serverless概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-overview.html
#   - コレクションの作成: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-create.html
#   - コレクション管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-collections.html
#   - 暗号化設定: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearchserverless_collection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: コレクションの名前を指定します。
  # 設定可能な値: 3〜32文字。小文字英字で始まり、小文字英数字とハイフンのみ使用可能
  # 注意: 作成後は変更不可（Forces new resource）
  name = "example-collection"

  # description (Optional)
  # 設定内容: コレクションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example OpenSearch Serverless collection"

  #-------------------------------------------------------------
  # コレクションタイプ設定
  #-------------------------------------------------------------

  # type (Optional)
  # 設定内容: コレクションのタイプを指定します。ユースケースに応じて選択してください。
  # 設定可能な値:
  #   - "SEARCH": 全文検索ユースケース向け。全データをホットストレージに保存
  #   - "TIMESERIES": ログ分析・時系列データ向け。ホットとウォームストレージを組み合わせて使用
  #   - "VECTORSEARCH": ベクター検索ユースケース向け。全データをホットストレージに保存
  # 省略時: "TIMESERIES"
  # 関連機能: コレクションタイプ
  #   ユースケースごとに最適化されたストレージ・インデックス構成が自動適用されます。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-overview.html
  type = "TIMESERIES"

  #-------------------------------------------------------------
  # 可用性設定
  #-------------------------------------------------------------

  # standby_replicas (Optional)
  # 設定内容: コレクションにスタンバイレプリカを使用するかどうかを指定します。
  # 設定可能な値:
  #   - "ENABLED": スタンバイレプリカを有効化。高可用性が確保されますが、コストが増加します
  #   - "DISABLED": スタンバイレプリカを無効化。開発・テスト環境でのコスト削減に適しています
  # 省略時: "ENABLED"
  # 関連機能: OpenSearch Serverless スケーリング
  #   スタンバイレプリカは複数AZにレプリカを配置し、高可用性を提供します。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-scaling.html
  standby_replicas = "ENABLED"

  #-------------------------------------------------------------
  # コレクショングループ設定
  #-------------------------------------------------------------

  # collection_group_name (Optional)
  # 設定内容: このコレクションを関連付けるコレクショングループの名前を指定します。
  # 設定可能な値: 既存のコレクショングループ名
  # 省略時: コレクショングループに関連付けません
  # 関連機能: OpenSearch Serverless コレクショングループ
  #   複数のコレクションをグループ化し、共通設定や課金単位を一元管理する機能です。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-collections.html
  collection_group_name = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encryption_config (Optional)
  # 設定内容: コレクションの暗号化設定を指定します。リスト形式のオブジェクト属性です。
  # 設定可能な値:
  #   - aws_owned_key (bool): AWS所有キーで暗号化するかどうか
  #   - kms_key_arn (string): カスタマーマネージドKMSキーのARN
  # 省略時: 関連する暗号化セキュリティポリシー（aws_opensearchserverless_security_policy）
  #         で定義された設定が適用されます。
  # 関連機能: OpenSearch Serverless 暗号化
  #   コレクション作成前に暗号化セキュリティポリシーの作成が必須です。
  #   通常はaws_opensearchserverless_security_policyリソースで暗号化設定を管理します。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-encryption.html
  # 注意: この属性はcomputed属性も兼ねるため、未指定の場合はAWS側で設定された値が反映されます。
  encryption_config = null

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
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-collection"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの期間文字列（s=秒, m=分, h=時間）
    create = "20m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "5m", "2h45m" などの期間文字列（s=秒, m=分, h=時間）
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: コレクションのAmazon Resource Name (ARN)
# - id: コレクションの一意識別子
# - collection_endpoint: インデックス・検索・データアップロードリクエストの送信に使用する
#                        コレクション固有のエンドポイント
# - dashboard_endpoint: OpenSearch Dashboardsへのアクセスに使用するエンドポイント
# - kms_key_arn: コレクションの暗号化に使用するAWS KMSキーのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
