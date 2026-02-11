# ==============================================================================
# AWS QuickSight User - Annotated Terraform Template
# ==============================================================================
# Provider Version: 6.28.0
# Resource: aws_quicksight_user
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_user
# AWS API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisterUser.html
#
# Purpose:
#   QuickSightユーザーを作成し、AWS IAMアイデンティティまたはロールと関連付けます。
#   QuickSightは、AWSのフルマネージド型ビジネスインテリジェンスサービスで、
#   ユーザーは対話型ダッシュボードを作成・共有できます。
#
# Key Features:
#   - IAM、QuickSight、IAM Identity Centerの3つの認証タイプをサポート
#   - READER、AUTHOR、ADMINなど、8つのユーザーロールから選択可能
#   - 名前空間を使用してユーザーを論理的に分離可能
#   - IAMロールベースの認証でセッション名をサポート
#
# Common Use Cases:
#   - ダッシュボード閲覧用のREADERユーザーの登録
#   - データソース接続とビジュアライゼーション作成用のAUTHORユーザーの作成
#   - QuickSight管理用のADMINユーザーの設定
#   - 生成AI機能を使用するPROロールユーザーの登録
#
# Important Notes:
#   - Terraform APIで登録したユーザーには登録メールが送信されません
#   - IAM Identity Typeの場合、iam_arnパラメータが必須です
#   - QUICKSIGHT Identity Typeの場合、user_nameパラメータが必須です
#   - セッション名は同じIAMロールで複数ユーザーを登録する場合に必要です
#   - カスタムパーミッションはEnterprise Editionでのみ利用可能です
#
# Prerequisites:
#   - QuickSightアカウントが有効化されていること
#   - IAM認証の場合、対応するIAMユーザーまたはロールが存在すること
#   - Enterprise Edition機能を使用する場合、適切なサブスクリプションがあること
#
# Security Considerations:
#   - 最小権限の原則に従って適切なユーザーロールを選択してください
#   - IAM ARNは正確に指定し、意図しないアクセス権限を付与しないよう注意してください
#   - Enterprise Editionのカスタムパーミッションを活用して、きめ細かいアクセス制御を実装してください
#
# Cost Considerations:
#   - READERユーザー: セッションごとに$0.30、月額最大$5
#   - AUTHORユーザー: 月額$24
#   - AUTHOR_PROユーザー: 月額$50（生成AI機能含む）
#   - ADMIN_PROユーザー: AUTHOR_PRO価格で請求
#   - READER_PROユーザー: Amazon Q in QuickSightへのアクセス含む
# ==============================================================================

