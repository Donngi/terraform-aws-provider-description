#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AWS S3 Control Bucket Policy (S3 on Outposts)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 概要:
#   Amazon S3 on Outpostsバケットのバケットポリシーを管理するリソースです。
#
# 重要な注意事項:
#   このリソースはS3 on Outposts専用です。通常のAWS S3バケットポリシーを管理する場合は
#   aws_s3_bucket_policy リソースを使用してください。
#
# ユースケース:
#   - S3 on Outpostsバケットのアクセスポリシー管理
#   - Outpostsストレージのセキュリティ制御の実施
#   - Outpostsバケットへのきめ細かいアクセス制御の実装
#
# 関連リソース:
#   - aws_s3control_bucket: S3 Controlバケットを管理
#   - aws_s3_bucket_policy: 標準AWSパーティションのS3バケットポリシーを管理
#   - aws_iam_policy_document: IAMポリシードキュメントを構築するデータソース
#
# ドキュメント:
#   - AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3control_bucket_policy
#   - AWS S3 on Outposts: https://docs.aws.amazon.com/AmazonS3/latest/dev/S3onOutposts.html
#   - IAM Policy Guide: https://learn.hashicorp.com/terraform/aws/iam-policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

resource "aws_s3control_bucket_policy" "example" {
  #============================================================================
  # 必須引数
  #============================================================================

  # bucket - (必須) バケットのAmazon Resource Name (ARN)
  #
  # 説明:
  #   ポリシーを適用するS3 Controlバケット(S3 on Outposts)のARNを指定します。
  #
  # 型: string
  # ARN形式: arn:aws:s3-outposts:{region}:{account-id}:outpost/{outpost-id}/bucket/{bucket-name}
  # 例: "arn:aws:s3-outposts:us-west-2:123456789012:outpost/op-01234567890123456/bucket/example-bucket"
  # 参照: 既存のバケットを参照する場合は aws_s3control_bucket.example.arn を使用
  bucket = aws_s3control_bucket.example.arn

  # policy - (必須) リソースポリシーのJSON文字列
  #
  # 説明:
  #   バケットポリシーをJSONドキュメントとして定義します。このポリシーは、S3 Control
  #   バケットへのアクセス権限を定義します。ポリシードキュメントの構築には jsonencode()
  #   を使用するか、より可読性と保守性の高い aws_iam_policy_document データソースを
  #   使用することを推奨します。
  #
  # 型: string (JSON形式)
  # 形式: 有効なIAMポリシードキュメントのJSON形式である必要があります
  # サイズ制限: 最大20KB
  # 検証: AWS IAMポリシー構文に従う必要があります
  # ベストプラクティス: ポリシー作成には aws_iam_policy_document データソースを使用
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/s3-outposts/S3Outposts-example-bucket-policies.html
  #
  # 例1 - jsonencode()を使用したインラインJSON:
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "testBucketPolicy"
    Statement = [
      {
        Sid    = "statement1"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        }
        Action   = "s3-outposts:PutBucketLifecycleConfiguration"
        Resource = aws_s3control_bucket.example.arn
      }
    ]
  })

  # 例2 - aws_iam_policy_document データソースを使用 (推奨):
  # policy = data.aws_iam_policy_document.example.json

  #============================================================================
  # オプション引数
  #============================================================================

  # region - (オプション) このリソースを管理するリージョン
  #
  # 説明:
  #   S3 Controlバケットポリシーを管理するAWSリージョンを指定します。
  #   指定しない場合は、プロバイダー設定のリージョンがデフォルトとなります。
  #
  # 型: string
  # デフォルト: プロバイダーで設定されたリージョン
  # 例: "us-west-2"
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #============================================================================
  # 属性リファレンス
  #============================================================================
  # このリソースは以下の属性をエクスポートします:
  #
  # - id: バケットのAmazon Resource Name (ARN)
  #       形式: bucket引数と同じ
  #       使用例: aws_s3control_bucket_policy.example.id として参照可能
}

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 追加の使用例
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 例1: aws_iam_policy_document データソースを使用 (推奨アプローチ)
# ────────────────────────────────────────────────────────────────────────────
# data "aws_iam_policy_document" "example" {
#   statement {
#     sid    = "statement1"
#     effect = "Deny"
#
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#
#     actions = [
#       "s3-outposts:PutBucketLifecycleConfiguration"
#     ]
#
#     resources = [
#       aws_s3control_bucket.example.arn
#     ]
#   }
# }
#
# resource "aws_s3control_bucket_policy" "example" {
#   bucket = aws_s3control_bucket.example.arn
#   policy = data.aws_iam_policy_document.example.json
# }

