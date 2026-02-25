#---------------------------------------------------------------
# Amazon QuickSight User
#---------------------------------------------------------------
#
# Amazon QuickSight にユーザーを登録・管理するリソースです。
# IAM アイデンティティ、QuickSight アイデンティティ、または
# IAM Identity Center アイデンティティを QuickSight ユーザーとして関連付けます。
# ユーザーにロールを割り当てることでダッシュボードや
# データセットへのアクセス権限を個別に制御できます。
#
# AWS公式ドキュメント:
#   - RegisterUser APIリファレンス: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisterUser.html
#   - QuickSight ユーザー管理: https://docs.aws.amazon.com/quicksight/latest/user/managing-users.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_user
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_user" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # email (Required)
  # 設定内容: 登録するユーザーのメールアドレスを指定します。
  # 設定可能な値: 有効なメールアドレス文字列
  email = "user@example.com"

  # identity_type (Required)
  # 設定内容: QuickSight アカウントがユーザーの ID 管理に使用するアイデンティティタイプを指定します。
  # 設定可能な値:
  #   - "IAM"                 : IAMユーザーまたはIAMロールとして認証
  #   - "IAM_IDENTITY_CENTER" : IAM Identity Center（旧AWS SSO）で認証
  #   - "QUICKSIGHT"          : QuickSight独自の認証（メール招待方式）
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_RegisterUser.html
  identity_type = "QUICKSIGHT"

  # user_role (Required)
  # 設定内容: ユーザーに割り当てる Amazon QuickSight のロールを指定します。
  # 設定可能な値:
  #   - "ADMIN"              : 管理者権限（全機能にアクセス可能）
  #   - "AUTHOR"             : コンテンツ作成権限（ダッシュボード・分析の作成可能）
  #   - "READER"             : 閲覧専用権限（共有されたコンテンツの閲覧のみ）
  #   - "ADMIN_PRO"          : 管理者プロ権限（高度な管理機能）
  #   - "AUTHOR_PRO"         : 著者プロ権限（高度な作成機能）
  #   - "READER_PRO"         : 閲覧者プロ権限（高度な閲覧機能）
  #   - "RESTRICTED_AUTHOR"  : 制限付き著者権限
  #   - "RESTRICTED_READER"  : 制限付き閲覧者権限
  user_role = "READER"

  #-------------------------------------------------------------
  # アカウント・ネームスペース設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: ユーザーを登録するAWSアカウントIDを指定します。
  # 設定可能な値: 有効な12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判定したアカウントIDを使用します。
  aws_account_id = null

  # namespace (Optional)
  # 設定内容: ユーザーを作成する Amazon QuickSight ネームスペースを指定します。
  # 設定可能な値: 既存のQuickSightネームスペース名
  # 省略時: "default" ネームスペースが使用されます。
  namespace = "default"

  #-------------------------------------------------------------
  # IAM連携設定
  #-------------------------------------------------------------

  # iam_arn (Optional)
  # 設定内容: Amazon QuickSight に登録する IAMユーザーまたはIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMユーザーまたはIAMロールのARN
  #               例（IAMロール）: "arn:aws:iam::123456789012:role/AuthorRole"
  #               例（IAMユーザー）: "arn:aws:iam::123456789012:user/authorpro1"
  # 省略時: identity_typeが"IAM"の場合は必須です。
  # 注意: identity_typeが"IAM"のユーザーにのみ必要です。
  iam_arn = null

  # session_name (Optional)
  # 設定内容: QuickSight ダッシュボードを埋め込むことができるロールを引き受ける際に
  #           使用する IAM セッション名を指定します。
  # 設定可能な値: 有効なセッション名文字列
  # 省略時: null（引き受けIAMロールを使用して登録するユーザーにのみ有効）
  # 注意: 同じIAMロールを使用して複数ユーザーを登録する場合、
  #       各ユーザーに一意のセッション名が必要です。
  session_name = null

  #-------------------------------------------------------------
  # QuickSightユーザー名設定
  #-------------------------------------------------------------

  # user_name (Optional)
  # 設定内容: 登録するユーザーに作成する Amazon QuickSight のユーザー名を指定します。
  # 設定可能な値: 有効なユーザー名文字列
  # 省略時: identity_typeが"QUICKSIGHT"の場合は必須です。
  # 注意: identity_typeが"QUICKSIGHT"のユーザーにのみ必要です。
  user_name = "example-reader"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ユーザーのAmazon Resource Name (ARN)
# - id: アカウントID、ネームスペース、ユーザー名を "/" で連結した一意の識別子
# - user_invitation_url: ユーザーが登録を完了してパスワードを設定するためのURL。
#                        identity_typeが"QUICKSIGHT"のユーザーにのみ返されます。
#---------------------------------------------------------------
