#---------------------------------------------------------------
# AWS WorkSpaces Web Trust Store
#---------------------------------------------------------------
#
# Amazon WorkSpaces Secure Browserのトラストストアリソースを
# プロビジョニングします。
# トラストストアはカスタムルート証明書および中間CA証明書を管理し、
# Webポータルに関連付けることで、社内プロキシや自己署名証明書を
# 使用したWebサイトへの安全なアクセスを実現します。
#
# AWS公式ドキュメント:
#   - トラストストア概要: https://docs.aws.amazon.com/workspaces-web/latest/adminguide/trust-store.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspacesweb_trust_store
#
# Provider Version: 6.28.0
# Generated: 2026-02-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_workspacesweb_trust_store" "example" {
  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # certificate (Optional)
  # 設定内容: トラストストアに追加するCA証明書のセットを指定します。
  # 設定可能な値: PEM形式の証明書本文を含むブロックの集合
  # 省略時: 証明書なし（空のトラストストアが作成されます）
  certificate {
    # body (Required)
    # 設定内容: PEM形式のCA証明書本文を指定します。
    # 設定可能な値: 有効なPEM形式の証明書文字列（-----BEGIN CERTIFICATE-----で始まる）
    body = file("certs/ca.pem")
  }

  # 複数の証明書を追加する場合は certificate ブロックを複数記述します。
  # certificate {
  #   body = file("certs/intermediate-ca.pem")
  # }

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
    Name        = "example-trust-store"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - trust_store_arn: トラストストアリソースのARN。
#
# - associated_portal_arns: このトラストストアに関連付けられている
#                           Webポータルの ARN のリスト。
#
# - certificate[*].issuer: 証明書の発行者情報。
# - certificate[*].not_valid_after: 証明書の有効期限終了日時（RFC3339形式）。
# - certificate[*].not_valid_before: 証明書の有効期限開始日時（RFC3339形式）。
# - certificate[*].subject: 証明書のサブジェクト情報。
# - certificate[*].thumbprint: 証明書のサムプリント（SHA-1ハッシュ）。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
