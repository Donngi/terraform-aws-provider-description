#---------------------------------------------------------------
# AWS RDS Integration (Zero-ETL統合)
#---------------------------------------------------------------
#
# Amazon RDSデータベースとAmazon Redshiftデータウェアハウス間の
# Zero-ETL統合をプロビジョニングするリソースです。
# ソースRDSデータベースのデータをターゲットRedshiftへ近リアルタイムで
# 複製し、複雑なETLパイプラインを必要とせずに分析ワークロードを実現します。
#
# AWS公式ドキュメント:
#   - Amazon RDS Zero-ETL統合概要: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/zero-etl.html
#   - Aurora Zero-ETL統合セットアップ: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.setting-up.html
#   - データフィルタリング: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.filtering.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_integration
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_integration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # integration_name (Required, Forces new resource)
  # 設定内容: Zero-ETL統合の名前を指定します。
  # 設定可能な値: 文字列
  integration_name = "example-integration"

  # source_arn (Required, Forces new resource)
  # 設定内容: レプリケーションのソースとして使用するデータベースのARNを指定します。
  # 設定可能な値: 有効なRDS DBインスタンス、DBクラスター、またはAuroraクラスターのARN
  source_arn = "arn:aws:rds:ap-northeast-1:123456789012:cluster:example-aurora-cluster"

  # target_arn (Required, Forces new resource)
  # 設定内容: レプリケーションのターゲットとして使用するRedshiftデータウェアハウスのARNを指定します。
  # 設定可能な値: 有効なRedshift Serverlessネームスペースまたはプロビジョニング済みクラスターのARN
  target_arn = "arn:aws:redshift-serverless:ap-northeast-1:123456789012:namespace/example-namespace-id"

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
  # データフィルタリング設定
  #-------------------------------------------------------------

  # data_filter (Optional)
  # 設定内容: 統合のデータフィルターを指定します。
  #   ソースデータベースのどのテーブルをターゲットのAmazon Redshiftデータウェアハウスに
  #   送信するかを制御するフィルター式を設定します。
  # 設定可能な値: AWS CLIの構文に準拠したフィルター式の文字列。
  #   include: または exclude: プレフィックスを使用し、複数の式はカンマで区切ります。
  #   例: "include: db1.table1, db1.table2"
  #   例: "exclude: db2.*"
  # 省略時: 全テーブルがレプリケーション対象になります。
  # 参考: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/zero-etl.filtering.html
  data_filter = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: 統合の暗号化に使用するKMSキーの識別子を指定します。
  # 設定可能な値: 有効なKMSキーARN、キーID、またはエイリアス
  # 省略時: RDSがデフォルトのAWS所有キーを使用します。
  # 注意: デフォルトのAWS所有キーを使用する場合、初回作成後の不意な変更を
  #       避けるため lifecycle の ignore_changes で kms_key_id を除外することを推奨します。
  kms_key_id = null

  # additional_encryption_context (Optional, Forces new resource)
  # 設定内容: データに関する追加コンテキスト情報を含む非シークレットなキーと値のペアを指定します。
  #   KMS暗号化の追加認証データ（AAD）として使用されます。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 注意: このパラメータを指定する場合は kms_key_id も指定する必要があります。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
  additional_encryption_context = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-integration"
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
    # 設定可能な値: 数値と単位サフィックスで構成される期間文字列
    #   例: "30s"（30秒）、"5m"（5分）、"2h"（2時間）、"2h45m"
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "60m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスで構成される期間文字列
    #   例: "30s"（30秒）、"5m"（5分）、"2h"（2時間）、"2h45m"
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "60m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 数値と単位サフィックスで構成される期間文字列
    #   例: "30s"（30秒）、"5m"（5分）、"2h"（2時間）、"2h45m"
    #   有効な時間単位: "s"（秒）、"m"（分）、"h"（時間）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    # 注意: 削除操作のタイムアウト設定は、destroyが発生する前にstateに保存された場合のみ有効
    delete = "60m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Zero-ETL統合のARN
#
# - integration_identifier: Zero-ETL統合の識別子
#
# - id: (非推奨) Zero-ETL統合のARN。arn属性を代わりに使用してください。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
