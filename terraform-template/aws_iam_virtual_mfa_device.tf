#---------------------------------------------------------------
# AWS IAM Virtual MFA Device
#---------------------------------------------------------------
#
# AWS Identity and Access Management (IAM) の仮想MFAデバイスを
# プロビジョニングするリソースです。
# 仮想MFAデバイスは、Google AuthenticatorなどのTOTPアプリを使用して
# 多要素認証を実現するためのソフトウェアベースのMFAデバイスです。
# 作成後は IAMユーザーに関連付けることで多要素認証を有効化できます。
#
# AWS公式ドキュメント:
#   - 仮想MFAデバイス: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html
#   - MFAデバイスの管理: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_virtual_mfa_device
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_iam_virtual_mfa_device" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # virtual_mfa_device_name (Required, Forces new resource)
  # 設定内容: 仮想MFAデバイスの名前を指定します。
  # 設定可能な値: 英数字および以下の記号: =,.@-_
  #   スペースは使用不可。最大64文字。
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html
  virtual_mfa_device_name = "example-mfa-device"

  #-------------------------------------------------------------
  # パス設定
  #-------------------------------------------------------------

  # path (Optional)
  # 設定内容: 仮想MFAデバイスを配置するIAMパスを指定します。
  # 設定可能な値: スラッシュ（/）で始まりスラッシュで終わるパス文字列（例: "/mfa/"）
  # 省略時: "/" (ルートパス)
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html
  path = "/"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-mfa-device"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AWS が割り当てた仮想MFAデバイスのARN
#
# - id: 仮想MFAデバイスのARN（arnと同一）
#
# - base_32_string_seed: TOTPアルゴリズムで使用するシークレットキーのBase32エンコード値。
#                        仮想MFAアプリへの手動設定に使用可能。
#
# - qr_code_png: QRコードのPNG画像（Base64エンコード）。
#                仮想MFAアプリでのスキャンに使用可能。
#
# - serial_number: 仮想MFAデバイスのシリアル番号（ARNと同一）
#
# - enable_date: 仮想MFAデバイスがIAMユーザーに関連付けられた日時
#
# - user_name: 仮想MFAデバイスが関連付けられているIAMユーザー名
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
