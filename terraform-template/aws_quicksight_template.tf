#---------------------------------------------------------------
# Amazon QuickSight Template
#---------------------------------------------------------------
#
# Amazon QuickSightのテンプレートを管理するリソースです。
# テンプレートは、分析やダッシュボードの作成に使用できるメタデータと
# ビジュアル設定を含むエンティティです。データセットのプレースホルダーを
# 使用することで、同じスキーマを持つ異なるデータセットで再利用可能な
# ダッシュボードや分析を作成できます。
#
# AWS公式ドキュメント:
#   - CreateTemplate API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateTemplate.html
#   - UpdateTemplate: https://docs.aws.amazon.com/quicksight/latest/developerguide/update-template.html
#   - TemplateVersionDefinition: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_TemplateVersionDefinition.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_template
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_template" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # template_id (Required)
  # 設定内容: テンプレートの一意な識別子を指定します。
  # 設定可能な値: 1〜512文字の英数字、ハイフン、アンダースコア
  # 注意: リソース作成後の変更はできません（Forces new resource）
  template_id = "example-template"

  # name (Required)
  # 設定内容: テンプレートの表示名を指定します。
  # 設定可能な値: 1〜2048文字の文字列
  # 用途: QuickSightコンソールや一覧で表示される名前
  name = "Example Dashboard Template"

  # version_description (Required)
  # 設定内容: 作成または更新されるテンプレートバージョンの説明を指定します。
  # 設定可能な値: 1〜512文字の文字列
  # 用途: バージョン管理やリリースノートとして使用
  # 推奨: 変更内容を明確に記載（例: "Initial version", "Added new filters"）
  version_description = "Initial version with basic dashboard layout"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional)
  # 設定内容: テンプレートを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraformで使用中のアWSアカウントIDを自動的に使用
  # 注意: リソース作成後の変更はできません（Forces new resource）
  aws_account_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-template"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # ソースエンティティ設定（既存のアセットからテンプレートを作成）
  #-------------------------------------------------------------

  # source_entity (Optional)
  # 設定内容: テンプレートを作成する際のソース（分析または別のテンプレート）を指定します。
  # 注意: definitionとsource_entityのいずれか一方のみを設定してください
  # 用途: 既存の分析やテンプレートからテンプレートを作成する場合に使用
  source_entity {
    #-----------------------------------------------------------
    # ソーステンプレート（別のテンプレートをベースにする場合）
    #-----------------------------------------------------------
    # source_template (Optional)
    # 設定内容: ソースとなるテンプレートを指定します。
    # 注意: source_analysisとsource_templateのいずれか一方のみを指定
    source_template {
      # arn (Required)
      # 設定内容: ソーステンプレートのARNを指定します。
      # 形式: arn:aws:quicksight:region:account-id:template/template-id
      arn = "arn:aws:quicksight:us-east-1:123456789012:template/source-template-id"
    }

    #-----------------------------------------------------------
    # ソース分析（分析をベースにする場合）
    #-----------------------------------------------------------
    # source_analysis (Optional)
    # 設定内容: ソースとなる分析を指定します。
    # 注意: source_analysisとsource_templateのいずれか一方のみを指定
    # 用途: QuickSightの分析からテンプレートを作成する際に使用
    # source_analysis {
    #   # arn (Required)
    #   # 設定内容: ソース分析のARNを指定します。
    #   # 形式: arn:aws:quicksight:region:account-id:analysis/analysis-id
    #   arn = "arn:aws:quicksight:us-east-1:123456789012:analysis/source-analysis-id"
    #
    #   # data_set_references (Required)
    #   # 設定内容: テンプレート内でプレースホルダーとして使用されるデータセット参照のリストです。
    #   # 用途: ソース分析で使用されているデータセットをプレースホルダーに置き換える
    #   data_set_references {
    #     # data_set_arn (Required)
    #     # 設定内容: データセットのARNを指定します。
    #     # 形式: arn:aws:quicksight:region:account-id:dataset/dataset-id
    #     data_set_arn = "arn:aws:quicksight:us-east-1:123456789012:dataset/example-dataset"
    #
    #     # data_set_placeholder (Required)
    #     # 設定内容: データセットのプレースホルダー文字列を指定します。
    #     # 用途: テンプレート内でデータセットを参照する際の識別子
    #     # 推奨: 意味のある名前を使用（例: "1", "sales_data", "dataset_placeholder"）
    #     data_set_placeholder = "1"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # テンプレート定義（詳細な構造を定義する場合）
  #-------------------------------------------------------------

  # definition (Optional)
  # 設定内容: テンプレートの詳細な定義を指定します。
  # 注意: definitionとsource_entityのいずれか一方のみを設定してください
  # 用途: シート、ビジュアル、フィルター、パラメーターなどを直接定義する場合に使用
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_TemplateVersionDefinition.html
  #
  # definition {
  #   #-----------------------------------------------------------
  #   # データセット設定
  #   #-----------------------------------------------------------
  #   # data_set_configuration (Required)
  #   # 設定内容: テンプレート内で使用される各データセットの必須列を定義する設定のリストです。
  #   # 最大項目数: 30
  #   # 用途: データセットのスキーマと列グループを定義
  #   data_set_configuration {
  #     # placeholder (Optional)
  #     # 設定内容: データセットのプレースホルダー識別子を指定します。
  #     # 用途: テンプレート内でデータセットを参照する際の識別子
  #     placeholder = "1"
  #
  #     # data_set_schema (Optional)
  #     # 設定内容: データセットのスキーマを定義します。
  #     data_set_schema {
  #       # column_schema_list (Optional)
  #       # 設定内容: データセット内の列のスキーマを定義するリストです。
  #       # 最大項目数: 500
  #       column_schema_list {
  #         # name (Optional)
  #         # 設定内容: 列の名前を指定します。
  #         name = "Column1"
  #
  #         # data_type (Optional)
  #         # 設定内容: 列のデータ型を指定します。
  #         # 設定可能な値: "STRING", "INTEGER", "DECIMAL", "DATETIME"
  #         data_type = "STRING"
  #
  #         # geographic_role (Optional)
  #         # 設定内容: 地理的データの役割を指定します。
  #         # 設定可能な値: "COUNTRY", "STATE", "COUNTY", "CITY", "POSTCODE", "LONGITUDE", "LATITUDE"
  #         # geographic_role = "COUNTRY"
  #       }
  #
  #       column_schema_list {
  #         name      = "Column2"
  #         data_type = "INTEGER"
  #       }
  #     }
  #
  #     # column_group_schema_list (Optional)
  #     # 設定内容: 列グループのスキーマを定義するリストです。
  #     # 最大項目数: 500
  #     # column_group_schema_list {
  #     #   # name (Optional)
  #     #   # 設定内容: 列グループの名前を指定します。
  #     #   name = "GeoSpatialColumnGroup"
  #     #
  #     #   # column_group_column_schema_list (Optional)
  #     #   # 設定内容: 列グループ内の列のリストです。
  #     #   # 最大項目数: 500
  #     #   column_group_column_schema_list {
  #     #     name = "City"
  #     #   }
  #     #   column_group_column_schema_list {
  #     #     name = "State"
  #     #   }
  #     # }
  #   }
  #
  #   #-----------------------------------------------------------
  #   # シート設定
  #   #-----------------------------------------------------------
  #   # sheets (Optional)
  #   # 設定内容: テンプレートのシート定義のリストです。
  #   # 用途: ダッシュボード内の各シート（ページ）とそのビジュアルを定義
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_SheetDefinition.html
  #   sheets {
  #     # sheet_id (Required)
  #     # 設定内容: シートの一意な識別子を指定します。
  #     # 設定可能な値: 1〜512文字の英数字、ハイフン、アンダースコア
  #     sheet_id = "Sheet1"
  #
  #     # title (Optional)
  #     # 設定内容: シートのタイトルを指定します。
  #     # 設定可能な値: 1〜1024文字の文字列
  #     title = "Sales Dashboard"
  #
  #     # description (Optional)
  #     # 設定内容: シートの説明を指定します。
  #     # description = "Monthly sales analysis by region"
  #
  #     # visuals (Optional)
  #     # 設定内容: シートに含まれるビジュアルのリストです。
  #     # 用途: 棒グラフ、円グラフ、テーブルなどのビジュアルを定義
  #     visuals {
  #       # bar_chart_visual (Optional)
  #       # 設定内容: 棒グラフビジュアルを定義します。
  #       # 注意: 一つのvisualsブロック内では一つのビジュアルタイプのみ指定
  #       bar_chart_visual {
  #         # visual_id (Required)
  #         # 設定内容: ビジュアルの一意な識別子を指定します。
  #         visual_id = "BarChart1"
  #
  #         # title (Optional)
  #         # 設定内容: ビジュアルのタイトルを定義します。
  #         # title {
  #         #   visibility = "VISIBLE"
  #         #   format_text {
  #         #     plain_text = "Sales by Category"
  #         #   }
  #         # }
  #
  #         # chart_configuration (Optional)
  #         # 設定内容: 棒グラフの設定を定義します。
  #         chart_configuration {
  #           # field_wells (Optional)
  #           # 設定内容: フィールドウェルの設定を定義します。
  #           # 用途: ビジュアルに表示するデータフィールドを指定
  #           field_wells {
  #             # bar_chart_aggregated_field_wells (Optional)
  #             # 設定内容: 集計済み棒グラフのフィールドウェルを定義します。
  #             bar_chart_aggregated_field_wells {
  #               # category (Optional)
  #               # 設定内容: カテゴリ（X軸）のディメンションフィールドを定義します。
  #               # 最大項目数: 200
  #               category {
  #                 # categorical_dimension_field (Optional)
  #                 # 設定内容: カテゴリカルディメンションフィールドを定義します。
  #                 categorical_dimension_field {
  #                   # field_id (Required)
  #                   # 設定内容: フィールドの一意な識別子を指定します。
  #                   field_id = "CategoryField"
  #
  #                   # column (Required)
  #                   # 設定内容: データソースの列を指定します。
  #                   column {
  #                     # column_name (Required)
  #                     # 設定内容: 列の名前を指定します。
  #                     column_name = "Column1"
  #
  #                     # data_set_identifier (Required)
  #                     # 設定内容: データセットの識別子を指定します。
  #                     data_set_identifier = "1"
  #                   }
  #                 }
  #               }
  #
  #               # values (Optional)
  #               # 設定内容: 値（Y軸）のメジャーフィールドを定義します。
  #               # 最大項目数: 200
  #               values {
  #                 # numerical_measure_field (Optional)
  #                 # 設定内容: 数値メジャーフィールドを定義します。
  #                 numerical_measure_field {
  #                   # field_id (Required)
  #                   # 設定内容: フィールドの一意な識別子を指定します。
  #                   field_id = "ValueField"
  #
  #                   # column (Required)
  #                   # 設定内容: データソースの列を指定します。
  #                   column {
  #                     column_name         = "Column2"
  #                     data_set_identifier = "1"
  #                   }
  #
  #                   # aggregation_function (Optional)
  #                   # 設定内容: 集計関数を指定します。
  #                   aggregation_function {
  #                     # simple_numerical_aggregation (Optional)
  #                     # 設定内容: シンプルな数値集計関数を指定します。
  #                     # 設定可能な値: "SUM", "AVERAGE", "MIN", "MAX", "COUNT", "DISTINCT_COUNT", "MEDIAN", "STDEV", "STDEVP", "VAR", "VARP"
  #                     simple_numerical_aggregation = "SUM"
  #                   }
  #                 }
  #               }
  #             }
  #           }
  #
  #           # orientation (Optional)
  #           # 設定内容: グラフの向きを指定します。
  #           # 設定可能な値: "HORIZONTAL", "VERTICAL"
  #           # orientation = "VERTICAL"
  #
  #           # legend (Optional)
  #           # 設定内容: 凡例の設定を定義します。
  #           # legend {
  #           #   visibility = "VISIBLE"
  #           #   position   = "RIGHT"
  #           # }
  #         }
  #
  #         # actions (Optional)
  #         # 設定内容: ビジュアルに関連付けられたアクションを定義します。
  #         # 最大項目数: 10
  #         # 用途: ドリルダウン、フィルターアクション、URLアクションなどを設定
  #         # actions {
  #         #   action_id = "DrillDownAction1"
  #         #   # ... アクション定義
  #         # }
  #       }
  #     }
  #
  #     # layouts (Optional)
  #     # 設定内容: シートのレイアウト設定を定義します。
  #     # layouts {
  #     #   # ... レイアウト定義
  #     # }
  #
  #     # filter_controls (Optional)
  #     # 設定内容: シートに表示するフィルターコントロールを定義します。
  #     # filter_controls {
  #     #   # ... フィルターコントロール定義
  #     # }
  #   }
  #
  #   #-----------------------------------------------------------
  #   # 計算フィールド設定
  #   #-----------------------------------------------------------
  #   # calculated_fields (Optional)
  #   # 設定内容: テンプレートレベルの計算フィールド定義のリストです。
  #   # 最大項目数: 500
  #   # 用途: データセットに存在しない計算値を定義
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CalculatedField.html
  #   # calculated_fields {
  #   #   # name (Required)
  #   #   # 設定内容: 計算フィールドの名前を指定します。
  #   #   name = "ProfitMargin"
  #   #
  #   #   # data_set_identifier (Required)
  #   #   # 設定内容: データセットの識別子を指定します。
  #   #   data_set_identifier = "1"
  #   #
  #   #   # expression (Required)
  #   #   # 設定内容: 計算式を指定します。
  #   #   # 例: QuickSight計算式構文を使用
  #   #   expression = "(Revenue - Cost) / Revenue * 100"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # 列設定
  #   #-----------------------------------------------------------
  #   # column_configurations (Optional)
  #   # 設定内容: テンプレートレベルの列設定のリストです。
  #   # 最大項目数: 2000
  #   # 用途: 列のデフォルトフォーマットを設定
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ColumnConfiguration.html
  #   # column_configurations {
  #   #   # column (Required)
  #   #   # 設定内容: 設定対象の列を指定します。
  #   #   column {
  #   #     column_name         = "Revenue"
  #   #     data_set_identifier = "1"
  #   #   }
  #   #
  #   #   # format_configuration (Optional)
  #   #   # 設定内容: 列のフォーマット設定を定義します。
  #   #   # 用途: 数値、日付、文字列などのフォーマットを指定
  #   #   format_configuration {
  #   #     number_format_configuration {
  #   #       format_configuration {
  #   #         number_display_format_configuration {
  #   #           prefix            = "$"
  #   #           decimal_places    = 2
  #   #           thousands_separator = "COMMA"
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # フィルターグループ設定
  #   #-----------------------------------------------------------
  #   # filter_groups (Optional)
  #   # 設定内容: テンプレートのフィルター定義のリストです。
  #   # 最大項目数: 2000
  #   # 用途: データのフィルタリングルールを定義
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_FilterGroup.html
  #   # filter_groups {
  #   #   # filter_group_id (Required)
  #   #   # 設定内容: フィルターグループの一意な識別子を指定します。
  #   #   filter_group_id = "FilterGroup1"
  #   #
  #   #   # filters (Required)
  #   #   # 設定内容: フィルターのリストを定義します。
  #   #   # 最大項目数: 20
  #   #   filters {
  #   #     # ... フィルター定義
  #   #   }
  #   #
  #   #   # scope_configuration (Required)
  #   #   # 設定内容: フィルターのスコープ設定を定義します。
  #   #   scope_configuration {
  #   #     # ... スコープ定義
  #   #   }
  #   #
  #   #   # cross_dataset (Required)
  #   #   # 設定内容: クロスデータセットフィルターかどうかを指定します。
  #   #   # 設定可能な値: "ALL_DATASETS", "SINGLE_DATASET"
  #   #   cross_dataset = "SINGLE_DATASET"
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # パラメーター宣言設定
  #   #-----------------------------------------------------------
  #   # parameters_declarations (Optional)
  #   # 設定内容: テンプレートのパラメーター宣言のリストです。
  #   # 最大項目数: 200
  #   # 用途: テンプレート内で使用できる動的パラメーターを定義
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/user/parameters-in-quicksight.html
  #   # parameters_declarations {
  #   #   # string_parameter_declaration (Optional)
  #   #   # 設定内容: 文字列パラメーターを宣言します。
  #   #   # 注意: string、integer、datetime、decimalのいずれか一つを指定
  #   #   string_parameter_declaration {
  #   #     # name (Required)
  #   #     # 設定内容: パラメーター名を指定します。
  #   #     name = "RegionFilter"
  #   #
  #   #     # parameter_value_type (Required)
  #   #     # 設定内容: パラメーター値のタイプを指定します。
  #   #     # 設定可能な値: "MULTI_VALUED", "SINGLE_VALUED"
  #   #     parameter_value_type = "SINGLE_VALUED"
  #   #
  #   #     # default_values (Optional)
  #   #     # 設定内容: デフォルト値を定義します。
  #   #     default_values {
  #   #       static_values = ["us-east-1"]
  #   #     }
  #   #   }
  #   # }
  #
  #   #-----------------------------------------------------------
  #   # 分析デフォルト設定
  #   #-----------------------------------------------------------
  #   # analysis_defaults (Optional)
  #   # 設定内容: デフォルトの分析設定を定義します。
  #   # 用途: 新規シートのデフォルトレイアウトなどを設定
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefaults.html
  #   # analysis_defaults {
  #   #   # default_new_sheet_configuration (Required)
  #   #   # 設定内容: 新規シートのデフォルト設定を定義します。
  #   #   default_new_sheet_configuration {
  #   #     # interactive_layout_configuration (Optional)
  #   #     # 設定内容: インタラクティブレイアウトの設定を定義します。
  #   #     interactive_layout_configuration {
  #   #       grid {
  #   #         canvas_size_options {
  #   #           screen_canvas_size_options {
  #   #             resize_option = "RESPONSIVE"
  #   #           }
  #   #         }
  #   #       }
  #   #     }
  #   #
  #   #     # sheet_content_type (Optional)
  #   #     # 設定内容: シートのコンテンツタイプを指定します。
  #   #     # 設定可能な値: "PAGINATED", "INTERACTIVE"
  #   #     sheet_content_type = "INTERACTIVE"
  #   #   }
  #   # }
  # }

  #-------------------------------------------------------------
  # アクセス許可設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: テンプレートのリソース許可を設定します。
  # 最大項目数: 64
  # 用途: 他のユーザーやグループにテンプレートへのアクセスを付与
  permissions {
    # actions (Required)
    # 設定内容: 付与または取り消すIAMアクションのリストを指定します。
    # 設定可能な値:
    #   - "quicksight:DescribeTemplate": テンプレートの詳細を表示
    #   - "quicksight:DescribeTemplateAlias": テンプレートエイリアスの詳細を表示
    #   - "quicksight:ListTemplateVersions": テンプレートバージョン一覧を表示
    #   - "quicksight:UpdateTemplate": テンプレートを更新
    #   - "quicksight:DeleteTemplate": テンプレートを削除
    #   - "quicksight:UpdateTemplatePermissions": テンプレートの許可を更新
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    actions = [
      "quicksight:DescribeTemplate",
      "quicksight:ListTemplateVersions"
    ]

    # principal (Required)
    # 設定内容: プリンシパルのARNを指定します。
    # 設定可能な値:
    #   - ユーザーARN: arn:aws:quicksight:region:account-id:user/namespace/user-name
    #   - グループARN: arn:aws:quicksight:region:account-id:group/namespace/group-name
    # 用途: テンプレートへのアクセスを付与するユーザーまたはグループを指定
    principal = "arn:aws:quicksight:us-east-1:123456789012:user/default/example-user"
  }

  # 追加の許可を設定する場合は、複数のpermissionsブロックを追加できます
  # permissions {
  #   actions = [
  #     "quicksight:DescribeTemplate",
  #     "quicksight:UpdateTemplate",
  #   ]
  #   principal = "arn:aws:quicksight:us-east-1:123456789012:group/default/admin-group"
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定します。
  # 用途: 作成、更新、削除操作の最大待機時間を指定
  # timeouts {
  #   # create (Optional)
  #   # 設定内容: テンプレート作成操作のタイムアウト時間を指定します。
  #   # 形式: 時間文字列（例: "5m", "1h", "30s"）
  #   # デフォルト: 5m
  #   create = "10m"
  #
  #   # update (Optional)
  #   # 設定内容: テンプレート更新操作のタイムアウト時間を指定します。
  #   # 形式: 時間文字列（例: "5m", "1h", "30s"）
  #   # デフォルト: 5m
  #   update = "10m"
  #
  #   # delete (Optional)
  #   # 設定内容: テンプレート削除操作のタイムアウト時間を指定します。
  #   # 形式: 時間文字列（例: "5m", "1h", "30s"）
  #   # デフォルト: 5m
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: テンプレートのAmazon Resource Name (ARN)
#        形式: arn:aws:quicksight:region:account-id:template/template-id
#
# - created_time: テンプレートが作成された時刻（RFC3339形式）
#
# - id: テンプレートの識別子
#      形式: account-id,template-id（カンマ区切り）
#
# - last_updated_time: テンプレートが最後に更新された時刻（RFC3339形式）
#
# - source_entity_arn: このテンプレートの作成に使用された分析または
#                      テンプレートのAmazon Resource Name (ARN)
#
# - status: テンプレートの作成ステータス
#          設定可能な値: "CREATION_IN_PROGRESS", "CREATION_SUCCESSFUL",
#                        "CREATION_FAILED", "UPDATE_IN_PROGRESS",
#                        "UPDATE_SUCCESSFUL", "UPDATE_FAILED", "DELETED"
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
