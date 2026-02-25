#---------------------------------------------------------------
# AWS Redshift Cluster IAM Roles
#---------------------------------------------------------------
#
# Amazon RedshiftクラスターにIAMロールを関連付けるリソースです。
# クラスターがAmazon S3、AWS Glue、Amazon Athena等のAWSサービスへ
# アクセスする際に使用するIAMロールを管理します。
# デフォルトIAMロールの設定も本リソースで行います。
#
# 注意: デフォルトIAMロール(default_iam_role_arn)は aws_redshift_cluster リソースの
#       同名引数と競合するため、両方で異なる値を設定しないでください。
#
# AWS公式ドキュメント:
#   - IAMロールのクラスターへの関連付け: https://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role-associating-with-clusters.html
#   - COPY/UNLOADでのIAMロール使用: https://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster_iam_roles
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_cluster_iam_roles" "example" {
  #-------------------------------------------------------------
  # クラスター識別子設定
  #-------------------------------------------------------------

  # cluster_identifier (Required)
  # 設定内容: IAMロールを関連付けるRedshiftクラスターの識別子を指定します。
  # 設定可能な値: 既存のRedshiftクラスターの識別子文字列
  cluster_identifier = "my-redshift-cluster"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # iam_role_arns (Optional)
  # 設定内容: クラスターに関連付けるIAMロールのARNのセットを指定します。
  # 設定可能な値: 有効なIAMロールARNのセット
  # 省略時: 既存の関連付けが管理対象外となります
  # 注意: クラスターに関連付けできるIAMロールは最大10件です。
  # 参考: https://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role-associating-with-clusters.html
  iam_role_arns = [
    "arn:aws:iam::123456789012:role/redshift-s3-access-role",
  ]

  # default_iam_role_arn (Optional)
  # 設定内容: クラスター作成時にデフォルトとして設定するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN。iam_role_arns に含まれているロールである必要があります。
  # 省略時: デフォルトIAMロールは設定されません
  # 注意: aws_redshift_cluster リソースの default_iam_role_arn 引数と競合します。
  #       両方のリソースで同時に管理しないでください。
  # 参考: https://docs.aws.amazon.com/redshift/latest/APIReference/API_ModifyClusterIamRoles.html
  default_iam_role_arn = "arn:aws:iam::123456789012:role/redshift-s3-access-role"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" などのGo duration形式の文字列
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: RedshiftクラスターのID（cluster_identifier と同じ値）
#---------------------------------------------------------------
