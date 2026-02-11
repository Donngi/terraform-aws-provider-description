################################################################################
# AWS Redshift Serverless Resource Policy
################################################################################
# Resource: aws_redshiftserverless_resource_policy
# Provider Version: 6.28.0
#
# 概要:
# Amazon Redshift Serverless のリソースポリシーを作成します。
# このリソースは主にスナップショットのクロスアカウント共有に使用され、
# 他の AWS アカウントがスナップショットから復元する権限を付与できます。
#
# ユースケース:
# - スナップショットのクロスアカウント共有
# - 災害復旧用のバックアップアクセス制御
# - 開発/本番環境間でのデータ共有
# - 組織内の複数アカウント間でのデータアクセス管理
#
# 主な特徴:
# - JSON形式のIAMポリシーベースのアクセス制御
# - スナップショットリソースへのアクセス権限管理
# - 特定のAWSアカウントへの復元権限付与
# - リージョン単位でのリソース管理
#
# 注意事項:
# - 各スナップショットは最大20アカウントまで共有可能
# - 暗号化されたスナップショットを共有する場合、KMSキーも共有が必要
# - 共有されたアカウントはスナップショットのコピーや削除はできない
# - リソースポリシーは RestoreFromSnapshot アクションに主に使用される
#
# 関連ドキュメント:
# - https://docs.aws.amazon.com/redshift/latest/mgmt/serverless-snapshot-share.html
# - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshot-share-snapshot.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_resource_policy
################################################################################

resource "aws_redshiftserverless_resource_policy" "example" {
  ################################################################################
  # 必須パラメータ
  ################################################################################

  # resource_arn - (必須) リソースポリシーを作成・更新する対象のARN
  #
  # 説明:
  # - Amazon Redshift Serverless のスナップショットARNを指定
  # - このARNに対してアクセスポリシーが適用される
  # - 通常は aws_redshiftserverless_snapshot リソースのARNを参照
  #
  # 形式: arn:aws:redshift-serverless:region:account-id:snapshot/snapshot-id
  #
  # 例:
  # - aws_redshiftserverless_snapshot.example.arn
  # - "arn:aws:redshift-serverless:us-east-1:123456789012:snapshot/my-snapshot"
  #
  # 注意:
  # - ARNは有効なRedshift Serverlessリソースである必要がある
  # - スナップショットが存在しない場合はエラーになる
  resource_arn = aws_redshiftserverless_snapshot.example.arn

  # policy - (必須) リソースポリシーの定義（JSON形式）
  #
  # 説明:
  # - IAMポリシードキュメント形式でアクセス権限を定義
  # - 他のAWSアカウントに対する権限を付与
  # - jsonencode() 関数を使用してTerraformオブジェクトから変換
  #
  # ポリシー要素:
  # - Version: ポリシー言語のバージョン（通常は "2012-10-17"）
  # - Statement: 権限ステートメントの配列
  #   - Effect: "Allow" または "Deny"
  #   - Principal: アクセスを許可するAWSアカウント
  #   - Action: 許可するアクション
  #   - Sid: ステートメント識別子（オプション）
  #
  # 主なアクション:
  # - redshift-serverless:RestoreFromSnapshot - スナップショットからの復元
  # - redshift-serverless:ListSnapshots - スナップショットの一覧表示
  #
  # セキュリティ考慮事項:
  # - 最小権限の原則に従って必要なアクションのみを許可
  # - 信頼できるAWSアカウントIDのみを指定
  # - 暗号化スナップショットの場合はKMSキーポリシーも更新が必要
  #
  # 例1: 単一アカウントへの復元権限付与
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [{
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = ["arn:aws:iam::123456789012:root"]
  #     }
  #     Action = ["redshift-serverless:RestoreFromSnapshot"]
  #     Sid = "AllowSnapshotRestore"
  #   }]
  # })
  #
  # 例2: 複数アカウントへの権限付与
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [{
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = [
  #         "123456789012",  # 開発アカウント
  #         "210987654321",  # ステージングアカウント
  #       ]
  #     }
  #     Action = [
  #       "redshift-serverless:RestoreFromSnapshot",
  #       "redshift-serverless:ListSnapshots",
  #     ]
  #     Sid = "CrossAccountAccess"
  #   }]
  # })
  #
  # 例3: 組織内アカウントへの権限付与
  # policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [{
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = "*"
  #     }
  #     Action = ["redshift-serverless:RestoreFromSnapshot"]
  #     Condition = {
  #       StringEquals = {
  #         "aws:PrincipalOrgID" = "o-xxxxxxxxxx"
  #       }
  #     }
  #     Sid = "OrganizationAccess"
  #   }]
  # })
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = ["123456789012"]  # 共有先のAWSアカウントID
      }
      Action = [
        "redshift-serverless:RestoreFromSnapshot",
      ]
      Sid = ""
    }]
  })

  ################################################################################
  # オプションパラメータ
  ################################################################################

  # region - (オプション) リソースを管理するAWSリージョン
  #
  # 説明:
  # - このリソースが管理されるAWSリージョンを指定
  # - 省略した場合はプロバイダー設定のリージョンが使用される
  # - スナップショットと同じリージョンを指定する必要がある
  #
  # 利用シーン:
  # - マルチリージョン構成での明示的なリージョン指定
  # - プロバイダーのデフォルトリージョンと異なるリージョンでの管理
  #
  # 値の例:
  # - "us-east-1"
  # - "eu-west-1"
  # - "ap-northeast-1"
  #
  # 注意:
  # - 指定したリージョンでRedshift Serverlessが利用可能である必要がある
  # - リソースARNのリージョンと一致している必要がある
  #
  # デフォルト: プロバイダー設定のリージョン
  # region = "us-east-1"

  ################################################################################
  # ライフサイクル設定
  ################################################################################

  # lifecycle {
  #   # ポリシー変更時の動作制御
  #   create_before_destroy = true
  #
  #   # 特定の属性変更を無視
  #   # ignore_changes = [
  #   #   policy,  # 外部でポリシーが変更される場合
  #   # ]
  #
  #   # リソースの削除防止
  #   # prevent_destroy = true
  # }

  ################################################################################
  # タグ
  ################################################################################
  # 注意: このリソースはタグをサポートしていません
  # タグが必要な場合は、スナップショットリソース自体にタグを設定してください

  ################################################################################
  # 依存関係の例
  ################################################################################

  # 明示的な依存関係
  # depends_on = [
  #   aws_redshiftserverless_snapshot.example,
  #   aws_kms_grant.snapshot_key,  # 暗号化スナップショットの場合
  # ]
}

