#---------------------------------------------------------------
# GuardDuty Publishing Destination
#---------------------------------------------------------------
#
# Amazon GuardDutyの脅威検出結果（Findings）をAmazon S3バケットに
# エクスポートするための送信先設定を管理します。
#
# GuardDutyは検出結果を90日間保持しますが、このリソースを使用して
# S3バケットにエクスポートすることで履歴データの追跡や、
# 修復手順の有効性を長期的に評価できます。
#
# 新しいアクティブな検出結果は5分以内に自動的にエクスポートされ、
# 更新頻度は設定可能です（15分、1時間、6時間のいずれか）。
#
# AWS公式ドキュメント:
#   - Exporting GuardDuty findings to Amazon S3: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_exportfindings.html
#   - CreatePublishingDestination API: https://docs.aws.amazon.com/guardduty/latest/APIReference/API_CreatePublishingDestination.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_guardduty_publishing_destination" "example" {
  #---------------------------------------------------------------
  # Required Parameters
  #---------------------------------------------------------------

  # GuardDuty Detectorの識別子
  # GuardDuty Detectorは事前に作成されている必要があります。
  # 例: aws_guardduty_detector.main.id
  detector_id = "example-detector-id"

  # 検出結果をエクスポートするS3バケットのARNとプレフィックス
  # 形式: arn:aws:s3:::bucket-name または arn:aws:s3:::bucket-name/prefix
  # プレフィックスが指定されていない場合、デフォルトで
  # AWSLogs/[Account-ID]/GuardDuty/[Region]/ が使用されます。
  #
  # 注意事項:
  # - S3バケットは事前に作成されている必要があります
  # - GuardDutyがPutObjectアクションを実行できるようバケットポリシーを設定する必要があります
  # - バケットはKMS暗号化されたリソースである必要があります
  destination_arn = "arn:aws:s3:::example-guardduty-findings-bucket"

  # GuardDutyの検出結果を暗号化するために使用するKMSキーのARN
  # GuardDutyは検出結果の暗号化を強制するため、このパラメータは必須です。
  #
  # KMSキーポリシーには以下の権限が必要:
  # - kms:GenerateDataKey: GuardDutyが検出結果を暗号化できるようにする
  #
  # 注意事項:
  # - KMSキーとS3バケットは同じリージョンに存在する必要があります
  # - GuardDutyサービスプリンシパル（guardduty.amazonaws.com）に権限を付与する必要があります
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"

  #---------------------------------------------------------------
  # Optional Parameters
  #---------------------------------------------------------------

  # 送信先のタイプ
  # 現在サポートされているのはS3のみです。
  # デフォルト値: "S3"
  # destination_type = "S3"

  # このリソースを管理するAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  #
  # 注意事項:
  # - GuardDuty Detector、S3バケット、KMSキーは全て同じリージョンに
  #   存在する必要があります
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id: GuardDuty Publishing Destinationの識別子
#       形式: {detector_id}:{destination_id}
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 設定例
#---------------------------------------------------------------
#
# 完全な設定例（Detector、S3バケット、KMSキーを含む）:
#
# data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}
#
# # GuardDuty Detector
# resource "aws_guardduty_detector" "main" {
#   enable = true
# }
#
# # S3バケット
# resource "aws_s3_bucket" "guardduty_findings" {
#   bucket        = "my-guardduty-findings"
#   force_destroy = true
# }
#
# resource "aws_s3_bucket_acl" "guardduty_findings" {
#   bucket = aws_s3_bucket.guardduty_findings.id
#   acl    = "private"
# }
#
# # S3バケットポリシー
# data "aws_iam_policy_document" "guardduty_bucket_policy" {
#   statement {
#     sid = "AllowGuardDutyPutObject"
#     actions = [
#       "s3:PutObject"
#     ]
#     resources = [
#       "${aws_s3_bucket.guardduty_findings.arn}/*"
#     ]
#     principals {
#       type        = "Service"
#       identifiers = ["guardduty.amazonaws.com"]
#     }
#   }
#
#   statement {
#     sid = "AllowGuardDutyGetBucketLocation"
#     actions = [
#       "s3:GetBucketLocation"
#     ]
#     resources = [
#       aws_s3_bucket.guardduty_findings.arn
#     ]
#     principals {
#       type        = "Service"
#       identifiers = ["guardduty.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_s3_bucket_policy" "guardduty_findings" {
#   bucket = aws_s3_bucket.guardduty_findings.id
#   policy = data.aws_iam_policy_document.guardduty_bucket_policy.json
# }
#
# # KMSキー
# data "aws_iam_policy_document" "guardduty_kms_policy" {
#   statement {
#     sid = "AllowGuardDutyGenerateDataKey"
#     actions = [
#       "kms:GenerateDataKey"
#     ]
#     resources = [
#       "*"
#     ]
#     principals {
#       type        = "Service"
#       identifiers = ["guardduty.amazonaws.com"]
#     }
#   }
#
#   statement {
#     sid = "AllowRootAccountManageKey"
#     actions = [
#       "kms:*"
#     ]
#     resources = [
#       "*"
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }
#   }
# }
#
# resource "aws_kms_key" "guardduty" {
#   description             = "KMS key for GuardDuty findings encryption"
#   deletion_window_in_days = 7
#   policy                  = data.aws_iam_policy_document.guardduty_kms_policy.json
# }
#
# # Publishing Destination
# resource "aws_guardduty_publishing_destination" "main" {
#   detector_id     = aws_guardduty_detector.main.id
#   destination_arn = aws_s3_bucket.guardduty_findings.arn
#   kms_key_arn     = aws_kms_key.guardduty.arn
#
#   depends_on = [
#     aws_s3_bucket_policy.guardduty_findings,
#   ]
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. 前提条件:
#    - GuardDuty Detectorが有効化されている必要があります
#    - S3バケットが作成されている必要があります
#    - KMSキーが作成され、適切なポリシーが設定されている必要があります
#
# 2. IAM権限:
#    このリソースを作成するには、以下のIAM権限が必要です:
#    - guardduty:CreatePublishingDestination
#    - s3:GetBucketLocation
#    - s3:PutObject (バケットポリシーで設定)
#    - kms:GenerateDataKey (KMSキーポリシーで設定)
#
# 3. リージョンの制約:
#    - GuardDuty Detector、S3バケット、KMSキーは全て同じリージョンに
#      存在する必要があります
#
# 4. エクスポート頻度:
#    - 新しいアクティブな検出結果は5分以内に自動エクスポートされます
#    - アクティブな検出結果の更新頻度は別途設定できます（15分/1時間/6時間）
#
# 5. データ保持:
#    - GuardDutyは検出結果を90日間保持します
#    - S3にエクスポートすることで、90日を超える長期保管が可能になります
#
# 6. エクスポートエラー:
#    - S3バケットの削除や権限変更によりエクスポートに失敗する場合があります
#    - KMSキーへのアクセスが失敗する場合があります
#    - 90日間の保持期間内に問題を解決しないと、検出結果は失われます
#
# 7. 削除動作:
#    - このリソースを削除すると、Publishing Destinationの設定が削除されます
#    - 既にS3にエクスポートされた検出結果は削除されません
#
#---------------------------------------------------------------
