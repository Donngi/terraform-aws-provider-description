#---------------------------------------------------------------
# AWS ACM Private Certificate Authority Permission
#---------------------------------------------------------------
#
# AWS Certificate Manager Private Certificate Authority (ACM PCA) の
# 権限をプロビジョニングするリソースです。
# 主にACMサービスがPCAによって発行された証明書を自動的に更新できるように
# するために使用されます。
#
# AWS公式ドキュメント:
#   - AWS Private CA アクセス制御: https://docs.aws.amazon.com/privateca/latest/userguide/granting-ca-access.html
#   - Permission API リファレンス: https://docs.aws.amazon.com/privateca/latest/APIReference/API_Permission.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acmpca_permission
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_acmpca_permission" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # certificate_authority_arn (Required)
  # 設定内容: 権限を付与するプライベート認証局 (CA) のARNを指定します。
  # 設定可能な値: 有効なACM PCA認証局のARN
  # 関連機能: AWS Private Certificate Authority
  #   プライベートCAを作成し、プライベート証明書を発行・管理するサービス。
  #   - https://docs.aws.amazon.com/privateca/latest/userguide/granting-ca-access.html
  certificate_authority_arn = aws_acmpca_certificate_authority.example.arn

  # actions (Required)
  # 設定内容: 指定したAWSサービスプリンシパルが使用できるアクションを指定します。
  # 設定可能な値:
  #   - "IssueCertificate": 証明書を発行するアクション
  #   - "GetCertificate": 証明書を取得するアクション
  #   - "ListPermissions": 権限を一覧表示するアクション
  # 注意: ACMがPCAによって発行された証明書を自動的に更新するためには、
  #       上記3つのアクション全てを許可する必要があります。
  # 関連機能: ACM証明書の自動更新
  #   ACMは、PCAから発行されたマネージド証明書を有効期限前に自動更新できます。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/ca-access.html
  actions = ["IssueCertificate", "GetCertificate", "ListPermissions"]

  # principal (Required)
  # 設定内容: 権限を受け取るAWSサービスまたはIDを指定します。
  # 設定可能な値:
  #   - "acm.amazonaws.com": AWS Certificate Managerサービスプリンシパル
  # 注意: 現時点では、有効なプリンシパルは "acm.amazonaws.com" のみです。
  principal = "acm.amazonaws.com"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # source_account (Optional)
  # 設定内容: 呼び出し元アカウントのIDを指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: 現在のアカウントIDが使用されます
  # 用途: クロスアカウントでの権限付与時に、ソースアカウントを明示的に指定する場合に使用
  source_account = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - policy: 権限に関連付けられたIAMポリシー
#
#---------------------------------------------------------------
