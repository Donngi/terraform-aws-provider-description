#---------------------------------------------------------------
# AWS CodeArtifact Domain Permissions Policy
#---------------------------------------------------------------
#
# AWS CodeArtifactドメインに対するリソースベースのアクセス許可ポリシーを
# 設定するリソースです。このポリシーにより、他のAWSアカウントやIAMプリンシパルに
# 対してドメインへのアクセス権限を制御できます。
#
# AWS公式ドキュメント:
#   - Domain policies: https://docs.aws.amazon.com/codeartifact/latest/ug/domain-policies.html
#   - PutDomainPermissionsPolicy API: https://docs.aws.amazon.com/codeartifact/latest/APIReference/API_PutDomainPermissionsPolicy.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_codeartifact_domain_permissions_policy" "example" {
  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: リソースポリシーを設定するCodeArtifactドメインの名前を指定します。
  # 設定可能な値: 既存のCodeArtifactドメイン名
  # 関連機能: CodeArtifact Domain
  #   CodeArtifactドメインは、リポジトリをグループ化し、組織全体で
  #   パッケージアセットとメタデータを共有するための階層構造を提供します。
  #   - https://docs.aws.amazon.com/codeartifact/latest/ug/domain-policies.html
  domain = "example-domain"

  #-------------------------------------------------------------
  # ポリシードキュメント設定
  #-------------------------------------------------------------

  # policy_document (Optional)
  # 設定内容: ドメインに適用するリソースベースのアクセス許可ポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式）
  # 関連機能: IAM Resource-based Policies
  #   このポリシーにより、他のAWSアカウントやIAMプリンシパルに対して
  #   ドメイン内でのリポジトリ作成、認証トークンの取得などの権限を付与できます。
  #   クロスアカウントアクセスを有効にする場合に必須です。
  #   - https://docs.aws.amazon.com/codeartifact/latest/ug/domain-policies.html
  # 注意: ドメインポリシーは、ドメインおよびそのすべてのリソースに対する
  #       操作に対して評価されます。
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "codeartifact:CreateRepository",
          "codeartifact:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })

  #-------------------------------------------------------------
  # ドメイン所有者設定
  #-------------------------------------------------------------

  # domain_owner (Optional)
  # 設定内容: ドメインを所有するAWSアカウントのアカウント番号を指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: 現在のAWSアカウントが使用されます
  # 用途: クロスアカウントでドメインにアクセスする場合に指定します
  #   - https://docs.aws.amazon.com/codeartifact/latest/ug/domain-policies.html
  domain_owner = null

  #-------------------------------------------------------------
  # ポリシーリビジョン設定
  #-------------------------------------------------------------

  # policy_revision (Optional)
  # 設定内容: 設定するリソースポリシーの現在のリビジョンIDを指定します。
  # 設定可能な値: ポリシーリビジョンID文字列
  # 省略時: リビジョンチェックは行われません
  # 関連機能: Optimistic Locking
  #   このリビジョンIDは楽観的ロックに使用され、他のユーザーがドメインの
  #   リソースポリシーに対する変更を上書きすることを防ぎます。
  #   ポリシーの更新時の競合を避けるために使用されます。
  #   - https://docs.aws.amazon.com/codeartifact/latest/APIReference/API_PutDomainPermissionsPolicy.html
  policy_revision = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  region = null

  #-------------------------------------------------------------
  # リソースID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: ドメイン名
  # 省略時: Terraformが自動的に管理します
  # 注意: 通常は明示的に指定する必要はありません。
  #       リソース作成後、この値にはドメイン名が設定されます。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインの名前
#
# - resource_arn: リソースポリシーに関連付けられたリソースのAmazon Resource Name (ARN)
#---------------------------------------------------------------

#---------------------------------------------------------------
# 1. クロスアカウントアクセスの設定:
#    - 他のAWSアカウントにドメインへのアクセスを許可する場合は、
#      policy_documentで適切なプリンシパルとアクションを指定してください。
#    - 最小権限の原則に従い、必要最小限の権限のみを付与してください。
#
# 2. セキュリティのベストプラクティス:
#    - 可能な限り、ワイルドカード(*)の使用を避け、特定のリソースARNを指定してください。
#    - 組織内の複数のアカウントに権限を付与する場合は、
#      aws:PrincipalOrgID条件キーの使用を検討してください。
#    - 定期的にポリシーを見直し、不要な権限が付与されていないか確認してください。
#
# 3. ポリシーの管理:
#    - policy_revisionを使用することで、ポリシーの同時更新による
#      競合を防ぐことができます。
#---------------------------------------------------------------
