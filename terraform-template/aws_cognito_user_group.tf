# ============================================================================
# Terraform AWS Resource Template: aws_cognito_user_group
# ============================================================================
# Generated: 2026-01-19
# Provider Version: 6.28.0
#
# NOTE: このテンプレートは生成時点の情報に基づいています。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group
# ============================================================================

# aws_cognito_user_group
#
# Amazon Cognito User Pool内のユーザーグループを管理するリソース。
# グループを使用することで、ユーザーのコレクションを管理し、IAMロールを割り当てて
# AWSリソースへのアクセスを制御できます。
#
# 公式ドキュメント:
# - Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group
# - AWS: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html

resource "aws_cognito_user_group" "example" {
  # ============================================================================
  # 必須パラメータ
  # ============================================================================

  # name (必須)
  # ユーザーグループの名前
  # - タイプ: string
  # - 最小長: 1
  # - 最大長: 128
  # - パターン: [\p{L}\p{M}\p{S}\p{N}\p{P}]+
  #
  # グループの一意な識別子として使用されます。
  # 作成後の変更はリソースの再作成をトリガーします。
  #
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_GroupType.html
  name = "example-user-group"

  # user_pool_id (必須)
  # このグループが所属するCognito User PoolのID
  # - タイプ: string
  #
  # グループを作成する対象のUser Poolを指定します。
  # 通常は aws_cognito_user_pool リソースの id 属性を参照します。
  #
  # 例: aws_cognito_user_pool.main.id
  user_pool_id = "us-east-1_XXXXXXXXX"

  # ============================================================================
  # オプションパラメータ
  # ============================================================================

  # description (オプション)
  # ユーザーグループの説明
  # - タイプ: string
  # - 最大長: 2048文字
  #
  # グループの目的や役割を説明するためのフレンドリーな説明文。
  # 管理コンソールやAPIレスポンスで表示されます。
  #
  # 参考: https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateGroup.html
  description = "Example user group managed by Terraform"

  # precedence (オプション)
  # グループの優先順位
  # - タイプ: number (非負整数)
  # - 範囲: 0 から 2^31-1
  # - デフォルト: null
  #
  # ユーザーが複数のグループに所属している場合、どのグループのIAMロールを
  # 適用するかを決定するための優先度を指定します。
  # より低い値のグループが優先されます（0が最高優先度）。
  #
  # 使用例:
  # - 管理者グループ: precedence = 0
  # - モデレーターグループ: precedence = 10
  # - 一般ユーザーグループ: precedence = 20
  #
  # 注意:
  # - 同じprecedence値を持つ2つのグループがある場合、どちらも優先されません
  # - Identity Poolsと統合する場合、最も優先度の高いグループのロールが
  #   cognito:roles および cognito:preferred_role クレームで使用されます
  #
  # 参考: https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html
  precedence = 42

  # role_arn (オプション)
  # グループに関連付けるIAMロールのARN
  # - タイプ: string
  # - パターン: arn:[\w+=/,.@-]+:[\w+=/,.@-]+:([\w+=/,.@-]*)?:[0-9]+:[\w+=/,.@-]+(:[\w+=/,.@-]+)?(:[\w+=/,.@-]+)?
  #
  # このグループのメンバーがアクセスできるAWSリソースを制御するIAMロールを指定します。
  # Amazon Cognito Identity Poolsと統合する際、このロールがユーザーの
  # 一時的なAWS認証情報に割り当てられます。
  #
  # ユースケース:
  # - グループベースのアクセス制御（RBAC）
  # - S3バケットへの差別化されたアクセス権限
  # - DynamoDBテーブルへの読み取り/書き込み権限の制御
  #
  # トークンクレーム:
  # - cognito:groups: ユーザーが所属する全グループのリスト
  # - cognito:roles: 利用可能なロールのリスト
  # - cognito:preferred_role: 最も優先度の高いグループのロール
  #
  # 注意:
  # - IAMロールには適切なTrust Policyが必要です
  # - Trust Policyでcognito-identity.amazonaws.comを信頼する必要があります
  #
  # 参考:
  # - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html
  # - https://docs.aws.amazon.com/cognito/latest/developerguide/group-based-multi-tenancy.html
  role_arn = "arn:aws:iam::123456789012:role/example-user-group-role"

  # region (オプション)
  # このリソースが管理されるAWSリージョン
  # - タイプ: string
  # - デフォルト: プロバイダー設定のリージョン
  #
  # 通常は設定不要です。プロバイダー設定のリージョンが使用されます。
  # マルチリージョン構成で明示的にリージョンを指定する場合に使用します。
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"
}

# ============================================================================
# 出力例（オプション）
# ============================================================================

# output "user_group_name" {
#   description = "The name of the user group"
#   value       = aws_cognito_user_group.example.name
# }
#
# output "user_group_precedence" {
#   description = "The precedence of the user group"
#   value       = aws_cognito_user_group.example.precedence
# }

# ============================================================================
# IAMロールの設定例
# ============================================================================

# data "aws_iam_policy_document" "user_group_assume_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Federated"
#       identifiers = ["cognito-identity.amazonaws.com"]
#     }
#
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#
#     condition {
#       test     = "StringEquals"
#       variable = "cognito-identity.amazonaws.com:aud"
#       values   = ["us-east-1:12345678-dead-beef-cafe-123456790ab"]
#     }
#
#     condition {
#       test     = "ForAnyValue:StringLike"
#       variable = "cognito-identity.amazonaws.com:amr"
#       values   = ["authenticated"]
#     }
#   }
# }
#
# resource "aws_iam_role" "user_group_role" {
#   name               = "example-user-group-role"
#   assume_role_policy = data.aws_iam_policy_document.user_group_assume_role.json
# }
#
# resource "aws_iam_role_policy_attachment" "user_group_policy" {
#   role       = aws_iam_role.user_group_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }

# ============================================================================
# 使用上の注意事項
# ============================================================================
#
# 1. グループの制限:
#    - User Poolあたりのグループ数には上限があります（通常10,000グループ）
#    - グループのネストはサポートされていません
#    - グループ内のユーザーを検索する機能は制限されています
#
# 2. Precedenceの動作:
#    - 低い値ほど優先度が高くなります
#    - 同じprecedence値を持つグループがある場合、優先順位は未定義です
#    - Identity Poolsと統合する場合のみ、precedenceが実際に使用されます
#
# 3. IAMロールの設定:
#    - role_arnを指定する場合、適切なTrust Policyが必要です
#    - Trust PolicyでAssumeRoleWithWebIdentityアクションを許可する必要があります
#    - cognito-identity.amazonaws.comを信頼済みエンティティとして追加します
#
# 4. マルチテナンシー:
#    - グループを使用してマルチテナント環境を実装できます
#    - 各テナントに専用のグループとIAMロールを割り当てます
#    - Amazon API Gatewayと統合してアクセス制御を実装できます
#
# 参考:
# - https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html
# - https://docs.aws.amazon.com/cognito/latest/developerguide/group-based-multi-tenancy.html
# - https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_CreateGroup.html
