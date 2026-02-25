#---------------------------------------------------------------
# AWS Glue Connection
#---------------------------------------------------------------
#
# AWS Glueのデータカタログに接続情報を定義するConnectionリソースをプロビジョニングします。
# JDBCデータソース、Kafka、MongoDB、Snowflake、BigQueryなどの外部データソースや、
# カスタムコネクターへの接続設定を管理します。
# VPC内のリソースに接続する場合はphysical_connection_requirementsブロックを使用します。
#
# AWS公式ドキュメント:
#   - AWS Glue接続の追加: https://docs.aws.amazon.com/glue/latest/dg/populate-add-connection.html
#   - 接続プロパティ: https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_connection" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: 接続の名前を指定します。
  # 設定可能な値: 文字列
  name = "example-connection"

  # description (Optional)
  # 設定内容: 接続の説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "example glue connection"

  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: 接続を作成するデータカタログのIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID
  # 省略時: プロバイダーに設定されているAWSアカウントIDが使用されます。
  catalog_id = null

  #-------------------------------------------------------------
  # 接続タイプ設定
  #-------------------------------------------------------------

  # connection_type (Optional)
  # 設定内容: 接続の種類を指定します。
  # 設定可能な値:
  #   - "JDBC" (デフォルト): JDBC経由のリレーショナルデータベース接続
  #   - "AZURECOSMOS": Azure Cosmos DB接続
  #   - "AZURESQL": Azure SQL接続
  #   - "BIGQUERY": Google BigQuery接続
  #   - "CUSTOM": カスタムコネクターを使用した接続
  #   - "DYNAMODB": Amazon DynamoDB接続
  #   - "KAFKA": Apache Kafka接続
  #   - "MARKETPLACE": AWS Marketplace経由のコネクター接続
  #   - "MONGODB": MongoDB接続
  #   - "NETWORK": VPCネットワーク経由の接続
  #   - "OPENSEARCH": Amazon OpenSearch Service接続
  #   - "SNOWFLAKE": Snowflake接続
  # 省略時: "JDBC"
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
  connection_type = "JDBC"

  # connection_properties (Optional)
  # 設定内容: この接続のパラメーターとして使用するキーと値のペアのマップを指定します。
  # 設定可能な値:
  #   JDBCの場合:
  #   - JDBC_CONNECTION_URL: JDBCエンドポイントURL（例: jdbc:mysql://host:3306/dbname）
  #   - USERNAME: データベースユーザー名
  #   - PASSWORD: データベースパスワード
  #   - SECRET_ID: Secrets ManagerのシークレットID（PASSWORD代替）
  #   SparkProperties対応接続タイプ（AZURECOSMOS, BIGQUERY, OPENSEARCH, SNOWFLAKEなど）の場合:
  #   - SparkProperties: 接続設定をJSONエンコードした文字列
  # 注意: 一部の接続タイプはSparkPropertiesプロパティにJSON形式で実際の接続プロパティを格納する必要があります。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://example.com/exampledatabase"
    PASSWORD            = "examplepassword"
    USERNAME            = "exampleusername"
  }

  # match_criteria (Optional)
  # 設定内容: この接続の選択に使用できる条件のリストを指定します。
  # 設定可能な値: 文字列のリスト
  # 省略時: 条件なし
  # 注意: カスタムコネクターを使用する場合、コネクター定義側では "template-connection"、
  #       接続側では ["Connection", <コネクター名>] を指定します。
  match_criteria = []

  #-------------------------------------------------------------
  # Athena設定
  #-------------------------------------------------------------

  # athena_properties (Optional)
  # 設定内容: Athenaコンピューティング環境固有の接続プロパティとして使用するキーと値のペアのマップを指定します。
  # 設定可能な値: Athenaフェデレーテッドクエリ用のプロパティマップ
  #   - lambda_function_arn: Athena連携Lambda関数のARN
  #   - disable_spill_encryption: スピル暗号化を無効化するかどうか（"true" または "false"）
  #   - spill_bucket: スピルデータの保存先S3バケット名
  # 省略時: Athena固有の接続プロパティなし
  athena_properties = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # physical_connection_requirements (Optional)
  # 設定内容: VPCやセキュリティグループなど物理的な接続要件の設定ブロックを指定します。
  # 設定可能な値: 以下のブロック属性を参照
  # 省略時: VPC接続なし（パブリックエンドポイントへの接続）
  # 関連機能: Glue VPC接続
  #   VPC内のデータソース（RDS、Redshift等）に接続する場合に設定します。
  #   - https://docs.aws.amazon.com/glue/latest/dg/start-connecting.html
  physical_connection_requirements {

    # availability_zone (Optional)
    # 設定内容: 接続に使用するアベイラビリティゾーンを指定します。
    # 設定可能な値: 有効なアベイラビリティゾーン名（例: ap-northeast-1a）
    # 省略時: subnet_idから暗示されます（このフィールドはAPIの要件として指定が必要な場合があります）
    availability_zone = "ap-northeast-1a"

    # security_group_id_list (Optional)
    # 設定内容: 接続に使用するセキュリティグループIDのリストを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    # 省略時: セキュリティグループなし
    security_group_id_list = ["sg-12345678"]

    # subnet_id (Optional)
    # 設定内容: 接続に使用するサブネットIDを指定します。
    # 設定可能な値: 有効なサブネットID
    # 省略時: サブネット指定なし
    subnet_id = "subnet-12345678"
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
  # 参考: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-connection"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: GlueコネクションのARN
# - id: カタログIDと接続名の組み合わせ（catalog_id:name）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
