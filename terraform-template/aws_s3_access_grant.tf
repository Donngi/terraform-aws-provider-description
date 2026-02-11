################################################################################
# S3 Access Grant
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/s3control_access_grant
################################################################################

# S3 Access Grantは、IAMユーザー、ロール、またはディレクトリユーザー/グループに
# 登録されたS3ロケーションへのアクセス権を付与します。
#
# 主な用途:
# - 大規模なデータ権限管理をシンプル化
# - IAM Identity CenterのユーザーやグループにS3アクセスを付与
# - バケット、プレフィックス、またはオブジェクトレベルでの細かなアクセス制御
# - CloudTrailでエンドユーザーIDとアプリケーションアクセスをログ記録
#
# 前提条件:
# - S3 Access Grants Instanceが同じリージョンに作成されている必要があります
# - アクセスを付与するS3ロケーションが登録されている必要があります
#
# 注意:
# - グラントを作成する前に、バケットが既に存在している必要があります
# - プレフィックスは存在しなくても作成可能です
# - 登録されたロケーションはIAMロールにマッピングされ、S3 Access Grantsが
#   そのロールをAssumeして一時的な認証情報を発行します

resource "aws_s3control_access_grant" "example" {
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 必須パラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # アクセスグラントロケーションID (必須)
  # アクセスを付与する対象のS3 Access GrantsロケーションのID
  # aws_s3control_access_grants_locationリソースから取得します
  access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id

  # アクセス権限レベル (必須)
  # グラントが付与するアクセスレベルを指定します
  # 有効な値:
  # - READ: 読み取り専用アクセス (GetObject, ListBucketなど)
  # - WRITE: 書き込み専用アクセス (PutObject, DeleteObjectなど)
  # - READWRITE: 読み取り・書き込み両方のアクセス
  permission = "READ"

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # オプションパラメータ
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # AWSアカウントID (オプション)
  # S3 Access Grantsロケーションに使用するAWSアカウントID
  # 省略時: Terraformで使用しているAWSプロバイダーのアカウントIDが自動的に使用されます
  # account_id = "123456789012"

  # リージョン (オプション)
  # このリソースを管理するリージョン
  # 省略時: AWSプロバイダー設定のリージョンが使用されます
  # 注意: S3 Access Grants InstanceとS3データは同じリージョンに存在する必要があります
  # region = "us-east-1"

  # S3プレフィックスタイプ (オプション)
  # 単一のオブジェクトにのみアクセスを付与する場合に指定します
  # 有効な値: "Object"
  # 省略時: プレフィックスまたはバケット全体へのアクセスとして扱われます
  # 使用例: 特定のログファイルや設定ファイルへのアクセスを制限する場合
  # s3_prefix_type = "Object"

  # タグ (オプション)
  # リソースに付与するKey-Valueタグのマップ
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーのタグはこちらで上書きされます
  # tags = {
  #   Environment = "production"
  #   Project     = "data-access"
  #   ManagedBy   = "terraform"
  # }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ネストブロック: アクセスグラントロケーション設定
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # アクセスグラントロケーション設定 (オプション)
  # 登録されたロケーションのスコープ内で、さらにアクセス範囲を絞り込みます
  access_grants_location_configuration {
    # サブプレフィックス (オプション)
    # ロケーションスコープ内の特定のサブプレフィックスにアクセスを制限します
    #
    # 例: ロケーションスコープが "s3://my-bucket/data/" の場合
    # - s3_sub_prefix = "2024/*" とすると、実際のグラントスコープは
    #   "s3://my-bucket/data/2024/*" になります
    # - ワイルドカード(*)を使用して、動的なパスマッチングが可能です
    #
    # 注意:
    # - 登録ロケーションがデフォルトS3パス("s3://")の場合、
    #   サブプレフィックスを指定してスコープを狭める必要があります
    # - グラントスコープ = ロケーションパス + サブプレフィックス
    s3_sub_prefix = "prefixB*"
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ネストブロック: グランティー (アクセス権限受領者)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # グランティー設定 (オプション)
  # アクセス権限を付与する対象のアイデンティティを指定します
  grantee {
    # グランティータイプ (必須)
    # アクセス権限を受け取るIDのタイプを指定します
    # 有効な値:
    # - IAM: IAMユーザーまたはロール
    # - DIRECTORY_USER: IAM Identity Centerのディレクトリユーザー
    # - DIRECTORY_GROUP: IAM Identity Centerのディレクトリグループ
    grantee_type = "IAM"

    # グランティー識別子 (必須)
    # グランティーを一意に識別するための識別子
    #
    # タイプ別の識別子形式:
    # - IAM: IAMユーザーまたはロールのARN
    #   例: "arn:aws:iam::123456789012:user/alice"
    #       "arn:aws:iam::123456789012:role/DataScientist"
    #
    # - DIRECTORY_USER: IAM Identity CenterユーザーのGUID
    #   例: "a1b2c3d4-5678-90ab-cdef-EXAMPLE11111"
    #   取得方法: IAM Identity Centerコンソールまたは
    #            identitystore:DescribeUser APIを使用
    #
    # - DIRECTORY_GROUP: IAM Identity CenterグループのGUID
    #   例: "a1b2c3d4-5678-90ab-cdef-EXAMPLE22222"
    #   取得方法: IAM Identity Centerコンソールまたは
    #            identitystore:DescribeGroup APIを使用
    grantee_identifier = aws_iam_user.example.arn
  }

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # 依存関係
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # S3 Access Grants InstanceとLocationが先に作成される必要があります
  # depends_on = [
  #   aws_s3control_access_grants_instance.example,
  #   aws_s3control_access_grants_location.example
  # ]
}

################################################################################
# 出力属性 (Computed Attributes)
################################################################################

# 以下の属性は、リソース作成後に自動的に設定され、参照可能になります:
#
# - access_grant_arn: S3 Access GrantのAmazon Resource Name (ARN)
#   例: "arn:aws:s3:us-east-1:123456789012:access-grants/default/grant/..."
#
# - access_grant_id: S3 Access Grantの一意のID
#   例: "a1b2c3d4-5678-90ab-cdef-EXAMPLE33333"
#
# - grant_scope: アクセスグラントのスコープ (実際にアクセスが許可されるS3パス)
#   例: "s3://my-bucket/data/2024/*"
#
# - tags_all: リソースに割り当てられた全てのタグ
#   (provider default_tagsから継承されたタグを含む)
#
# 参照例:
# output "grant_arn" {
#   value = aws_s3control_access_grant.example.access_grant_arn
# }

################################################################################
# 関連リソース
################################################################################

# S3 Access Grantsを使用するには、以下のリソースも必要です:
#
# 1. aws_s3control_access_grants_instance
#    - S3 Access Grants機能を有効化するためのインスタンス
#    - リージョンごとに1つ作成します
#    - 任意でIAM Identity Centerと統合できます
#
# 2. aws_s3control_access_grants_location
#    - S3バケットまたはプレフィックスをIAMロールにマッピングする登録ロケーション
#    - グラントを作成する前に、アクセスを許可したいロケーションを登録します
#
# 3. IAMロール (ロケーション用)
#    - S3 Access Grantsがassumeするロール
#    - 実際のS3バケットへのアクセス権限を持つ必要があります
#
# 4. aws_iam_user / aws_iam_role (グランティー用、IAMタイプの場合)
#    - アクセスを付与する対象のIAMユーザーまたはロール

################################################################################
# ベストプラクティス
################################################################################

# 1. 最小権限の原則
#    - 必要最小限のpermission (READ/WRITE/READWRITE)を付与
#    - s3_sub_prefixを使用してアクセススコープを可能な限り狭める
#    - s3_prefix_type = "Object"で特定オブジェクトのみに制限
#
# 2. CloudTrailログ記録
#    - S3 Access Grantsは自動的にCloudTrailにログを記録します
#    - エンドユーザーIDとアプリケーションアクセスを追跡可能
#    - コンプライアンスと監査の要件を満たすために活用
#
# 3. IAM Identity Center統合
#    - 企業ディレクトリユーザーにS3アクセスを付与する場合は、
#      DIRECTORY_USERまたはDIRECTORY_GROUPタイプを使用
#    - グループ単位で権限管理することで、運用を簡素化
#
# 4. タグ戦略
#    - 環境、プロジェクト、所有者などのタグを一貫して付与
#    - コスト配分とリソース管理に活用
#
# 5. 一時認証情報の使用
#    - グランティーはGetDataAccess APIを使用して一時認証情報を取得
#    - durationSecondsパラメータで有効期限を設定可能
#    - 長期的な認証情報の管理が不要になり、セキュリティが向上

################################################################################
# 使用例: 完全な構成
################################################################################

# 以下は、S3 Access Grantsの完全な構成例です:
#
# # 1. S3 Access Grants Instance
# resource "aws_s3control_access_grants_instance" "example" {
#   identity_center_arn = aws_ssoadmin_instance.example.arn # オプション
# }
#
# # 2. IAMロール (ロケーション用)
# resource "aws_iam_role" "location" {
#   name = "s3-access-grants-location-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "access-grants.s3.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }
#
# resource "aws_iam_role_policy" "location" {
#   role = aws_iam_role.location.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Action = [
#         "s3:GetObject",
#         "s3:ListBucket",
#         "s3:PutObject"
#       ]
#       Resource = [
#         "${aws_s3_bucket.example.arn}",
#         "${aws_s3_bucket.example.arn}/*"
#       ]
#     }]
#   })
# }
#
# # 3. S3 Access Grants Location
# resource "aws_s3control_access_grants_location" "example" {
#   depends_on     = [aws_s3control_access_grants_instance.example]
#   iam_role_arn   = aws_iam_role.location.arn
#   location_scope = "s3://${aws_s3_bucket.example.bucket}/data/*"
# }
#
# # 4. S3 Access Grant (このファイルのリソース)
# resource "aws_s3control_access_grant" "example" {
#   # 上記の設定を参照
# }

################################################################################
# トラブルシューティング
################################################################################

# 問題: グラント作成時に "LocationNotFound" エラー
# 解決策: access_grants_location_idが正しく、ロケーションが既に作成されていることを確認
#        depends_onを使用して依存関係を明示的に定義
#
# 問題: 一時認証情報の取得に失敗
# 解決策: - ロケーション用IAMロールがS3バケットへのアクセス権限を持つか確認
#        - IAMロールの信頼ポリシーでaccess-grants.s3.amazonaws.comを許可
#        - グランティーのIDが正しいか確認 (ARNまたはGUID)
#
# 問題: DIRECTORY_USER/GROUPのGUIDがわからない
# 解決策: IAM Identity Centerコンソールから確認、または
#        identitystore:DescribeUser/DescribeGroup APIを使用
#        AWS CLIの場合:
#        aws identitystore describe-user --identity-store-id <id> --user-id <id>
