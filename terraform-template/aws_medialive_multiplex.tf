#---------------------------------------------------------------
# AWS MediaLive Multiplex
#---------------------------------------------------------------
#
# AWS Elemental MediaLive Multiplexを管理するリソース。
# MediaLive Multiplexは、複数のプログラムを含むマルチプログラムトランスポートストリーム（MPTS）を作成するためのエンティティです。
# MediaConnectを介してRTP/UDP経由でトランスポートストリームコンテンツを配信する際に使用されます。
# 各Multiplexには最大20のプログラムを追加でき、それぞれが専用のMediaLiveチャネルに関連付けられます。
#
# AWS公式ドキュメント:
#   - Working with multiplexes: https://docs.aws.amazon.com/medialive/latest/ug/eml-multiplex.html
#   - Overview of multiplex and MPTS: https://docs.aws.amazon.com/medialive/latest/ug/mpts-general.html
#   - Using MediaLive multiplex to create an MPTS: https://docs.aws.amazon.com/medialive/latest/ug/feature-multiplex.html
#   - Setting up a multiplex: https://docs.aws.amazon.com/medialive/latest/ug/setting-up-multiplex.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_multiplex
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_multiplex" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # Multiplexを配置するAWSアベイラビリティゾーンのリスト
  # 【必須】正確に2つのAZを指定する必要があります
  # 高可用性を確保するため、Multiplexは2つのAZに分散配置されます
  # MediaConnect入力を使用する場合、入力は同じリージョンとAZを使用する必要があります
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Multiplexの名前
  # 【必須】Multiplex識別のための一意の名前
  name = "example-multiplex"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # リソースを管理するAWSリージョン
  # 未指定の場合、プロバイダー設定のリージョンがデフォルトで使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  # Multiplexを開始するかどうか
  # デフォルト: false
  # trueに設定すると、Multiplex作成後に自動的に開始されます
  # falseの場合、後で手動で開始する必要があります
  start_multiplex = true

  # Multiplexに割り当てるタグのマップ
  # プロバイダーのdefault_tags設定ブロックが存在する場合、
  # キーが一致するタグはプロバイダーレベルで定義されたものを上書きします
  tags = {
    Environment = "production"
    Application = "streaming"
  }

  # すべてのタグ（プロバイダーのdefault_tagsとマージされたもの）
  # 通常は明示的に設定せず、tagsとdefault_tagsの自動マージ結果を使用します
  # tags_all = {}

  # Terraform管理用のID
  # 通常は明示的に設定する必要はなく、Terraformが自動生成します
  # id = null

  #---------------------------------------------------------------
  # Nested Blocks
  #---------------------------------------------------------------

  # Multiplexの設定
  # 【必須ブロック】MPTSの全体的なビットレートや設定を定義します
  # 最大1つまで設定可能
  multiplex_settings {
    # トランスポートストリーム全体のビットレート（bps）
    # 【必須】MPTS全体のビットレートを指定します
    # 各プログラムのビットレートの合計がこの値を超えないようにする必要があります
    transport_stream_bitrate = 1000000

    # 各Multiplex固有のID
    # 【必須】各Multiplexを識別するための一意のID
    # トランスポートストリーム内でMultiplexを識別するために使用されます
    transport_stream_id = 1

    # トランスポートストリームの予約ビットレート（bps）
    # オーバーヘッドやバッファリング用に予約されるビットレート
    # transport_stream_reserved_bitrate = 1

    # 最大ビデオバッファ遅延（ミリ秒）
    # ビデオストリームのバッファリングに許容される最大遅延時間
    # デフォルト値が設定されます（未指定時）
    # maximum_video_buffer_delay_milliseconds = 1000
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # 各操作のタイムアウト設定
  # timeouts {
  #   # Multiplex作成のタイムアウト
  #   # デフォルト: 5分
  #   create = "5m"
  #
  #   # Multiplex更新のタイムアウト
  #   # デフォルト: 5分
  #   update = "5m"
  #
  #   # Multiplex削除のタイムアウト
  #   # デフォルト: 5分
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - arn - MultiplexのARN（Amazon Resource Name）
#
# 使用例:
# output "multiplex_arn" {
#   value = aws_medialive_multiplex.example.arn
# }
#---------------------------------------------------------------
