#---------------------------------------------------------------
# AWS QuickSight Dashboard
#---------------------------------------------------------------
#
# Amazon QuickSightダッシュボードをプロビジョニングするリソースです。
# QuickSightはビジネスインテリジェンス（BI）サービスで、データの可視化、
# インタラクティブなダッシュボード、アドホック分析を提供します。
#
# AWS公式ドキュメント:
#   - QuickSight概要: https://docs.aws.amazon.com/quicksight/latest/user/welcome.html
#   - Dashboard管理: https://docs.aws.amazon.com/quicksight/latest/user/working-with-dashboards.html
#   - Dashboard API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_Dashboard.html
#   - CreateDashboard API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDashboard.html
#   - Filtering Data: https://docs.aws.amazon.com/quicksight/latest/user/filtering-visual-data.html
#   - Parameters in QuickSight: https://docs.aws.amazon.com/quicksight/latest/user/parameters-in-quicksight.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_dashboard
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_dashboard" "example" {
  #-------------------------------------------------------------
  # 基本設定 (Required)
  #-------------------------------------------------------------

  # dashboard_id (Required, Forces new resource)
  # 設定内容: ダッシュボードの一意の識別子を指定します。
  # 設定可能な値: 英数字、ハイフン、アンダースコアを使用した文字列
  # 注意: この値を変更すると新しいリソースが作成され、既存のリソースは削除されます
  # 関連機能: QuickSight Dashboard Identifier
  #   AWSアカウント内でダッシュボードを一意に識別します。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateDashboard.html
  dashboard_id = "example-dashboard-id"

  # name (Required)
  # 設定内容: ダッシュボードの表示名を指定します。
  # 設定可能な値: 文字列（ユーザーに表示される名前）
  # 用途: QuickSightコンソールでダッシュボードを識別するための名前
  name = "Example Dashboard"

  # version_description (Required)
  # 設定内容: 作成/更新されるダッシュボードバージョンの説明を指定します。
  # 設定可能な値: バージョンの変更内容を説明する文字列
  # 用途: バージョン管理とチーム間でのコミュニケーションに使用
  version_description = "Initial version"

  #-------------------------------------------------------------
  # アカウント設定 (Optional)
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: ダッシュボードを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁のAWSアカウントID
  # 省略時: Terraform AWSプロバイダーで自動的に決定されたアカウントIDを使用
  # 注意: この値を変更すると新しいリソースが作成され、既存のリソースは削除されます
  aws_account_id = null

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # テーマ設定 (Optional)
  #-------------------------------------------------------------

  # theme_arn (Optional)
  # 設定内容: このダッシュボードに使用されるテーマのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なQuickSightテーマのARN
  # 用途: ダッシュボードの視覚的なスタイル（色、フォント、レイアウトなど）を定義
  # 注意: テーマARNは、ダッシュボードを作成するのと同じAWSアカウントに存在する必要があります
  # 関連機能: QuickSight Theme
  #   テーマはダッシュボードの色、フォント、その他のスタイル設定を定義します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/themes-in-quicksight.html
  theme_arn = null

  #-------------------------------------------------------------
  # タグ設定 (Optional)
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 関連機能: AWSリソースタグ付け
  #   コスト配分、リソース管理、アクセス制御などに使用されます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  #   - https://docs.aws.amazon.com/quicksight/latest/user/tagging-resources.html
  tags = {
    Name        = "example-dashboard"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # source_entity ブロック (Optional)
  #-------------------------------------------------------------
  # ダッシュボード作成時にソースとして使用するエンティティ（テンプレート）を指定します。
  # 注意: definitionまたはsource_entityのいずれか一方のみを設定してください（両方は不可）
  # 用途: 既存のテンプレートからダッシュボードを作成
  # 関連機能: QuickSight Source Entity
  #   テンプレートを使用してダッシュボードを標準化します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/create-a-template.html

  source_entity {
    # source_template ブロック (Optional)
    # ソーステンプレートの設定を定義します。

    source_template {
      # arn (Required)
      # 設定内容: リソースのAmazon Resource Name (ARN)を指定します。
      # 設定可能な値: 有効なQuickSightテンプレートのARN
      # 形式: arn:aws:quicksight:{region}:{account-id}:template/{template-id}
      arn = "arn:aws:quicksight:ap-northeast-1:123456789012:template/example-template"

      # data_set_references ブロック (Required)
      # データセット参照のリストを定義します。
      # テンプレートで使用されるデータセットをダッシュボードに関連付けます。

      data_set_references {
        # data_set_arn (Required)
        # 設定内容: データセットのAmazon Resource Name (ARN)を指定します。
        # 設定可能な値: 有効なQuickSightデータセットのARN
        # 形式: arn:aws:quicksight:{region}:{account-id}:dataset/{dataset-id}
        data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset"

        # data_set_placeholder (Required)
        # 設定内容: データセットのプレースホルダーを指定します。
        # 設定可能な値: テンプレートで定義されたプレースホルダー文字列
        # 用途: テンプレート内のデータセット参照を実際のデータセットに置き換えるために使用
        data_set_placeholder = "1"
      }
    }
  }

  #-------------------------------------------------------------
  # definition ブロック (Optional)
  #-------------------------------------------------------------
  # ダッシュボードの詳細な定義を指定します。
  # 注意: definitionまたはsource_entityのいずれか一方のみを設定してください（両方は不可）
  # 用途: ダッシュボードの構造、ビジュアル、フィルターなどを直接定義
  # 関連機能: QuickSight Dashboard Definition
  #   ダッシュボードの構成要素を細かく制御します。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DashboardVersionDefinition.html
  # 以下はdefinitionブロックの例です（コメントアウトされています）

  # definition {
  #   # data_set_identifiers_declarations ブロック (Required)
  #   # データセット識別子宣言のリストを定義します。
  #   # このマッピングにより、ダッシュボードのサブ構造全体でデータセットARNの代わりに
  #   # データセット識別子を使用できます。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DataSetIdentifierDeclaration.html
  #
  #   data_set_identifiers_declarations {
  #     # data_set_arn (Required)
  #     # 設定内容: データセットのARNを指定します。
  #     # 設定可能な値: 有効なQuickSightデータセットのARN
  #     data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset"
  #
  #     # identifier (Required)
  #     # 設定内容: データセットの識別子を指定します。
  #     # 設定可能な値: 文字列識別子（例: "1", "dataset_1"）
  #     # 用途: ダッシュボード内でこの識別子を使ってデータセットを参照
  #     identifier = "1"
  #   }
  #
  #   # analysis_defaults ブロック (Optional)
  #   # デフォルトの分析設定を指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefaults.html
  #
  #   # calculated_fields ブロック (Optional)
  #   # ダッシュボードの計算フィールド定義のリストを指定します。
  #   # 計算フィールドは、既存のデータセット列から派生した新しいフィールドです。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CalculatedField.html
  #
  #   # column_configurations ブロック (Optional)
  #   # ダッシュボードレベルの列設定のリストを指定します。
  #   # 列設定は、ダッシュボード全体で使用される列のデフォルトフォーマットを設定するために使用されます。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ColumnConfiguration.html
  #
  #   # filter_groups ブロック (Optional)
  #   # ダッシュボードのフィルター定義のリストを指定します。
  #   # フィルターグループは、複数のフィルターをまとめて管理するために使用されます。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_FilterGroup.html
  #   # 詳細: https://docs.aws.amazon.com/quicksight/latest/user/filtering-visual-data.html
  #
  #   # parameters_declarations ブロック (Optional)
  #   # ダッシュボードのパラメーター宣言のリストを指定します。
  #   # パラメーターは、アクションまたはオブジェクトで使用する値を転送できる名前付き変数です。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ParameterDeclaration.html
  #   # 詳細: https://docs.aws.amazon.com/quicksight/latest/user/parameters-in-quicksight.html
  #
  #   # sheets ブロック (Optional)
  #   # ダッシュボードのシート定義のリストを指定します。
  #   # 各シートは、ビジュアル、テキストボックス、フィルターなどの要素を含むことができます。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_SheetDefinition.html
  #
  #   sheets {
  #     # title (Optional)
  #     # 設定内容: シートのタイトルを指定します。
  #     # 設定可能な値: 文字列
  #     title = "Example Sheet"
  #
  #     # sheet_id (Required)
  #     # 設定内容: シートの一意の識別子を指定します。
  #     # 設定可能な値: 英数字、ハイフン、アンダースコアを使用した文字列
  #     sheet_id = "Example1"
  #
  #     # visuals ブロック (Optional)
  #     # シート内のビジュアルのリストを定義します。
  #     # ビジュアルは、グラフ、テーブル、ピボットテーブルなどのデータ可視化要素です。
  #
  #     visuals {
  #       # line_chart_visual ブロック (Optional)
  #       # 折れ線グラフビジュアルの設定を定義します。
  #       # 他のビジュアルタイプ: bar_chart_visual, pie_chart_visual, table_visual など
  #
  #       line_chart_visual {
  #         # visual_id (Required)
  #         # 設定内容: ビジュアルの一意の識別子を指定します。
  #         # 設定可能な値: 英数字を使用した文字列
  #         visual_id = "LineChart"
  #
  #         # title ブロック (Optional)
  #         # ビジュアルのタイトル設定を定義します。
  #
  #         title {
  #           # format_text ブロック (Optional)
  #           # タイトルのテキストフォーマットを定義します。
  #
  #           format_text {
  #             # plain_text (Optional)
  #             # 設定内容: プレーンテキストのタイトルを指定します。
  #             # 設定可能な値: 文字列
  #             plain_text = "Line Chart Example"
  #           }
  #         }
  #
  #         # chart_configuration ブロック (Optional)
  #         # チャートの設定を定義します。
  #
  #         chart_configuration {
  #           # field_wells ブロック (Optional)
  #           # フィールドウェルの設定を定義します。
  #           # フィールドウェルは、ビジュアルに表示するデータフィールドを指定します。
  #
  #           field_wells {
  #             # line_chart_aggregated_field_wells ブロック (Optional)
  #             # 集約された折れ線グラフのフィールドウェルを定義します。
  #
  #             line_chart_aggregated_field_wells {
  #               # category ブロック (Optional)
  #               # カテゴリフィールドの設定を定義します。
  #               # カテゴリは通常、X軸に表示されるディメンションフィールドです。
  #
  #               category {
  #                 # categorical_dimension_field ブロック (Optional)
  #                 # カテゴリカルディメンションフィールドを定義します。
  #
  #                 categorical_dimension_field {
  #                   # field_id (Required)
  #                   # 設定内容: フィールドの一意の識別子を指定します。
  #                   # 設定可能な値: 文字列
  #                   field_id = "1"
  #
  #                   # column ブロック (Required)
  #                   # 列の参照を定義します。
  #
  #                   column {
  #                     # data_set_identifier (Required)
  #                     # 設定内容: データセットの識別子を指定します。
  #                     # 設定可能な値: data_set_identifiers_declarationsで定義した識別子
  #                     data_set_identifier = "1"
  #
  #                     # column_name (Required)
  #                     # 設定内容: 列の名前を指定します。
  #                     # 設定可能な値: データセット内に存在する列名の文字列
  #                     column_name = "Column1"
  #                   }
  #                 }
  #               }
  #
  #               # values ブロック (Optional)
  #               # 値フィールドの設定を定義します。
  #               # 値は通常、Y軸に表示されるメジャーフィールドです。
  #
  #               values {
  #                 # categorical_measure_field ブロック (Optional)
  #                 # カテゴリカルメジャーフィールドを定義します。
  #
  #                 categorical_measure_field {
  #                   # field_id (Required)
  #                   # 設定内容: フィールドの一意の識別子を指定します。
  #                   # 設定可能な値: 文字列
  #                   field_id = "2"
  #
  #                   # column ブロック (Required)
  #                   # 列の参照を定義します。
  #
  #                   column {
  #                     # data_set_identifier (Required)
  #                     # 設定内容: データセットの識別子を指定します。
  #                     # 設定可能な値: data_set_identifiers_declarationsで定義した識別子
  #                     data_set_identifier = "1"
  #
  #                     # column_name (Required)
  #                     # 設定内容: 列の名前を指定します。
  #                     # 設定可能な値: データセット内に存在する列名の文字列
  #                     column_name = "Column1"
  #                   }
  #
  #                   # aggregation_function (Optional)
  #                   # 設定内容: 集約関数を指定します。
  #                   # 設定可能な値: "COUNT", "DISTINCT_COUNT", "SUM", "AVERAGE", "MAX", "MIN" など
  #                   aggregation_function = "COUNT"
  #                 }
  #               }
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # parameters ブロック (Optional)
  #-------------------------------------------------------------
  # ダッシュボード作成時のパラメーターを指定します。
  # デフォルト設定を上書きしたい場合に使用します。
  # 注意: ダッシュボードは任意の型のパラメーターを持つことができ、
  #       一部のパラメーターは複数の値を受け入れる場合があります。
  # 関連機能: QuickSight Parameters
  #   パラメーターは、ダッシュボードの動的な動作を制御します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/parameters-in-quicksight.html

  # parameters {
  #   # string_parameters ブロック (Optional)
  #   # 文字列データ型を持つパラメーターのリストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_StringParameter.html
  #
  #   # string_parameters {
  #   #   name   = "parameter_name"
  #   #   values = ["value1", "value2"]
  #   # }
  #
  #   # integer_parameters ブロック (Optional)
  #   # 整数データ型を持つパラメーターのリストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_IntegerParameter.html
  #
  #   # integer_parameters {
  #   #   name   = "parameter_name"
  #   #   values = [1, 2, 3]
  #   # }
  #
  #   # decimal_parameters ブロック (Optional)
  #   # 小数データ型を持つパラメーターのリストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DecimalParameter.html
  #
  #   # decimal_parameters {
  #   #   name   = "parameter_name"
  #   #   values = [1.5, 2.5, 3.5]
  #   # }
  #
  #   # date_time_parameters ブロック (Optional)
  #   # 日時データ型を持つパラメーターのリストを指定します。
  #   # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DateTimeParameter.html
  #
  #   # date_time_parameters {
  #   #   name   = "parameter_name"
  #   #   values = ["2026-01-01T00:00:00Z"]
  #   # }
  # }

  #-------------------------------------------------------------
  # permissions ブロック (Optional, 複数指定可能)
  #-------------------------------------------------------------
  # ダッシュボードのリソース権限を設定します。
  # 最大64個のアイテムを指定可能です。
  # 用途: ダッシュボードへのアクセスを制御
  # 関連機能: QuickSight Resource Permissions
  #   ユーザーやグループに対してダッシュボードの読み取り、更新、削除などの権限を付与します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/sharing-a-dashboard.html

  permissions {
    # principal (Required)
    # 設定内容: プリンシパルのARNを指定します。
    # 設定可能な値: IAMユーザー、IAMロール、またはQuickSightユーザーのARN
    # 形式例:
    #   - IAMユーザー: arn:aws:iam::123456789012:user/username
    #   - IAMロール: arn:aws:iam::123456789012:role/rolename
    #   - QuickSightユーザー: arn:aws:quicksight:ap-northeast-1:123456789012:user/default/username
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/username"

    # actions (Required)
    # 設定内容: 付与または取り消すIAMアクションのリストを指定します。
    # 設定可能な値: QuickSightのアクション名のリスト
    # 主なアクション:
    #   - quicksight:DescribeDashboard: ダッシュボードの詳細を表示
    #   - quicksight:ListDashboardVersions: ダッシュボードのバージョン一覧を表示
    #   - quicksight:UpdateDashboardPermissions: ダッシュボードの権限を更新
    #   - quicksight:QueryDashboard: ダッシュボードをクエリ
    #   - quicksight:UpdateDashboard: ダッシュボードを更新
    #   - quicksight:DeleteDashboard: ダッシュボードを削除
    #   - quicksight:DescribeDashboardPermissions: ダッシュボードの権限を表示
    #   - quicksight:UpdateDashboardPublishedVersion: 公開バージョンを更新
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    actions = [
      "quicksight:DescribeDashboard",
      "quicksight:ListDashboardVersions",
      "quicksight:QueryDashboard",
    ]
  }

  #-------------------------------------------------------------
  # dashboard_publish_options ブロック (Optional)
  #-------------------------------------------------------------
  # ダッシュボードの公開オプションを設定します。
  # ユーザーインターフェースでの機能の有効/無効を制御します。
  # 用途: ダッシュボードの機能とユーザーインタラクションを制御
  # 関連機能: QuickSight Dashboard Publish Options
  #   フィルタリング、エクスポート、ドリルダウンなどの機能を有効/無効化します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/working-with-dashboards.html

  dashboard_publish_options {
    # ad_hoc_filtering_option ブロック (Optional)
    # アドホック（一回限り）フィルタリングオプションを設定します。
    # 用途: ユーザーがダッシュボード上で動的にフィルターを適用できるかを制御

    ad_hoc_filtering_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # data_point_drill_up_down_option ブロック (Optional)
    # データポイントのドリルアップ/ドリルダウンオプションを設定します。
    # 用途: ユーザーがデータをドリルダウン/アップできるかを制御

    data_point_drill_up_down_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # data_point_menu_label_option ブロック (Optional)
    # データポイントメニューラベルオプションを設定します。
    # 用途: データポイント上のメニューラベルを表示するかを制御

    data_point_menu_label_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # data_point_tooltip_option ブロック (Optional)
    # データポイントツールチップオプションを設定します。
    # 用途: データポイント上のツールチップを表示するかを制御

    data_point_tooltip_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # export_to_csv_option ブロック (Optional)
    # CSVエクスポートオプションを設定します。
    # 用途: ユーザーがダッシュボードデータをCSVにエクスポートできるかを制御

    export_to_csv_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # export_with_hidden_fields_option ブロック (Optional)
    # 非表示フィールドを含めてエクスポートするオプションを設定します。
    # 用途: 非表示フィールドをエクスポートに含めるかを制御

    export_with_hidden_fields_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効（非表示フィールドをエクスポートに含める）
      #   - "DISABLED": 無効（非表示フィールドをエクスポートから除外）
      availability_status = "DISABLED"
    }

    # sheet_controls_option ブロック (Optional)
    # シートコントロールオプションを設定します。
    # 用途: シートコントロールパネルの表示状態を制御

    sheet_controls_option {
      # visibility_state (Optional)
      # 設定内容: 表示状態を指定します。
      # 設定可能な値:
      #   - "EXPANDED": 展開
      #   - "COLLAPSED": 折りたたみ
      visibility_state = "EXPANDED"
    }

    # sheet_layout_element_maximization_option ブロック (Optional)
    # シートレイアウト要素の最大化オプションを設定します。
    # 用途: ユーザーがビジュアルを最大化できるかを制御

    sheet_layout_element_maximization_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # visual_axis_sort_option ブロック (Optional)
    # ビジュアル軸ソートオプションを設定します。
    # 用途: ユーザーが軸でビジュアルをソートできるかを制御

    visual_axis_sort_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }

    # visual_menu_option ブロック (Optional)
    # ビジュアルメニューオプションを設定します。
    # 用途: ビジュアル上のメニューオプションを表示するかを制御

    visual_menu_option {
      # availability_status (Optional)
      # 設定内容: 可用性ステータスを指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効
      #   - "DISABLED": 無効
      availability_status = "ENABLED"
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ダッシュボードのAmazon Resource Name (ARN)
#
# - created_time: ダッシュボードが作成された時刻
#
# - id: コンマ区切りのAWSアカウントIDとダッシュボードIDの結合文字列
#       形式: {aws_account_id},{dashboard_id}
#
# - last_updated_time: ダッシュボードが最後に更新された時刻
#
# - source_entity_arn: このダッシュボードの作成に使用されたテンプレートのARN
#
# - status: ダッシュボードの作成ステータス
#           可能な値: CREATION_IN_PROGRESS, CREATION_SUCCESSFUL, CREATION_FAILED,
#                     UPDATE_IN_PROGRESS, UPDATE_SUCCESSFUL, UPDATE_FAILED, DELETED
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - version_number: ダッシュボードバージョンの番号
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import (インポート)
#---------------------------------------------------------------
# 既存のダッシュボードをインポートするには、以下のコマンドを使用します:
#
# terraform import aws_quicksight_dashboard.example <aws_account_id>,<dashboard_id>
#
# 例:
# terraform import aws_quicksight_dashboard.example 123456789012,example-dashboard-id
#---------------------------------------------------------------