# ------------------------------------------------------------------------------
# Example 1: IAMロール認証を使用したAUTHORユーザーの作成
# ------------------------------------------------------------------------------
# Use Case: IAMロールベースでダッシュボード作成権限を持つユーザーを登録
# このパターンは、AWSアカウント内の既存のIAMロールを活用する場合に使用します。
# ------------------------------------------------------------------------------
resource "aws_quicksight_user" "author_with_iam_role" {
  # ------------------------------------------------------------------------------
  # Required: Email Address
  # ------------------------------------------------------------------------------
  # 登録するユーザーのメールアドレスを指定します。
  # このメールアドレスはQuickSightアカウント内で一意である必要があります。
  #
  # Note: Terraform APIで登録した場合、このアドレスに登録メールは送信されません。
  #       ユーザーを招待する場合は、QuickSightコンソールから行う必要があります。
  #
  # AWS Constraints:
  #   - 有効なメールアドレス形式である必要があります
  #   - アカウント内で一意である必要があります
  # ------------------------------------------------------------------------------
  email = "author1@example.com"

  # ------------------------------------------------------------------------------
  # Required: Identity Type
  # ------------------------------------------------------------------------------
  # QuickSightがユーザーのアイデンティティを管理する方法を指定します。
  #
  # Valid Values:
  #   - "IAM": AWS IAMユーザーまたはロールと関連付け
  #     - 既存のAWS認証情報を活用
  #     - iam_arnパラメータが必須
  #     - AWSアカウント内の既存のIAMエンティティが必要
  #
  #   - "QUICKSIGHT": QuickSight固有のユーザー認証
  #     - QuickSight独自のユーザー管理
  #     - user_nameパラメータが必須
  #     - registration URLでパスワード設定が必要
  #
  #   - "IAM_IDENTITY_CENTER": AWS IAM Identity Center（旧AWS SSO）と統合
  #     - 組織全体でのシングルサインオン
  #     - IAM Identity Centerが設定済みであることが必要
  #
  # Best Practice:
  #   - 組織内の複数ユーザーには"IAM_IDENTITY_CENTER"を推奨
  #   - 少数の技術ユーザーには"IAM"が適切
  #   - QuickSight専用アカウントには"QUICKSIGHT"を使用
  # ------------------------------------------------------------------------------
  identity_type = "IAM"

  # ------------------------------------------------------------------------------
  # Required: User Role
  # ------------------------------------------------------------------------------
  # QuickSight内でのユーザーの権限レベルを定義します。
  #
  # Available Roles (Standard):
  #   - "READER": ダッシュボードの閲覧のみ可能
  #     - 対話型ダッシュボードの探索
  #     - レポートの受信
  #     - データのダウンロード
  #     - 月額$5まで（セッションごとに$0.30）
  #
  #   - "AUTHOR": データソース接続、分析、ダッシュボード作成が可能
  #     - データソースへの接続
  #     - データセットの作成
  #     - ビジュアライゼーションの作成
  #     - ダッシュボードの公開
  #     - 月額$24
  #
  #   - "ADMIN": AUTHOR権限 + QuickSight設定の管理
  #     - ユーザー管理
  #     - サブスクリプション管理
  #     - セキュリティ設定
  #     - AUTHOR価格で請求
  #
  # Pro Roles (Generative BI Capabilities):
  #   - "READER_PRO": READER + Amazon Q in QuickSight
  #     - Amazon Qでストーリー構築
  #     - ダッシュボードからのエグゼクティブサマリー生成
  #
  #   - "AUTHOR_PRO": AUTHOR + 生成AI機能
  #     - 自然言語でのダッシュボード作成
  #     - Amazon Qでのストーリー構築
  #     - Q&A用トピック作成
  #     - 月額$50
  #
  #   - "ADMIN_PRO": AUTHOR_PRO + 管理機能
  #     - AUTHOR_PRO価格で請求
  #
  # Restricted Roles (Currently Unavailable):
  #   - "RESTRICTED_READER": 将来の使用のために予約済み
  #   - "RESTRICTED_AUTHOR": 将来の使用のために予約済み
  #
  # Cost Note: ProロールはAmazon Q in QuickSightアカウント有効化料金
  #            （月額$250、最低1 Proユーザー必要）が別途発生します。
  # ------------------------------------------------------------------------------
  user_role = "AUTHOR"

  # ------------------------------------------------------------------------------
  # Optional (Required for IAM identity type): IAM ARN
  # ------------------------------------------------------------------------------
  # QuickSightに登録するIAMユーザーまたはロールのARNを指定します。
  #
  # When Required:
  #   - identity_typeが"IAM"の場合は必須
  #   - identity_typeが"QUICKSIGHT"または"IAM_IDENTITY_CENTER"の場合は不要
  #
  # Supported Formats:
  #   - IAM User: "arn:aws:iam::123456789012:user/username"
  #   - IAM Role: "arn:aws:iam::123456789012:role/rolename"
  #
  # Important:
  #   - 指定するIAMエンティティは事前に存在している必要があります
  #   - IAMロールの場合、QuickSightサービスがAssumeRole可能な信頼関係が必要です
  #   - 複数ユーザーで同じIAMロールを使用する場合、各ユーザーに一意の
  #     session_nameが必要です
  #
  # Best Practice:
  #   - セキュリティのため、専用のIAMロールを作成することを推奨
  #   - 必要最小限の権限を持つIAMポリシーを適用
  # ------------------------------------------------------------------------------
  iam_arn = "arn:aws:iam::123456789012:role/AuthorRole"

  # ------------------------------------------------------------------------------
  # Optional: Session Name (Required when using same IAM role for multiple users)
  # ------------------------------------------------------------------------------
  # IAMロールをAssumeする際のセッション名を指定します。
  #
  # When Required:
  #   - 同じIAMロールを使用して複数のユーザーを登録する場合に必須
  #   - 各ユーザーに一意のセッション名が必要
  #
  # When Not Needed:
  #   - IAMユーザーを登録する場合
  #   - QuickSightアイデンティティタイプを使用する場合
  #   - 1つのIAMロールに対して1人のユーザーのみの場合
  #
  # Use Case:
  #   - ダッシュボードを埋め込む際のセッション識別
  #   - 監査ログでのユーザーアクション追跡
  #   - 同一IAMロールを共有する複数ユーザーの区別
  #
  # AWS Constraints:
  #   - Length: 2〜64文字
  #   - Pattern: [\w+=.@-]*
  #   - 英数字と特定の特殊文字のみ使用可能
  #
  # Best Practice:
  #   - ユーザーを識別しやすい命名規則を使用
  #   - 例: "user-{username}", "session-{userid}", など
  # ------------------------------------------------------------------------------
  session_name = "author1"

  # ------------------------------------------------------------------------------
  # Optional: AWS Account ID (Forces new resource if changed)
  # ------------------------------------------------------------------------------
  # ユーザーを登録するAWSアカウントIDを指定します。
  #
  # Default Behavior:
  #   - 指定しない場合、Terraformプロバイダーから自動的に決定されます
  #   - 通常は明示的な指定は不要です
  #
  # When to Specify:
  #   - クロスアカウント環境で明示的に指定する必要がある場合
  #   - 異なるAWSアカウントのQuickSightにユーザーを登録する場合
  #
  # Important:
  #   - この値を変更するとリソースが再作成されます（Forces new resource）
  #   - 12桁の数字である必要があります
  #
  # AWS Constraints:
  #   - Format: 固定長12桁
  #   - Pattern: ^[0-9]{12}$
  #
  # Example:
  #   aws_account_id = "123456789012"
  # ------------------------------------------------------------------------------
  # aws_account_id = "123456789012"  # Uncomment if needed

  # ------------------------------------------------------------------------------
  # Optional: Namespace
  # ------------------------------------------------------------------------------
  # ユーザーを作成するQuickSight名前空間を指定します。
  #
  # Default Value: "default"
  #
  # What is Namespace:
  #   - QuickSight内でユーザー、グループ、アセットを論理的に分離する仕組み
  #   - マルチテナント環境で異なる組織やチームを分離するために使用
  #   - 名前空間は事前にQuickSightコンソールまたはAPIで作成しておく必要があります
  #
  # Use Cases:
  #   - 部門ごとにユーザーとダッシュボードを分離
  #   - 開発/ステージング/本番環境の分離
  #   - 複数の顧客環境を同一アカウント内で管理
  #
  # AWS Constraints:
  #   - Length: 最大64文字
  #   - Pattern: ^[a-zA-Z0-9._-]*$
  #   - 英数字、ドット、アンダースコア、ハイフンのみ使用可能
  #
  # Best Practice:
  #   - 明確な命名規則を使用（例: "dept-sales", "env-prod"）
  #   - デフォルト名前空間で問題ない場合は省略可能
  #
  # Example:
  #   namespace = "production"
  # ------------------------------------------------------------------------------
  # namespace = "default"  # Default value, uncomment to customize

  # ------------------------------------------------------------------------------
  # Optional: Region
  # ------------------------------------------------------------------------------
  # このリソースが管理されるAWSリージョンを指定します。
  #
  # Default Behavior:
  #   - プロバイダー設定で指定されたリージョンを使用
  #   - 通常は明示的な指定は不要です
  #
  # When to Specify:
  #   - 特定のリソースを異なるリージョンで管理する必要がある場合
  #   - リージョン間でのリソース分散が必要な場合
  #
  # Available QuickSight Regions:
  #   - us-east-1 (N. Virginia)
  #   - us-west-2 (Oregon)
  #   - eu-west-1 (Ireland)
  #   - eu-central-1 (Frankfurt)
  #   - ap-southeast-1 (Singapore)
  #   - ap-southeast-2 (Sydney)
  #   - ap-northeast-1 (Tokyo)
  #   - その他のリージョンについては公式ドキュメントを参照
  #
  # Important:
  #   - QuickSightアカウントが指定リージョンで有効化されている必要があります
  #   - 一部の機能は特定のリージョンでのみ利用可能な場合があります
  #
  # Example:
  #   region = "us-east-1"
  # ------------------------------------------------------------------------------
  # region = "us-east-1"  # Uncomment if needed
}

