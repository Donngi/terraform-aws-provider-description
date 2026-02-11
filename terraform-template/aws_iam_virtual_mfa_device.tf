#---------------------------------------------------------------
# IAM Virtual MFA Device
#---------------------------------------------------------------
#
# IAM仮想MFAデバイスをプロビジョニングします。仮想MFAデバイスは
# 時間ベースワンタイムパスワード（TOTP）アルゴリズムを使用する
# ソフトウェアベースの認証デバイスで、IAMユーザーの多要素認証を
# 強化するために使用されます。
#
# 重要な注意事項:
# - すべての属性（特にbase_32_string_seedとqr_code_png）は
#   プレーンテキストとしてTerraformステートファイルに保存されます
# - 仮想MFAデバイスはTerraformから直接IAMユーザーに関連付けることは
#   できません。デバイスを有効化するには、base_32_string_seedまたは
#   qr_code_pngから生成されたTOTP認証コードを使用して、AWS CLIの
#   `aws iam enable-mfa-device`コマンドまたはAPI呼び出しを実行する
#   必要があります
#
# AWS公式ドキュメント:
#   - Multi-factor authentication in IAM: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html
#   - Assign a virtual MFA device: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html
#   - CreateVirtualMFADevice API: https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateVirtualMFADevice.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_virtual_mfa_device
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_virtual_mfa_device" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 仮想MFAデバイスの名前
  # - IAMアカウント内で一意である必要があります
  # - 英数字と以下の特殊文字が使用可能: +=,.@-_
  # - pathと組み合わせて仮想MFAデバイスを一意に識別します
  # - 最大128文字
  virtual_mfa_device_name = "example-mfa-device"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 仮想MFAデバイスのIAMパス
  # - デフォルト: "/" (ルートパス)
  # - パスの形式: スラッシュで始まりスラッシュで終わる必要があります
  #   例: "/division_abc/subdivision_xyz/"
  # - パスは組織の階層構造を反映するために使用できます
  # - 英数字とスラッシュ、以下の特殊文字が使用可能: +=,.@-_
  # - 最大512文字
  path = "/"

  # リソースタグ
  # - 仮想MFAデバイスに関連付けるキーバリューペアのマップ
  # - タグを使用してリソースの分類、追跡、管理を行うことができます
  # - provider default_tags設定ブロックで定義されたタグと
  #   キーが一致する場合、このタグが優先されます
  tags = {
    Name        = "example-mfa-device"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  # 注意: tags_allはprovider default_tagsとの統合のために
  # Terraformによって自動的に管理されます。通常は明示的に設定する
  # 必要はありません。
  # tags_all = {}

  # 注意: idはTerraformによって自動的に管理されます。
  # 通常は明示的に設定する必要はありません。
  # id = ""
}

#---------------------------------------------------------------
# Attributes Reference (Computed/Read-Only)
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定することはできません:
#
# - arn (string)
#   仮想MFAデバイスのAmazon Resource Name (ARN)。
#   シリアル番号としても機能します。
#   形式: arn:aws:iam::account-id:mfa/path/device-name
#
# - base_32_string_seed (string)
#   RFC3548で定義されているBase32シード（Base64エンコードされています）。
#   このシードは仮想MFAアプリケーションに設定するために使用されます。
#   機密情報として扱う必要があります。
#
# - enable_date (string)
#   仮想MFAデバイスが有効化された日時（ISO 8601形式）。
#   デバイスがまだ有効化されていない場合は空です。
#
# - qr_code_png (string)
#   QRコードのPNG画像（Base64エンコードされています）。
#   形式: otpauth://totp/$virtualMFADeviceName@$AccountName?secret=$Base32String
#   仮想MFAアプリケーションでスキャンして設定できます。
#
# - serial_number (string)
#   仮想MFAデバイスに関連付けられたシリアル番号。
#   arnと同じ値です。
#
# - user_name (string)
#   この仮想MFAデバイスに関連付けられているIAMユーザーの名前。
#   デバイスがユーザーに関連付けられていない場合は空です。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 仮想MFAデバイスの出力
#---------------------------------------------------------------
# 以下の出力を使用して、MFAデバイスのセットアップに必要な情報を取得できます:
#
# output "mfa_device_arn" {
#   description = "仮想MFAデバイスのARN"
#   value       = aws_iam_virtual_mfa_device.example.arn
# }
#
# output "mfa_device_base32_seed" {
#   description = "仮想MFAデバイスのBase32シード（機密情報）"
#   value       = aws_iam_virtual_mfa_device.example.base_32_string_seed
#   sensitive   = true
# }
#
# output "mfa_device_qr_code" {
#   description = "仮想MFAデバイスのQRコード（機密情報）"
#   value       = aws_iam_virtual_mfa_device.example.qr_code_png
#   sensitive   = true
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# MFAデバイスの有効化手順
#---------------------------------------------------------------
# 1. Terraformでこのリソースを作成
# 2. qr_code_pngまたはbase_32_string_seedを取得
# 3. 仮想MFAアプリ（Google Authenticator、Authy等）で設定
# 4. アプリから2つの連続したTOTPコードを取得
# 5. AWS CLIで有効化:
#    aws iam enable-mfa-device \
#      --user-name <IAM_USER_NAME> \
#      --serial-number <DEVICE_ARN> \
#      --authentication-code1 <CODE1> \
#      --authentication-code2 <CODE2>
#
#---------------------------------------------------------------