# 例2: 特定のIAMロールにアクセスを許可するポリシー
# ────────────────────────────────────────────────────────────────────────────
# resource "aws_s3control_bucket_policy" "role_access" {
#   bucket = aws_s3control_bucket.example.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowRoleAccess"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:role/example-role"
#         }
#         Action = [
#           "s3-outposts:GetObject",
#           "s3-outposts:PutObject",
#           "s3-outposts:DeleteObject"
#         ]
#         Resource = "${aws_s3control_bucket.example.arn}/*"
#       }
#     ]
#   })
# }

# 例3: 複数のステートメントを含むポリシー
# ────────────────────────────────────────────────────────────────────────────
# resource "aws_s3control_bucket_policy" "multi_statement" {
#   bucket = aws_s3control_bucket.example.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowListBucket"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:role/example-role"
#         }
#         Action   = "s3-outposts:ListBucket"
#         Resource = aws_s3control_bucket.example.arn
#       },
#       {
#         Sid    = "AllowObjectAccess"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:role/example-role"
#         }
#         Action = [
#           "s3-outposts:GetObject",
#           "s3-outposts:PutObject"
#         ]
#         Resource = "${aws_s3control_bucket.example.arn}/*"
#       },
#       {
#         Sid    = "DenyUnencryptedUploads"
#         Effect = "Deny"
#         Principal = {
#           AWS = "*"
#         }
#         Action   = "s3-outposts:PutObject"
#         Resource = "${aws_s3control_bucket.example.arn}/*"
#         Condition = {
#           StringNotEquals = {
#             "s3-outposts:x-amz-server-side-encryption" = "AES256"
#           }
#         }
#       }
#     ]
#   })
# }

# 例4: 明示的なリージョン設定を含む
# ────────────────────────────────────────────────────────────────────────────
# resource "aws_s3control_bucket_policy" "with_region" {
#   bucket = aws_s3control_bucket.example.arn
#   region = "us-west-2"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "RequireMFA"
#         Effect = "Deny"
#         Principal = {
#           AWS = "*"
#         }
#         Action   = "s3-outposts:*"
#         Resource = "${aws_s3control_bucket.example.arn}/*"
#         Condition = {
#           BoolIfExists = {
#             "aws:MultiFactorAuthPresent" = "false"
#           }
#         }
#       }
#     ]
#   })
# }

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ベストプラクティス
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. 保守性向上のため、aws_iam_policy_document データソースを使用する
# 2. 権限付与時は最小権限の原則に従う
# 3. 可能な限りワイルドカードではなく具体的なアクションを使用する
# 4. 機密操作に対しては明示的なDenyステートメントを含める
# 5. 条件を使用して追加のセキュリティ要件(MFA、暗号化など)を実装する
# 6. 本番環境への適用前に非本番環境でポリシーをテストする
# 7. Sid(ステートメントID)を使用して各ポリシーステートメントの目的を文書化する
# 8. これはS3 on Outposts用であり、標準S3バケット用ではないことに注意する
# 9. リソースARNパターンを慎重に使用する(バケットARN vs /*を含むオブジェクトARN)
# 10. AWS S3 on Outposts固有のアクションと条件を確認する
#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 重要な注意事項
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# - このリソースはS3 on Outposts専用です
# - 標準S3バケットの場合は aws_s3_bucket_policy を使用してください
# - S3 Outpostsは標準S3とは異なるアクションプレフィックス(s3-outposts:*)を使用します
# - bucket引数には有効なS3 ControlバケットARNを指定する必要があります
# - ポリシー変更の反映には数分かかる場合があります
# - 無効なポリシーはTerraform applyを失敗させます
# - ポリシー変更を適用する前に terraform plan で検証してください
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
