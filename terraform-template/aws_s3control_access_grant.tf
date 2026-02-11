#---------------------------------------------------------------
# S3 Access Grant
#---------------------------------------------------------------
#
# S3アクセス許可を管理するリソースです。
# 各アクセス許可には独自のIDがあり、IAMユーザー、ロール、またはディレクトリユーザー・グループ
# (被付与者)に登録された場所へのアクセスを許可します。
# アクセスレベル(READ、WRITE、READWRITE)を決定できます。
#
# 前提条件:
#   - S3データと同じリージョンにS3 Access Grantsインスタンスが必要です
#   - アクセス許可を作成する前に、S3 Access Grants位置情報を登録する必要があります
#
# AWS公式ドキュメント:
#   - S3 Access Grantsの概要: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants.html
#   - アクセス許可の作成: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grant
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_s3control_access_grant" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # access_grants_location_id (Required)
  # 設定内容: アクセス許可を付与するS3 Access Grants位置情報のIDを指定します。
  # 設定可能な値: 事前に作成されたアクセス許可位置情報のID
  #             (aws_s3control_access_grants_location.example.access_grants_location_idなど)
  # 関連機能: S3 Access Grants位置情報
  #   この値を変更すると、リソースが再作成されます。
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-location.html
  access_grants_location_id = "default"

  # permission (Required)
  # 設定内容: 登録された場所に対するアクセス許可レベルを指定します。
  # 設定可能な値:
  #   - READ: 読み取り操作を許可 (s3:GetObject, s3:ListBucket)
  #   - WRITE: 書き込み操作を許可 (s3:PutObject, s3:DeleteObject)
  #   - READWRITE: 読み取りと書き込みの両方を許可
  # ベストプラクティス: 最小権限の原則に従い、必要な権限のみを付与してください
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  permission = "READ"

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: S3 Access Grants位置情報のAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動的に決定されるアカウントIDを使用
  # 利用例: クロスアカウントのアクセス許可を管理する場合に指定
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants.html
  # account_id = "123456789012"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このアクセス許可を管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 制約事項: S3 Access Grantsインスタンスおよび位置情報と同じリージョンである必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #-------------------------------------------------------------
  # プレフィックスタイプ設定
  #-------------------------------------------------------------

  # s3_prefix_type (Optional)
  # 設定内容: アクセス許可のスコープを指定します。
  # 設定可能な値:
  #   - Object: 単一のオブジェクトへのアクセスのみを許可
  # 省略時: プレフィックスに一致するすべてのオブジェクトに許可が適用されます
  # 利用例: プレフィックス全体ではなく、単一のファイルへのアクセスを許可する場合
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  # s3_prefix_type = "Object"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # ベストプラクティス:
  #   - Environment: 環境の識別 (Production, Staging, Development)
  #   - Owner: リソースの所有者またはチーム
  #   - Project: プロジェクト名
  #   - CostCenter: コスト配分用のコストセンター
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  # tags = {
  #   Environment = "Production"
  #   ManagedBy   = "Terraform"
  #   Project     = "DataAccess"
  #   Owner       = "DataTeam"
  # }

  #-------------------------------------------------------------
  # 位置情報設定ブロック (Optional)
  #-------------------------------------------------------------

  # access_grants_location_configuration (Optional)
  # ブロックタイプ: list
  # 設定内容: 登録された位置情報内のサブプレフィックスを指定して、アクセスをさらに制限します。
  # 利用例: より広範な位置情報内の特定のサブフォルダーへのアクセスを許可する場合
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  #
  # access_grants_location_configuration {
  #   # s3_sub_prefix (Optional)
  #   # 設定内容: 登録された位置情報のスコープ内のサブプレフィックスを指定します。
  #   # 設定可能な値: S3プレフィックス形式の文字列
  #   # 例: 位置情報が "s3://bucket/data/*" の場合、sub_prefix を "2024/*" に設定すると
  #   #     実効的なアクセス許可スコープは "s3://bucket/data/2024/*" になります
  #   # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  #   s3_sub_prefix = "subfolder/*"
  # }

  #-------------------------------------------------------------
  # 被付与者設定ブロック (Optional)
  #-------------------------------------------------------------

  # grantee (Optional)
  # ブロックタイプ: list
  # 設定内容: アクセス許可を受け取るエンティティ(ユーザー、ロール、またはディレクトリエンティティ)を指定します。
  # 省略時: 呼び出し元のIDに許可が適用されます
  # 利用例: 特定のIAMプリンシパルまたはディレクトリユーザーへのアクセスを許可する場合
  # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  #
  # grantee {
  #   # grantee_type (Required within grantee block)
  #   # 設定内容: アクセスを受け取る被付与者のタイプを指定します。
  #   # 設定可能な値:
  #   #   - IAM: AWS IAMユーザーまたはロール
  #   #   - DIRECTORY_USER: AWS IAM Identity Centerディレクトリのユーザー
  #   #   - DIRECTORY_GROUP: AWS IAM Identity Centerディレクトリのグループ
  #   # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  #   grantee_type = "IAM"
  #
  #   # grantee_identifier (Required within grantee block)
  #   # 設定内容: 被付与者の識別子を指定します。形式はgrantee_typeによって異なります。
  #   # 設定可能な値:
  #   #   - IAMの場合: IAMユーザーまたはロールの完全なARN
  #   #     例: "arn:aws:iam::123456789012:user/username"
  #   #     例: "arn:aws:iam::123456789012:role/rolename"
  #   #   - DIRECTORY_USER/GROUPの場合: ディレクトリエンティティ識別子
  #   #     例: "user-id@domain.com" または "group-id"
  #   # 重要: 大文字と小文字が区別されるため、正確に指定してください
  #   # 参考: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-grant.html
  #   grantee_identifier = "arn:aws:iam::123456789012:user/example-user"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Terraformリソース識別子
