# ================================================================
# AWS S3 Access Grants Instance
# Provider Version: 6.28.0
# Resource: aws_s3control_access_grants_instance
# ================================================================
#
# S3 Access Grants インスタンスは、S3 Access Grants のリソース(登録された
# ロケーションとアクセスグラント)の論理的なコンテナです。各AWSアカウントの
# 各リージョンに1つのS3 Access Grantsインスタンスを作成できます。
#
# 主な用途:
# - IAMユーザーやロールに対する細かいS3アクセス権限の管理
# - IAM Identity Center(旧AWS SSO)との統合による企業アイデンティティの管理
# - S3バケットへのアクセス権限を一元管理するコンテナの提供
#
# 重要な考慮事項:
# - 1リージョン・1アカウントあたり1インスタンスのみ作成可能
# - 削除前に、全てのアクセスグラントとロケーションを削除する必要あり
# - IAM Identity Centerとの関連付けがある場合は、削除前に関連付けを解除
# - インスタンスの削除は永久的で、全てのgranteeのアクセスが失われる
#
# 参考資料:
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-grants-instance.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3control_access_grants_instance
# ================================================================

resource "aws_s3control_access_grants_instance" "example" {
  # ================================================================
  # 必須パラメータ
  # ================================================================
  # このリソースには必須パラメータはありません。
  # 最小構成では、単純に空のブロックで作成可能です。


  # ================================================================
  # オプションパラメータ
  # ================================================================

  # account_id - S3 Access Grantsインスタンスを作成するAWSアカウントID
  # - デフォルト: Terraformプロバイダーで設定されたアカウントIDが自動的に使用される
  # - 通常は明示的に指定する必要はない
  # - クロスアカウント管理を行う場合に使用
  # account_id = "123456789012"

  # region - このリソースが管理されるリージョン
  # - デフォルト: Terraformプロバイダーで設定されたリージョンが使用される
  # - 通常は明示的に指定する必要はない
  # - 特定のリージョンに明示的にリソースを作成する場合に使用
  # - 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # identity_center_arn - 関連付けるIAM Identity CenterインスタンスのARN
  # - オプション: IAM Identity Centerと統合する場合に指定
  # - 企業のアイデンティティディレクトリを使用する場合に必要
  # - 形式: arn:aws:sso:::instance/ssoins-xxxxxxxxxxxxxxxxx
  # - IAM Identity Centerインスタンスは事前にセットアップされている必要がある
  # - 後から関連付け・解除も可能
  # identity_center_arn = "arn:aws:sso:::instance/ssoins-890759e9c7bfdc1d"

  # tags - リソースに付与するタグ
  # - Key-Valueペアのマップ形式
  # - プロバイダーレベルのdefault_tagsと併用可能
  # tags = {
  #   Name        = "example-access-grants-instance"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }


  # ================================================================
  # 計算される属性(読み取り専用)
  # ================================================================
  # 以下の属性はTerraformによって自動的に設定され、outputs等で参照可能:
  #
  # - id: リソースの一意識別子
  # - access_grants_instance_arn: S3 Access GrantsインスタンスのARN
  # - access_grants_instance_id: S3 Access Grantsインスタンスの一意ID
  # - identity_center_application_arn: IAM Identity Centerインスタンスアプリケーションの
  #   ARN(元のIdentity Centerインスタンスのサブリソース)
  # - tags_all: プロバイダーのdefault_tagsを含む全てのタグのマップ
  # ================================================================
}


# ================================================================
# 使用例: 基本構成
# ================================================================
# 最もシンプルな構成。IAM Identity Centerとの統合なし。
# resource "aws_s3control_access_grants_instance" "basic" {}


# ================================================================
# 使用例: IAM Identity Center統合
# ================================================================
# IAM Identity Centerと統合し、企業アイデンティティでアクセス管理を行う構成。
#
# resource "aws_s3control_access_grants_instance" "with_identity_center" {
#   identity_center_arn = "arn:aws:sso:::instance/ssoins-890759e9c7bfdc1d"
#
#   tags = {
#     Name        = "production-access-grants"
#     Environment = "production"
#     Department  = "data-engineering"
#   }
# }


# ================================================================
# 使用例: 完全な構成
# ================================================================
# 全てのオプションパラメータを明示的に指定した構成。
#
# resource "aws_s3control_access_grants_instance" "complete" {
#   account_id          = "123456789012"
#   region              = "us-east-1"
#   identity_center_arn = "arn:aws:sso:::instance/ssoins-890759e9c7bfdc1d"
#
#   tags = {
#     Name            = "complete-access-grants-instance"
#     Environment     = "production"
#     ManagedBy       = "terraform"
#     CostCenter      = "data-platform"
#     SecurityLevel   = "high"
#     DataClassification = "internal"
#   }
# }


