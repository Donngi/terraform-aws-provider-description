#---------------------------------------------------------------
# S3 Access Grant
#---------------------------------------------------------------
#
# S3 Access Grantsのアクセス許可を管理するリソース。
# IAMユーザー・ロールまたはディレクトリユーザー・グループ（被付与者）に対して、
# 登録済みロケーションへのアクセス権（READ / WRITE / READWRITE）を付与する。
# アクセス許可を作成する前に、同一リージョンにS3 Access Grantsインスタンスが必要。
#
# AWS公式ドキュメント:
#   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-manage-grants.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grant" "example" {

  #---------------------------------------
  # ロケーション設定
  #---------------------------------------

  # 設定内容: アクセス許可の対象となるS3 Access Grantsロケーションのid
  # 省略時: 必須項目のため省略不可
  access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id

  # 設定内容: アクセス許可のレベル
  # 設定可能な値: "READ", "WRITE", "READWRITE"
  # 省略時: 必須項目のため省略不可
  permission = "READ"

  #---------------------------------------
  # アカウント・プレフィックス設定
  #---------------------------------------

  # 設定内容: S3 Access Grantsロケーションが属するAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動判定したアカウントIDが使用される
  account_id = "123456789012"

  # 設定内容: 単一オブジェクトのみへのアクセス許可を作成する場合の指定
  # 設定可能な値: "Object"
  # 省略時: 設定なし（オブジェクト単位の制限なし）
  s3_prefix_type = "Object"

  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定で指定されたリージョンが使用される
  region = "ap-northeast-1"

  #---------------------------------------
  # ロケーション詳細設定
  #---------------------------------------

  # 設定内容: ロケーションのサブプレフィックス設定
  # 省略時: 設定なし（ロケーション全体がスコープとなる）
  access_grants_location_configuration {
    # 設定内容: アクセス対象のS3サブプレフィックス
    # 省略時: 設定なし
    s3_sub_prefix = "prefixB*"
  }

  #---------------------------------------
  # 被付与者設定
  #---------------------------------------

  # 設定内容: アクセス許可を付与する被付与者の設定
  # 省略時: 設定なし
  grantee {
    # 設定内容: 被付与者の識別子（IAMの場合はARN、ディレクトリの場合はID）
    # 省略時: 必須項目のため省略不可
    grantee_identifier = aws_iam_user.example.arn

    # 設定内容: 被付与者の種別
    # 設定可能な値: "DIRECTORY_USER", "DIRECTORY_GROUP", "IAM"
    # 省略時: 必須項目のため省略不可
    grantee_type = "IAM"
  }

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # 設定内容: リソースに付与するタグのキーと値のマップ
  # 省略時: タグなし
  tags = {
    Name = "example"
  }
}

#---------------------------------------
# Attributes Reference
#---------------------------------------
# id                - S3 Access GrantのユニークID
# access_grant_arn  - S3 AccessGrantのARN（Amazon Resource Name）
# access_grant_id   - S3 Access GrantのユニークID
# grant_scope       - このアクセス許可がカバーするS3スコープ（パス）
# tags_all          - プロバイダーのdefault_tagsを含む全タグのマップ
