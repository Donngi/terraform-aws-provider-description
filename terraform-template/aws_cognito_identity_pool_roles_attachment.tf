#---------------------------------------------------------------
# AWS Cognito Identity Pool Roles Attachment
#---------------------------------------------------------------
#
# Amazon Cognito Identity Poolに対してIAMロールをアタッチするリソースです。
# Identity Poolを使用するユーザーに対して、認証済み/未認証ユーザー向けの
# デフォルトロールや、トークンのクレームに基づいたルールベースのロール
# マッピングを設定できます。
#
# AWS公式ドキュメント:
#   - Role-based Access Control: https://docs.aws.amazon.com/cognito/latest/developerguide/role-based-access-control.html
#   - SetIdentityPoolRoles API: https://docs.aws.amazon.com/cognitoidentity/latest/APIReference/API_SetIdentityPoolRoles.html
#   - RoleMapping: https://docs.aws.amazon.com/cognitoidentity/latest/APIReference/API_RoleMapping.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cognito_identity_pool_roles_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # identity_pool_id (Required)
  # 設定内容: ロールをアタッチする対象のIdentity Pool IDを指定します。
  # 設定可能な値: REGION:GUID形式の文字列（例: us-east-1:12345678-1234-1234-1234-123456789012）
  # 注意: Identity Pool IDは aws_cognito_identity_pool リソースから取得できます
  identity_pool_id = "us-east-1:12345678-1234-1234-1234-123456789012"

  # roles (Required)
  # 設定内容: Identity Poolに関連付けるIAMロールを定義するマップです。
  # 設定可能な値: キーと値のペアのマップ
  #   - キー: "authenticated" または "unauthenticated"
  #   - 値: IAMロールのARN
  # 関連機能: Cognito Identity Pool Roles
  #   認証済みユーザーと未認証ユーザーに対して、GetCredentialsForIdentityアクションで
  #   使用されるデフォルトロールを設定します。
  #   - https://docs.aws.amazon.com/cognitoidentity/latest/APIReference/API_SetIdentityPoolRoles.html
  roles = {
    "authenticated"   = "arn:aws:iam::123456789012:role/cognito-authenticated-role"
    "unauthenticated" = "arn:aws:iam::123456789012:role/cognito-unauthenticated-role"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ロールマッピング設定
  #-------------------------------------------------------------

  # role_mapping (Optional, Set)
  # 設定内容: Identity Providerごとにクレームベースのロールマッピングルールを定義します。
  # 関連機能: Rule-based Role Mapping
  #   IDトークンのクレーム（claim）に基づいて、ユーザーに割り当てるIAMロールを動的に
  #   決定できます。各ルールは、トークン内のクレーム名、マッチタイプ、値、および
  #   対応するロールARNを指定します。
  #   - https://docs.aws.amazon.com/cognito/latest/developerguide/role-based-access-control.html
  role_mapping {
    # identity_provider (Required)
    # 設定内容: ロールマッピングを適用するIdentity Providerを指定します。
    # 設定可能な値: Identity Providerの識別子（例: "graph.facebook.com", "accounts.google.com"）
    # 注意: SAML、OpenID Connect、またはソーシャルプロバイダーの識別子を使用
    identity_provider = "graph.facebook.com"

    # type (Required)
    # 設定内容: ロールマッピングのタイプを指定します。
    # 設定可能な値:
    #   - "Token": トークン内の cognito:roles および cognito:preferred_role クレームを使用してロールを決定
    #   - "Rules": mapping_rule ブロックで定義したルールに基づいてロールを決定
    # 関連機能: Role Mapping Types
    #   Tokenタイプはトークンのクレームから直接ロールを取得し、Rulesタイプは
    #   カスタムルールに基づいてマッピングを行います。
    #   - https://docs.aws.amazon.com/cognitoidentity/latest/APIReference/API_RoleMapping.html
    type = "Rules"

    # ambiguous_role_resolution (Optional)
    # 設定内容: クレーム値が一致しない場合、または複数のロールがマッチした場合の動作を指定します。
    # 設定可能な値:
    #   - "AuthenticatedRole": デフォルトの認証済みロールを使用
    #   - "Deny": アクセスを拒否
    # 注意: typeが "Token" または "Rules" の場合に必須
    # 関連機能: Ambiguous Role Resolution
    #   ルールに一致しない場合やトークンのクレームが曖昧な場合のフォールバック動作を制御します。
    #   - https://docs.aws.amazon.com/cognitoidentity/latest/APIReference/API_RoleMapping.html
    ambiguous_role_resolution = "AuthenticatedRole"

    # mapping_rule (Optional, List, Max: 25)
    # 設定内容: クレーム値に基づいてロールをマッピングするルールを定義します。
    # 制約: 最大25個のルールまで設定可能
    # 注意: typeが "Rules" の場合に必須
    # 関連機能: Rule-based Mapping
    #   各ルールは順番に評価され、最初にマッチしたルールが適用されます。
    #   カスタム属性を使用する場合は "custom:" プレフィックスが必要です。
    #   - https://docs.aws.amazon.com/cognito/latest/developerguide/role-based-access-control.html
    mapping_rule {
      # claim (Required)
      # 設定内容: マッピングに使用するトークン内のクレーム名を指定します。
      # 設定可能な値: トークン内の任意のクレーム名（例: "isAdmin", "department", "custom:subscription"）
      # 注意: カスタム属性の場合は "custom:" プレフィックスを付ける必要があります
      claim = "isAdmin"

      # match_type (Required)
      # 設定内容: クレーム値とvalue属性を比較する方法を指定します。
      # 設定可能な値:
      #   - "Equals": 完全一致
      #   - "Contains": クレーム値が指定した値を含む
      #   - "StartsWith": クレーム値が指定した値で始まる
      #   - "NotEqual": 一致しない
      match_type = "Equals"

      # role_arn (Required)
      # 設定内容: ルールにマッチした場合に割り当てるIAMロールのARNを指定します。
      # 設定可能な値: 有効なIAMロールARN
      role_arn = "arn:aws:iam::123456789012:role/cognito-admin-role"

      # value (Required)
      # 設定内容: クレーム値と比較するための値を指定します。
      # 設定可能な値: 任意の文字列
      # 注意: match_typeで指定した比較方法に基づいて評価されます
      value = "paid"
    }

    # 複数のルールを定義する例
    # mapping_rule {
    #   claim      = "department"
    #   match_type = "Equals"
    #   role_arn   = "arn:aws:iam::123456789012:role/cognito-finance-role"
    #   value      = "finance"
    # }
  }

  # 複数のIdentity Providerに対してロールマッピングを定義する例
  # role_mapping {
  #   identity_provider         = "accounts.google.com"
  #   type                      = "Token"
  #   ambiguous_role_resolution = "Deny"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Identity Pool ID
#---------------------------------------------------------------
