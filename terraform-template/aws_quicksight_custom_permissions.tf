################################################################################
# AWS QuickSight Custom Permissions
################################################################################

# このリソースは Amazon QuickSight のカスタム権限プロファイルを管理します。
# カスタム権限プロファイルを使用すると、QuickSight アプリケーション内の特定の機能へのアクセスを
# ユーザーレベルで制限できます。
#
# 主な用途:
# - データエクスポート機能(CSV、Excel、PDF)の制限
# - QuickSight アセット(ダッシュボード、分析、データセット)の共有制限
# - メールレポート機能の制限
# - データソース・テーマ・SPICE データセットの作成制限
#
# 重要な考慮事項:
# - IAM Identity Center ユーザーとその他すべてのアイデンティティタイプで利用可能
# - プロファイル名は変更するとリソースが再作成されます
# - 機能制限は "DENY" のみを指定可能(許可する機能は省略)
# - QuickSight が利用可能なすべての AWS リージョンで使用可能
#
# ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_custom_permissions

resource "aws_quicksight_custom_permissions" "example" {
  # ────────────────────────────────────────────────────────────────────────────
  # 必須パラメータ
  # ────────────────────────────────────────────────────────────────────────────

  # カスタム権限プロファイル名
  # - 1〜64 文字の英数字とアンダースコア、ハイフンのみ使用可能
  # - 変更するとリソースが再作成されます
  # 例: "RestrictedUserPermissions", "DataAnalystProfile"
  custom_permissions_name = "example-custom-permissions"

  # カスタム権限プロファイルに含める機能制限
  # - 各機能は "DENY" を指定することで無効化できます
  # - 省略された機能は許可されます
  capabilities {
    # ────────────────────────────────────────────────────────────────────────
    # データエクスポート機能
    # ────────────────────────────────────────────────────────────────────────

    # UI からの CSV ファイルエクスポート機能
    # "DENY" で無効化、省略で許可
    export_to_csv = "DENY"

    # スケジュールされたメールレポートでの CSV ファイルエクスポート機能
    export_to_csv_in_scheduled_reports = "DENY"

    # UI からの Excel ファイルエクスポート機能
    export_to_excel = "DENY"

    # スケジュールされたメールレポートでの Excel ファイルエクスポート機能
    export_to_excel_in_scheduled_reports = "DENY"

    # UI からの PDF ファイルエクスポート機能
    export_to_pdf = "DENY"

    # スケジュールされたメールレポートでの PDF ファイルエクスポート機能
    export_to_pdf_in_scheduled_reports = "DENY"

    # レポートの印刷機能
    print_reports = "DENY"

    # ────────────────────────────────────────────────────────────────────────
    # 共有機能
    # ────────────────────────────────────────────────────────────────────────

    # 分析の共有機能
    share_analyses = "DENY"

    # ダッシュボードの共有機能
    share_dashboards = "DENY"

    # データセットの共有機能
    share_datasets = "DENY"

    # データソースの共有機能
    share_data_sources = "DENY"

    # ────────────────────────────────────────────────────────────────────────
    # 作成・更新機能
    # ────────────────────────────────────────────────────────────────────────

    # データセットの作成・更新機能
    create_and_update_datasets = "DENY"

    # データソースの作成・更新機能
    create_and_update_data_sources = "DENY"

    # テーマの作成・更新機能
    create_and_update_themes = "DENY"

    # しきい値アラートの作成・更新機能
    create_and_update_threshold_alerts = "DENY"

    # SPICE データセットの作成機能
    # SPICE: Super-fast, Parallel, In-memory Calculation Engine
    create_spice_dataset = "DENY"

    # ────────────────────────────────────────────────────────────────────────
    # メールレポート機能
    # ────────────────────────────────────────────────────────────────────────

    # ダッシュボードのメールレポートの作成・更新機能
    create_and_update_dashboard_email_reports = "DENY"

    # メールレポートへの購読機能
    subscribe_dashboard_email_reports = "DENY"

    # スケジュールされたメールレポートへのコンテンツ含有機能
    include_content_in_scheduled_reports_email = "DENY"

    # ────────────────────────────────────────────────────────────────────────
    # フォルダ管理機能
    # ────────────────────────────────────────────────────────────────────────

    # 共有フォルダの作成機能
    create_shared_folders = "DENY"

    # 共有フォルダの名前変更機能
    rename_shared_folders = "DENY"

    # ────────────────────────────────────────────────────────────────────────
    # その他の機能
    # ────────────────────────────────────────────────────────────────────────

    # 分析の異常検知機能の追加・実行
    add_or_run_anomaly_detection_for_analyses = "DENY"

    # アカウントの SPICE 容量の表示機能
    view_account_spice_capacity = "DENY"
  }

  # ────────────────────────────────────────────────────────────────────────────
  # オプションパラメータ
  # ────────────────────────────────────────────────────────────────────────────

  # AWS アカウント ID
  # - 省略した場合、Terraform AWS プロバイダーのアカウント ID が使用されます
  # - 変更するとリソースが再作成されます
  # 例: "123456789012"
  # aws_account_id = "123456789012"

  # リージョン
  # - このリソースが管理されるリージョンを指定します
  # - 省略した場合、プロバイダーで設定されたリージョンが使用されます
  # 例: "us-east-1", "ap-northeast-1"
  # region = "us-east-1"

  # タグ
  # - リソースに付与するキーバリューマップのタグ
  # - プロバイダーレベルの default_tags と統合されます
  tags = {
    Name        = "example-custom-permissions"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "Restrict user capabilities in QuickSight"
  }
}

