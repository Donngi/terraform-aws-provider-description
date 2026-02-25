#---------------------------------------------------------------
# AWS QuickSight Analysis
#---------------------------------------------------------------
#
# Amazon QuickSight の分析（Analysis）をプロビジョニングするリソースです。
# 分析はデータセットを使用してビジュアライゼーションやインサイトを作成する
# QuickSight のワークスペースです。テンプレートから作成する方法と、
# definition ブロックで直接定義する方法の2種類があります。
#
# AWS公式ドキュメント:
#   - Amazon QuickSight 分析の操作: https://docs.aws.amazon.com/quicksight/latest/user/working-with-analyses.html
#   - CreateAnalysis API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAnalysis.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/quicksight_analysis
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_analysis" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # analysis_id (Required, Forces new resource)
  # 設定内容: 分析の一意の識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを含む文字列
  analysis_id = "example-analysis-id"

  # name (Required)
  # 設定内容: 分析の表示名を指定します。
  # 設定可能な値: 1-2048文字の文字列
  name = "example-analysis"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: 分析を作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーが自動的に判別したアカウントIDを使用
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
  # 設定内容: 分析に適用するテーマのARNを指定します。
  # 設定可能な値: QuickSight テーマのARN（分析と同一AWSアカウント内のテーマ）
  # 省略時: デフォルトテーマが適用されます。
  theme_arn = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # recovery_window_in_days (Optional)
  # 設定内容: 分析を削除する前にQuickSightが待機する日数を指定します。
  # 設定可能な値: 0（即時削除）、7〜30の整数
  # 省略時: 30（30日間の回復ウィンドウが設定されます）
  # 注意: 0を指定すると回復なしで強制削除されます。
  recovery_window_in_days = 30

  #-------------------------------------------------------------
  # ソースエンティティ設定
  # ※ definition と source_entity はどちらか一方のみ指定可能
  #-------------------------------------------------------------

  # source_entity (Optional)
  # 設定内容: 分析の作成元となるソーステンプレートを指定します。
  # 設定可能な値: source_template ブロックを含む設定
  # 注意: definition と排他的（どちらか一方のみ指定可能）
  source_entity {
    # source_template (Optional)
    # 設定内容: ソースとなるQuickSight テンプレートの情報を指定します。
    source_template {
      # arn (Required)
      # 設定内容: ソーステンプレートのARNを指定します。
      # 設定可能な値: QuickSight テンプレートのARN
      arn = "arn:aws:quicksight:ap-northeast-1:123456789012:template/example-template"

      # data_set_references (Required)
      # 設定内容: テンプレートのプレースホルダーと実際のデータセットのマッピングを指定します。
      # 注意: 最低1件以上指定が必要です。
      data_set_references {
        # data_set_arn (Required)
        # 設定内容: データセットのARNを指定します。
        # 設定可能な値: QuickSight データセットのARN
        data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset"

        # data_set_placeholder (Required)
        # 設定内容: テンプレート内のデータセットプレースホルダー名を指定します。
        # 設定可能な値: テンプレートで定義されたプレースホルダー文字列
        data_set_placeholder = "1"
      }
    }
  }

  #-------------------------------------------------------------
  # 分析定義設定
  # ※ definition と source_entity はどちらか一方のみ指定可能
  #-------------------------------------------------------------

  # definition (Optional)
  # 設定内容: 分析の詳細な定義をコードで直接記述します。
  # 注意: source_entity と排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefinition.html
  # definition {
  #   #-------------------------------------------------------------
  #   # データセット識別子設定
  #   #-------------------------------------------------------------
  #
  #   # data_set_identifiers_declarations (Required)
  #   # 設定内容: データセット識別子の宣言リストを指定します。
  #   #           ARNの代わりに識別子を使用してデータセットを参照できます。
  #   # 設定可能な値: 最大50件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DataSetIdentifierDeclaration.html
  #   data_set_identifiers_declarations {
  #     # data_set_arn (Optional)
  #     # 設定内容: データセットのARNを指定します。
  #     data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset"
  #
  #     # identifier (Optional)
  #     # 設定内容: データセットの識別子を指定します。
  #     # 設定可能な値: 分析内で一意の文字列
  #     identifier = "1"
  #   }
  #
  #   #-------------------------------------------------------------
  #   # 分析デフォルト設定
  #   #-------------------------------------------------------------
  #
  #   # analysis_defaults (Optional)
  #   # 設定内容: 新しいシートのデフォルト設定を指定します。
  #   # 設定可能な値: 最大1件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefaults.html
  #   analysis_defaults {
  #     # default_new_sheet_configuration (Required)
  #     # 設定内容: 新規シートのデフォルトレイアウト設定を指定します。
  #     default_new_sheet_configuration {
  #       # sheet_content_type (Optional)
  #       # 設定内容: シートのコンテンツタイプを指定します。
  #       # 設定可能な値:
  #       #   - "INTERACTIVE": インタラクティブシート
  #       #   - "PAGINATED": ページ分割シート（レポート向け）
  #       sheet_content_type = "INTERACTIVE"
  #
  #       # interactive_layout_configuration (Optional)
  #       # 設定内容: インタラクティブシートのレイアウト設定を指定します。
  #       interactive_layout_configuration {
  #         # free_form (Optional)
  #         # 設定内容: フリーフォームレイアウトの設定を指定します。
  #         free_form {
  #           canvas_size_options {
  #             screen_canvas_size_options {
  #               # optimized_view_port_width (Required)
  #               # 設定内容: 最適化されたビューポートの幅をピクセル単位で指定します。
  #               optimized_view_port_width = "1600px"
  #             }
  #           }
  #         }
  #
  #         # grid (Optional)
  #         # 設定内容: グリッドレイアウトの設定を指定します。
  #         grid {
  #           canvas_size_options {
  #             screen_canvas_size_options {
  #               # resize_option (Required)
  #               # 設定内容: リサイズオプションを指定します。
  #               # 設定可能な値: "FIXED", "RESPONSIVE"
  #               resize_option = "FIXED"
  #
  #               # optimized_view_port_width (Optional)
  #               # 設定内容: 最適化されたビューポートの幅をピクセル単位で指定します。
  #               optimized_view_port_width = "1600px"
  #             }
  #           }
  #         }
  #       }
  #
  #       # paginated_layout_configuration (Optional)
  #       # 設定内容: ページ分割レイアウト（レポート）の設定を指定します。
  #       paginated_layout_configuration {
  #         section_based {
  #           canvas_size_options {
  #             paper_canvas_size_options {
  #               # paper_size (Optional)
  #               # 設定内容: 用紙サイズを指定します。
  #               # 設定可能な値: "US_LETTER", "US_LEGAL", "US_TABLOID_LEDGER",
  #               #   "A0", "A1", "A2", "A3", "A4", "A5", "JIS_B4", "JIS_B5"
  #               paper_size = "A4"
  #
  #               # paper_orientation (Optional)
  #               # 設定内容: 用紙の向きを指定します。
  #               # 設定可能な値: "PORTRAIT"（縦）, "LANDSCAPE"（横）
  #               paper_orientation = "PORTRAIT"
  #
  #               paper_margin {
  #                 top    = "0.5in"
  #                 bottom = "0.5in"
  #                 left   = "0.5in"
  #                 right  = "0.5in"
  #               }
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  #
  #   #-------------------------------------------------------------
  #   # 計算フィールド設定
  #   #-------------------------------------------------------------
  #
  #   # calculated_fields (Optional)
  #   # 設定内容: 分析の計算フィールド定義リストを指定します。
  #   # 設定可能な値: 最大500件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CalculatedField.html
  #   calculated_fields {
  #     # data_set_identifier (Required)
  #     # 設定内容: 計算フィールドが属するデータセットの識別子を指定します。
  #     data_set_identifier = "1"
  #
  #     # name (Required)
  #     # 設定内容: 計算フィールドの名前を指定します。
  #     name = "calculated_field_name"
  #
  #     # expression (Required)
  #     # 設定内容: 計算フィールドの式を指定します。
  #     # 設定可能な値: QuickSight 計算式文字列（最大32000文字）
  #     expression = "sum({column_name})"
  #   }
  #
  #   #-------------------------------------------------------------
  #   # 列設定
  #   #-------------------------------------------------------------
  #
  #   # column_configurations (Optional)
  #   # 設定内容: 分析全体で列のデフォルトフォーマットを設定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ColumnConfiguration.html
  #   column_configurations {
  #     # role (Optional)
  #     # 設定内容: 列の役割を指定します。
  #     # 設定可能な値: "DIMENSION", "MEASURE"
  #     role = "MEASURE"
  #
  #     column {
  #       # column_name (Required)
  #       # 設定内容: 列名を指定します。
  #       column_name = "example_column"
  #
  #       # data_set_identifier (Required)
  #       # 設定内容: 列が属するデータセットの識別子を指定します。
  #       data_set_identifier = "1"
  #     }
  #   }
  #
  #   #-------------------------------------------------------------
  #   # フィルターグループ設定
  #   #-------------------------------------------------------------
  #
  #   # filter_groups (Optional)
  #   # 設定内容: 分析のフィルター定義リストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_FilterGroup.html
  #   filter_groups {
  #     # filter_group_id (Required)
  #     # 設定内容: フィルターグループの一意の識別子を指定します。
  #     filter_group_id = "filter-group-1"
  #
  #     # cross_dataset (Required)
  #     # 設定内容: クロスデータセットフィルターの種類を指定します。
  #     # 設定可能な値:
  #     #   - "ALL_DATASETS": すべてのデータセットに適用
  #     #   - "SINGLE_DATASET": 単一データセットに適用
  #     cross_dataset = "ALL_DATASETS"
  #
  #     # status (Optional)
  #     # 設定内容: フィルターグループのステータスを指定します。
  #     # 設定可能な値: "ENABLED", "DISABLED"
  #     status = "ENABLED"
  #
  #     filters {
  #       # フィルターの種類に応じたブロックを指定します
  #       # category_filter, numeric_equality_filter, numeric_range_filter,
  #       # date_time_equality_filter, date_time_range_filter, relative_dates_filter,
  #       # top_bottom_filter, time_equality_filter, time_range_filter
  #     }
  #
  #     scope_configuration {
  #       # selected_sheets または all_sheets を指定
  #     }
  #   }
  #
  #   #-------------------------------------------------------------
  #   # パラメーター宣言設定
  #   #-------------------------------------------------------------
  #
  #   # parameter_declarations (Optional)
  #   # 設定内容: 分析のパラメーター宣言リストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ParameterDeclaration.html
  #   parameter_declarations {
  #     # date_time_parameter_declaration (Optional)
  #     # 設定内容: 日時型パラメーターの宣言を指定します。
  #     date_time_parameter_declaration {
  #       # name (Required)
  #       # 設定内容: パラメーター名を指定します。
  #       name = "DateTimeParam"
  #
  #       # time_granularity (Optional)
  #       # 設定内容: 時間粒度を指定します。
  #       # 設定可能な値: "YEAR", "QUARTER", "MONTH", "WEEK", "DAY",
  #       #   "HOUR", "MINUTE", "SECOND", "MILLISECOND"
  #       time_granularity = "DAY"
  #     }
  #   }
  #
  #   #-------------------------------------------------------------
  #   # シート設定
  #   #-------------------------------------------------------------
  #
  #   # sheets (Optional)
  #   # 設定内容: 分析のシート定義リストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_SheetDefinition.html
  #   sheets {
  #     # sheet_id (Required)
  #     # 設定内容: シートの一意の識別子を指定します。
  #     sheet_id = "Sheet1"
  #
  #     # name (Optional)
  #     # 設定内容: シートの内部名を指定します。
  #     name = "Sheet 1"
  #
  #     # title (Optional)
  #     # 設定内容: シートのタイトルを指定します（表示名）。
  #     title = "メインダッシュボード"
  #
  #     # description (Optional)
  #     # 設定内容: シートの説明を指定します。
  #     description = "主要KPIを表示するシートです"
  #
  #     # content_type (Optional, Computed)
  #     # 設定内容: シートのコンテンツタイプを指定します。
  #     # 設定可能な値: "INTERACTIVE", "PAGINATED"
  #     # 省略時: QuickSight が自動的に設定します。
  #     # content_type = "INTERACTIVE"
  #
  #     # filter_controls, layouts, parameter_controls, sheet_control_layouts,
  #     # text_boxes, title, visuals 等のブロックを追加可能
  #   }
  # }

  #-------------------------------------------------------------
  # パラメーター設定（作成時の上書き）
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: 分析作成時にデフォルト設定を上書きするパラメーターを指定します。
  # 設定可能な値: 最大1件
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_Parameters.html
  # parameters {
  #   # date_time_parameters (Optional)
  #   # 設定内容: 日時型パラメーターのリストを指定します。
  #   # 設定可能な値: 最大100件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DateTimeParameter.html
  #   date_time_parameters {
  #     # name (Required)
  #     # 設定内容: パラメーター名を指定します。
  #     name = "StartDate"
  #
  #     # values (Required)
  #     # 設定内容: 日時型パラメーターの値リストを指定します。
  #     # 設定可能な値: ISO 8601形式の日時文字列リスト
  #     values = ["2024-01-01T00:00:00Z"]
  #   }
  #
  #   # decimal_parameters (Optional)
  #   # 設定内容: 小数型パラメーターのリストを指定します。
  #   # 設定可能な値: 最大100件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DecimalParameter.html
  #   decimal_parameters {
  #     # name (Required)
  #     # 設定内容: パラメーター名を指定します。
  #     name = "Threshold"
  #
  #     # values (Required)
  #     # 設定内容: 小数型パラメーターの値リストを指定します。
  #     values = [99.5]
  #   }
  #
  #   # integer_parameters (Optional)
  #   # 設定内容: 整数型パラメーターのリストを指定します。
  #   # 設定可能な値: 最大100件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_IntegerParameter.html
  #   integer_parameters {
  #     # name (Required)
  #     # 設定内容: パラメーター名を指定します。
  #     name = "TopN"
  #
  #     # values (Required)
  #     # 設定内容: 整数型パラメーターの値リストを指定します。
  #     values = [10]
  #   }
  #
  #   # string_parameters (Optional)
  #   # 設定内容: 文字列型パラメーターのリストを指定します。
  #   # 設定可能な値: 最大100件
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_StringParameter.html
  #   string_parameters {
  #     # name (Required)
  #     # 設定内容: パラメーター名を指定します。
  #     name = "Region"
  #
  #     # values (Required)
  #     # 設定内容: 文字列型パラメーターの値リストを指定します。
  #     values = ["ap-northeast-1"]
  #   }
  # }

  #-------------------------------------------------------------
  # アクセス権限設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: 分析に対するリソース権限を指定します。
  # 設定可能な値: 最大64件
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  permissions {
    # actions (Required)
    # 設定内容: 付与または取り消すIAMアクションのリストを指定します。
    # 設定可能な値:
    #   閲覧者権限:
    #     - "quicksight:DescribeAnalysis"
    #     - "quicksight:ListAnalyses"
    #     - "quicksight:QueryAnalysis"
    #   共同作成者権限（上記に加えて）:
    #     - "quicksight:RestoreAnalysis"
    #     - "quicksight:UpdateAnalysis"
    #     - "quicksight:DeleteAnalysis"
    #     - "quicksight:DescribeAnalysisPermissions"
    #     - "quicksight:UpdateAnalysisPermissions"
    actions = [
      "quicksight:DescribeAnalysis",
      "quicksight:ListAnalyses",
      "quicksight:QueryAnalysis",
      "quicksight:RestoreAnalysis",
      "quicksight:UpdateAnalysis",
      "quicksight:DeleteAnalysis",
      "quicksight:DescribeAnalysisPermissions",
      "quicksight:UpdateAnalysisPermissions",
    ]

    # principal (Required)
    # 設定内容: 権限を付与するプリンシパルのARNを指定します。
    # 設定可能な値: QuickSight ユーザー、グループ、またはIAMロールのARN
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/example-user"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 参考: https://docs.aws.amazon.com/quicksight/latest/user/tagging-resources.html
  tags = {
    Name        = "example-analysis"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などのGo duration形式の文字列
    create = null

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などのGo duration形式の文字列
    update = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "5m", "1h" などのGo duration形式の文字列
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 分析のAmazon Resource Name (ARN)
# - created_time: 分析が作成された日時
# - last_published_time: 分析が最後に公開された日時
# - last_updated_time: 分析が最後に更新された日時
# - status: 分析の作成ステータス
# - id: AWSアカウントIDと分析IDをカンマ区切りで結合した文字列
# - tags_all: プロバイダーのdefault_tags設定から継承したタグを含む全タグのマップ
#---------------------------------------------------------------
