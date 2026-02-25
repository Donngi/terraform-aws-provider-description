#---------------------------------------------------------------
# AWS S3 Object Lambda Access Point Policy
#---------------------------------------------------------------
#
# Amazon S3 Object Lambdaアクセスポイントにリソースポリシーを設定するリソースです。
# Object Lambdaアクセスポイントは、S3からデータを取得する際にAWS Lambda関数を
# 呼び出してデータを変換・加工する機能を提供します。本リソースでは、その
# アクセスポイントへのアクセスを制御するIAMリソースポリシーを管理します。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_object_lambda_access_point_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# NOTE: aws_s3_object_lambda_access_point リソースのインラインポリシーと
#       本リソースを同時に使用しないでください。ポリシーの競合が発生し、
#       アクセスポイントのリソースポリシーが上書きされます。
#
#---------------------------------------------------------------

resource "aws_s3control_object_lambda_access_point_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ポリシーを関連付けるObject Lambdaアクセスポイントの名前を指定します。
  # 設定可能な値: 既存のObject Lambdaアクセスポイント名（文字列）
  #   例: "my-object-lambda-ap"
  name = "my-object-lambda-ap"

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: Object LambdaアクセスポイントへのアクセスをJSON形式で定義する
  #           IAMリソースポリシーを指定します。
  # 設定可能な値: IAMポリシードキュメント（JSON文字列）
  # 注意: jsonencode()を使用してポリシードキュメントを記述することを推奨します。
  #       アクセスポイントポリシーで許可された権限は、基盤となるS3バケットポリシーでも
  #       同じアクセスを許可している場合にのみ有効です。
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3-object-lambda:GetObject"
      Principal = {
        AWS = "arn:aws:iam::123456789012:role/example-role"
      }
      Resource = "arn:aws:s3-object-lambda:ap-northeast-1:123456789012:accesspoint/my-object-lambda-ap"
    }]
  })

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: Object Lambdaアクセスポイントが属するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID（文字列）
  # 省略時: プロバイダー設定のアカウントIDを使用
  account_id = null

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
# - has_public_access_policy: このObject Lambdaアクセスポイントに現在
#                             パブリックアクセスを許可するポリシーが設定
#                             されているかどうかを示すブール値。
#
# - id: AWSアカウントIDとアクセスポイント名をコロン（:）で区切った値。
#---------------------------------------------------------------
