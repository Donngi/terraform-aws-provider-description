#---------------------------------------------------------------
# AWS S3 Vectors Vector Bucket Policy
#---------------------------------------------------------------
#
# Amazon S3 Vectors（ベクトルストレージ機能）のベクトルバケットに対する
# アクセス制御ポリシーをプロビジョニングするリソースです。
# ベクトルバケットポリシーは、リソースベースポリシーとして直接ベクトルバケットに
# アタッチされ、バケットとそのコンテンツへのアクセスを制御します。
# 他のAWSアカウントのプリンシパルに権限を付与できるため、
# クロスアカウントアクセスシナリオに有用です。
#
# AWS公式ドキュメント:
#   - S3 Vectors ベクトルバケットポリシー管理: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-bucket-policy.html
#   - S3 Vectors リソースベースポリシー例: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-resource-based-policies.html
#   - PutVectorBucketPolicy API: https://docs.aws.amazon.com/AmazonS3/latest/API/API_S3VectorBuckets_PutVectorBucketPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3vectors_vector_bucket_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3vectors_vector_bucket_policy" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vector_bucket_arn (Required, Forces new resource)
  # 設定内容: ポリシーを適用するベクトルバケットのARNを指定します。
  # 設定可能な値: 有効なS3 Vectorsベクトルバケットのアマゾンリソースネーム（ARN）
  #   形式: arn:aws[-a-z0-9]*:s3vectors:[a-z0-9-]+:[0-9]{12}:bucket/[バケット名]
  #   例: arn:aws:s3vectors:us-east-1:123456789012:bucket/my-vector-bucket
  # 注意: この属性が変更されると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/API/API_S3VectorBuckets_VectorBucket.html
  vector_bucket_arn = "arn:aws:s3vectors:us-east-1:123456789012:bucket/my-vector-bucket"

  # policy (Required)
  # 設定内容: ベクトルバケットに適用するポリシードキュメントをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式の文字列）
  # ポリシー構造:
  #   - Version: ポリシー言語バージョン（通常は "2012-10-17"）
  #   - Statement: 権限ステートメントの配列
  #     - Effect: "Allow" または "Deny"
  #     - Principal: 権限を付与/拒否する対象（AWSアカウント、IAMユーザー、ロール等）
  #     - Action: 許可/拒否するアクション（s3vectors:PutVectors, s3vectors:GetVectors等）
  #     - Resource: ポリシーが適用されるリソース
  # 関連機能: S3 Vectors リソースベースポリシー
  #   ベクトルバケットとそのコンテンツへのアクセス制御を定義します。
  #   リソースベースポリシーは、アイデンティティベースポリシーと組み合わせて評価され、
  #   有効な権限は該当するすべてのポリシーの和集合によって決定されます。
  #   クロスアカウントアクセスやきめ細かなアクセス制御に最適です。
  # 注意: ポリシードキュメントはJSON形式で記述する必要があります。
  #       ヒアドキュメント（<<EOF）やjsonencodeを使用して記述できます。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-vectors-resource-based-policies.html
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "VectorBucketPolicy",
  "Statement": [
    {
      "Sid": "AllowVectorWrite",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": [
        "s3vectors:PutVectors"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンが使用されます。
  # 関連機能: AWSリージョンエンドポイント
  #   リソースが管理されるリージョンを明示的に指定できます。
  #   マルチリージョン構成において、特定のリソースを異なるリージョンで
  #   管理したい場合に有用です。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは標準的な属性のみをエクスポートします。
# スキーマ定義には明示的な computed only 属性は含まれていません。
#---------------------------------------------------------------