#   形式: account_id,access_grant_id
#
# - access_grant_arn: S3アクセス許可のAmazon Resource Name (ARN)
#   形式: arn:aws:s3:region:account-id:access-grants/instance-id/grant/grant-id
#   用途: IAMポリシーでの参照、監視・監査目的
#
# - access_grant_id: S3アクセス許可の一意の識別子
#   用途: API操作または他のリソースでの参照
#
# - grant_scope: アクセス許可の実効スコープ (S3プレフィックスパス)
#   説明: 位置情報スコープとsub_prefix(指定されている場合)の組み合わせを反映
#   例: "s3://bucket-name/prefix/*"
#   用途: 付与された実際のアクセススコープの検証
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 完全なS3 Access Grantsセットアップ
#---------------------------------------------------------------

# 例1: アクセス許可位置情報用のIAMロール
# resource "aws_iam_role" "access_grants_location" {
#   name = "s3-access-grants-location-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "access-grants.s3.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# 例2: S3アクセス用のIAMロールポリシー
# resource "aws_iam_role_policy" "access_grants_location" {
#   name = "s3-access-policy"
#   role = aws_iam_role.access_grants_location.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:ListBucket"
#         ]
#         Resource = [
#           "${aws_s3_bucket.example.arn}",
#           "${aws_s3_bucket.example.arn}/*"
#         ]
#       }
#     ]
#   })
# }

# 例3: アクセスを許可するS3バケット
# resource "aws_s3_bucket" "example" {
#   bucket = "my-access-grants-bucket"
# }

# 例4: S3 Access Grantsインスタンスの作成 (最初のステップ)
# resource "aws_s3control_access_grants_instance" "example" {
#   # オプション: ディレクトリ統合用のidentity_center_arn
#   # identity_center_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"
# }

# 例5: S3位置情報の登録 (アクセス許可作成前に必要)
# resource "aws_s3control_access_grants_location" "example" {
#   depends_on = [aws_s3control_access_grants_instance.example]
#
#   iam_role_arn   = aws_iam_role.access_grants_location.arn
#   location_scope = "s3://${aws_s3_bucket.example.bucket}/data/*"
# }

# 例6: IAMユーザーへの読み取りアクセス許可
# resource "aws_s3control_access_grant" "iam_user_read" {
#   access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id
#   permission                = "READ"
#
#   grantee {
#     grantee_type       = "IAM"
#     grantee_identifier = aws_iam_user.example.arn
#   }
#
#   tags = {
#     Name        = "user-read-access"
#     Environment = "production"
#   }
# }

# 例7: 特定のサブフォルダーへの書き込みアクセス許可
# resource "aws_s3control_access_grant" "subfolder_write" {
#   access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id
#   permission                = "WRITE"
#
#   access_grants_location_configuration {
#     s3_sub_prefix = "uploads/*"
#   }
#
#   grantee {
#     grantee_type       = "IAM"
#     grantee_identifier = aws_iam_role.upload_service.arn
#   }
# }

# 例8: 単一オブジェクトへのアクセス許可
# resource "aws_s3control_access_grant" "single_object" {
#   access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id
#   permission                = "READ"
#   s3_prefix_type            = "Object"
#
#   access_grants_location_configuration {
#     s3_sub_prefix = "reports/monthly-report.pdf"
#   }
#
#   grantee {
#     grantee_type       = "IAM"
#     grantee_identifier = aws_iam_user.analyst.arn
#   }
# }

# 例9: ディレクトリグループへのアクセス許可 (IAM Identity Center統合)
# resource "aws_s3control_access_grant" "directory_group" {
#   access_grants_location_id = aws_s3control_access_grants_location.example.access_grants_location_id
#   permission                = "READWRITE"
#
#   grantee {
#     grantee_type       = "DIRECTORY_GROUP"
#     grantee_identifier = "engineering-team-group-id"
#   }
#
#   tags = {
#     Name        = "engineering-team-access"
#     Environment = "production"
#   }
# }

#---------------------------------------------------------------
# 出力値の例
#---------------------------------------------------------------

# output "access_grant_arn" {
#   description = "S3アクセス許可のARN"
#   value       = aws_s3control_access_grant.example.access_grant_arn
# }

# output "access_grant_id" {
#   description = "S3アクセス許可の一意のID"
#   value       = aws_s3control_access_grant.example.access_grant_id
# }