################################################################################
# 出力値
################################################################################

# カスタム権限プロファイルの ARN
output "custom_permissions_arn" {
  description = "ARN of the QuickSight custom permissions profile"
  value       = aws_quicksight_custom_permissions.example.arn
}

# カスタム権限プロファイル名
output "custom_permissions_name" {
  description = "Name of the QuickSight custom permissions profile"
  value       = aws_quicksight_custom_permissions.example.custom_permissions_name
}

# すべてのタグ(プロバイダー default_tags を含む)
output "custom_permissions_tags_all" {
  description = "All tags assigned to the custom permissions profile"
  value       = aws_quicksight_custom_permissions.example.tags_all
}

################################################################################
# 使用例
################################################################################

# ──────────────────────────────────────────────────────────────────────────────
# 例1: データアナリスト向けの制限プロファイル
# ──────────────────────────────────────────────────────────────────────────────
# データ分析は許可するが、データソースやデータセットの作成は制限

# resource "aws_quicksight_custom_permissions" "data_analyst" {
#   custom_permissions_name = "data-analyst-permissions"
#
#   capabilities {
#     # データソース・データセットの作成を制限
#     create_and_update_datasets     = "DENY"
#     create_and_update_data_sources = "DENY"
#
#     # エクスポート機能は許可(コメントアウトまたは省略)
#     # export_to_csv   = "DENY"
#     # export_to_excel = "DENY"
#   }
#
#   tags = {
#     Name = "data-analyst-permissions"
#     Role = "DataAnalyst"
#   }
# }

# ──────────────────────────────────────────────────────────────────────────────
# 例2: ビューアー向けの厳格な制限プロファイル
# ──────────────────────────────────────────────────────────────────────────────
# 閲覧のみ許可し、すべてのエクスポート・共有・作成機能を制限

