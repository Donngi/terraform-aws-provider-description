#---------------------------------------------------------------
# AWS Redshift Integration
#---------------------------------------------------------------
#
# Amazon RedshiftとのZero-ETLインテグレーションをプロビジョニングするリソースです。
# DynamoDBテーブルまたはS3バケットをソースとして、データをAmazon Redshiftデータ
# ウェアハウスへリアルタイムにレプリケートするフルマネージドな統合を構成します。
# ETLパイプラインを構築・管理することなく、分析ワークロードへのデータ連携が可能です。
#
# AWS公式ドキュメント:
#   - Zero-ETLインテグレーション概要: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-using.html
#   - DynamoDB Zero-ETL統合の作成: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-setting-up.create-integration-ddb.html
#   - Zero-ETL統合の考慮事項: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl.reqs-lims.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_integration
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_integration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # integration_name (Required)
  # 設定内容: インテグレーションの名前を指定します。
  # 設定可能な値: 任意の文字列
  integration_name = "example-integration"

  # source_arn (Required, Forces new resource)
  # 設定内容: レプリケーションのソースとなるデータベースのARNを指定します。
  # 設定可能な値: DynamoDBテーブルのARN、またはS3バケットのARN
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-using.html
  source_arn = "arn:aws:dynamodb:ap-northeast-1:123456789012:table/example-table"

  # target_arn (Required, Forces new resource)
  # 設定内容: レプリケーションのターゲットとなるRedshiftデータウェアハウスのARNを指定します。
  # 設定可能な値: Redshift Serverlessネームスペースのいずれかの有効なARN
  # 注意: ターゲットのRedshiftはRA3ノードタイプまたはServerlessであること、
  #       プロビジョニングクラスターの場合は暗号化が有効であること、
  #       大文字小文字の区別が有効であることが必要です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl.reqs-lims.html
  target_arn = "arn:aws:redshift-serverless:ap-northeast-1:123456789012:namespace/example-namespace-id"

  # description (Optional)
  # 設定内容: インテグレーションの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "DynamoDB to Redshift zero-ETL integration"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional, Forces new resource)
  # 設定内容: インテグレーションの暗号化に使用するKMSキーの識別子を指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: AWSが管理するデフォルトキーを使用して暗号化されます。
  # 注意: source_arnがDynamoDBテーブルを参照する場合にのみ指定可能です。
  #       このパラメータを指定する場合は、Redshiftサービスプリンシパルに
  #       kms:Decrypt と kms:CreateGrant の許可が必要です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/zero-etl-setting-up.create-integration-ddb.html
  kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # additional_encryption_context (Optional, Forces new resource)
  # 設定内容: データに関する追加のコンテキスト情報を含む非シークレットのキーバリューペアを指定します。
  # 設定可能な値: 文字列のキーバリューマップ
  # 省略時: 追加の暗号化コンテキストなし
  # 注意: kms_key_id を指定する場合にのみ使用できます。
  # 参考: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#encrypt_context
  additional_encryption_context = {
    "department" = "analytics"
    "project"    = "data-warehouse"
  }

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
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-integration"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウト
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウト
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "30s", "2h45m" などの期間文字列（s: 秒, m: 分, h: 時間）
    # 省略時: プロバイダーのデフォルトタイムアウト
    # 注意: 削除操作のタイムアウトは、destroyが発生する前にstateへ保存された変更にのみ適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: インテグレーションのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
