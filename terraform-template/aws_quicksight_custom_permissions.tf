#---------------------------------------------------------------
# AWS QuickSight Custom Permissions
#---------------------------------------------------------------
#
# Amazon QuickSightのカスタム権限プロファイルをプロビジョニングするリソースです。
# カスタム権限プロファイルを使用すると、QuickSightユーザーまたはロールに対して
# データエクスポート、共有、レポート等の特定の機能へのアクセスを制限できます。
# プロファイルはアカウント・ロール・ユーザーレベルで適用でき、ユーザーレベルの
# 設定がロールレベルおよびアカウントレベルの設定よりも優先されます。
#
# AWS公式ドキュメント:
#   - カスタム権限プロファイルの概要: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CustomPermissions.html
#   - カスタム権限プロファイルの作成: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateCustomPermissions.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_custom_permissions
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_custom_permissions" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # custom_permissions_name (Required, Forces new resource)
  # 設定内容: カスタム権限プロファイルの名前を指定します。
  # 設定可能な値: 1〜64文字の文字列（英数字、ハイフン、アンダースコア等）
  custom_permissions_name = "example-custom-permissions"

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: カスタム権限プロファイルを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に特定したアカウントIDを使用します。
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # 機能制限設定
  #-------------------------------------------------------------

  # capabilities (Required)
  # 設定内容: カスタム権限プロファイルに含める機能制限の設定ブロックです。
  # 設定内容: 各属性に "DENY" を指定すると、その機能へのアクセスが拒否されます。
  # 関連機能: QuickSight カスタム権限プロファイル
  #   ユーザーまたはロールに対してQuickSightの特定機能を制限します。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateCustomPermissions.html
  capabilities {

    #-------------------------------------------------------------
    # 分析設定
    #-------------------------------------------------------------

    # add_or_run_anomaly_detection_for_analyses (Optional)
    # 設定内容: 分析での異常検出の追加・実行を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    add_or_run_anomaly_detection_for_analyses = null

    # share_analyses (Optional)
    # 設定内容: 分析の共有機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    share_analyses = null

    #-------------------------------------------------------------
    # ダッシュボード設定
    #-------------------------------------------------------------

    # share_dashboards (Optional)
    # 設定内容: ダッシュボードの共有機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    share_dashboards = null

    #-------------------------------------------------------------
    # データソース・データセット設定
    #-------------------------------------------------------------

    # create_and_update_data_sources (Optional)
    # 設定内容: データソースの作成・更新機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_and_update_data_sources = null

    # share_data_sources (Optional)
    # 設定内容: データソースの共有機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    share_data_sources = null

    # create_and_update_datasets (Optional)
    # 設定内容: データセットの作成・更新機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_and_update_datasets = null

    # share_datasets (Optional)
    # 設定内容: データセットの共有機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    share_datasets = null

    # create_spice_dataset (Optional)
    # 設定内容: SPICEデータセットの作成機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    # 参考: SPICEはQuickSightのインメモリ計算エンジンです。
    create_spice_dataset = null

    # view_account_spice_capacity (Optional)
    # 設定内容: アカウントのSPICEキャパシティ表示機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    view_account_spice_capacity = null

    #-------------------------------------------------------------
    # テーマ・アラート設定
    #-------------------------------------------------------------

    # create_and_update_themes (Optional)
    # 設定内容: テーマの作成・更新機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_and_update_themes = null

    # create_and_update_threshold_alerts (Optional)
    # 設定内容: しきい値アラートの作成・更新機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_and_update_threshold_alerts = null

    #-------------------------------------------------------------
    # フォルダ設定
    #-------------------------------------------------------------

    # create_shared_folders (Optional)
    # 設定内容: 共有フォルダの作成機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_shared_folders = null

    # rename_shared_folders (Optional)
    # 設定内容: 共有フォルダの名前変更機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    rename_shared_folders = null

    #-------------------------------------------------------------
    # エクスポート設定
    #-------------------------------------------------------------

    # export_to_csv (Optional)
    # 設定内容: UIからのCSVファイルへのエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_csv = null

    # export_to_excel (Optional)
    # 設定内容: UIからのExcelファイルへのエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_excel = null

    # export_to_pdf (Optional)
    # 設定内容: UIからのPDFファイルへのエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_pdf = null

    # print_reports (Optional)
    # 設定内容: レポートの印刷機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    print_reports = null

    #-------------------------------------------------------------
    # メールレポート設定
    #-------------------------------------------------------------

    # create_and_update_dashboard_email_reports (Optional)
    # 設定内容: ダッシュボードのメールレポートの作成・更新機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    create_and_update_dashboard_email_reports = null

    # subscribe_dashboard_email_reports (Optional)
    # 設定内容: ダッシュボードのメールレポートへのサブスクライブ機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    subscribe_dashboard_email_reports = null

    # export_to_csv_in_scheduled_reports (Optional)
    # 設定内容: スケジュールされたメールレポートでのCSVエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_csv_in_scheduled_reports = null

    # export_to_excel_in_scheduled_reports (Optional)
    # 設定内容: スケジュールされたメールレポートでのExcelエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_excel_in_scheduled_reports = null

    # export_to_pdf_in_scheduled_reports (Optional)
    # 設定内容: スケジュールされたメールレポートでのPDFエクスポート機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    export_to_pdf_in_scheduled_reports = null

    # include_content_in_scheduled_reports_email (Optional)
    # 設定内容: スケジュールされたメールレポートへのコンテンツ添付機能を制限するかを指定します。
    # 設定可能な値: "DENY"（拒否する場合）
    # 省略時: 制限を設けません（機能を許可します）。
    include_content_in_scheduled_reports_email = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-custom-permissions"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: カスタム権限プロファイルのARN
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
