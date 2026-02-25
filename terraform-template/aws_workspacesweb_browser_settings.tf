#---------------------------------------------------------------
# AWS WorkSpaces Web Browser Settings
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのブラウザー設定リソースを
# プロビジョニングします。
# ブラウザーポリシー（JSON形式）を定義し、エンドユーザーのブラウザー
# 動作を細かく制御できます。ダウンロード・アップロードの制限、
# 印刷制御、クリップボードアクセスなどのセキュリティポリシーを
# 一元管理し、Webポータルに関連付けることで適用できます。
#
# AWS公式ドキュメント:
#   - ブラウザー設定概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/browser-settings.html
#   - ブラウザーポリシー: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/browser-policy.html
#   - カスタマー管理キー: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/data-protection.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_browser_settings
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_browser_settings" "example" {
  #-------------------------------------------------------------
  # ブラウザーポリシー設定
  #-------------------------------------------------------------

  # browser_policy (Required)
  # 設定内容: ブラウザー動作を制御するJSON形式のポリシーを指定します。
  # 設定可能な値: 有効なJSON文字列（WorkSpaces Webブラウザーポリシー形式）
  # 注意: ポリシーにはダウンロード・アップロード制限、印刷制御、
  #       クリップボードアクセス制御などのルールを含めることができます。
  browser_policy = jsonencode({
    chromePolicies = [
      {
        policy = "DownloadRestrictions"
        value  = 3
      }
    ]
  })

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # customer_managed_key (Optional)
  # 設定内容: リソースの暗号化に使用するカスタマー管理KMSキーのARNを指定します。
  # 設定可能な値: 有効なAWS KMSキーのARN
  # 省略時: AWSマネージドキーによる暗号化を使用
  customer_managed_key = null

  # additional_encryption_context (Optional)
  # 設定内容: カスタマー管理KMSキーを使用する際の追加暗号化コンテキストを指定します。
  # 設定可能な値: キーと値のペアのマップ（文字列）
  # 省略時: 追加の暗号化コンテキストなし
  additional_encryption_context = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-browser-settings"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - browser_settings_arn: ブラウザー設定リソースのARN。
#
# - associated_portal_arns: このブラウザー設定に関連付けられている
#                           Webポータルの ARN のリスト。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