# resource "aws_quicksight_custom_permissions" "viewer_only" {
#   custom_permissions_name = "viewer-only-permissions"
#
#   capabilities {
#     # すべてのエクスポート機能を制限
#     export_to_csv                           = "DENY"
#     export_to_csv_in_scheduled_reports      = "DENY"
#     export_to_excel                         = "DENY"
#     export_to_excel_in_scheduled_reports    = "DENY"
#     export_to_pdf                           = "DENY"
#     export_to_pdf_in_scheduled_reports      = "DENY"
#     print_reports                           = "DENY"
#
#     # すべての共有機能を制限
#     share_analyses     = "DENY"
#     share_dashboards   = "DENY"
#     share_datasets     = "DENY"
#     share_data_sources = "DENY"
#
#     # すべての作成・更新機能を制限
#     create_and_update_datasets              = "DENY"
#     create_and_update_data_sources          = "DENY"
#     create_and_update_themes                = "DENY"
#     create_and_update_threshold_alerts      = "DENY"
#     create_and_update_dashboard_email_reports = "DENY"
#     create_spice_dataset                    = "DENY"
#     create_shared_folders                   = "DENY"
#     rename_shared_folders                   = "DENY"
#
#     # その他の機能も制限
#     subscribe_dashboard_email_reports               = "DENY"
#     include_content_in_scheduled_reports_email      = "DENY"
#     add_or_run_anomaly_detection_for_analyses       = "DENY"
#     view_account_spice_capacity                     = "DENY"
#   }
#
#   tags = {
#     Name = "viewer-only-permissions"
#     Role = "Viewer"
#   }
# }

# ──────────────────────────────────────────────────────────────────────────────
# 例3: レポート専用ユーザー向けプロファイル
# ──────────────────────────────────────────────────────────────────────────────
# メールレポートの受信のみ許可し、他の機能を制限

# resource "aws_quicksight_custom_permissions" "report_subscriber" {
#   custom_permissions_name = "report-subscriber-permissions"
#
#   capabilities {
#     # メールレポートの購読は許可(省略)
#     # subscribe_dashboard_email_reports = "DENY"
#
#     # 共有機能を制限
#     share_analyses     = "DENY"
#     share_dashboards   = "DENY"
#     share_datasets     = "DENY"
#     share_data_sources = "DENY"
#
#     # 作成・更新機能を制限
#     create_and_update_datasets              = "DENY"
#     create_and_update_data_sources          = "DENY"
#     create_and_update_dashboard_email_reports = "DENY"
#   }
#
#   tags = {
#     Name = "report-subscriber-permissions"
#     Role = "ReportSubscriber"
#   }
# }

# ──────────────────────────────────────────────────────────────────────────────
# 例4: データエンジニア向けプロファイル
# ──────────────────────────────────────────────────────────────────────────────
# データソース・データセットの管理は許可するが、共有は制限

# resource "aws_quicksight_custom_permissions" "data_engineer" {
#   custom_permissions_name = "data-engineer-permissions"
#
#   capabilities {
#     # データソース・データセットの作成は許可(省略)
#     # create_and_update_datasets     = "DENY"
#     # create_and_update_data_sources = "DENY"
#
#     # 共有機能は制限
#     share_analyses     = "DENY"
#     share_dashboards   = "DENY"
#     share_datasets     = "DENY"
#     share_data_sources = "DENY"
#
#     # SPICE データセットの作成は許可(省略)
#     # create_spice_dataset = "DENY"
#   }
#
#   tags = {
#     Name = "data-engineer-permissions"
#     Role = "DataEngineer"
#   }
# }

################################################################################
# 補足情報
################################################################################

# ユーザーへのカスタム権限プロファイルの割り当て:
# カスタム権限プロファイルを作成した後、QuickSight API を使用してユーザーに割り当てます。
# Terraform では aws_quicksight_user リソースと組み合わせて使用することができます。
#
# API リファレンス:
# - CreateCustomPermissions
# - UpdateCustomPermissions
# - DeleteCustomPermissions
# - DescribeCustomPermissions
# - ListCustomPermissions
# - UpdateUserCustomPermission
# - DeleteUserCustomPermission
#
# リージョン可用性:
# Amazon QuickSight が利用可能なすべての AWS リージョンで使用可能
#
# 機能の詳細:
# - capabilities ブロック内のすべてのパラメータはオプションです
# - 各機能パラメータは "DENY" のみを値として受け付けます
# - 機能を許可する場合は、パラメータを省略またはコメントアウトします
# - "DENY" を指定すると、その機能がユーザーから削除されます
#
# セキュリティのベストプラクティス:
# - 最小権限の原則に従い、必要な機能のみを許可する
# - 定期的に権限プロファイルを見直し、不要な権限を削除する
# - 役割ごとに異なるカスタム権限プロファイルを作成する
# - タグを使用して権限プロファイルの目的と対象ユーザーを明確にする