# output "grant_scope" {
#   description = "アクセス許可の実効S3スコープ"
#   value       = aws_s3control_access_grant.example.grant_scope
# }

#---------------------------------------------------------------
# 重要な注意事項とベストプラクティス
#---------------------------------------------------------------
#
# 1. 前提条件:
#    - 最初に同じリージョンにS3 Access Grantsインスタンスを作成する必要があります
#    - アクセス許可を作成する前にS3 Access Grants位置情報を登録する必要があります
#    - 位置情報のIAMロールに必要なS3権限があることを確認してください
#
# 2. 権限レベル:
#    - READ: s3:GetObject、s3:ListBucket権限を付与
#    - WRITE: s3:PutObject、s3:DeleteObject権限を付与
#    - READWRITE: READとWRITEの両方の権限を付与
#    - 常に最小権限の原則に従ってください
#
# 3. 被付与者タイプ:
#    - IAM: AWS IAMユーザーとロール用 (最も一般的)
#    - DIRECTORY_USER: IAM Identity Centerの個別ユーザー用
#    - DIRECTORY_GROUP: IAM Identity Centerのグループ用
#    - granteeブロックを省略すると、呼び出し元のIDに許可が付与されます
#
# 4. スコープ階層:
#    - 位置情報スコープはaws_s3control_access_grants_locationで定義されます
#    - サブプレフィックスは位置情報スコープ内でさらに制限します
#    - 単一オブジェクトアクセスにはs3_prefix_type = "Object"を使用
#    - 実効スコープはgrant_scope計算属性に表示されます
#
# 5. クロスアカウントアクセス:
#    - クロスアカウント許可にはaccount_idパラメータを使用
#    - 適切なIAM信頼関係が設定されていることを確認してください
#    - 被付与者の認証情報を使用してAWS CLIまたはSDKでアクセスをテストしてください
#
# 6. タグ付け戦略:
#    - 組織化、コスト追跡、コンプライアンスのためにアクセス許可にタグを付けてください
#    - すべてのS3 Access Grantsリソースで一貫したタグを使用してください
#    - 推奨タグ: Environment、Owner、Project、CostCenter
#
# 7. 監視と監査:
#    - CloudTrailを使用してアクセス許可の使用状況を監視してください
#    - アクセス許可が引き続き必要かどうかを定期的に確認してください
#    - タグを使用してアクセス許可の所有権と目的を追跡してください
#    - grant_scopeを監視して、意図したアクセスと一致することを確認してください
#
# 8. ライフサイクル管理:
#    - ほとんどの属性についてはインプレースで更新できます
#    - access_grants_location_idを変更すると、リソースが再作成されます
#    - 適切な作成順序を確保するためにdepends_onを使用してください
#    - 複数のアクセス許可を管理するためにfor_eachの使用を検討してください
#
# 9. セキュリティ上の考慮事項:
#    - 定期的にアクティブなアクセス許可を監査し、未使用のものを削除してください
#    - 外部自動化を使用して時間ベースのアクセスを実装してください
#    - CloudWatch Eventsを使用してアクセス許可の作成/削除を通知してください
#    - 多層防御のためにS3バケットポリシーと組み合わせてください
#
# 10. 一般的なパターン:
#     - ユーザー固有のフォルダー: "users/{username}/*"にREADWRITEを付与
#     - 部門データ: 部門グループにREADを付与
#     - アプリケーションアクセス: サービスロールに特定の権限を付与
#     - 一時アクセス: アクセス許可を作成、使用、その後削除
#
# 11. 制限事項:
#     - アクセス許可はリージョナル - S3データと同じリージョンである必要があります
#     - インスタンスごとのアクセス許可の最大数が適用される場合があります(AWS制限を確認)
#     - サブプレフィックスは位置情報スコープ内である必要があります
#     - 登録された位置情報外へのアクセスは付与できません
#
# 12. トラブルシューティング:
#     - アクセス拒否の場合: grant_scopeが要求されたパスと一致することを確認
#     - grantee_identifierが正しいことを確認(大文字小文字の区別あり)
#     - 位置情報のIAMロールに必要なS3権限があることを確認
#     - S3 Access Grantsインスタンスが存在することを確認
#     - AWS CLI を使用: aws s3control list-access-grants で検証
#
# 13. コスト最適化:
#     - S3 Access Grants自体に追加コストはかかりません
#     - 標準のS3リクエストとストレージコストが適用されます
#     - クリーンな構成を維持するために未使用のアクセス許可を削除してください
#
# 14. IAM Identity Centerとの統合:
#     - ディレクトリ統合のためにidentity_center_arnを使用してインスタンスを作成
#     - SSOユーザーにはDIRECTORY_USER/GROUP被付与者タイプを使用
#     - 大規模なユーザーベースの権限管理を簡素化します
#
# 15. Terraformのベストプラクティス:
#     - データソースを使用して既存のインスタンス/位置情報を参照してください
#     - 作成順序のために適切なdepends_onを実装してください
#     - 再利用可能なアクセス許可構成のために変数を使用してください
#     - 複雑なアクセス許可階層のためにモジュールの使用を検討してください
#
#---------------------------------------------------------------
