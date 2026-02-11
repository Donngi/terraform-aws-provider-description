#---------------------------------------------------------------
# AWS MediaLive Multiplex Program
#---------------------------------------------------------------
#
# AWS Elemental MediaLive Multiplex Programを管理するリソース。
# Multiplexは複数のプログラムを含むMulti-program Transport Stream (MPTS)を
# 作成するためのMediaLiveエンティティで、最大20のプログラムを含めることができます。
# 各プログラムはMultiplexに接続され、ビデオビットレート（固定または可変）の
# 情報を提供します。
#
# AWS公式ドキュメント:
#   - MediaLive Multiplex概要: https://docs.aws.amazon.com/medialive/latest/ug/mpts-general.html
#   - Multiplexの操作: https://docs.aws.amazon.com/medialive/latest/ug/eml-multiplex.html
#   - Multiplexのセットアップ: https://docs.aws.amazon.com/medialive/latest/ug/setting-up-multiplex.html
#   - API Reference (Programs): https://docs.aws.amazon.com/medialive/latest/apireference/multiplexes-multiplexid-programs-programname.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_multiplex_program
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_multiplex_program" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (Required) Multiplex ID
  # このプログラムが属するMultiplexのID。
  # Multiplexは事前に作成されている必要があります。
  multiplex_id = "example-multiplex-id"

  # (Required) 一意のプログラム名
  # このMultiplex内で一意のプログラム名。
  program_name = "example_program"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # (Optional) リージョン
  # このリソースが管理されるAWSリージョン。
  # 未指定の場合はプロバイダー設定のリージョンがデフォルトで使用されます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = "us-east-1"

  #---------------------------------------------------------------
  # Multiplex Program Settings (Required)
  #---------------------------------------------------------------
  # MPTSの設定情報を提供します。
  # プログラム番号、パイプライン設定、ビデオ設定などを含みます。

  multiplex_program_settings {
    # (Required) 優先チャネルパイプライン
    # 優先されるチャネルパイプラインを指定します。
    # 有効な値: "CURRENTLY_ACTIVE", "PIPELINE_0", "PIPELINE_1"
    preferred_channel_pipeline = "CURRENTLY_ACTIVE"

    # (Required) 一意のプログラム番号
    # このMultiplex内で一意のプログラム番号。
    # プログラムを識別するための数値。
    program_number = 1

    #---------------------------------------------------------------
    # Service Descriptor (Optional)
    #---------------------------------------------------------------
    # サービス記述子の設定。
    # プロバイダー名とサービス名を定義します。

    service_descriptor {
      # (Required) 一意のプロバイダー名
      provider_name = "example_provider"

      # (Required) 一意のサービス名
      service_name = "example_service"
    }

    #---------------------------------------------------------------
    # Video Settings (Optional)
    #---------------------------------------------------------------
    # ビデオストリームの設定。
    # 固定ビットレートまたは統計的多重化(Statmux)設定を指定できます。

    video_settings {
      # (Optional) 固定ビットレート値
      # ビデオストリームの固定ビットレート（bps単位）。
      # statmux_settingsと排他的に使用されます。
      constant_bitrate = 100000

      #---------------------------------------------------------------
      # Statmux Settings (Optional)
      #---------------------------------------------------------------
      # 統計的多重化(Statistical Multiplexing)の設定。
      # 可変ビットレートでビデオストリームを管理する場合に使用します。
      # constant_bitrateと排他的に使用されます。

      # statmux_settings {
      #   # (Optional) 最大ビットレート
      #   # プログラムが使用できる最大ビットレート（bps単位）。
      #   maximum_bitrate = 200000
      #
      #   # (Optional) 最小ビットレート
      #   # プログラムが使用できる最小ビットレート（bps単位）。
      #   minimum_bitrate = 50000
      #
      #   # (Optional) 優先度値
      #   # Multiplex内の他のプログラムと比較した優先度。
      #   # 値が大きいほど優先度が高くなります。
      #   priority = 5
      # }
    }
  }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定

  timeouts {
    # (Optional) 作成時のタイムアウト
    # リソース作成操作のタイムアウト時間。
    # 形式: "30s", "5m", "1h" など（秒、分、時間の単位を使用）
    create = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします（computed only）:
#
# - id: MultiplexProgramのID
#
# これらの属性は出力専用であり、Terraformの設定では指定できません。
#---------------------------------------------------------------
