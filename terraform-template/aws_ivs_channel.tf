#---------------------------------------------------------------
# Amazon IVS Channel (Interactive Video Service チャンネル)
#---------------------------------------------------------------
#
# Amazon Interactive Video Service (IVS) のライブストリーミングチャンネルを
# プロビジョニングするリソースです。チャンネルはライブ動画ストリームを受信・配信する
# エンドポイントであり、視聴者への配信設定や録画設定を管理します。
#
# AWS公式ドキュメント:
#   - Amazon IVS Low-Latency Streaming概要: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/what-is.html
#   - Channel APIリファレンス: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_Channel.html
#   - CreateChannel APIリファレンス: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_CreateChannel.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivs_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivs_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: チャンネルの名前を指定します。
  # 設定可能な値: 0-128文字の文字列（英数字、ハイフン、アンダースコア）
  # 省略時: Terraformが自動生成します。
  name = "my-ivs-channel"

  # type (Optional)
  # 設定内容: チャンネルタイプを指定します。許容する解像度とビットレートを決定します。
  # 設定可能な値:
  #   - "STANDARD": トランスコードを行い、フルHDまでの解像度をサポート。最大8500 Kbpsのビットレート
  #   - "BASIC": トランスマックスのみ。最大1500 Kbpsのビットレート、480p解像度まで
  #   - "ADVANCED_SD": 高度なSDトランスコード。SDQualityを提供
  #   - "ADVANCED_HD": 高度なHDトランスコード。HDQualityを提供
  # 省略時: "STANDARD" が適用されます。
  # 参考: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/streaming-config.html
  type = "STANDARD"

  #-------------------------------------------------------------
  # レイテンシー設定
  #-------------------------------------------------------------

  # latency_mode (Optional)
  # 設定内容: チャンネルのレイテンシーモードを指定します。
  # 設定可能な値:
  #   - "LOW": 低レイテンシーモード。視聴者とのリアルタイムインタラクションに適しています
  #   - "NORMAL": 通常レイテンシーモード。フルHDまでのブロードキャスト配信に適しています
  # 省略時: "LOW" が適用されます。
  # 参考: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_Channel.html
  latency_mode = "LOW"

  #-------------------------------------------------------------
  # アクセス制御設定
  #-------------------------------------------------------------

  # authorized (Optional)
  # 設定内容: チャンネルをプライベートチャンネルとして設定するかを指定します。
  #           trueに設定すると、視聴の認可が有効になり、再生トークンが必要になります。
  # 設定可能な値:
  #   - true: プライベートチャンネル。再生時に認可トークンが必要
  #   - false: パブリックチャンネル。誰でも視聴可能
  # 省略時: false が適用されます。
  authorized = false

  #-------------------------------------------------------------
  # 録画設定
  #-------------------------------------------------------------

  # recording_configuration_arn (Optional)
  # 設定内容: チャンネルのライブ配信を録画するための録画設定ARNを指定します。
  #           有効なARNを指定すると録画が有効になります。
  # 設定可能な値: 有効な aws_ivs_recording_configuration リソースのARN
  # 省略時: 空文字列（録画が無効）
  # 参考: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_Channel.html
  recording_configuration_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-ivs-channel"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウトが適用されます。
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: チャンネルのAmazon Resource Name (ARN)
#
# - ingest_endpoint: チャンネルの取り込みエンドポイント。
#                    ストリーミングソフトウェアのセットアップ時に使用するサーバー定義の一部。
#
# - playback_url: チャンネルの再生URL。視聴者がストリームを視聴するために使用するURL。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
