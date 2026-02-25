#---------------------------------------------------------------
# AWS MediaLive Multiplex Program
#---------------------------------------------------------------
#
# Amazon MediaLive のマルチプレックスプログラムをプロビジョニングするリソースです。
# マルチプレックスプログラムは、マルチプレックス内の個別の番組（チャンネル）を表し、
# MPEG-2トランスポートストリーム内で1つのサービスを定義します。
# 各プログラムはビデオ・オーディオ・データストリームをひとつにまとめ、
# 視聴者が受信できる単一のサービスとして提供されます。
#
# AWS公式ドキュメント:
#   - MediaLive マルチプレックスの操作: https://docs.aws.amazon.com/medialive/latest/ug/working-with-multiplex.html
#   - マルチプレックスプログラムの作成: https://docs.aws.amazon.com/medialive/latest/ug/multiplex-create-program.html
#   - StatMux設定: https://docs.aws.amazon.com/medialive/latest/ug/multiplex-statmux.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_multiplex_program
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_multiplex_program" "example" {
  #-------------------------------------------------------------
  # マルチプレックス識別設定
  #-------------------------------------------------------------

  # multiplex_id (Required)
  # 設定内容: このプログラムを追加するマルチプレックスのIDを指定します。
  # 設定可能な値: 有効なMediaLiveマルチプレックスID（文字列）
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/working-with-multiplex.html
  multiplex_id = "example-multiplex-id"

  # program_name (Required)
  # 設定内容: マルチプレックスプログラムの名前を指定します。
  # 設定可能な値: 一意の文字列。マルチプレックス内でユニークである必要があります。
  # 省略時: 省略不可（必須）
  program_name = "example-program"

  #-------------------------------------------------------------
  # プログラム設定
  #-------------------------------------------------------------

  # multiplex_program_settings (Required)
  # 設定内容: マルチプレックスプログラムの詳細設定を指定します。
  # 設定可能な値: 1つのブロック。プログラム番号、優先チャンネルパイプライン、
  #               サービスディスクリプタ、ビデオ設定を含みます。
  # 参考: https://docs.aws.amazon.com/medialive/latest/ug/multiplex-create-program.html
  multiplex_program_settings {
    # preferred_channel_pipeline (Required)
    # 設定内容: このプログラムが優先的に使用するチャンネルパイプラインを指定します。
    # 設定可能な値:
    #   - "CURRENTLY_ACTIVE" : 現在アクティブなパイプラインを優先
    #   - "PIPELINE_0"       : パイプライン0を優先
    #   - "PIPELINE_1"       : パイプライン1を優先
    # 用途: マルチパイプライン構成での冗長性制御に使用します。
    preferred_channel_pipeline = "CURRENTLY_ACTIVE"

    # program_number (Required)
    # 設定内容: MPEG-2トランスポートストリーム内でのプログラム番号（PMT PID）を指定します。
    # 設定可能な値: 0〜65535 の整数。マルチプレックス内でユニークである必要があります。
    # 用途: 受信機がトランスポートストリーム内の特定プログラムを識別するために使用します。
    program_number = 1

    #-----------------------------------------------------------
    # サービスディスクリプタ設定
    #-----------------------------------------------------------

    # service_descriptor (Optional)
    # 設定内容: DVBサービスディスクリプタ情報を指定します。
    # 設定可能な値: 0または1つのブロック。プロバイダー名とサービス名を含みます。
    # 省略時: サービスディスクリプタなし
    # 用途: DVB規格の受信機がプログラムを識別・表示する際に使用するメタデータです。
    service_descriptor {
      # provider_name (Required)
      # 設定内容: サービスプロバイダーの名前を指定します。
      # 設定可能な値: 最大256文字の文字列
      provider_name = "ExampleProvider"

      # service_name (Required)
      # 設定内容: サービス（チャンネル）の名前を指定します。
      # 設定可能な値: 最大256文字の文字列
      service_name = "ExampleService"
    }

    #-----------------------------------------------------------
    # ビデオ設定
    #-----------------------------------------------------------

    # video_settings (Optional)
    # 設定内容: プログラムのビデオビットレート設定を指定します。
    # 設定可能な値: 0または1つのブロック。
    #               constant_bitrate（固定ビットレート）または statmux_settings（統計的多重化）
    #               のいずれかを指定します。両方を同時に指定することはできません。
    # 省略時: マルチプレックスのデフォルトビデオ設定を使用
    video_settings {
      # constant_bitrate (Optional)
      # 設定内容: ビデオの固定ビットレート（bps）を指定します。
      # 設定可能な値: 有効なビットレート値（整数、bps単位）
      # 省略時: statmux_settings を使用するか、デフォルト値が適用される
      # 注意: constant_bitrate と statmux_settings は排他的です。
      #       statmux_settings を使用する場合は constant_bitrate を省略してください。
      constant_bitrate = null

      # statmux_settings (Optional)
      # 設定内容: 統計的多重化（StatMux）によるビットレート管理設定を指定します。
      # 設定可能な値: 0または1つのブロック。最小/最大ビットレートと優先度を含みます。
      # 省略時: constant_bitrate を使用するか、固定ビットレートが適用される
      # 用途: 複数プログラム間でビットレートを動的に配分し、帯域使用効率を最大化します。
      # 参考: https://docs.aws.amazon.com/medialive/latest/ug/multiplex-statmux.html
      statmux_settings {
        # minimum_bitrate (Optional)
        # 設定内容: StatMux使用時の最小ビットレート（bps）を指定します。
        # 設定可能な値: 有効なビットレート値（整数、bps単位）。maximum_bitrate 以下の値。
        # 省略時: プロバイダーによりデフォルト値が設定される
        minimum_bitrate = null

        # maximum_bitrate (Optional)
        # 設定内容: StatMux使用時の最大ビットレート（bps）を指定します。
        # 設定可能な値: 有効なビットレート値（整数、bps単位）。minimum_bitrate 以上の値。
        # 省略時: プロバイダーによりデフォルト値が設定される
        maximum_bitrate = null

        # priority (Optional)
        # 設定内容: 複数プログラム間でビットレートを配分する際の優先度を指定します。
        # 設定可能な値: -100〜100 の整数。値が大きいほど優先度が高くなります。
        # 省略時: プロバイダーによりデフォルト値が設定される（通常0）
        # 用途: 高優先度のプログラムに帯域を優先的に割り当てる場合に使用します。
        priority = null
      }
    }
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 期間を表す文字列（例: "5m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: マルチプレックスIDとプログラム名を "/" で連結した識別子
#         形式: "<multiplex_id>/<program_name>"
#---------------------------------------------------------------