# ------------------------------------------------------------------------------
# Example 2: IAMユーザー認証を使用したAUTHOR_PROユーザーの作成
# ------------------------------------------------------------------------------
# Use Case: 生成AI機能を使用してダッシュボードを作成するユーザーを登録
# AUTHOR_PROロールは、自然言語でのダッシュボード作成やAmazon Q統合を提供します。
# ------------------------------------------------------------------------------
resource "aws_quicksight_user" "author_pro_with_iam_user" {
  email         = "authorpro1@example.com"
  identity_type = "IAM"
  user_role     = "AUTHOR_PRO"

  # ------------------------------------------------------------------------------
  # IAMユーザーを使用する場合
  # ------------------------------------------------------------------------------
  # IAMユーザーのARNを指定します。session_nameは不要です。
  # IAMユーザーは既に一意のアイデンティティを持っているため、セッション名は必要ありません。
  #
  # Note: IAMユーザーは事前に作成されている必要があります。
  #       QuickSightサービスへのアクセスを許可するIAMポリシーが必要です。
  # ------------------------------------------------------------------------------
  iam_arn = "arn:aws:iam::123456789012:user/authorpro1"
}

# ------------------------------------------------------------------------------
# Example 3: QuickSightアイデンティティタイプを使用したREADERユーザーの作成
# ------------------------------------------------------------------------------
# Use Case: QuickSight専用のアカウントでダッシュボード閲覧ユーザーを作成
# このパターンは、AWS IAMとは独立したQuickSight専用の認証を使用します。
# ------------------------------------------------------------------------------
resource "aws_quicksight_user" "reader_with_quicksight_identity" {
  email         = "reader1@example.com"
  identity_type = "QUICKSIGHT"
  user_role     = "READER"

  # ------------------------------------------------------------------------------
  # Optional (Required for QUICKSIGHT identity type): User Name
  # ------------------------------------------------------------------------------
  # QuickSightユーザー名を指定します。
  #
  # When Required:
  #   - identity_typeが"QUICKSIGHT"の場合は必須
  #   - identity_typeが"IAM"または"IAM_IDENTITY_CENTER"の場合は不要
  #
  # Use Case:
  #   - QuickSight専用のログイン認証情報
  #   - AWS IAMとは独立したユーザー管理
  #   - シンプルなダッシュボード共有シナリオ
  #
  # AWS Constraints:
  #   - Length: 最低1文字
  #   - Pattern: [\u0020-\u00FF]+
  #   - Unicode文字（基本的なASCII文字を含む）を使用可能
  #
  # Important:
  #   - このユーザー名はQuickSight名前空間内で一意である必要があります
  #   - ユーザーは登録URLを通じてパスワードを設定する必要があります
  #   - user_invitation_url属性から登録URLを取得できます
  #
  # Best Practice:
  #   - メールアドレスのローカル部分を使用するなど、識別しやすい名前を選択
  #   - 命名規則を統一して管理を容易にする
  # ------------------------------------------------------------------------------
  user_name = "reader1"

  # カスタム名前空間の使用例
  namespace = "example"
}

