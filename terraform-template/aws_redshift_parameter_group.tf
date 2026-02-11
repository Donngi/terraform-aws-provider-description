#---------------------------------------------------------------
# Amazon Redshift Parameter Group
#---------------------------------------------------------------
#
# Amazon Redshift パラメータグループを管理するリソースです。
# パラメータグループは、Redshiftクラスターのデータベースエンジン設定を定義します。
# 複数のクラスターで同じパラメータ設定を共有することができます。
#
# AWS公式ドキュメント:
#   - Redshift パラメータグループ概要: https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html
#   - Redshift パラメータリファレンス: https://docs.aws.amazon.com/redshift/latest/mgmt/parameter-groups.html
#   - Redshift API リファレンス: https://docs.aws.amazon.com/redshift/latest/APIReference/Welcome.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_parameter_group
#
# Provider Version: 6.28.0
# Generated: 2026-02-03
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_redshift_parameter_group" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Redshiftパラメータグループの名前を指定します。
  # 設定可能な値: 小文字の英数字とハイフンのみ。最大255文字
  # 用途: パラメータグループを一意に識別するための名前
  # 関連機能: Redshift パラメータグループの命名規則
  #   - 小文字、数字、ハイフン(-)のみ使用可能
  #   - 先頭は英字である必要があります
  #   - リージョン内で一意である必要があります
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html
  name = "example-parameter-group"

  # family (Required)
  # 設定内容: Redshiftパラメータグループファミリーを指定します。
  # 設定可能な値: "redshift-1.0" (標準的なRedshiftクラスター向け)
  # 用途: パラメータグループが対応するRedshiftエンジンバージョンを定義
  # 関連機能: Redshift パラメータグループファミリー
  #   - 現在、redshift-1.0が標準のファミリーです
  #   - Redshiftのメジャーバージョンに応じてファミリーが決定されます
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html
  family = "redshift-1.0"

  # description (Optional)
  # 設定内容: パラメータグループの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: "Managed by Terraform" がデフォルト値として設定されます
  # 用途: パラメータグループの目的や用途を記述
  # 関連機能: Redshift パラメータグループの説明
  #   - 管理しやすいように分かりやすい説明を付けることを推奨
  description = "Example Redshift parameter group for production cluster"

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: Redshiftパラメータの設定を定義します。
  # 用途: データベースエンジンの動作を制御するパラメータを設定
  # 関連機能: Redshift パラメータ
  #   - クラスターの動作、セキュリティ、パフォーマンスを制御
  #   - 変更可能なパラメータと静的なパラメータがあります
  #   - 静的パラメータの変更にはクラスターの再起動が必要
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html

  # require_ssl パラメータ
  # 設定内容: クライアント接続でSSL/TLSの使用を強制します
  # 設定可能な値: "true" (SSL必須) または "false" (SSL任意)
  # 用途: データベース接続のセキュリティを強化
  # 注意: 本番環境では "true" を推奨
  parameter {
    name  = "require_ssl"
    value = "true"
  }

  # enable_user_activity_logging パラメータ
  # 設定内容: ユーザーアクティビティのログ記録を有効化します
  # 設定可能な値: "true" (ログ記録有効) または "false" (ログ記録無効)
  # 用途: 監査やセキュリティ分析のためにユーザーの操作を記録
  # 注意: S3へのログ記録には追加のIAMロールとS3バケットの設定が必要
  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  # query_group パラメータ
  # 設定内容: デフォルトのクエリグループを指定します
  # 設定可能な値: 任意の文字列 (最大63文字)
  # 用途: ワークロード管理(WLM)でクエリをグループ化して優先度を制御
  # 省略可能: 設定しない場合、クエリは "default" グループに分類されます
  parameter {
    name  = "query_group"
    value = "default"
  }

  # max_concurrency_scaling_clusters パラメータ
  # 設定内容: 同時実行スケーリングで使用できる最大クラスター数を指定
  # 設定可能な値: 0〜10の整数
  # 用途: 読み取りクエリの同時実行性を向上させるためのスケーリング設定
  # 注意: 0に設定すると同時実行スケーリングが無効化されます
  parameter {
    name  = "max_concurrency_scaling_clusters"
    value = "1"
  }

  # statement_timeout パラメータ
  # 設定内容: 単一のSQLステートメントの最大実行時間をミリ秒で指定
  # 設定可能な値: 0 (無制限) または正の整数 (ミリ秒)
  # 用途: 長時間実行クエリを防止してリソースを保護
  # 例: 3600000 = 1時間
  parameter {
    name  = "statement_timeout"
    value = "3600000"
  }

  # wlm_json_configuration パラメータ
  # 設定内容: ワークロード管理(WLM)の設定をJSON形式で定義
  # 設定可能な値: WLM設定を含むJSON文字列
  # 用途: クエリキューの優先度、メモリ割り当て、同時実行性を詳細に制御
  # 注意: 複雑な設定のため、AWS公式ドキュメントを参照して設定してください
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/workload-mgmt-config.html
  # parameter {
  #   name  = "wlm_json_configuration"
  #   value = jsonencode([
  #     {
  #       query_concurrency = 5
  #       memory_percent_to_use = 40
  #     }
  #   ])
  # }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード (例: us-east-1, ap-northeast-1)
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
  #   - https://docs.aws.amazon.com/redshift/latest/mgmt/tagging-resources.html
  tags = {
    Name        = "example-redshift-parameter-group"
    Environment = "production"
    ManagedBy   = "Terraform"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tagsから継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースのID。通常はパラメータグループ名と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動管理します
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: パラメータグループのAmazon Resource Name (ARN)
#
# - id: Redshiftパラメータグループの名前
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
#
# 1. セキュリティのベストプラクティス:
#    - require_ssl を "true" に設定して暗号化通信を強制
#    - enable_user_activity_logging を有効化して監査ログを取得
#
# 2. パフォーマンス最適化:
#    - wlm_json_configuration でワークロード管理を設定
#    - max_concurrency_scaling_clusters で同時実行性を制御
#    - statement_timeout で長時間実行クエリを制限
#
# 3. パラメータグループの適用:
#    resource "aws_redshift_cluster" "example" {
#---------------------------------------------------------------
