#---------------------------------------------------------------
# Amazon QLDB Stream
#---------------------------------------------------------------
#
# Amazon Quantum Ledger Database (QLDB) のストリーム機能を提供し、
# 台帳のジャーナルからドキュメントリビジョンをリアルタイムで
# Amazon Kinesis Data Streams に配信します。
#
# QLDBストリームは、台帳に対するすべてのドキュメントリビジョンを
# 継続的にキャプチャし、指定した期間のデータを Kinesis Data Streams
# を通じて配信することができます。
#
# AWS公式ドキュメント:
#   - QLDB Streams: https://docs.aws.amazon.com/qldb/latest/developerguide/streams.html
#   - Kinesis Data Streams統合: https://docs.aws.amazon.com/streams/latest/dev/using-other-services-quantum-ledger.html
#   - QLDB FAQ: https://aws.amazon.com/qldb/faqs/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/qldb_stream
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_qldb_stream" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # 台帳名
  # ストリームを作成するQLDB台帳の名前を指定します。
  # 事前に作成されている台帳名である必要があります。
  ledger_name = "existing-ledger-name"

  # ストリーム名
  # QLDBジャーナルストリームに割り当てる名前を指定します。
  # ストリーム名は、指定された台帳の他のアクティブなストリーム間で
  # 一意である必要があります。台帳名と同じ命名制約が適用されます。
  # 詳細: https://docs.aws.amazon.com/qldb/latest/developerguide/limits.html#limits.naming
  stream_name = "sample-ledger-stream"

  # IAMロールARN
  # QLDBがジャーナルストリームから Kinesis Data Streams リソースに
  # データレコードを書き込むための権限を付与するIAMロールのARNを指定します。
  # このロールには、Kinesis Data Streams への書き込み権限が必要です。
  role_arn = "arn:aws:iam::123456789012:role/qldb-stream-role"

  # 開始日時（包含的）
  # ジャーナルデータのストリーミングを開始する包含的な開始日時を指定します。
  # ISO 8601形式（UTC）で指定する必要があります。
  # 例: "2019-06-13T21:36:34Z"
  # この値は将来の日時にすることはできず、exclusive_end_time より前である必要があります。
  # 台帳の CreationDateTime より前の値を指定した場合、QLDBは実質的に
  # 台帳の CreationDateTime をデフォルト値として使用します。
  inclusive_start_time = "2021-01-01T00:00:00Z"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # 終了日時（排他的）
  # ストリームが終了する排他的な日時を指定します。
  # このパラメータを定義しない場合、ストリームはキャンセルされるまで
  # 無期限に実行されます。
  # ISO 8601形式（UTC）で指定する必要があります。
  # 例: "2019-06-13T21:36:34Z"
  # exclusive_end_time = "2021-12-31T23:59:59Z"

  # リソースID
  # このリソースの一意識別子を指定します。
  # 通常は自動生成されるため、明示的に指定する必要はありません。
  # 特定のIDを使用する必要がある場合のみ指定します。
  # id = null

  # リージョン
  # このリソースが管理されるリージョンを指定します。
  # デフォルトではプロバイダー設定のリージョンが使用されます。
  # 詳細: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # タグ
  # リソースに割り当てるキーバリューのタグマップを指定します。
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # 一致するキーを持つタグは上書きされます。
  tags = {
    Environment = "production"
    Application = "ledger-streaming"
  }

  # すべてのタグ
  # リソースに割り当てられたすべてのタグのマップを指定します。
  # プロバイダーのdefault_tags設定ブロックから継承されたタグも含まれます。
  # 通常はTerraformが自動的に管理するため、明示的に指定する必要はありません。
  # tags_all = null

  #---------------------------------------------------------------
  # ネストブロック: kinesis_configuration
  #---------------------------------------------------------------

  # Kinesis Data Streams の設定
  # ストリームリクエストの Kinesis Data Streams 宛先の設定を指定します。
  # このブロックは必須です。
  kinesis_configuration {
    # ストリームARN (必須)
    # Kinesis Data Streams リソースのARNを指定します。
    # QLDBストリームがデータを配信する宛先のKinesisストリームです。
    stream_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-kinesis-stream"

    # 集約有効化フラグ (オプション)
    # QLDBが複数のデータレコードを単一の Kinesis Data Streams レコードに
    # 公開できるようにし、API呼び出しごとに送信されるレコード数を増やします。
    # デフォルト: true
    aggregation_enabled = false
  }

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # リソースの作成・削除に関するタイムアウトをカスタマイズできます。
  # timeouts {
  #   # 作成タイムアウト
  #   # リソースの作成処理がタイムアウトするまでの時間を指定します。
  #   # デフォルトでは適切なタイムアウト値が設定されています。
  #   create = "10m"
  #
  #   # 削除タイムアウト
  #   # リソースの削除処理がタイムアウトするまでの時間を指定します。
  #   # デフォルトでは適切なタイムアウト値が設定されています。
  #   delete = "10m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします（computed属性）:
#
# - id
#   QLDB Stream のID。
#
# - arn
#   QLDB Stream のARN（Amazon Resource Name）。
#
# - tags_all
#   リソースに割り当てられたタグのマップ。
#   プロバイダーのdefault_tags設定ブロックから継承されたタグも含まれます。
#
#---------------------------------------------------------------
