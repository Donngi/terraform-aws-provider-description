#---------------------------------------------------------------
# AWS Glue User Defined Function
#---------------------------------------------------------------
#
# AWS Glue Data Catalog にユーザー定義関数 (UDF) を定義するリソースです。
# Hive 互換の UDF 定義を Data Catalog に登録し、Glue ETL ジョブや
# Athena などのサービスから参照できます。
#
# AWS公式ドキュメント:
#   - User-defined Function API: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-catalog-functions.html
#   - UserDefinedFunction データ型: https://docs.aws.amazon.com/glue/latest/webapi/API_UserDefinedFunction.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_user_defined_function
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_user_defined_function" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: UDF の名前を指定します。
  # 設定可能な値: 1〜255文字の文字列
  name = "my_func"

  # database_name (Required)
  # 設定内容: UDF を作成する Data Catalog データベースの名前を指定します。
  # 設定可能な値: 既存の Glue Catalog データベース名
  database_name = "my_database"

  # class_name (Required)
  # 設定内容: 関数コードを含む Java クラスの完全修飾クラス名を指定します。
  # 設定可能な値: 1〜255文字の文字列（例: "com.example.MyUDF"）
  class_name = "com.example.MyUDF"

  #-------------------------------------------------------------
  # オーナー設定
  #-------------------------------------------------------------

  # owner_name (Required)
  # 設定内容: UDF の所有者名を指定します。
  # 設定可能な値: 1〜255文字の文字列
  owner_name = "owner"

  # owner_type (Required)
  # 設定内容: UDF の所有者タイプを指定します。
  # 設定可能な値:
  #   - "USER":  個人ユーザーを所有者として指定
  #   - "ROLE":  IAM ロールを所有者として指定
  #   - "GROUP": グループを所有者として指定
  owner_type = "GROUP"

  #-------------------------------------------------------------
  # カタログ設定
  #-------------------------------------------------------------

  # catalog_id (Optional)
  # 設定内容: UDF を作成する Glue Data Catalog の ID (AWS アカウント ID) を指定します。
  # 設定可能な値: 12桁の AWS アカウント ID
  # 省略時: 現在の AWS アカウント ID が使用されます。
  catalog_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # リソース URI 設定
  #-------------------------------------------------------------

  # resource_uris (Optional)
  # 設定内容: UDF の実装ファイル（JAR、ファイル、アーカイブ）の参照先 URI を指定します。
  # 設定可能な値: 最大 1000 個のブロックを指定できます。
  # 省略時: リソース URI なしで UDF が作成されます。
  resource_uris {
    # resource_type (Required)
    # 設定内容: リソースのタイプを指定します。
    # 設定可能な値:
    #   - "JAR":     Java アーカイブ (.jar) ファイル
    #   - "FILE":    通常のファイル
    #   - "ARCHIVE": アーカイブファイル (.zip, .tar.gz 等)
    resource_type = "JAR"

    # uri (Required)
    # 設定内容: リソースにアクセスするための URI を指定します。
    # 設定可能な値: S3 URI 等のリソースパス（例: s3://my-bucket/my-func.jar）
    uri = "s3://my-bucket/my-func.jar"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Glue User Defined Function の ID。
#
# - arn: Glue User Defined Function の Amazon Resource Name (ARN)。
#
# - create_time: UDF が作成された日時 (ISO 8601 形式)。
#---------------------------------------------------------------
