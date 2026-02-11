#---------------------------------------------------------------
# AWS EBS Default KMS Key
#---------------------------------------------------------------
#
# AWSアカウントがEBSボリュームの暗号化に使用するデフォルトの
# カスタマーマスターキー (CMK) を管理するリソースです。
#
# AWSアカウントには、EBSボリュームを作成するAPIコールでCMKが指定されていない
# 場合に使用されるAWSマネージドのデフォルトCMKがあります。
# このリソースを使用することで、AWSマネージドのデフォルトCMKの代わりに
# カスタマーマネージドCMKを指定できます。
#
# 重要な注意事項:
#   - このリソースを作成しても、デフォルトのEBS暗号化は有効になりません。
#     デフォルトのEBS暗号化を有効にするには aws_ebs_encryption_by_default
#     リソースを使用してください。
#   - このリソースを削除すると、デフォルトCMKはアカウントのAWSマネージド
#     デフォルトCMK (EBS用) にリセットされます。
#
# AWS公式ドキュメント:
#   - EBS 暗号化: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-encryption.html
#   - EBS 暗号化のデフォルト: https://docs.aws.amazon.com/ebs/latest/userguide/encryption-by-default.html
#   - KMS キー管理: https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_default_kms_key
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ebs_default_kms_key" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # key_arn (Required, ForceNew)
  # 設定内容: EBSボリュームの暗号化に使用するAWS KMSカスタマーマスターキー (CMK) の
  #           ARNを指定します。
  # 設定可能な値: 有効なKMS CMKのARN
  # 用途: EBSボリューム作成時にCMKが指定されていない場合、このキーが使用されます
  # 注意: この値を変更すると、リソースが強制的に再作成されます (ForceNew)
  # 関連機能: AWS KMS
  #   カスタマーマネージドキーを使用することで、キーのローテーションや
  #   アクセス制御をより細かく管理できます。
  #   - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html
  key_arn = aws_kms_key.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: EBSデフォルトKMSキーはリージョン単位で設定されるため、
  #       複数のリージョンで使用する場合は各リージョンごとに設定が必要です
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ID (通常は明示的に設定不要)
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースのID
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  # id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リソースのID (リージョン名と同じ)
#
# - key_arn: 設定されているKMSキーのARN
#
# - region: リソースが管理されているリージョン
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
# EBSデフォルトKMSキーを設定する場合、通常は以下のリソースと
# 組み合わせて使用します:
#
# 1. KMSキーの作成
# resource "aws_kms_key" "example" {
#   description             = "KMS key for EBS encryption"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
# }
#
# 2. デフォルト暗号化の有効化
# resource "aws_ebs_encryption_by_default" "example" {
#   enabled = true
# }
#
# 3. デフォルトKMSキーの設定 (このリソース)
# resource "aws_ebs_default_kms_key" "example" {
#   key_arn = aws_kms_key.example.arn
# }
#---------------------------------------------------------------
