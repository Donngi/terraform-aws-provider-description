#---------------------------------------------------------------
# AWS Redshift Data Share Authorization
#---------------------------------------------------------------
#
# AWS Redshift Data Share Authorizationを管理するリソースです。
# このリソースは、データプロデューサーがデータコンシューマー（他のAWSアカウント
# またはADXなど）にデータシェアへのアクセスを許可するために使用します。
# Redshift Data Sharingを使用すると、異なるRedshiftクラスター間または
# AWS Data Exchangeとの間で、データのコピーを作成せずにライブデータを
# 安全に共有できます。
#
# AWS公式ドキュメント:
#   - Redshift Data Sharing概要: https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html
#   - Data Sharingの使用: https://docs.aws.amazon.com/redshift/latest/dg/using-datashare.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_data_share_authorization
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_data_share_authorization" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須パラメータ）
  #-------------------------------------------------------------

  # consumer_identifier (Required)
  # 設定内容: データシェアへのアクセスを許可されるデータコンシューマーの識別子を指定します。
  # 設定可能な値:
  #   - AWSアカウントID（12桁の数字）
  #   - キーワード "ADX" (AWS Data Exchangeの場合)
  # 例: "123456789012" または "ADX"
  # 関連機能: Redshift Data Sharing
  #   データコンシューマーは、データシェアへのアクセスを許可された
  #   AWSアカウントまたはAWS Data Exchangeです。
  #   - https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html
  consumer_identifier = "123456789012"

  # data_share_arn (Required)
  # 設定内容: プロデューサーが共有を許可するデータシェアのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なRedshift データシェアARN
  # ARN形式: arn:aws:redshift:region:account-id:datashare:cluster-namespace-id/datashare-name
  # 例: "arn:aws:redshift:us-west-2:123456789012:datashare:3072dae5-022b-4d45-9cd3-01f010aae4b2/example_share"
  # 関連機能: Redshift Data Share
  #   データシェアは、1つ以上のデータベースオブジェクト（スキーマ、テーブル、ビューなど）
  #   を含む論理的なコンテナです。
  #   - https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html
  data_share_arn = "arn:aws:redshift:us-west-2:123456789012:datashare:3072dae5-022b-4d45-9cd3-01f010aae4b2/example_share"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # allow_writes (Optional)
  # 設定内容: データシェアに対する書き込み操作を許可するかどうかを指定します。
  # 設定可能な値:
  #   - true: 書き込み操作を許可
  #   - false: 書き込み操作を許可しない（デフォルト）
  # 省略時: false
  # 関連機能: Redshift Data Sharing Write Access
  #   書き込みアクセスを許可すると、コンシューマーは共有されたデータに対して
  #   変更を加えることができます。セキュリティ要件に応じて慎重に設定してください。
  #   - https://docs.aws.amazon.com/redshift/latest/dg/datashare-overview.html
  allow_writes = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: Redshift Data Sharingはクロスリージョンで機能しますが、
  #       パフォーマンスとコストの観点から同一リージョン内での共有を推奨します。
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: データシェアARNとコンシューマー識別子を連結したカンマ区切りの文字列
#   形式: "data_share_arn,consumer_identifier"
#
# - managed_by: データシェアの管理エンティティを示す識別子
#   この属性は、データシェアがどのエンティティによって管理されているかを示します。
#
# - producer_arn: プロデューサーのAmazon Resource Name (ARN)
#   データシェアを作成・所有するRedshiftクラスターまたはワークグループのARNです。
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. 基本的なアカウント間データ共有:
#    - プロデューサーアカウントでデータシェアを作成
#    - このリソースでコンシューマーアカウントにアクセスを許可
#    - コンシューマーアカウントでデータシェアを受け入れて使用
#
# 2. AWS Data Exchangeへの共有:
#    consumer_identifier = "ADX"
#    を指定してAWS Data Exchangeにデータを公開
#---------------------------------------------------------------