################################################################################
# 出力値の例
################################################################################

# output "resource_policy_id" {
#   description = "リソースポリシーのID（リソースARNと同じ）"
#   value       = aws_redshiftserverless_resource_policy.example.id
# }

# output "resource_policy_arn" {
#   description = "ポリシーが適用されているリソースのARN"
#   value       = aws_redshiftserverless_resource_policy.example.resource_arn
# }

################################################################################
# 関連リソースの例
################################################################################

# スナップショットリソースの定義例
# resource "aws_redshiftserverless_snapshot" "example" {
#   snapshot_name = "example-snapshot"
#   namespace_name = aws_redshiftserverless_namespace.example.namespace_name
#
#   retention_period = 7
# }

# 暗号化スナップショット用のKMSキーポリシー例
# resource "aws_kms_key_policy" "snapshot_sharing" {
#   key_id = aws_kms_key.redshift.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow use of the key for snapshot sharing"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::123456789012:root"  # 共有先アカウント
#         }
#         Action = [
#           "kms:Decrypt",
#           "kms:DescribeKey",
#           "kms:CreateGrant",
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "kms:ViaService" = "redshift-serverless.us-east-1.amazonaws.com"
#           }
#         }
#       },
#     ]
#   })
# }

# 共有先アカウントでの復元用IAMポリシー例
# resource "aws_iam_policy" "restore_shared_snapshot" {
#   name        = "RedshiftServerlessRestoreSharedSnapshot"
#   description = "Allow restoring from shared Redshift Serverless snapshots"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "redshift-serverless:RestoreFromSnapshot",
#           "redshift-serverless:GetSnapshot",
#         ]
#         Resource = [
#           "arn:aws:redshift-serverless:us-east-1:SOURCE_ACCOUNT_ID:snapshot/*",
#           "arn:aws:redshift-serverless:us-east-1:DEST_ACCOUNT_ID:namespace/*",
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "kms:Decrypt",
#           "kms:DescribeKey",
#           "kms:CreateGrant",
#         ]
#         Resource = "arn:aws:kms:us-east-1:SOURCE_ACCOUNT_ID:key/*"
#       },
#     ]
#   })
# }

################################################################################
# ベストプラクティス
################################################################################
#
# 1. セキュリティ:
#    - 最小権限の原則に従い、必要なアクションのみを許可
#    - 信頼できるアカウントIDのみを Principal に指定
#    - 暗号化スナップショットの場合は KMS キーポリシーも適切に設定
#    - 定期的にポリシーをレビューして不要な権限を削除
#
# 2. アクセス制御:
#    - AWS Organizations を使用している場合は条件キーを活用
#    - 特定のアクションのみを許可し、ワイルドカード（*）の使用を避ける
#    - Sid（ステートメントID）を使用してポリシーを文書化
#
# 3. 運用:
#    - ポリシー変更は Terraform で管理し、手動変更を避ける
#    - 共有するスナップショットの保持期間を適切に設定
#    - 共有先アカウントでの復元権限も合わせて設定
#
# 4. モニタリング:
#    - CloudTrail でポリシーの使用状況を監視
#    - 不正なアクセス試行を検出するアラートを設定
#    - 定期的にアクセスログをレビュー
#
# 5. 災害復旧:
#    - クロスリージョンでのスナップショット共有を検討
#    - 復元手順を文書化してテスト
#    - 自動化されたバックアップとポリシー管理を実装
#
# 6. コスト最適化:
#    - 不要になったスナップショット共有は速やかに削除
#    - スナップショットの保持期間を適切に設定
#    - 共有されたスナップショットのストレージコストを考慮
#
################################################################################
# トラブルシューティング
################################################################################
#
# 問題: ポリシーが適用されない
# 解決策:
#   - リソースARNが正しいか確認
#   - ポリシーのJSON構文が正しいか確認（jsonencode使用推奨）
#   - IAMポリシーシミュレーターでポリシーをテスト
#
# 問題: 共有先アカウントで復元できない
# 解決策:
#   - リソースポリシーで適切なアクションが許可されているか確認
#   - 共有先アカウントのIAMポリシーに復元権限があるか確認
#   - 暗号化スナップショットの場合、KMSキーへのアクセス権限を確認
#   - スナップショットのステータスが AVAILABLE であるか確認
#
# 問題: KMS暗号化エラー
# 解決策:
#   - KMSキーポリシーで共有先アカウントに kms:Decrypt 権限を付与
#   - KMSキーが有効化されているか確認
#   - ViaService 条件で redshift-serverless サービスが許可されているか確認
#
# 問題: リージョン間での問題
# 解決策:
#   - リソースポリシーとスナップショットが同じリージョンにあるか確認
#   - region パラメータが正しく設定されているか確認
#   - クロスリージョンアクセスにはスナップショットコピーが必要
#
################################################################################