# ------------------------------------------------------------------------------
# Example 4: Enterprise Edition - カスタムパーミッション付きユーザー
# ------------------------------------------------------------------------------
# Use Case: きめ細かいアクセス制御が必要な場合
# Enterprise Editionでは、カスタムパーミッションプロファイルを使用して、
# ユーザーの操作を細かく制限できます。
#
# Note: この機能はQuickSight Enterprise Editionでのみ利用可能です。
# ------------------------------------------------------------------------------
resource "aws_quicksight_user" "restricted_author" {
  email         = "restricted-author@example.com"
  identity_type = "IAM"
  user_role     = "AUTHOR"
  iam_arn       = "arn:aws:iam::123456789012:role/RestrictedAuthorRole"

  # ------------------------------------------------------------------------------
  # Optional: Custom Permissions Name (Enterprise Edition only)
  # ------------------------------------------------------------------------------
  # カスタムパーミッションプロファイル名を指定します。
  #
  # What is Custom Permissions:
  #   - ユーザーのアクセスをより細かく制御するための機能
  #   - 標準のロール（READER、AUTHOR、ADMIN）に加えて追加の制限を適用
  #   - IAMポリシーを通じて実装され、デフォルトのロール権限を上書き
  #
  # Available Restrictions:
  #   - データソースの作成と更新
  #   - データセットの作成と更新
  #   - メールレポートの作成と更新
  #   - メールレポートへのサブスクリプション
  #
  # How to Create:
  #   1. QuickSightコンソールでカスタムパーミッションプロファイルを作成
  #   2. 制限する操作を選択
  #   3. プロファイル名を保存
  #   4. Terraformでこのプロファイル名を参照
  #
  # AWS Constraints:
  #   - Length: 1〜64文字
  #   - Pattern: ^[a-zA-Z0-9+=,.@_-]+$
  #   - 英数字と特定の特殊文字のみ
  #
  # Important:
  #   - カスタムパーミッション名はQuickSightコンソールで事前に作成する必要があります
  #   - この機能はEnterprise Editionサブスクリプションでのみ利用可能
  #   - 既存ユーザーに追加する場合は、UpdateUser APIを使用
  #
  # Use Cases:
  #   - データソース接続を制限しながら分析作成を許可
  #   - 特定のデータセットのみへのアクセスを許可
  #   - レポート配信機能を制限
  #
  # Best Practice:
  #   - 最小権限の原則に従ってカスタムパーミッションを設計
  #   - 明確な命名規則を使用（例: "no-datasource-creation"）
  #   - 定期的にパーミッション設定をレビュー
  # ------------------------------------------------------------------------------
  # custom_permissions_name = "restricted-author-permissions"  # Uncomment if using Enterprise Edition
}

