################################################################################
# AWS QuickSight Namespace - 完全実装テンプレート
################################################################################
# QuickSightネームスペースは、QuickSightユーザーとリソースを論理的にグループ化
# するための組織単位です。各AWSアカウント内で複数のネームスペースを作成でき、
# ユーザーアイデンティティストアの管理とアクセス制御を提供します。
#
# ユースケース:
# - 組織内の部門やチームごとにQuickSightリソースを分離
# - マルチテナント環境でのデータとダッシュボードの分離
# - 異なるアイデンティティストアを使用する環境の管理
#
# 重要な考慮事項:
# - デフォルトネームスペース(default)は自動的に作成される
# - ネームスペース名は一意である必要がある
# - identity_storeは現在QUICKSIGHTのみサポート
# - ネームスペース削除前に、すべてのユーザーとリソースを削除する必要がある
################################################################################

################################################################################
# 基本設定 - 最小限の必須パラメータのみ
################################################################################
resource "aws_quicksight_namespace" "basic" {
  # 必須パラメータ
  # ネームスペース名 - QuickSight内で一意である必要がある
  # 制約: 英数字、ハイフン、アンダースコアのみ使用可能
  namespace = "analytics-team"

  # タグ - リソース管理とコスト配分に使用
  tags = {
    Environment = "production"
    Team        = "Analytics"
    ManagedBy   = "Terraform"
  }
}

################################################################################
# 完全設定 - すべてのオプションパラメータを含む
################################################################################
resource "aws_quicksight_namespace" "complete" {
  #-----------------------------------------------------------------------------
  # 必須パラメータ
  #-----------------------------------------------------------------------------

  # ネームスペース名
  # - 組織内で一意の識別子
  # - 作成後は変更不可（変更するとリソースの再作成が必要）
  # - 推奨: チーム名、部門名、環境名などを含む命名規則を使用
  namespace = "finance-reporting-prod"

  #-----------------------------------------------------------------------------
  # オプションパラメータ
  #-----------------------------------------------------------------------------

  # AWSアカウントID
  # - デフォルト: Terraformプロバイダーのアカウント
  # - 明示的に指定することで、異なるアカウントのネームスペースを管理可能
  # - 変更するとリソースの再作成が必要（Forces new resource）
  # aws_account_id = "123456789012"

  # アイデンティティストアタイプ
  # - 現在の有効値: "QUICKSIGHT"（デフォルト）
  # - 将来的に他のアイデンティティプロバイダー統合が追加される可能性あり
  # - QUICKSIGHTを使用すると、QuickSightネイティブのユーザー管理を使用
  identity_store = "QUICKSIGHT"

  # リージョン指定
  # - デフォルト: プロバイダー設定のリージョン
  # - QuickSightが利用可能なリージョンでのみ使用可能
  # - データレジデンシー要件がある場合に明示的に指定
  # region = "us-east-1"

  # タグ - リソース管理、コスト配分、アクセス制御に使用
  # provider default_tagsとマージされる
  tags = {
    Environment  = "production"
    Department   = "Finance"
    CostCenter   = "CC-12345"
    DataClass    = "Confidential"
    Compliance   = "SOX"
    ManagedBy    = "Terraform"
    Application  = "Financial Reporting"
    Owner        = "finance-team@example.com"
  }

  #-----------------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------------

  timeouts {
    # 作成時のタイムアウト
    # - デフォルト: 2分
    # - ネームスペース作成とアイデンティティストアの初期化に必要な時間
    create = "5m"

    # 削除時のタイムアウト
    # - デフォルト: 2分
    # - ネームスペース内のリソースクリーンアップに必要な時間
    # - 注意: ユーザーやリソースが残っている場合、削除は失敗する
    delete = "5m"
  }
}

################################################################################
# マルチネームスペース構成例 - 複数の環境・チーム向け
################################################################################

# 開発環境用ネームスペース
resource "aws_quicksight_namespace" "development" {
  namespace = "analytics-dev"

  tags = {
    Environment = "development"
    Team        = "Analytics"
    ManagedBy   = "Terraform"
  }
}

# ステージング環境用ネームスペース
resource "aws_quicksight_namespace" "staging" {
  namespace = "analytics-staging"

  tags = {
    Environment = "staging"
    Team        = "Analytics"
    ManagedBy   = "Terraform"
  }
}

