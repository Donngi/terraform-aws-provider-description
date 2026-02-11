#---------------------------------------------------------------
# AWS Config Aggregate Authorization
#---------------------------------------------------------------
#
# AWS Configのアグリゲート承認をプロビジョニングするリソースです。
# アグリゲート承認は、複数のアカウントやリージョンからAWS Configの設定および
# コンプライアンスデータを収集するための権限を付与します。
# 個別アカウントアグリゲーターでは、すべてのソースアカウントとリージョンに対して
# 承認が必要です。組織アグリゲーターでは、AWS Organizationsとの統合により
# メンバーアカウントのリージョンに対する承認は不要です。
#
# AWS公式ドキュメント:
#   - マルチアカウント・マルチリージョンのデータ集約: https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html
#   - アグリゲーターアカウントの承認: https://docs.aws.amazon.com/config/latest/developerguide/aggregated-add-authorization.html
#   - CLIによるアグリゲーターアカウントの承認: https://docs.aws.amazon.com/config/latest/developerguide/authorize-aggregator-account-cli.html
#   - AggregationAuthorization API: https://docs.aws.amazon.com/config/latest/APIReference/API_AggregationAuthorization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_config_aggregate_authorization" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: 集約されたデータの収集を許可する12桁のアカウントIDを指定します。
  # 設定可能な値: 12桁の数字からなるAWSアカウントID
  # 説明: このアカウントIDは、AWS Configアグリゲーターを設定するアカウントのIDです。
  #       ソースアカウントから設定とコンプライアンスデータを収集する権限を持ちます。
  # 関連機能: AWS Config マルチアカウント・マルチリージョンデータ集約
  #   アグリゲーターアカウントは、複数のソースアカウントとリージョンから
  #   AWS Config データを収集できます。個別アカウントアグリゲーターの場合、
  #   承認リクエストは7日間有効です。
  #   - https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html
  account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # authorized_aws_region (Optional)
  # 設定内容: 集約されたデータの収集を許可するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, eu-west-2, ap-northeast-1）
  # 省略時: リージョンの指定がない場合は、regionパラメータで指定されたリージョン
  #        （または現在のリージョン）が使用されます
  # 説明: このリージョンは、アグリゲーターアカウントがデータを収集することを
  #       許可されるリージョンを示します。AWS Config は、ソースアカウントと
  #       リージョンで有効になっている必要があります。
  # 関連機能: AWS Config サポートされているリージョン
  #   マルチアカウント・マルチリージョンのデータ集約は、米国、アジアパシフィック、
  #   ヨーロッパ、カナダ、中東、南米のリージョン、および AWS GovCloud リージョンで
  #   サポートされています。
  #   - https://docs.aws.amazon.com/config/latest/developerguide/aggregate-data.html
  authorized_aws_region = "ap-northeast-1"

  # region (Optional, Deprecated)
  # 設定内容: 集約されたデータの収集を許可するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード
  # 非推奨: このパラメータは非推奨です。代わりに authorized_aws_region を使用してください。
  # 注意: 新しい設定では authorized_aws_region を使用することを強く推奨します。
  # region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 説明: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 関連機能: AWSリソースタグ付け
  #   タグを使用してAWSリソースを分類および管理できます。タグはメタデータとして
  #   機能し、コスト配分、アクセス制御、リソース整理に役立ちます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  tags = {
    Name        = "config-aggregate-authorization"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 集約承認のAmazon Resource Name (ARN)
#        例: arn:aws:config:ap-northeast-1:123456789012:aggregation-authorization/987654321098/us-east-1
#
# - id: リソースの一意の識別子。形式は "{account_id}:{region}" です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
