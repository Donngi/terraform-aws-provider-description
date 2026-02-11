#---------------------------------------------------------------
# Amazon Timestream Database
#---------------------------------------------------------------
#
# Amazon Timestream for LiveAnalyticsのデータベースをプロビジョニングするリソースです。
# データベースは、時系列データを格納するテーブルのコンテナとして機能します。
# 各データベースには、暗号化キーやタグなどの設定を定義できます。
#
# AWS公式ドキュメント:
#   - Amazon Timestream概要: https://docs.aws.amazon.com/timestream/latest/developerguide/what-is-timestream.html
#   - データベースの管理: https://docs.aws.amazon.com/timestream/latest/developerguide/managing-databases.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamwrite_database
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_timestreamwrite_database" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # database_name (Required)
  # 設定内容: Timestreamデータベースの名前を指定します。
  # 設定可能な値: 3-64文字の文字列
  # 注意: データベース名はAWSアカウントとリージョン内で一意である必要があります。
  # 参考: https://docs.aws.amazon.com/timestream/latest/developerguide/API_CreateDatabase.html
  database_name = "database-example"

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
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_key_id (Optional)
  # 設定内容: データベースに格納されるデータの暗号化に使用するKMSキーのARN（AliasARNではない）を指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: TimestreamがAWSアカウント内で管理するKMSキーでデータベースが暗号化されます
  # 関連機能: Amazon Timestream データ暗号化
  #   Timestreamはデータを保存時に自動的に暗号化します。デフォルトではAWS管理のKMSキーを使用しますが、
  #   カスタマー管理のKMSキーを指定することで、より細かいアクセス制御とキー管理が可能になります。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#aws-managed-cmk
  kms_key_id = null

  #-------------------------------------------------------------
  # 識別子設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: Terraformリソース識別子を指定します。
  # 省略時: データベース名が使用されます
  # 注意: 通常、この属性を明示的に設定する必要はありません。
  #       Terraformが自動的に管理します。
  id = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: データベースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/timestream/latest/developerguide/managing-databases.html
  tags = {
    Name        = "my-timestream-database"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップを指定します。
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます
  # 注意: 通常、この属性を明示的に設定する必要はありません。
  #       Terraformが自動的に管理します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: このデータベースを一意に識別するAmazon Resource Name (ARN)。
#
# - table_count: Timestreamデータベース内に見つかったテーブルの総数。
#---------------------------------------------------------------