# ------------------------------------------------------------------------------
# Example 5: 外部IDプロバイダーを使用したユーザー（Amazon Cognito）
# ------------------------------------------------------------------------------
# Use Case: Amazon Cognitoを使用したフェデレーションアクセス
# 外部IDプロバイダーを使用して、QuickSightへのフェデレーションアクセスを実現します。
# ------------------------------------------------------------------------------
resource "aws_quicksight_user" "federated_user" {
  email         = "federated@example.com"
  identity_type = "IAM"
  user_role     = "AUTHOR"
  iam_arn       = "arn:aws:iam::123456789012:role/QuickSightFederatedRole"

  # ------------------------------------------------------------------------------
  # Optional: External Login Federation Provider Type
  # ------------------------------------------------------------------------------
  # 外部ログインプロバイダーのタイプを指定します。
  #
  # Valid Values:
  #   - "COGNITO": Amazon Cognito
  #     - Provider URL: cognito-identity.amazonaws.com
  #     - CustomFederationProviderUrlパラメータは不要
  #     - AWS Cognitoアイデンティティプールと統合
  #
  #   - "CUSTOM_OIDC": カスタムOpenID Connect (OIDC) プロバイダー
  #     - CustomFederationProviderUrlパラメータが必須
  #     - 任意のOIDC準拠プロバイダーを使用可能
  #     - 例: Okta、Auth0、Azure ADなど
  #
  # When to Use:
  #   - 既存のIDプロバイダーとQuickSightを統合
  #   - シングルサインオン(SSO)を実装
  #   - 外部のユーザー管理システムと連携
  #
  # Prerequisites:
  #   - IAMロールに適切な信頼関係が設定されていること
  #   - IDプロバイダーがQuickSightへのアクセスを許可していること
  #
  # Example with Cognito:
  #   external_login_federation_provider_type = "COGNITO"
  #
  # Example with Custom OIDC:
  #   external_login_federation_provider_type = "CUSTOM_OIDC"
  #   custom_federation_provider_url = "https://custom-oidc-provider.example.com"
  # ------------------------------------------------------------------------------
  # external_login_federation_provider_type = "COGNITO"  # Uncomment if using federated login

  # ------------------------------------------------------------------------------
  # Optional: External Login ID
  # ------------------------------------------------------------------------------
  # 外部ログインプロバイダーにおけるユーザーのアイデンティティIDを指定します。
  #
  # Purpose:
  #   - 外部IDプロバイダーでのユーザー識別子とQuickSightユーザーを紐付け
  #   - フェデレーションログイン時のユーザーマッピング
  #
  # Use Case:
  #   - Cognitoユーザープール内のユーザーIDを指定
  #   - カスタムOIDCプロバイダーのユーザーサブジェクトIDを指定
  #   - 外部システムとの一貫したユーザー管理
  #
  # Example:
  #   external_login_id = "us-east-1:12345678-1234-1234-1234-123456789012"
  # ------------------------------------------------------------------------------
  # external_login_id = "cognito-user-id"  # Uncomment if using federated login

  # ------------------------------------------------------------------------------
  # Optional: Custom Federation Provider URL
  # ------------------------------------------------------------------------------
  # カスタムOpenID Connect (OIDC) プロバイダーのURLを指定します。
  #
  # When Required:
  #   - external_login_federation_provider_typeが"CUSTOM_OIDC"の場合に必須
  #   - "COGNITO"を使用する場合は不要
  #
  # Format:
  #   - 完全なHTTPS URLを指定
  #   - OIDCプロバイダーのベースURL
  #
  # Supported Providers:
  #   - Okta
  #   - Auth0
  #   - Azure Active Directory
  #   - Google Identity Platform
  #   - その他のOIDC準拠プロバイダー
  #
  # Example:
  #   custom_federation_provider_url = "https://your-tenant.okta.com"
  # ------------------------------------------------------------------------------
  # custom_federation_provider_url = "https://custom-oidc-provider.example.com"  # Only for CUSTOM_OIDC
}

