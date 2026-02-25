#---------------------------------------------------------------
# Amazon Redshift Partner Integration
#---------------------------------------------------------------
#
# Amazon Redshift のパートナーインテグレーションをプロビジョニングするリソースです。
# パートナーインテグレーションにより、承認されたAWSパートナーが指定されたRedshiftクラスターの
# データベースに対してステータス更新を送信できるようになります。
# 統合を完了するには、パートナー側のウェブサイトでも設定が必要です。
#
# AWS公式ドキュメント:
#   - Redshift パートナーインテグレーション: https://docs.aws.amazon.com/redshift/latest/mgmt/partner-integration.html
#   - AddPartner API: https://docs.aws.amazon.com/redshift/latest/APIReference/API_AddPartner.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_partner
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_partner" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # account_id (Required)
  # 設定内容: クラスターを所有するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁の数字で構成されるAWSアカウントID
  account_id = "012345678910"

  # cluster_identifier (Required)
  # 設定内容: パートナーからデータを受信するクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子
  cluster_identifier = "example-cluster"

  # database_name (Required)
  # 設定内容: パートナーからデータを受信するデータベースの名前を指定します。
  # 設定可能な値: 最大127文字の文字列
  database_name = "example_database"

  # partner_name (Required)
  # 設定内容: データ送信を許可するパートナーの名前を指定します。
  # 設定可能な値: 最大255文字の文字列。対応パートナー例: Datacoral, Etleap, Fivetran, SnapLogic, Stitch, Upsolver 等
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/partner-integration.html
  partner_name = "example-partner"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Redshiftパートナーの識別子。account_id、cluster_identifier、
#       database_name、partner_name をコロン（:）で連結した値
#
# - status: パートナーインテグレーションのステータス。
#           有効な値: Active（接続・タスク完了可能）、Inactive（統合なし）、
#           RuntimeFailure（接続可能だがタスク未完了）、ConnectionFailure（接続不可）
#
# - status_message: パートナーから提供されるステータスメッセージ。最大262144文字
#---------------------------------------------------------------
