#---------------------------------------------------------------
# AWS RDS Cluster Role Association
#---------------------------------------------------------------
#
# RDS DBクラスターとIAMロールの関連付けを管理するリソースです。
# このリソースにより、Amazon Auroraクラスターが他のAWSサービス（S3、Lambda等）に
# アクセスするための権限を付与できます。
#
# 主なユースケース:
#   - Amazon S3からデータをインポート/エクスポート
#   - Lambda関数の呼び出し
#   - SageMaker、Comprehend等のAIサービスとの統合
#
# AWS公式ドキュメント:
#   - IAMロールでAuroraからAWSサービスへのアクセス: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Authorizing.IAM.CreateRole.html
#   - S3データのインポート（PostgreSQL）: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PostgreSQL.S3Import.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_role_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rds_cluster_role_association" "example" {
  #-------------------------------------------------------------
  # DBクラスター設定 (Required)
  #-------------------------------------------------------------

  # db_cluster_identifier (Required)
  # 設定内容: IAMロールを関連付けるDBクラスターの識別子を指定します。
  # 設定可能な値: 既存のRDS DBクラスターの識別子（ID）
  # 用途: Auroraクラスターと外部AWSサービスとの統合を実現します。
  # 参考: 他のTerraformリソース（aws_rds_cluster）を参照する場合は
  #       aws_rds_cluster.example.id のように指定します。
  # 例: "my-aurora-cluster"
  db_cluster_identifier = "my-aurora-cluster"

  #-------------------------------------------------------------
  # IAMロール設定 (Required)
  #-------------------------------------------------------------

  # role_arn (Required)
  # 設定内容: DBクラスターに関連付けるIAMロールのARN（Amazon Resource Name）を指定します。
  # 設定可能な値: 有効なIAMロールのARN形式
  # 形式: arn:aws:iam::123456789012:role/RoleName
  # 用途: このロールの権限を使用してDBクラスターが他のAWSサービスにアクセスします。
  # 重要: IAMロールには適切な信頼関係ポリシーとアクセス許可ポリシーが必要です。
  #       - 信頼関係: rds.amazonaws.com がロールを引き受けられるようにする
  #       - アクセス許可: 必要なAWSサービス（S3、Lambda等）へのアクセス権限
  # 参考: 他のTerraformリソース（aws_iam_role）を参照する場合は
  #       aws_iam_role.example.arn のように指定します。
  # 例: "arn:aws:iam::123456789012:role/aurora-s3-integration-role"
  role_arn = "arn:aws:iam::123456789012:role/aurora-s3-integration-role"

  #-------------------------------------------------------------
  # 機能名設定 (Optional)
  #-------------------------------------------------------------

  # feature_name (Optional)
  # 設定内容: 関連付けに使用する機能の名前を指定します。
  # 設定可能な値: AWSが提供する統合機能名
  #   主な例:
  #   - "S3_INTEGRATION": Amazon S3との統合（データインポート/エクスポート）
  #   - "Lambda": AWS Lambda関数の呼び出し
  #   - "SageMaker": Amazon SageMakerとの統合
  #   - "Comprehend": Amazon Comprehendとの統合
  # 省略時: 一般的なIAMロール関連付けとして機能します
  # 確認方法: 利用可能な機能名の完全なリストは以下のAWS CLIコマンドで確認できます:
  #           aws rds describe-db-engine-versions --engine aurora-postgresql \
  #             --query "DBEngineVersions[].SupportedFeatureNames" --output table
  # 用途: 特定の統合機能を有効化し、その機能に必要な権限をロールから取得します。
  # 参考: https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-engine-versions.html
  # 例: "S3_INTEGRATION"
  feature_name = "S3_INTEGRATION"

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: マルチリージョン環境で明示的にリージョンを指定する必要がある場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 例: "us-east-1"
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: 特定の操作のタイムアウト時間を設定します。
  # 用途: デフォルトのタイムアウト時間を変更する必要がある場合に使用します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: 通常は5分で十分ですが、大規模なクラスターの場合は長めに設定
    create = null

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "5m", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が適用されます
    # 推奨値: 削除は通常高速ですが、念のため5分程度を想定
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: DBクラスター識別子とIAMロールARNの組み合わせ
#       形式: {db_cluster_identifier},{role_arn}
#       例: "my-aurora-cluster,arn:aws:iam::123456789012:role/aurora-s3-integration-role"
#       用途: リソースのインポートや参照時に使用
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、Aurora PostgreSQLクラスターでS3統合を設定する完全な例です:
#
# # 1. IAMロールの作成
# resource "aws_iam_role" "aurora_s3_integration" {
#   name = "aurora-s3-integration-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#---------------------------------------------------------------