# ================================================================
# Output例
# ================================================================
# 作成したインスタンスの情報を出力する例。
#
# output "access_grants_instance_arn" {
#   description = "S3 Access GrantsインスタンスのARN"
#   value       = aws_s3control_access_grants_instance.example.access_grants_instance_arn
# }
#
# output "access_grants_instance_id" {
#   description = "S3 Access Grantsインスタンスの一意ID"
#   value       = aws_s3control_access_grants_instance.example.access_grants_instance_id
# }
#
# output "identity_center_application_arn" {
#   description = "関連するIAM Identity CenterアプリケーションのARN"
#   value       = aws_s3control_access_grants_instance.example.identity_center_application_arn
# }


# ================================================================
# 関連リソース
# ================================================================
# S3 Access Grantsインスタンスと一緒に使用する関連リソース:
#
# - aws_s3control_access_grants_location
#   S3バケットやプレフィックスをS3 Access Grantsに登録
#
# - aws_s3control_access_grant
#   特定のIAMプリンシパルやIdentity Centerユーザーに対してアクセス権限を付与
#
# - aws_s3control_access_grants_instance_resource_policy
#   S3 Access Grantsインスタンスのリソースポリシーを管理
#
# - aws_identitystore_user / aws_identitystore_group
#   IAM Identity Centerのユーザーやグループ管理


# ================================================================
# セキュリティのベストプラクティス
# ================================================================
# 1. IAM Identity Centerとの統合
#    - 可能な限りIAM Identity Centerと統合し、企業アイデンティティを使用
#    - 中央集権的なアクセス管理を実現
#
# 2. 最小権限の原則
#    - 必要最小限のアクセス権限のみを付与
#    - アクセスグラントは細かい粒度で設定
#
# 3. タグ付けの標準化
#    - 環境、コストセンター、オーナー情報を必ずタグ付け
#    - タグベースのアクセス制御やコスト配分に活用
#
# 4. モニタリングとログ
#    - CloudTrailでS3 Access Grantsの操作ログを記録
#    - アクセスパターンの異常を検知
#
# 5. 削除保護
#    - 本番環境では削除前の承認プロセスを設定
#    - Terraformのライフサイクルルールで保護を検討


# ================================================================
# トラブルシューティング
# ================================================================
# 1. インスタンス作成の失敗
#    - 同一リージョンに既にインスタンスが存在していないか確認
#    - 必要なIAM権限(s3:CreateAccessGrantsInstance)があるか確認
#
# 2. IAM Identity Center関連付けの失敗
#    - Identity CenterインスタンスARNが正しいか確認
#    - Identity Centerインスタンスが有効化されているか確認
#    - 同一リージョンのIdentity Centerインスタンスを使用しているか確認
#
# 3. 削除の失敗
#    - 全てのアクセスグラントが削除されているか確認
#    - 全てのロケーションが削除されているか確認
#    - IAM Identity Centerとの関連付けが解除されているか確認
#
# 4. 権限エラー
#    - Terraformの実行ロールに適切なs3control権限があるか確認
#    - 必要な権限: s3:CreateAccessGrantsInstance, s3:DeleteAccessGrantsInstance,
#      s3:GetAccessGrantsInstance, s3:ListAccessGrantsInstances


# ================================================================
# コスト最適化
# ================================================================
# - S3 Access Grantsインスタンス自体の作成に追加料金はかかりません
# - アクセスグラントの評価とログ記録には料金が発生する可能性があります
# - 不要なインスタンスは削除してリソースを整理
# - CloudWatchログやCloudTrailのログ保持期間を適切に設定


# ================================================================
# 変更管理の注意点
# ================================================================
# 1. インスタンスの削除
#    - 永久的な操作であり、元に戻せない
#    - 全てのgranteeのアクセスが失われる
#    - 削除前に必ずバックアップと影響範囲の確認を実施
#
# 2. IAM Identity Centerとの関連付け変更
#    - 既存のアクセスグラントに影響する可能性
#    - 変更前にアクセス権限の再設定が必要かどうか確認
#
# 3. リージョン変更
#    - region属性の変更はリソースの再作成を伴う
#    - 再作成時にダウンタイムが発生する可能性
#    - 計画的なメンテナンスウィンドウで実施


# ================================================================
# 参考コマンド(AWS CLI)
# ================================================================
# インスタンスの詳細を取得:
# aws s3control get-access-grants-instance \
#   --account-id 123456789012 \
#   --region us-east-1
#
# インスタンスの一覧を取得:
# aws s3control list-access-grants-instances \
#   --account-id 123456789012 \
#   --region us-east-1
#
# インスタンスの削除(注意: 永久的):
# aws s3control delete-access-grants-instance \
#   --account-id 123456789012 \
#   --region us-east-1
