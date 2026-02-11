#---------------------------------------------------------------
# S3 Access Grants Instance
#---------------------------------------------------------------
#
# Amazon S3 Access Grantsインスタンスをプロビジョニングするリソースです。
# S3 Access Grantsインスタンスは、登録された場所やアクセス許可を含む
# S3 Access Grantsリソースのコンテナとして機能します。
# 1つのAWSアカウント・リージョンにつき、1つのインスタンスのみ作成できます。
#
# AWS公式ドキュメント:
#   - S3 Access Grantsインスタンスの操作: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance.html
#   - S3 Access Grantsインスタンスの作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance-create.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grants_instance" "example" {
  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: S3 Access Grantsインスタンスを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance-create.html
  account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: S3 Access Grantsインスタンス
  #   1つのAWSアカウント・リージョンにつき、1つのインスタンスのみ作成可能です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Identity Center統合設定
  #-------------------------------------------------------------

  # identity_center_arn (Optional)
  # 設定内容: S3 Access GrantsインスタンスとIAM Identity Centerインスタンスを関連付けるための
  #          IAM Identity CenterインスタンスのARNを指定します。
  # 設定可能な値: 有効なIAM Identity CenterインスタンスのARN
  #             (形式例: arn:aws:sso:::instance/ssoins-890759e9c7bfdc1d)
  # 省略時: IAM Identity Centerインスタンスとの関連付けは行われず、
  #        IAMユーザーとロールに対してのみアクセス許可を作成できます
  # 関連機能: IAM Identity Center統合
  #   企業のアイデンティティディレクトリをIAM Identity Centerに追加している場合、
  #   S3 Access Grantsインスタンスと関連付けることで、企業のユーザーとグループに対して
  #   アクセス許可を作成できます。後から関連付けることも可能です。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance.html
  #   - https://docs.aws.amazon.com/singlesignon/latest/userguide/manage-your-identity-source-idp.html
  identity_center_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "s3-access-grants-instance"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: S3 Access Grantsインスタンスのリソース識別子
#
# - access_grants_instance_arn: S3 Access GrantsインスタンスのAmazon Resource Name (ARN)
#
# - access_grants_instance_id: S3 Access Grantsインスタンスの一意のID
#
# - identity_center_application_arn: IAM Identity Centerインスタンスアプリケーションの
#                                    ARN（元のIdentity Centerインスタンスのサブリソース）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
