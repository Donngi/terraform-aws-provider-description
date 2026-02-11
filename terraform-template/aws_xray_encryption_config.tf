#---------------------------------------------------------------
# AWS X-Ray Encryption Config
#---------------------------------------------------------------
#
# AWS X-Rayの暗号化設定をプロビジョニングするリソースです。
# X-Rayで収集されるトレースデータおよび関連データの暗号化方式を設定します。
# デフォルト暗号化またはAWS KMSキーを使用したカスタム暗号化を選択できます。
#
# AWS公式ドキュメント:
#   - Data protection in AWS X-Ray: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-encryption.html
#   - PutEncryptionConfig API: https://docs.aws.amazon.com/xray/latest/api/API_PutEncryptionConfig.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_encryption_config
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_xray_encryption_config" "example" {
  #-------------------------------------------------------------
  # 暗号化タイプ設定
  #-------------------------------------------------------------

  # type (Required)
  # 設定内容: X-Rayデータの暗号化タイプを指定します。
  # 設定可能な値:
  #   - "NONE": デフォルト暗号化を使用。AWSが管理する暗号化キーでデータを保護します。
  #   - "KMS": AWS KMSカスタマーマスターキー(CMK)を使用した暗号化。
  #            独自のキーでデータを暗号化し、キー使用状況をAWS CloudTrailで監査可能。
  # 関連機能: X-Ray データ保護
  #   X-Rayは保存時のトレースデータおよび関連データを暗号化します。
  #   KMSキーを使用する場合、キーへのアクセス権限が必要です。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-encryption.html
  type = "KMS"

  #-------------------------------------------------------------
  # KMSキー設定
  #-------------------------------------------------------------

  # key_id (Optional)
  # 設定内容: 暗号化に使用するAWS KMSカスタマーマスターキー(CMK)のARNを指定します。
  # 設定可能な値:
  #   - KMSキーのARN（例: arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012）
  #   - KMSキーのID（例: 12345678-1234-1234-1234-123456789012）
  #   - KMSキーのエイリアス（例: alias/my-key）
  # 省略時: typeが"KMS"の場合は必須。typeが"NONE"の場合は不要。
  # 関連機能: AWS KMS暗号化
  #   カスタマー管理キーを使用すると、キーへのアクセス制御やキーローテーションの
  #   設定が可能です。AWS管理キー（aws/xray）を使用することもできます。
  #   X-Rayは非対称KMSキーをサポートしていません。
  #   - https://docs.aws.amazon.com/xray/latest/devguide/xray-console-encryption.html
  # 注意: X-Rayが暗号化キーにアクセスできない場合、データの保存が停止します。
  key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: リージョン名。暗号化設定が適用されているリージョンを示します。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 例1: デフォルト暗号化を使用する場合
#
# resource "aws_xray_encryption_config" "default" {
#   type = "NONE"
# }
#
# 例2: KMSキーを使用した暗号化
#
# resource "aws_kms_key" "xray" {
#   description             = "X-Ray encryption key"
#   deletion_window_in_days = 7
# }
#
# resource "aws_xray_encryption_config" "kms" {
#---------------------------------------------------------------
