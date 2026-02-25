#---------------------------------------------------------------
# AWS MediaStore Container Policy
#---------------------------------------------------------------
#
# AWS Elemental MediaStoreコンテナにリソースベースのポリシーを
# アタッチするためのリソースです。
# コンテナポリシーにより、コンテナへのアクセス制御を細かく設定できます。
#
# 注意: このリソースは非推奨（deprecated）となっており、今後削除される予定です。
# 新規の実装では代替サービスの使用を検討してください。
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/media_store_container_policy
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_media_store_container_policy" "example" {
  #-------------------------------------------------------------
  # コンテナ設定
  #-------------------------------------------------------------

  # container_name (Required)
  # 設定内容: ポリシーをアタッチするMediaStoreコンテナの名前を指定します。
  # 設定可能な値: 既存のMediaStoreコンテナ名（aws_media_store_containerリソースの名前等）
  container_name = aws_media_store_container.example.name

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Required)
  # 設定内容: コンテナにアタッチするJSON形式のリソースベースポリシーを指定します。
  # 設定可能な値: 有効なJSON形式のIAMポリシードキュメント
  policy = data.aws_iam_policy_document.example.json

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
# IAMポリシードキュメントの例
#---------------------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "example" {
  # コンテナへのアクセスを許可するステートメント
  statement {
    sid    = "AllowMediaStoreAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "mediastore:GetObject",
      "mediastore:DescribeObject",
      "mediastore:PutObject",
      "mediastore:ListItems",
    ]

    resources = ["arn:aws:mediastore:*:${data.aws_caller_identity.current.account_id}:container/*"]
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: コンテナ名（container_name と同値）
#
#---------------------------------------------------------------
