#---------------------------------------------------------------
# Amazon QuickSight Analysis
#---------------------------------------------------------------
#
# Amazon QuickSight のアナリシス（分析）をプロビジョニングするリソースです。
# アナリシスは、データセットに基づいた可視化やインタラクティブな分析を
# 作成するための QuickSight のコアリソースです。テンプレートから作成するか、
# 詳細な定義から作成する2つの方法があります。
#
# AWS公式ドキュメント:
#   - CreateAnalysis API: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAnalysis.html
#   - QuickSight Analysis概要: https://docs.aws.amazon.com/quicksight/latest/user/working-with-analyses.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_analysis
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_quicksight_analysis" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # analysis_id (Required, Forces new resource)
  # 設定内容: アナリシスの一意の識別子を指定します。
  # 設定可能な値: 1-512文字の文字列。パターン: [\w\-]+
  # 注意: この値はアナリシスのURLに表示されます。変更時は再作成されます。
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAnalysis.html
  analysis_id = "example-analysis-id"

  # name (Required)
  # 設定内容: アナリシスの表示名を指定します。
  # 設定可能な値: 1-2048文字の文字列
  # 関連機能: QuickSight Console
  #   この名前は Amazon QuickSight コンソールでアナリシスの表示に使用されます。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/working-with-analyses.html
  name = "Example Analysis"

  #-------------------------------------------------------------
  # アカウント・リージョン設定
  #-------------------------------------------------------------

  # aws_account_id (Optional, Forces new resource)
  # 設定内容: アナリシスを作成するAWSアカウントIDを指定します。
  # 設定可能な値: 12桁の数字からなるAWSアカウントID
  # 省略時: Terraform AWS プロバイダーから自動的に決定されたアカウントIDを使用
  # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_CreateAnalysis.html
  aws_account_id = null

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 省略時: AWS アカウント ID と analysis_id をカンマ区切りで結合した文字列が自動生成されます。
  id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ソース設定
  #-------------------------------------------------------------
  # アナリシスは source_entity または definition のいずれか一方を指定して作成します。
  # 両方を指定することはできません。

  # source_entity (Optional)
  # 設定内容: アナリシス作成時にソースとして使用するエンティティ（テンプレート）を指定します。
  # 注意: definition との排他的設定（どちらか一方のみ指定可能）
  # 関連機能: テンプレートからのアナリシス作成
  #   既存のテンプレートを元にアナリシスを作成する場合に使用します。
  #   テンプレートのARNとデータセット参照を指定します。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/create-an-analysis.html
  source_entity {
    source_template {
      # arn (Required)
      # 設定内容: ソーステンプレートのAmazon Resource Name (ARN) を指定します。
      # 設定可能な値: 有効なQuickSightテンプレートARN
      arn = "arn:aws:quicksight:ap-northeast-1:123456789012:template/example-template"

      # data_set_references (Required)
      # 設定内容: テンプレートで使用するデータセット参照のリストを指定します。
      # 関連機能: データセット参照
      #   テンプレート内のプレースホルダーと実際のデータセットをマッピングします。
      data_set_references {
        # data_set_arn (Required)
        # 設定内容: データセットのAmazon Resource Name (ARN) を指定します。
        data_set_arn = "arn:aws:quicksight:ap-northeast-1:123456789012:dataset/example-dataset"

        # data_set_placeholder (Required)
        # 設定内容: テンプレート内のデータセットプレースホルダーを指定します。
        # 設定可能な値: テンプレート定義で使用されているプレースホルダー文字列
        data_set_placeholder = "1"
      }
    }
  }

  #-------------------------------------------------------------
  # 定義設定
  #-------------------------------------------------------------
  # 注意: source_entity と definition は排他的です。
  # definition を使用する場合は source_entity をコメントアウトしてください。

  # definition (Optional)
  # 設定内容: アナリシスの詳細な定義を指定します。
  # 注意: source_entity との排他的設定（どちらか一方のみ指定可能）
  # 関連機能: アナリシス定義
  #   ダッシュボード、テンプレート、またはアナリシスのすべての機能のデータモデルです。
  #   データセット識別子、シート、ビジュアル、フィルター、パラメーター等を含む
  #   完全なアナリシスの構造を定義します。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefinition.html
  #
  # definition ブロックは非常に複雑な構造を持ち、以下のサブブロックを含みます:
  # - data_set_identifiers_declarations: データセット識別子宣言（必須）
  # - analysis_defaults: デフォルト設定
  # - calculated_fields: 計算フィールド定義
  # - column_configurations: 列設定
  # - filter_groups: フィルターグループ
  # - parameters_declarations: パラメーター宣言
  # - sheets: シート定義（ビジュアル、レイアウト等を含む）
  # - options: その他オプション設定
  # - query_execution_options: クエリ実行オプション
  # - static_files: 静的ファイル
  #
  # 詳細な設定項目については以下のドキュメントを参照してください:
  # - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_AnalysisDefinition.html
  # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/quicksight_analysis#definition
  #
  # 簡単な例:
  # definition {
  #   data_set_identifiers_declarations {
  #     data_set_arn = aws_quicksight_data_set.example.arn
  #     identifier   = "1"
  #   }
  #   sheets {
  #     title    = "Example Sheet"
  #     sheet_id = "example-sheet-1"
  #     visuals {
  #       # ビジュアルの定義（line_chart_visual, bar_chart_visual等）
  #     }
  #   }
  # }

  #-------------------------------------------------------------
  # パラメーター設定
  #-------------------------------------------------------------

  # parameters (Optional)
  # 設定内容: アナリシス作成時に使用するパラメーター名と上書き値を指定します。
  # 関連機能: QuickSight パラメーター
  #   アナリシスは任意の型のパラメーターを持つことができ、
  #   一部のパラメーターは複数の値を受け入れる可能性があります。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/parameters-in-quicksight.html
  parameters {
    # string_parameters (Optional)
    # 設定内容: 文字列型のパラメーターのリストを指定します。
    # 最大項目数: 100
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_StringParameter.html
    string_parameters {
      # name (Required)
      # 設定内容: パラメーターの名前を指定します。
      name = "region_filter"

      # values (Required)
      # 設定内容: パラメーターの値のリストを指定します。
      values = ["us-east-1", "ap-northeast-1"]
    }

    # integer_parameters (Optional)
    # 設定内容: 整数型のパラメーターのリストを指定します。
    # 最大項目数: 100
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_IntegerParameter.html
    integer_parameters {
      # name (Required)
      # 設定内容: パラメーターの名前を指定します。
      name = "threshold"

      # values (Required)
      # 設定内容: パラメーターの値のリストを指定します。
      values = [100, 500, 1000]
    }

    # decimal_parameters (Optional)
    # 設定内容: 小数型のパラメーターのリストを指定します。
    # 最大項目数: 100
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DecimalParameter.html
    decimal_parameters {
      # name (Required)
      # 設定内容: パラメーターの名前を指定します。
      name = "percentage"

      # values (Required)
      # 設定内容: パラメーターの値のリストを指定します。
      values = [0.5, 0.75, 0.95]
    }

    # date_time_parameters (Optional)
    # 設定内容: 日時型のパラメーターのリストを指定します。
    # 最大項目数: 100
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_DateTimeParameter.html
    date_time_parameters {
      # name (Required)
      # 設定内容: パラメーターの名前を指定します。
      name = "start_date"

      # values (Required)
      # 設定内容: パラメーターの値のリストを指定します（ISO 8601形式の日時文字列）。
      values = ["2024-01-01T00:00:00Z"]
    }
  }

  #-------------------------------------------------------------
  # 権限設定
  #-------------------------------------------------------------

  # permissions (Optional)
  # 設定内容: アナリシスに対するリソースレベルの権限を指定します。
  # 最大項目数: 64
  # 関連機能: QuickSight リソース権限
  #   プリンシパル（IAMユーザー、ロール、グループ）ごとに
  #   許可するアクションのリストを指定します。
  #   - https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
  permissions {
    # actions (Required)
    # 設定内容: 許可または拒否するIAMアクションのリストを指定します。
    # 設定可能な値: QuickSight のアクション（例: quicksight:DescribeAnalysis, quicksight:QueryAnalysis等）
    actions = [
      "quicksight:DescribeAnalysis",
      "quicksight:DescribeAnalysisPermissions",
      "quicksight:QueryAnalysis",
      "quicksight:UpdateAnalysis",
      "quicksight:DeleteAnalysis",
      "quicksight:UpdateAnalysisPermissions"
    ]

    # principal (Required)
    # 設定内容: プリンシパルのARNを指定します。
    # 設定可能な値: IAMユーザー、ロール、またはQuickSightユーザー/グループのARN
    # 参考: https://docs.aws.amazon.com/quicksight/latest/APIReference/API_ResourcePermission.html
    principal = "arn:aws:quicksight:ap-northeast-1:123456789012:user/default/example-user"
  }

  #-------------------------------------------------------------
  # テーマ設定
  #-------------------------------------------------------------

  # theme_arn (Optional)
  # 設定内容: このアナリシスに適用するテーマのAmazon Resource Name (ARN) を指定します。
  # 設定可能な値: 有効なQuickSightテーマARN
  # 関連機能: QuickSight テーマ
  #   アナリシスの外観（色、フォント、レイアウト等）をカスタマイズするために
  #   使用します。テーマARNは、このアナリシスを作成するのと同じAWSアカウントに
  #   存在する必要があります。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/themes-in-quicksight.html
  # 注意: QuickSightコンソールでテーマを表示するには、テーマへのアクセス権限が必要です。
  theme_arn = null

  #-------------------------------------------------------------
  # 削除設定
  #-------------------------------------------------------------

  # recovery_window_in_days (Optional)
  # 設定内容: Amazon QuickSightがアナリシスを削除するまでの待機日数を指定します。
  # 設定可能な値:
  #   - 0: リカバリー期間なしで即座に削除を強制
  #   - 7-30: 指定した日数後に削除（最小値: 7、最大値: 30）
  # 省略時: 30日（デフォルト）
  # 関連機能: QuickSight リソースリカバリー
  #   削除操作後、指定した期間内であればアナリシスをリカバリーすることができます。
  #   0を指定すると、リカバリー不可能な完全削除となります。
  recovery_window_in_days = 30

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ（最小: 1項目、最大: 200項目）
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/quicksight/latest/user/tagging-resources.html
  tags = {
    Name        = "example-analysis"
    Environment = "production"
    Team        = "analytics"
  }

  # tags_all (Computed)
  # 説明: この属性は読み取り専用で、明示的に設定できません。
  #       プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
  #       リソースに割り当てられたすべてのタグのマップが自動的に設定されます。
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: アナリシスのAmazon Resource Name (ARN)
#
# - created_time: アナリシスが作成された時刻
#
# - id: AWS アカウント ID と analysis_id をカンマ区切りで結合した文字列
#
# - last_published_time: アナリシスが最後に公開された時刻
#
# - last_updated_time: アナリシスが最後に更新された時刻
#
# - status: アナリシスの作成ステータス
#           可能な値: CREATION_IN_PROGRESS, CREATION_SUCCESSFUL, CREATION_FAILED,
#                     UPDATE_IN_PROGRESS, UPDATE_SUCCESSFUL, UPDATE_FAILED, DELETED
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------

#---------------------------------------------------------------
# Import
#---------------------------------------------------------------
# 既存のQuickSightアナリシスは以下のコマンドでインポートできます:
#
# terraform import aws_quicksight_analysis.example <aws_account_id>,<analysis_id>
#
# 例:
# terraform import aws_quicksight_analysis.example 123456789012,example-analysis-id
#---------------------------------------------------------------