# ==============================================================================
# Computed Attributes (Read-Only)
# ==============================================================================
# これらの属性はTerraformによって自動的に計算され、読み取り専用です。
# 他のリソースで参照することができます。
# ==============================================================================

# ------------------------------------------------------------------------------
# Output Examples - リソースから計算される属性の使用例
# ------------------------------------------------------------------------------

# arn: Amazon Resource Name
# ユーザーの一意なAWS ARN識別子
# Format: arn:aws:quicksight:region:account-id:user/namespace/username
# Use Case: IAMポリシー、CloudWatchイベント、監査ログでの参照
output "quicksight_user_arn" {
  description = "The ARN of the QuickSight user"
  value       = aws_quicksight_user.author_with_iam_role.arn
}

# id: Terraform Resource Identifier
# アカウントID、名前空間、ユーザー名を"/"で結合した一意の識別子
# Format: account-id/namespace/username
# Use Case: Terraform内でのリソース参照、importコマンドでの使用
output "quicksight_user_id" {
  description = "The unique identifier for the QuickSight user"
  value       = aws_quicksight_user.author_with_iam_role.id
}

# user_invitation_url: User Invitation URL
# ユーザー登録とパスワード設定用のURL
#
# Important Notes:
#   - identity_typeが"QUICKSIGHT"の場合のみ返されます
#   - IAMまたはIAM_IDENTITY_CENTERの場合は空です
#   - このURLをユーザーに送信して、アカウント設定を完了させます
#   - URLには有効期限があるため、速やかにユーザーに共有してください
#
# Use Case:
#   - QUICKSIGHTアイデンティティタイプのユーザー招待
#   - パスワード設定プロセスの開始
#   - 自動化されたユーザーオンボーディングフロー
output "quicksight_user_invitation_url" {
  description = "The URL for QUICKSIGHT identity type users to complete registration (only available for QUICKSIGHT identity type)"
  value       = aws_quicksight_user.reader_with_quicksight_identity.user_invitation_url
  sensitive   = true # URLは機密情報として扱う
}

# ==============================================================================
# Import Instructions
# ==============================================================================
# 既存のQuickSightユーザーをTerraformにインポートする方法:
#
# Format:
#   terraform import aws_quicksight_user.<resource_name> <account-id>/<namespace>/<username>
#
# Example:
#   terraform import aws_quicksight_user.author_with_iam_role 123456789012/default/author1
#
# Notes:
#   - アカウントID、名前空間、ユーザー名を"/"で区切って指定
#   - 名前空間を指定しなかった場合は"default"が使用されます
#   - インポート後、terraform planで差分を確認し、必要に応じて設定を調整してください
# ==============================================================================

# ==============================================================================
# Additional Resources
# ==============================================================================
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_user
#
# - AWS QuickSight RegisterUser API:
#   https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisterUser.html
#
# - AWS QuickSight User Management Guide:
#   https://docs.aws.amazon.com/quicksight/latest/user/managing-users.html
#
# - AWS QuickSight Identity Types:
#   https://docs.aws.amazon.com/quicksight/latest/user/managing-users.html#inviting-users
#
# - AWS QuickSight Custom Permissions (Enterprise Edition):
#   https://docs.aws.amazon.com/quicksight/latest/user/custom-permissions.html
#
# - AWS QuickSight Pricing:
#   https://aws.amazon.com/quicksight/pricing/
#
# - AWS QuickSight Federated Access:
#   https://docs.aws.amazon.com/quicksight/latest/user/external-identity-providers.html
# ==============================================================================
