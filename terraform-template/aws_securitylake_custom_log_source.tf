#---------------------------------------------------------------
# AWS Security Lake Custom Log Source
#---------------------------------------------------------------
#
# Amazon Security Lakeのカスタムログソースをプロビジョニングするリソースです。
# サードパーティのカスタムソースからセキュリティデータを収集するための設定を行い、
# AWS Glueクローラーやプロバイダーのアイデンティティ情報を構成します。
#
# AWS公式ドキュメント:
#   - カスタムソースからのデータ収集: https://docs.aws.amazon.com/security-lake/latest/userguide/custom-sources.html
#   - カスタムソースの追加: https://docs.aws.amazon.com/security-lake/latest/userguide/adding-custom-sources.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securitylake_custom_log_source
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_securitylake_custom_log_source" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # source_name (Required, Forces new resource)
  # 設定内容: サードパーティカスタムソースの名前を指定します。
  # 設定可能な値: リージョン内で一意の文字列（最大20文字）
  # 注意: この値はリージョンごとに一意である必要があります。
  source_name = "example-custom-source"

  # source_version (Optional)
  # 設定内容: カスタムデータソースの特定のバージョンにログ収集を制限するためのソースバージョンを指定します。
  # 設定可能な値: バージョン文字列（例: "1.0"）
  # 省略時: 自動的に設定されます。
  source_version = "1.0"

  #-------------------------------------------------------------
  # イベントクラス設定
  #-------------------------------------------------------------

  # event_classes (Optional)
  # 設定内容: カスタムソースがSecurity Lakeに送信するデータの種類を記述するOCSF（Open Cybersecurity Schema Framework）イベントクラスを指定します。
  # 設定可能な値: OCSFイベントクラスの文字列セット
  #   例: "FILE_ACTIVITY", "DNS_ACTIVITY", "NETWORK_ACTIVITY", "PROCESS_ACTIVITY" 等
  # 参考: https://docs.aws.amazon.com/security-lake/latest/userguide/adding-custom-sources.html
  event_classes = ["FILE_ACTIVITY"]

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
  # ソース構成設定
  #-------------------------------------------------------------

  # configuration (Required)
  # 設定内容: サードパーティカスタムソースの構成を指定します。
  configuration {

    # crawler_configuration (Required)
    # 設定内容: サードパーティカスタムソース用のAWS Glueクローラーの構成を指定します。
    crawler_configuration {

      # role_arn (Required)
      # 設定内容: AWS Glueクローラーが使用するIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      # 注意: このロールにはAWSGlueServiceRoleポリシーと、データファイルの読み取りおよび
      #       Data Catalogテーブルの作成・更新を許可するインラインポリシーが必要です。
      # 参考: https://docs.aws.amazon.com/security-lake/latest/userguide/custom-sources.html
      role_arn = "arn:aws:iam::123456789012:role/example-glue-crawler-role"
    }

    # provider_identity (Required)
    # 設定内容: サードパーティカスタムソースのログプロバイダーのアイデンティティ情報を指定します。
    provider_identity {

      # external_id (Required)
      # 設定内容: AWSアイデンティティとの信頼関係を確立するための外部IDを指定します。
      # 設定可能な値: 任意の文字列
      external_id = "example-external-id"

      # principal (Required)
      # 設定内容: AWSアイデンティティのプリンシパル（AWSアカウントID）を指定します。
      # 設定可能な値: 有効なAWSアカウントID
      principal = "123456789012"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースの識別子
#
# - attributes: サードパーティカスタムソースの属性情報
#     - crawler_arn: AWS Glueクローラーの ARN
#     - database_arn: 結果が書き込まれるAWS Glueデータベースの ARN
#     - table_arn: AWS Glueテーブルの ARN
#
# - provider_details: サードパーティカスタムソースのログプロバイダーの詳細情報
#     - location: Security Lake用Amazon S3バケット内のパーティションの場所
#     - role_arn: カスタムソースパーティションにログを格納するエンティティが
#                 使用するIAMロールの ARN
#---------------------------------------------------------------
