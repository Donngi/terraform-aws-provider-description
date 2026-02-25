#---------------------------------------------------------------
# AWS IAM Roles Anywhere Profile
#---------------------------------------------------------------
#
# IAM Roles Anywhereのプロファイルをプロビジョニングするリソースです。
# プロファイルは、IAM Roles Anywhereサービスが一時的な認証情報を発行する際に
# 引き受け可能なIAMロールの一覧と、セッションに適用するポリシーを定義します。
# トラストアンカーと組み合わせることで、AWSの外部ワークロードがX.509証明書を使って
# 一時的なAWS認証情報を取得できるようになります。
#
# AWS公式ドキュメント:
#   - IAM Roles Anywhere 入門ガイド: https://docs.aws.amazon.com/rolesanywhere/latest/userguide/getting-started.html
#   - IAM Roles Anywhere APIリファレンス - ProfileDetail: https://docs.aws.amazon.com/rolesanywhere/latest/APIReference/API_ProfileDetail.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_profile
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_rolesanywhere_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: プロファイルの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-profile"

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_arns (Optional)
  # 設定内容: このプロファイルが引き受け可能なIAMロールのARNのリストを指定します。
  # 設定可能な値: 有効なIAMロールARNのセット
  # 省略時: null (ロールが関連付けられていない状態)
  # 注意: 指定するIAMロールの信頼ポリシーには、IAM Roles Anywhereサービスプリンシパル
  #       (rolesanywhere.amazonaws.com) が含まれている必要があります。
  role_arns = [
    "arn:aws:iam::123456789012:role/example-role",
  ]

  # managed_policy_arns (Optional)
  # 設定内容: 発行されるセッション認証情報に適用するIAMマネージドポリシーのARNのリストを指定します。
  # 設定可能な値: 有効なIAMマネージドポリシーARNのセット
  # 省略時: null (マネージドポリシーは追加されません)
  # 注意: セッションポリシーはIAMロールに付与された権限との積集合として機能します。
  managed_policy_arns = []

  #-------------------------------------------------------------
  # セッション設定
  #-------------------------------------------------------------

  # duration_seconds (Optional)
  # 設定内容: 発行されるセッション認証情報の有効期間を秒単位で指定します。
  # 設定可能な値: 数値（秒）
  # 省略時: 3600秒（1時間）
  duration_seconds = 3600

  # session_policy (Optional)
  # 設定内容: 発行されるセッション認証情報のトラストバウンダリーに適用するセッションポリシーを
  #           JSON形式で指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 省略時: null (追加のセッションポリシーは適用されません)
  # 注意: セッションポリシーはIAMロールのポリシーとの積集合として機能するため、
  #       セッションポリシーで許可してもIAMロールで拒否されている権限は使用できません。
  session_policy = null

  # accept_role_session_name (Optional)
  # 設定内容: CreateSessionリクエストでカスタムロールセッション名の受け入れを許可するかを指定します。
  # 設定可能な値:
  #   - true: カスタムロールセッション名を受け入れます
  #   - false: カスタムロールセッション名を受け入れません
  # 省略時: false
  # 参考: https://docs.aws.amazon.com/rolesanywhere/latest/userguide/getting-started.html
  accept_role_session_name = false

  # require_instance_properties (Optional)
  # 設定内容: このプロファイルを使用するCreateSessionリクエストにインスタンスプロパティの
  #           指定を必須とするかどうかを指定します。
  # 設定可能な値:
  #   - true: インスタンスプロパティを必須とします
  #   - false: インスタンスプロパティを必須としません
  # 省略時: false
  require_instance_properties = false

  #-------------------------------------------------------------
  # 有効化設定
  #-------------------------------------------------------------

  # enabled (Optional)
  # 設定内容: プロファイルを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: プロファイルを有効化します
  #   - false: プロファイルを無効化します
  # 省略時: null
  enabled = true

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: null
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-profile"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: プロファイルのAmazon Resource Name (ARN)
# - id: プロファイルID
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
