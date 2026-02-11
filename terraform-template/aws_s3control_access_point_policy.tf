#---------------------------------------------------------------
# AWS S3 Access Point Policy
#---------------------------------------------------------------
#
# Amazon S3アクセスポイントのリソースポリシーをプロビジョニングするリソースです。
# アクセスポイントポリシーは、S3アクセスポイントを通じたデータアクセスを制御する
# IAMリソースポリシーを定義します。アクセスポイントごとに個別のアクセス制御を
# 設定でき、共有データセットへのアクセス管理を簡素化します。
#
# AWS公式ドキュメント:
#   - S3アクセスポイント概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points.html
#   - アクセスポイントのIAMポリシー設定: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-policies.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_point_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# NOTE: Access Pointリソースのインライン resource policy と本リソースを
#       同時に使用しないでください。ポリシーの競合が発生し、
#       アクセスポイントのリソースポリシーが上書きされます。
#
#---------------------------------------------------------------

resource "aws_s3control_access_point_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # access_point_arn (Required)
  # 設定内容: ポリシーを関連付けるアクセスポイントのARNを指定します。
  # 設定可能な値: 有効なS3アクセスポイントARN
  #   例: "arn:aws:s3:ap-northeast-1:123456789012:accesspoint/my-access-point"
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points.html
  access_point_arn = "arn:aws:s3:ap-northeast-1:123456789012:accesspoint/my-access-point"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: アクセスポイントに適用するリソースポリシーをJSON形式で指定します。
  # 設定可能な値: IAMポリシードキュメント（JSON文字列）
  # 関連機能: S3アクセスポイントポリシー
  #   アクセスポイントポリシーで許可された権限は、基盤となるバケットポリシーでも
  #   同じアクセスを許可している場合にのみ有効です。バケットからアクセスポイントへ
  #   アクセス制御を委任するか、バケットポリシーにも同等の権限を追加する必要があります。
  #   - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-policies.html
  # 注意: jsonencode()を使用してポリシードキュメントを記述することを推奨します。
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3:GetObjectTagging"
      Principal = {
        AWS = "*"
      }
      Resource = "arn:aws:s3:ap-northeast-1:123456789012:accesspoint/my-access-point/object/*"
    }]
  })

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
# - has_public_access_policy: このアクセスポイントに現在パブリックアクセスを
#                             許可するポリシーが設定されているかどうかを示す
#                             ブール値。
#
# - id: AWSアカウントIDとアクセスポイント名をコロン（:）で区切った値。
#---------------------------------------------------------------
