#---------------------------------------------------------------
# Amazon QuickSight Dashboard
#---------------------------------------------------------------
#
# Amazon QuickSightのダッシュボードをプロビジョニングするリソースです。
# ダッシュボードはインタラクティブなビジュアルと分析情報を含むエンティティで、
# テンプレートや定義から作成できます。ユーザーやグループと共有することで
# データのインサイトを組織全体に共有できます。
#
# AWS公式ドキュメント:
#   - QuickSight ダッシュボード概要: https://docs.aws.amazon.com/quicksight/latest/user/working-with-dashboards.html
#   - CreateDashboard API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDashboard.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_dashboard
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_dashboard" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # dashboard_id (Required, Forces new resource)
  # 設定内容: ダッシュボードの一意な識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  dashboard_id = "example-dashboard-id"

  # name (Required)
  # 設定内容: ダッシュボードの表示名を指定します。
  # 設定可能な値: 1文字以上の文字列
  name = "example-dashboard"

  # version_description (Required)
  # 設定内容: 現在作成・更新しているダッシュボードバージョンの説明を指定します。
  # 設定可能な値: 1文字以上の文字列
  version_description = "Initial version"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: ダッシュボードを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁の数字からなるAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動判定されたアカウントIDを使用
  aws_account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # テーマ設定
  #-------------------------------------------------------------

  # theme_arn (Optional)
  # 設定内容: ダッシュボードに適用するテーマのARNを指定します。
  # 設定可能な値: 有効なQuickSightテーマのARN（ダッシュボードと同一AWSアカウント内に存在するもの）
  # 省略時: テーマは適用されません
  theme_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-dashboard"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # ソースエンティティ設定（テンプレートから作成する場合）
  #-------------------------------------------------------------
  # 注意: source_entity と definition はどちらか一方のみ設定可能です。

  # source_entity (Optional)
  # 設定内容: ダッシュボード作成のソースとなるエンティティ（テンプレート）の設定ブロックです。
  # 設定可能な値: source_template ブロックを含む設定
  # 注意: definition ブロックと排他的（どちらか一方のみ指定可能）
  source_entity {

    #---------------------------------------------------------
    # ソーステンプレート設定
    #---------------------------------------------------------

    # source_template (Optional)
    # 設定内容: ダッシュボード作成のソーステンプレートを指定するブロックです。
    source_template {

      # arn (Required)
      # 設定内容: ソーステンプレートのAmazon Resource Name (ARN) を指定します。
      # 設定可能な値: 有効なQuickSightテンプレートARN
      arn = "arn:aws:quicksight:ap-northeast-1:123456789012:template/source-template-id"

      # data_set_references (Required)
      # 設定内容: テンプレートで参照するデータセットのマッピングを指定するブロックです。
      # 複数のデータセットを参照する場合は複数のブロックを記載します。
      data_set_references {

        # data_set_arn (Required)
        # 設定内容: 参照するデータセットのARNを指定します。
        # 設定可能な値: 有効なQuickSightデータセットARN
        data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset-id"

        # data_set_placeholder (Required)
        # 設定内容: テンプレート内でのデータセットプレースホルダーを指定します。
        # 設定可能な値: テンプレートで使用しているプレースホルダー文字列
        data_set_placeholder = "1"
      }
    }
  }

  #-------------------------------------------------------------
  # 定義設定（コードで直接定義する場合）
  #-------------------------------------------------------------
  # 注意: source_entity と definition はどちらか一方のみ設定可能です。
  # definition ブロックを使用する場合は source_entity を削除してください。

  # definition (Optional)
  # 設定内容: ダッシュボードの詳細な定義を直接指定するブロックです。
  # テンプレートを使わずコードでダッシュボードを定義する場合に使用します。
  # 注意: source_entity ブロックと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DashboardVersionDefinition.html
  #
  # definition {
  #
  #   #---------------------------------------------------------
  #   # データセット識別子宣言
  #   #---------------------------------------------------------
  #
  #   # data_set_identifiers_declarations (Required, 1-50件)
  #   # 設定内容: ダッシュボード内で使用するデータセット識別子の宣言ブロックです。
  #   # ARNの代わりに識別子でデータセットを参照できます。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DataSetIdentifierDeclaration.html
  #   data_set_identifiers_declarations {
  #
  #     # data_set_arn (Optional)
  #     # 設定内容: データセットのARNを指定します。
  #     # 設定可能な値: 有効なQuickSightデータセットARN
  #     data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset-id"
  #
  #     # identifier (Optional)
  #     # 設定内容: ダッシュボード内でデータセットを参照するための識別子を指定します。
  #     # 設定可能な値: 文字列
  #     identifier = "1"
  #   }
  #
  #   #---------------------------------------------------------
  #   # 計算フィールド設定
  #   #---------------------------------------------------------
  #
  #   # calculated_fields (Optional, 最大500件)
  #   # 設定内容: ダッシュボードの計算フィールド定義を指定するブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CalculatedField.html
  #   calculated_fields {
  #
  #     # data_set_identifier (Required)
  #     # 設定内容: 計算フィールドが属するデータセットの識別子を指定します。
  #     # 設定可能な値: data_set_identifiers_declarations で宣言した識別子
  #     data_set_identifier = "1"
  #
  #     # expression (Required)
  #     # 設定内容: 計算フィールドの計算式を指定します。
  #     # 設定可能な値: QuickSight計算フィールドの式文字列
  #     expression = "toDecimal({ColumnName})"
  #
  #     # name (Required)
  #     # 設定内容: 計算フィールドの名前を指定します。
  #     # 設定可能な値: 文字列
  #     name = "calculated_field_name"
  #   }
  #
  #   #---------------------------------------------------------
  #   # カラム設定
  #   #---------------------------------------------------------
  #
  #   # column_configurations (Optional)
  #   # 設定内容: ダッシュボード全体で使用するカラムのデフォルトフォーマット設定ブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ColumnConfiguration.html
  #   column_configurations {
  #
  #     # role (Optional)
  #     # 設定内容: カラムのロールを指定します。
  #     # 設定可能な値: "DIMENSION", "MEASURE"
  #     role = "DIMENSION"
  #
  #     column {
  #       # column_name (Required)
  #       # 設定内容: カラム名を指定します。
  #       column_name = "ColumnName"
  #
  #       # data_set_identifier (Required)
  #       # 設定内容: カラムが属するデータセットの識別子を指定します。
  #       data_set_identifier = "1"
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # フィルターグループ設定
  #   #---------------------------------------------------------
  #
  #   # filter_groups (Optional)
  #   # 設定内容: ダッシュボードのフィルター定義ブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_FilterGroup.html
  #   filter_groups {
  #
  #     # cross_dataset (Required)
  #     # 設定内容: フィルターがクロスデータセットかどうかを指定します。
  #     # 設定可能な値: "ALL_DATASETS", "SINGLE_DATASET"
  #     cross_dataset = "ALL_DATASETS"
  #
  #     # filter_group_id (Required)
  #     # 設定内容: フィルターグループの一意な識別子を指定します。
  #     # 設定可能な値: 文字列
  #     filter_group_id = "filter-group-1"
  #
  #     # status (Optional)
  #     # 設定内容: フィルターグループの有効状態を指定します。
  #     # 設定可能な値: "ENABLED", "DISABLED"
  #     # 省略時: "ENABLED"
  #     status = "ENABLED"
  #
  #     scope_configuration {
  #       selected_sheets {
  #         sheet_visual_scoping_configurations {
  #           # scope (Required)
  #           # 設定内容: ビジュアルのスコープを指定します。
  #           # 設定可能な値: "ALL_VISUALS", "SELECTED_VISUALS", "SELECTED_SHEETS"
  #           scope = "ALL_VISUALS"
  #
  #           # sheet_id (Required)
  #           # 設定内容: フィルターを適用するシートのIDを指定します。
  #           sheet_id = "sheet-1"
  #
  #           # visual_ids (Optional)
  #           # 設定内容: フィルターを適用するビジュアルIDのセットを指定します。
  #           # 省略時: scope が ALL_VISUALS の場合は全ビジュアルに適用
  #           visual_ids = []
  #         }
  #       }
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # パラメータ宣言設定
  #   #---------------------------------------------------------
  #
  #   # parameter_declarations (Optional)
  #   # 設定内容: ダッシュボードのパラメータ宣言ブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ParameterDeclaration.html
  #   parameter_declarations {
  #     string_parameter_declaration {
  #       # name (Required)
  #       # 設定内容: パラメータ名を指定します。
  #       name = "StringParam"
  #
  #       # parameter_value_type (Required)
  #       # 設定内容: パラメータ値のタイプを指定します。
  #       # 設定可能な値: "SINGLE_VALUED", "MULTI_VALUED"
  #       parameter_value_type = "SINGLE_VALUED"
  #     }
  #   }
  #
  #   #---------------------------------------------------------
  #   # シート設定
  #   #---------------------------------------------------------
  #
  #   # sheets (Optional)
  #   # 設定内容: ダッシュボードのシート定義ブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_SheetDefinition.html
  #   sheets {
  #
  #     # sheet_id (Required)
  #     # 設定内容: シートの一意な識別子を指定します。
  #     # 設定可能な値: 文字列
  #     sheet_id = "sheet-1"
  #
  #     # title (Optional)
  #     # 設定内容: シートのタイトルを指定します。
  #     # 設定可能な値: 文字列
  #     title = "Main Sheet"
  #
  #     # name (Optional)
  #     # 設定内容: シートの名前を指定します。
  #     # 設定可能な値: 文字列
  #     name = "Sheet1"
  #
  #     # description (Optional)
  #     # 設定内容: シートの説明を指定します。
  #     # 設定可能な値: 文字列
  #     description = "メインダッシュボードシート"
  #
  #     # content_type (Optional)
  #     # 設定内容: シートのコンテンツタイプを指定します。
  #     # 設定可能な値: "INTERACTIVE", "PAGINATED"
  #     content_type = "INTERACTIVE"
  #   }
  #
  #   #---------------------------------------------------------
  #   # 分析デフォルト設定
  #   #---------------------------------------------------------
  #
  #   # analysis_defaults (Optional)
  #   # 設定内容: デフォルト分析設定のブロックです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefaults.html
  #   analysis_defaults {
  #     default_new_sheet_configuration {
  #       # sheet_content_type (Optional)
  #       # 設定内容: 新規シートのデフォルトコンテンツタイプを指定します。
  #       # 設定可能な値: "INTERACTIVE", "PAGINATED"
  #       sheet_content_type = "INTERACTIVE"
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # ダッシュボード公開オプション設定
  #-------------------------------------------------------------

  # dashboard_publish_options (Optional)
  # 設定内容: ダッシュボードの公開オプションを設定するブロックです。
  # 各種インタラクション機能の有効・無効を制御します。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DashboardPublishOptions.html
  dashboard_publish_options {

    # ad_hoc_filtering_option (Optional)
    # 設定内容: アドホック（都度）フィルタリングオプションを設定するブロックです。
    ad_hoc_filtering_option {

      # availability_status (Optional)
      # 設定内容: アドホックフィルタリング機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # data_point_drill_up_down_option (Optional)
    # 設定内容: データポイントのドリルアップ・ドリルダウンオプションを設定するブロックです。
    data_point_drill_up_down_option {

      # availability_status (Optional)
      # 設定内容: ドリルアップ・ドリルダウン機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # data_point_menu_label_option (Optional)
    # 設定内容: データポイントのメニューラベルオプションを設定するブロックです。
    data_point_menu_label_option {

      # availability_status (Optional)
      # 設定内容: データポイントメニューラベル機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # data_point_tooltip_option (Optional)
    # 設定内容: データポイントのツールチップオプションを設定するブロックです。
    data_point_tooltip_option {

      # availability_status (Optional)
      # 設定内容: データポイントツールチップ機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # export_to_csv_option (Optional)
    # 設定内容: CSVエクスポートオプションを設定するブロックです。
    export_to_csv_option {

      # availability_status (Optional)
      # 設定内容: CSVエクスポート機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # export_with_hidden_fields_option (Optional)
    # 設定内容: 非表示フィールドを含むエクスポートオプションを設定するブロックです。
    export_with_hidden_fields_option {

      # availability_status (Optional)
      # 設定内容: 非表示フィールド付きエクスポート機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "DISABLED"
      availability_status = "DISABLED"
    }

    # sheet_controls_option (Optional)
    # 設定内容: シートコントロールの表示オプションを設定するブロックです。
    sheet_controls_option {

      # visibility_state (Optional)
      # 設定内容: シートコントロールパネルの表示状態を指定します。
      # 設定可能な値: "EXPANDED", "COLLAPSED"
      # 省略時: "COLLAPSED"
      visibility_state = "EXPANDED"
    }

    # sheet_layout_element_maximization_option (Optional)
    # 設定内容: シートレイアウト要素の最大化オプションを設定するブロックです。
    sheet_layout_element_maximization_option {

      # availability_status (Optional)
      # 設定内容: シートレイアウト要素の最大化機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # visual_axis_sort_option (Optional)
    # 設定内容: ビジュアルの軸ソートオプションを設定するブロックです。
    visual_axis_sort_option {

      # availability_status (Optional)
      # 設定内容: 軸ソート機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }

    # visual_menu_option (Optional)
    # 設定内容: ビジュアルのメニューオプションを設定するブロックです。
    visual_menu_option {

      # availability_status (Optional)
      # 設定内容: ビジュアルメニュー機能の有効状態を指定します。
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: "ENABLED"
      availability_status = "ENABLED"
    }
  }

  #-------------------------------------------------------------
  # パラメータ設定（ダッシュボード作成時のデフォルト値オーバーライド）
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: ダッシュボード作成時にデフォルト設定をオーバーライドするパラメータのブロックです。
  # 各パラメータタイプは最大100件まで指定可能です。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_Parameters.html
  parameters {

    # date_time_parameters (Optional, 最大100件)
    # 設定内容: 日時型パラメータの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DateTimeParameter.html
    date_time_parameters {

      # name (Required)
      # 設定内容: パラメータ名を指定します。
      # 設定可能な値: 文字列
      name = "DateParam"

      # values (Required)
      # 設定内容: 日時型パラメータの値リストを指定します。
      # 設定可能な値: ISO 8601形式の日時文字列のリスト
      values = ["2024-01-01T00:00:00Z"]
    }

    # decimal_parameters (Optional, 最大100件)
    # 設定内容: 小数型パラメータの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DecimalParameter.html
    decimal_parameters {

      # name (Required)
      # 設定内容: パラメータ名を指定します。
      # 設定可能な値: 文字列
      name = "DecimalParam"

      # values (Required)
      # 設定内容: 小数型パラメータの値リストを指定します。
      # 設定可能な値: 数値のリスト
      values = [1.5]
    }

    # integer_parameters (Optional, 最大100件)
    # 設定内容: 整数型パラメータの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_IntegerParameter.html
    integer_parameters {

      # name (Required)
      # 設定内容: パラメータ名を指定します。
      # 設定可能な値: 文字列
      name = "IntParam"

      # values (Required)
      # 設定内容: 整数型パラメータの値リストを指定します。
      # 設定可能な値: 整数のリスト
      values = [10]
    }

    # string_parameters (Optional, 最大100件)
    # 設定内容: 文字列型パラメータの設定ブロックです。
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_StringParameter.html
    string_parameters {

      # name (Required)
      # 設定内容: パラメータ名を指定します。
      # 設定可能な値: 文字列
      name = "StringParam"

      # values (Required)
      # 設定内容: 文字列型パラメータの値リストを指定します。
      # 設定可能な値: 文字列のリスト
      values = ["value1"]
    }
  }

  #-------------------------------------------------------------
  # アクセス権限設定
  #-------------------------------------------------------------

  # permissions (Optional, 最大64件)
  # 設定内容: ダッシュボードへのアクセス権限を設定するブロックです。
  # ユーザーやグループにIAMアクションを付与または取り消します。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  permissions {

    # actions (Required)
    # 設定内容: 付与または取り消すIAMアクションのセットを指定します。
    # 設定可能な値: QuickSightのIAMアクション文字列のセット
    #   閲覧者: ["quicksight:DescribeDashboard", "quicksight:ListDashboardVersions",
    #            "quicksight:UpdateDashboardPermissions", "quicksight:QueryDashboard",
    #            "quicksight:UpdateDashboard", "quicksight:DeleteDashboard",
    #            "quicksight:DescribeDashboardPermissions", "quicksight:UpdateDashboardPublishedVersion"]
    actions = [
      "quicksight:DescribeDashboard",
      "quicksight:ListDashboardVersions",
      "quicksight:QueryDashboard",
    ]

    # principal (Required)
    # 設定内容: 権限を付与するプリンシパルのARNを指定します。
    # 設定可能な値: QuickSightユーザーまたはグループのARN
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/example-user"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルト値を使用
    create = "5m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルト値を使用
    update = "5m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" 等のGo duration形式の文字列
    # 省略時: プロバイダーのデフォルト値を使用
    delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ダッシュボードのAmazon Resource Name (ARN)
# - created_time: ダッシュボードが作成された日時
# - id: AWSアカウントIDとダッシュボードIDをカンマ区切りで結合した文字列
# - last_published_time: ダッシュボードが最後に公開された日時
# - last_updated_time: ダッシュボードが最後に更新された日時
# - source_entity_arn: ダッシュボード作成に使用されたテンプレートのARN
# - status: ダッシュボードの作成ステータス
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む全タグのマップ
# - version_number: ダッシュボードバージョンのバージョン番号
#---------------------------------------------------------------
