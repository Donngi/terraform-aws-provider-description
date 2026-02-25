#---------------------------------------------------------------
# AWS Glue ML Transform
#---------------------------------------------------------------
#
# AWS Glue の機械学習トランスフォームをプロビジョニングするリソースです。
# 機械学習トランスフォームは、データセット内のマッチングレコードを検出・
# 統合するための FindMatches アルゴリズムを提供します。
# ラベリングデータを学習させることで、完全一致しないレコード間の
# 重複・マッチングを自動的に識別することができます。
#
# AWS公式ドキュメント:
#   - AWS Glue ML トランスフォーム概要: https://docs.aws.amazon.com/glue/latest/dg/machine-learning.html
#   - FindMatches パラメータ: https://docs.aws.amazon.com/glue/latest/webapi/API_FindMatchesParameters.html
#   - ML トランスフォームチュートリアル: https://docs.aws.amazon.com/glue/latest/dg/machine-learning-transform-tutorial.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_ml_transform
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_glue_ml_transform" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ML トランスフォームに割り当てる一意の名前を指定します。
  # 設定可能な値: アカウント内で一意の文字列
  name = "example-ml-transform"

  # role_arn (Required)
  # 設定内容: この ML トランスフォームに関連付ける IAM ロールの ARN を指定します。
  # 設定可能な値: 有効な IAM ロール ARN
  # 注意: このロールには AWS Glue サービスとデータソースへのアクセス権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/glue-ml-transform-role"

  # description (Optional)
  # 設定内容: ML トランスフォームの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "FindMatches ML transform for deduplication"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # Glue バージョン設定
  #-------------------------------------------------------------

  # glue_version (Optional)
  # 設定内容: 使用する AWS Glue のバージョンを指定します。
  # 設定可能な値: "1.0", "2.0" 等のバージョン文字列
  # 省略時: AWS がデフォルトのバージョンを自動選択します。
  # 参考: https://docs.aws.amazon.com/glue/latest/dg/release-notes.html
  # 注意: FindMatches は Glue 2.0 との互換性があります。
  glue_version = "2.0"

  #-------------------------------------------------------------
  # ワーカー設定
  #-------------------------------------------------------------

  # worker_type (Optional)
  # 設定内容: ML トランスフォーム実行時に割り当てる定義済みワーカーの種類を指定します。
  # 設定可能な値:
  #   - "Standard": 標準ワーカー
  #   - "G.1X": 1 DPU に相当するワーカー。メモリ集約型ジョブ向け
  #   - "G.2X": 2 DPU に相当するワーカー。より大きなメモリ要件向け
  # 省略時: null（number_of_workers と共に使用する場合は必須）
  # 注意: number_of_workers と同時に指定する必要があります。max_capacity とは排他的です。
  worker_type = "G.1X"

  # number_of_workers (Optional)
  # 設定内容: ML トランスフォーム実行時に割り当てる定義済みワーカー数を指定します。
  # 設定可能な値: 正の整数
  # 省略時: null（worker_type と共に使用する場合は必須）
  # 注意: worker_type と同時に指定する必要があります。max_capacity とは排他的です。
  number_of_workers = 10

  # max_capacity (Optional)
  # 設定内容: タスクの実行に割り当てる AWS Glue データ処理ユニット（DPU）数を指定します。
  # 設定可能な値: 2〜100 の数値。デフォルトは 10
  # 省略時: AWS が自動的に値を設定します。
  # 注意: number_of_workers および worker_type とは排他的なオプションです。
  #       worker_type / number_of_workers を使用する場合はこの属性を省略してください。
  max_capacity = null

  #-------------------------------------------------------------
  # 再試行・タイムアウト設定
  #-------------------------------------------------------------

  # max_retries (Optional)
  # 設定内容: ML トランスフォームが失敗した場合の最大再試行回数を指定します。
  # 設定可能な値: 非負整数
  # 省略時: 再試行なし
  max_retries = 0

  # timeout (Optional)
  # 設定内容: ML トランスフォームのタイムアウト時間を分単位で指定します。
  # 設定可能な値: 正の整数（分）
  # 省略時: 2880（48時間）
  timeout = 2880

  #-------------------------------------------------------------
  # 入力テーブル設定
  #-------------------------------------------------------------

  # input_record_tables (Required)
  # 設定内容: トランスフォームで使用する AWS Glue テーブル定義のリストを指定します。
  # 設定可能な値: 1件以上のブロック。各ブロックに Glue データカタログのテーブル情報を記述します。
  input_record_tables {

    # database_name (Required)
    # 設定内容: AWS Glue データカタログ内のデータベース名を指定します。
    # 設定可能な値: 有効な Glue データカタログのデータベース名
    database_name = "example_database"

    # table_name (Required)
    # 設定内容: AWS Glue データカタログ内のテーブル名を指定します。
    # 設定可能な値: 有効な Glue データカタログのテーブル名
    table_name = "example_table"

    # catalog_id (Optional)
    # 設定内容: AWS Glue データカタログの一意な識別子を指定します。
    # 設定可能な値: 12桁のAWSアカウントID
    # 省略時: 現在のアカウントのデータカタログを使用
    catalog_id = null

    # connection_name (Optional)
    # 設定内容: データソースへの接続名を指定します。
    # 設定可能な値: 有効な Glue 接続名
    # 省略時: 接続なし（S3等の接続不要なソースの場合）
    connection_name = null
  }

  #-------------------------------------------------------------
  # アルゴリズムパラメータ設定
  #-------------------------------------------------------------

  # parameters (Required)
  # 設定内容: トランスフォームタイプに固有のアルゴリズムパラメータの設定ブロックです。
  # 設定可能な値: 1件のブロック（min_items=1, max_items=1）
  # 参考: http://docs.aws.amazon.com/glue/latest/dg/add-job-machine-learning-transform.html
  parameters {

    # transform_type (Required)
    # 設定内容: 機械学習トランスフォームの種類を指定します。
    # 設定可能な値:
    #   - "FIND_MATCHES": レコードマッチングアルゴリズム。重複レコードの検出・統合に使用
    transform_type = "FIND_MATCHES"

    #-----------------------------------------------------------
    # FindMatches パラメータ設定
    #-----------------------------------------------------------

    # find_matches_parameters (Required)
    # 設定内容: FindMatches アルゴリズムのパラメータ設定ブロックです。
    # 設定可能な値: 1件のブロック（min_items=1, max_items=1）
    # 参考: https://docs.aws.amazon.com/glue/latest/webapi/API_FindMatchesParameters.html
    find_matches_parameters {

      # primary_key_column_name (Optional)
      # 設定内容: ソーステーブルの行を一意に識別するカラム名を指定します。
      # 設定可能な値: テーブルスキーマ内の有効なカラム名
      # 省略時: null（一意識別カラムなし）
      # 注意: このカラムはマッチングレコードの識別を補助するために使用されます。
      primary_key_column_name = "id"

      # accuracy_cost_trade_off (Optional)
      # 設定内容: 精度とコストのトレードオフを調整する値を指定します。
      # 設定可能な値: 0.0〜1.0 の数値
      #   - 0.0: コスト優先（使用リソース最小化、マッチ数が減少する可能性）
      #   - 0.5: 精度とコストの均衡
      #   - 1.0: 精度優先（より多くのリソースを使用、高い再現率）
      # 省略時: AWS がデフォルト値を設定します。
      # 参考: https://docs.aws.amazon.com/glue/latest/dg/machine-learning-accuracy-cost-tradeoff.html
      accuracy_cost_trade_off = 0.5

      # precision_recall_trade_off (Optional)
      # 設定内容: 適合率と再現率のトレードオフを調整する値を指定します。
      # 設定可能な値: 0.0〜1.0 の数値
      #   - 0.0: 再現率優先（より多くのマッチを検出、誤検出が増える可能性）
      #   - 0.5: 適合率と再現率の均衡
      #   - 1.0: 適合率優先（誤検出を最小化、検出漏れが増える可能性）
      # 省略時: AWS がデフォルト値を設定します。
      # 参考: https://docs.aws.amazon.com/glue/latest/dg/machine-learning-precision-recall-tradeoff.html
      precision_recall_trade_off = 0.5

      # enforce_provided_labels (Optional)
      # 設定内容: ユーザーが提供したラベルに出力を強制的に一致させるかを指定します。
      # 設定可能な値:
      #   - true: ユーザー提供ラベルで通常の統合結果を上書き（実行時間が増加する場合あり）
      #   - false: 通常のアルゴリズム結果を使用
      # 省略時: false
      # 参考: https://docs.aws.amazon.com/glue/latest/dg/machine-learning-teaching.html
      enforce_provided_labels = false
    }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-ml-transform"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: Glue ML トランスフォームの Amazon Resource Name (ARN)
# - id: Glue ML トランスフォームの ID
# - label_count: このトランスフォームで利用可能なラベルの数
# - schema: トランスフォームが受け入れるスキーマ情報のリスト
#           各要素は name（カラム名）と data_type（データ型）を含みます
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
