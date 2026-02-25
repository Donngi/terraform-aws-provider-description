#---------------------------------------------------------------
# AWS IVS Chat (Interactive Video Service Chat) ロギング設定
#---------------------------------------------------------------
#
# Amazon IVS Chat のロギング設定を管理するリソースです。
# チャットメッセージのログを CloudWatch Logs、Kinesis Firehose、
# または Amazon S3 に転送するための設定を提供します。
#
# IVS Chat ロギング設定の主要な機能:
#   - チャットメッセージのリアルタイムログ転送
#   - CloudWatch Logs、Firehose、S3 の 3 種類の転送先をサポート
#   - ルームごとにロギング設定を関連付けて適用可能
#   - ロギング設定のライフサイクル管理 (作成・更新・削除)
#
# AWS公式ドキュメント:
#   - IVS Chat ロギング: https://docs.aws.amazon.com/ivs/latest/ChatAPIReference/logging-destination.html
#   - IVS Chat API リファレンス: https://docs.aws.amazon.com/ivs/latest/ChatAPIReference/Welcome.html
#   - CreateLoggingConfiguration: https://docs.aws.amazon.com/ivs/latest/ChatAPIReference/API_CreateLoggingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivschat_logging_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivschat_logging_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: ロギング設定の名前を指定します。
  # 設定可能な値: 0〜128文字の文字列。英数字、ハイフン、アンダースコアを使用可能
  # 省略時: AWS により自動的に名前が生成されます
  # 用途: ロギング設定を識別するための分かりやすい名前を指定
  name = "example-ivschat-logging"

  #-------------------------------------------------------------
  # 転送先設定
  #-------------------------------------------------------------

  # destination_configuration (Optional)
  # 設定内容: チャットログの転送先となるサービスの情報を指定します。
  # 用途: チャットメッセージのログをどのサービスに送信するかを定義
  # 注意:
  #   - cloudwatch_logs、firehose、s3 のいずれか 1 つのみ指定可能
  #   - 複数の転送先に送信する場合は複数のロギング設定を作成してください
  # 関連機能: IVS Chat Logging Destination
  #   チャットルームで送受信されたメッセージ、イベント、アクションのログを
  #   指定したサービスに自動的に転送します。
  #   - https://docs.aws.amazon.com/ivs/latest/ChatAPIReference/logging-destination.html
  destination_configuration {
    #-----------------------------------------------------------
    # CloudWatch Logs 転送先設定
    #-----------------------------------------------------------

    # cloudwatch_logs (Optional)
    # 設定内容: CloudWatch Logs へのログ転送設定を指定します。
    # 用途: チャットログを CloudWatch Logs に転送してモニタリングや分析に利用
    # 注意: firehose または s3 と同時に指定することはできません
    cloudwatch_logs {
      # log_group_name (Required)
      # 設定内容: ログを転送する CloudWatch Logs のロググループ名を指定します。
      # 設定可能な値: 有効な CloudWatch Logs ロググループ名
      # 注意:
      #   - ロググループは事前に作成しておく必要があります
      #   - IVS Chat サービスがロググループに書き込む権限を持つ IAM ポリシーが必要です
      log_group_name = "/aws/ivschat/example"
    }

    # firehose (Optional)
    # 設定内容: Kinesis Data Firehose への転送設定を指定します。
    # 用途: チャットログを Firehose 経由で S3、Redshift、OpenSearch 等に転送
    # 注意: cloudwatch_logs または s3 と同時に指定することはできません
    # firehose {
    #   # delivery_stream_name (Required)
    #   # 設定内容: ログを転送する Kinesis Data Firehose のデリバリーストリーム名を指定します。
    #   # 設定可能な値: 有効な Kinesis Data Firehose デリバリーストリーム名
    #   # 注意:
    #   #   - デリバリーストリームは事前に作成しておく必要があります
    #   #   - IVS Chat サービスがストリームにレコードを書き込む権限が必要です
    #   delivery_stream_name = "example-ivschat-delivery-stream"
    # }

    # s3 (Optional)
    # 設定内容: Amazon S3 への転送設定を指定します。
    # 用途: チャットログを S3 バケットに直接保存して長期保管や分析に利用
    # 注意: cloudwatch_logs または firehose と同時に指定することはできません
    # s3 {
    #   # bucket_name (Required)
    #   # 設定内容: ログを保存する S3 バケット名を指定します。
    #   # 設定可能な値: 有効な S3 バケット名
    #   # 注意:
    #   #   - バケットは事前に作成しておく必要があります
    #   #   - IVS Chat サービスがバケットにオブジェクトを書き込む権限が必要です
    #   bucket_name = "example-ivschat-logs-bucket"
    # }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 用途: リソースの識別、分類、コスト配分などに使用
  # 関連機能: AWS リソースタグ付け
  #   プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/ivs/latest/ChatAPIReference/tagging.html
  tags = {
    Name        = "example-ivschat-logging"
    Environment = "production"
    Service     = "ivschat"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーの default_tags から継承されるタグを含む全タグのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  tags_all = null

  # id (Optional, Computed)
  # 設定内容: リソースの ID。通常は ARN と同じ値
  # 注意: 通常は明示的に設定する必要はありません。Terraform が自動管理します
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除時のタイムアウト時間を指定します。
  # 用途: 長時間かかる操作のタイムアウトをカスタマイズする場合に使用
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ロギング設定の Amazon Resource Name (ARN)
#   ロギング設定を一意に識別する ARN。チャットルームへの関連付けに使用されます。
#
# - state: ロギング設定の現在の状態
#   設定可能な値:
#     - "CREATING": 作成中
#     - "CREATE_FAILED": 作成失敗
#     - "DELETING": 削除中
#     - "DELETE_FAILED": 削除失敗
#     - "UPDATING": 更新中
#     - "UPDATE_FAILED": 更新失敗
#     - "ACTIVE": アクティブ (使用可能)
#
# - id: リソース ID (ARN と同じ値)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
