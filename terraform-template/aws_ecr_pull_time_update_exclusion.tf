# ================================================================================
# Terraform Resource: aws_ecr_pull_time_update_exclusion
# Provider Version: 6.28.0
# ================================================================================
#
# AWS ECR (Elastic Container Registry) Pull Time Update Exclusion を管理します。
# このリソースにより、特定のIAMプリンシパルによるイメージプル時に、
# LastRecordedPullTime タイムスタンプの更新を除外できます。
# テスト環境やCI/CD環境など、プル時刻をライフサイクルポリシーの判断に
# 影響させたくないロールの除外に有用です。
#
# 公式ドキュメント:
# - リソース: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_time_update_exclusion
# - API: https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_RegisterPullTimeUpdateExclusion.html
# - ガイド: https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-time-update-exclusions.html
#
# 重要な制約:
# - アカウントあたり最大100個の除外設定が可能
# - principal_arn の変更は強制的に新しいリソースを作成(ForceNew)
# ================================================================================

resource "aws_ecr_pull_time_update_exclusion" "example" {

  # ============================================================
  # 必須パラメータ (Required Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # principal_arn
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: Yes
  # 変更時の動作: ForceNew (リソース再作成)
  #
  # イメージプル時刻の記録から除外するIAMプリンシパルのARN。
  # IAMロール、IAMユーザーなどのARNを指定できます。
  #
  # ユースケース:
  # - CI/CDパイプラインで使用されるロールを除外
  # - テスト環境のロールをライフサイクルポリシーから除外
  # - セキュリティスキャンツールの実行ロールを除外
  #
  # 例:
  # - IAMロール: "arn:aws:iam::123456789012:role/my-ci-role"
  # - IAMユーザー: "arn:aws:iam::123456789012:user/my-test-user"
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_RegisterPullTimeUpdateExclusion.html
  # ------------------------------------------------------------
  principal_arn = "arn:aws:iam::123456789012:role/example-role"


  # ============================================================
  # オプションパラメータ (Optional Parameters)
  # ============================================================

  # ------------------------------------------------------------
  # region
  # ------------------------------------------------------------
  # タイプ: string
  # 必須: No
  # デフォルト: プロバイダー設定のリージョン
  # 計算される: Yes
  #
  # このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # ユースケース:
  # - マルチリージョン構成で明示的にリージョンを指定
  # - プロバイダーのデフォルトリージョンと異なるリージョンで管理
  #
  # 例:
  # - "us-east-1"
  # - "ap-northeast-1"
  # - "eu-west-1"
  #
  # AWS公式ドキュメント:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # ------------------------------------------------------------
  # region = "us-east-1"  # オプション: 明示的にリージョンを指定する場合


  # ============================================================
  # タグ (Tags)
  # ============================================================
  # 注意: このリソースはタグをサポートしていません。


  # ============================================================
  # ライフサイクル設定例
  # ============================================================
  # lifecycle {
  #   # principal_arn の変更を防止(誤って変更すると再作成される)
  #   prevent_destroy = true
  #
  #   # 除外設定を削除前に新しいものを作成
  #   create_before_destroy = true
  # }
}


# ================================================================================
# 補足情報とベストプラクティス
# ================================================================================
#
# 【プル時刻更新除外の仕組み】
# - 通常、ECRはイメージがプルされるたびに LastRecordedPullTime を更新
# - 除外リストに追加されたプリンシパルによるプルでは更新されない
# - ライフサイクルポリシーで「最終プル日時」ベースのルール利用時に有用
#
# 【必要な IAM 権限】
# このリソースを管理するには以下の権限が必要:
# - ecr:RegisterPullTimeUpdateExclusion (作成時)
# - ecr:DeregisterPullTimeUpdateExclusion (削除時)
# - ecr:ListPullTimeUpdateExclusions (読み取り時)
#
# 【制限事項】
# - アカウントあたり最大100個の除外設定
# - 既に存在するプリンシパルARNを追加するとエラー
# - リージョンごとに個別の除外リストを管理
#
# 【典型的な使用例】
#
# 1. CI/CDロールの除外:
#    resource "aws_ecr_pull_time_update_exclusion" "ci_cd" {
#      principal_arn = aws_iam_role.ci_cd_role.arn
#    }
#
# 2. テスト環境ユーザーの除外:
#    resource "aws_ecr_pull_time_update_exclusion" "test_user" {
#      principal_arn = aws_iam_user.test_user.arn
#    }
#
# 3. マルチリージョン設定:
#    resource "aws_ecr_pull_time_update_exclusion" "eu_west" {
#      principal_arn = aws_iam_role.scanner.arn
#      region        = "eu-west-1"
#    }
#
# 【関連リソース】
# - aws_ecr_repository: ECR リポジトリの管理
# - aws_ecr_lifecycle_policy: イメージライフサイクルポリシー
# - aws_iam_role: 除外するIAMロールの定義
# - aws_iam_user: 除外するIAMユーザーの定義
#
# 【エラーハンドリング】
# - ExclusionAlreadyExistsException: 既に存在する除外設定
# - InvalidParameterException: 無効なARN形式
# - LimitExceededException: 100個の制限超過
# - ValidationException: バリデーションエラー
#
# 【参考リンク】
# - Pull-time update exclusions 概要:
#   https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-time-update-exclusions.html
# - Pull-time update exclusions 管理:
#   https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-time-update-exclusions-manage.html
# - RegisterPullTimeUpdateExclusion API:
#   https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_RegisterPullTimeUpdateExclusion.html
# - DeregisterPullTimeUpdateExclusion API:
#   https://docs.aws.amazon.com/AmazonECR/latest/APIReference/API_DeregisterPullTimeUpdateExclusion.html
#
# ================================================================================
