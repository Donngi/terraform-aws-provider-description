# ============================================================
# Terraform Template: aws_cognito_identity_pool_provider_principal_tag
# ============================================================
# Generated: 2026-01-19
# Provider Version: hashicorp/aws 6.28.0
#
# 注意事項:
# - このテンプレートは生成時点(2026-01-19)の AWS Provider 6.28.0 の仕様に基づいています
# - 最新の仕様や詳細については、必ず公式ドキュメントをご確認ください
# - AWS Provider Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_provider_principal_tag
# ============================================================

# AWS Cognito Identity Pool Provider Principal Tag
#
# このリソースは、Amazon Cognito Identity Pool の Principal Mapping を提供します。
# Identity Provider から受け取った属性を、IAM ロールに渡されるタグにマッピングすることができます。
# これにより、より詳細な属性ベースのアクセス制御(ABAC)を実装できます。
#
# AWS公式ドキュメント:
# - Amazon Cognito Identity Pools: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-identity.html
# - Attribute-Based Access Control: https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html
resource "aws_cognito_identity_pool_provider_principal_tag" "example" {
  # ============================================================
  # 必須パラメータ
  # ============================================================

  # identity_pool_id - (Required) Cognito Identity Pool の ID
  # - 対象となる Identity Pool を指定します
  # - 形式: リージョン:UUID (例: us-east-1:12345678-1234-1234-1234-123456789012)
  # - aws_cognito_identity_pool リソースの id 属性を参照することが一般的です
  identity_pool_id = "us-east-1:12345678-1234-1234-1234-123456789012"

  # identity_provider_name - (Required) Identity Provider の名前
  # - Principal タグを設定する Identity Provider を指定します
  # - Cognito User Pool の場合: User Pool の endpoint 属性を使用
  #   形式: cognito-idp.<region>.amazonaws.com/<user_pool_id>
  # - その他の IdP の場合: それぞれの Provider 名を指定
  identity_provider_name = "cognito-idp.us-east-1.amazonaws.com/us-east-1_Example"

  # ============================================================
  # オプションパラメータ
  # ============================================================

  # id - (Optional) リソースの ID
  # - Terraform による管理用の識別子
  # - 省略可能: Terraform が自動的に生成します
  # - 形式: <identity_pool_id>:<identity_provider_name>
  # - Computed: リソース作成後に自動的に設定されます
  id = null

  # principal_tags - (Optional) Principal タグのマッピング
  # - Identity Provider から取得した属性を、IAM Principal タグとしてマッピングします
  # - Map 型: キーと値のペア
  # - キー: IAM Principal タグのキー名
  # - 値: Identity Provider から取得する属性名（通常は OIDC クレーム名など）
  # - これらのタグは、引き受けられる IAM ロールのセッションタグとして渡されます
  # - ABAC (Attribute-Based Access Control) ポリシーで使用できます
  #
  # 例:
  # - "department" = "custom:department" (Cognito User Pool のカスタム属性)
  # - "email" = "email" (標準属性)
  # - "team" = "custom:team"
  #
  # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_session-tags.html
  principal_tags = {
    department = "custom:department"
    email      = "email"
  }

  # region - (Optional) リソースを管理するリージョン
  # - このリソースがデプロイされる AWS リージョンを指定します
  # - 省略時はプロバイダー設定のリージョンが使用されます
  # - Computed: 自動的に決定されます
  # - 明示的に指定する場合は、リージョンコードを使用します（例: "us-east-1", "ap-northeast-1"）
  #
  # AWS リージョン一覧: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # use_defaults - (Optional) デフォルトのマッピングを使用するかどうか
  # - Boolean 型
  # - true: AWS が提供するデフォルトの属性マッピングを使用します
  # - false: principal_tags で明示的に指定したマッピングのみを使用します
  # - デフォルト値はプロバイダーの動作に依存しますが、通常は false の動作になります
  # - true を指定すると、一般的な属性（sub, email など）が自動的にマッピングされます
  use_defaults = false

  # ============================================================
  # 備考
  # ============================================================
  # このリソースを使用する際の注意点:
  #
  # 1. Identity Pool の設定
  #    - 対象の Identity Pool で、該当する Identity Provider が設定されている必要があります
  #    - aws_cognito_identity_pool の cognito_identity_providers ブロックで設定します
  #
  # 2. IAM ロールの設定
  #    - マッピングしたタグを利用するには、対応する IAM ロールのポリシーで
  #      Principal タグを参照する必要があります
  #    - 例: "Condition": {"StringEquals": {"aws:PrincipalTag/department": "engineering"}}
  #
  # 3. Identity Provider の属性
  #    - principal_tags で指定する値（属性名）は、Identity Provider が
  #      実際に提供する属性名と一致している必要があります
  #    - Cognito User Pool の場合、カスタム属性は "custom:" プレフィックスが必要です
  #
  # 4. セキュリティ考慮事項
  #    - Principal タグは IAM ポリシーの評価に使用されるため、
  #      信頼できる属性のみをマッピングしてください
  #    - 不適切なマッピングは、意図しないアクセス権限の付与につながる可能性があります
}