# 本番環境用ネームスペース
resource "aws_quicksight_namespace" "production" {
  namespace = "analytics-prod"

  tags = {
    Environment = "production"
    Team        = "Analytics"
    ManagedBy   = "Terraform"
    Compliance  = "Required"
  }

  # 本番環境は長めのタイムアウトを設定
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

################################################################################
# 部門別ネームスペース構成例
################################################################################

# 各部門に専用のネームスペースを作成することで、
# データとダッシュボードのアクセス制御を強化

locals {
  # 部門リストを定義
  departments = [
    "finance",
    "marketing",
    "sales",
    "operations"
  ]
}

# 部門ごとにネームスペースを動的に作成
resource "aws_quicksight_namespace" "departments" {
  for_each = toset(local.departments)

  namespace = "${each.value}-analytics"

  tags = {
    Department  = title(each.value)
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

################################################################################
# 出力値 - 他のリソースで参照可能な属性
################################################################################

# 基本設定のネームスペース出力
output "basic_namespace_arn" {
  description = "基本ネームスペースのARN"
  value       = aws_quicksight_namespace.basic.arn
}

output "basic_namespace_id" {
  description = "基本ネームスペースのID（アカウントID,ネームスペース名の形式）"
  value       = aws_quicksight_namespace.basic.id
}

output "basic_namespace_capacity_region" {
  description = "基本ネームスペースが作成されたリージョン"
  value       = aws_quicksight_namespace.basic.capacity_region
}

output "basic_namespace_creation_status" {
  description = "基本ネームスペースの作成ステータス"
  value       = aws_quicksight_namespace.basic.creation_status
}

# 完全設定のネームスペース出力
output "complete_namespace_arn" {
  description = "完全設定ネームスペースのARN"
  value       = aws_quicksight_namespace.complete.arn
}

output "complete_namespace_id" {
  description = "完全設定ネームスペースのID"
  value       = aws_quicksight_namespace.complete.id
}

output "complete_namespace_capacity_region" {
  description = "完全設定ネームスペースのキャパシティリージョン"
  value       = aws_quicksight_namespace.complete.capacity_region
}

output "complete_namespace_creation_status" {
  description = "完全設定ネームスペースの作成ステータス"
  value       = aws_quicksight_namespace.complete.creation_status
}

output "complete_namespace_tags_all" {
  description = "完全設定ネームスペースに適用されたすべてのタグ（default_tagsを含む）"
  value       = aws_quicksight_namespace.complete.tags_all
}

# 環境別ネームスペースARNのマップ
output "environment_namespaces" {
  description = "環境別のネームスペースARNマップ"
  value = {
    development = aws_quicksight_namespace.development.arn
    staging     = aws_quicksight_namespace.staging.arn
    production  = aws_quicksight_namespace.production.arn
  }
}

# 部門別ネームスペースARNのマップ
output "department_namespaces" {
  description = "部門別のネームスペースARNマップ"
  value = {
    for dept, ns in aws_quicksight_namespace.departments :
    dept => ns.arn
  }
}

# 部門別ネームスペースIDのマップ
output "department_namespace_ids" {
  description = "部門別のネームスペースIDマップ"
  value = {
    for dept, ns in aws_quicksight_namespace.departments :
    dept => ns.id
  }
}

################################################################################
# 実装上の注意事項とベストプラクティス
################################################################################

# 1. ネームスペース命名規則
#    - 組織の命名規則に従った一貫性のある名前を使用
#    - 環境（dev/staging/prod）を含めることを推奨
#    - チーム名や部門名を含めることで管理を容易に
#
# 2. アイデンティティストア管理
#    - 現在はQUICKSIGHTのみサポート
#    - 将来的にIAM Identity Centerとの統合が追加される可能性
#    - ユーザー管理はaws_quicksight_userリソースで行う
#
# 3. タグ戦略
#    - コスト配分タグを使用してQuickSightコストを追跡
#    - 部門、プロジェクト、環境でタグ付け
#    - default_tagsと個別タグを組み合わせて使用
#
# 4. リソース依存関係
#    - ネームスペース削除前に、すべてのユーザーを削除
#    - ダッシュボード、データセット、データソースも削除が必要
#    - Terraformのdepends_onで依存関係を明示的に定義
#
# 5. マルチリージョン展開
#    - QuickSightは一部リージョンでのみ利用可能
#    - データレジデンシー要件を考慮してリージョンを選択
#    - 各リージョンで個別にネームスペースを作成
#
# 6. セキュリティ考慮事項
#    - ネームスペースレベルでアクセス制御を実装
#    - 最小権限の原則に従ってユーザー権限を付与
#    - 本番とテスト環境のネームスペースを分離
#
# 7. 監視とコンプライアンス
#    - CloudTrailでQuickSightアクティビティを監視
#    - creation_statusを監視してネームスペースの正常性を確認
#    - コンプライアンス要件に応じたタグ付けを実施
#
# 8. コスト最適化
#    - 使用されていないネームスペースは定期的に削除
#    - ユーザー数とセッション数を監視してコストを管理
#    - 開発/テスト環境は必要時のみ作成
#
# 9. 移行とバックアップ
#    - ネームスペース間でのリソース移行は手動操作が必要
#    - 定期的にダッシュボードとデータセットをエクスポート
#    - ディザスタリカバリ計画にネームスペースの再作成を含める
#
# 10. トラブルシューティング
#     - creation_statusがCREATED以外の場合は作成失敗の可能性
#     - ネームスペース削除エラーは残存リソースが原因
#     - タイムアウトエラーはネットワーク遅延やAPI制限が原因

################################################################################
# 関連リソース
################################################################################
# - aws_quicksight_user: ネームスペース内のユーザー管理
# - aws_quicksight_group: ユーザーグループ管理
# - aws_quicksight_group_membership: グループメンバーシップ管理
# - aws_quicksight_data_source: データソース定義
# - aws_quicksight_data_set: データセット定義
# - aws_quicksight_dashboard: ダッシュボード作成
# - aws_quicksight_analysis: 分析の作成と管理
# - aws_quicksight_template: テンプレート管理
# - aws_quicksight_folder: フォルダー構造管理
# - aws_quicksight_refresh_schedule: データ更新スケジュール
#
# QuickSightリソースの典型的な依存関係:
# Namespace -> User/Group -> Data Source -> Data Set -> Analysis/Dashboard

################################################################################
# 参考リンク
################################################################################
# - Terraform AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_namespace
# - AWS QuickSight Namespace API:
#   https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateNamespace.html
# - QuickSight User Guide:
#   https://docs.aws.amazon.com/quicksight/latest/user/
# - QuickSight Security:
#   https://docs.aws.amazon.com/quicksight/latest/user/security.html
# - QuickSight Pricing:
#   https://aws.amazon.com/quicksight/pricing/
