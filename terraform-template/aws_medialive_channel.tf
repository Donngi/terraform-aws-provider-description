# Generated: 2026-01-18
# Provider Version: 6.28.0
# 注意: このテンプレートは生成時点の情報です。最新の仕様は公式ドキュメントを確認してください。

# AWS MediaLive Channelリソース
# AWS MediaLiveチャネルを作成・管理します。
# MediaLiveチャネルは、ライブビデオストリームのエンコード、パッケージング、配信を行います。
#
# 注意: このリソースは非常に複雑で、多数の設定オプションがあります。
# このテンプレートでは主要な構造を示していますが、実際のユースケースに応じて
# 詳細な設定が必要になります。
#
# Terraform公式ドキュメント: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_channel

resource "aws_medialive_channel" "example" {
  # name - (Required) チャネルの名前。
  name = "example-medialive-channel"

  # channel_class - (Required) チャネルのクラス。
  # STANDARD: 冗長性のある2つのパイプラインで構成
  # SINGLE_PIPELINE: 1つのパイプラインのみ（コスト削減）
  channel_class = "STANDARD"

  # role_arn - (Optional) チャネルが使用するIAMロールのARN。
  # S3への書き込みやMediaPackageへのアクセスなど、リソースアクセスに必要です。
  role_arn = "arn:aws:iam::123456789012:role/MediaLiveAccessRole"

  # log_level - (Optional) CloudWatch Logsに書き込むログレベル。
  # 有効な値: DISABLED, ERROR, WARNING, INFO, DEBUG
  log_level = "INFO"

  # start_channel - (Optional) チャネルを開始/停止するかどうか。
  # デフォルト: false（チャネルは作成されるが開始されない）
  start_channel = false

  # region - (Optional) このリソースが管理されるリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  region = "us-east-1"

  # tags - (Optional) リソースに割り当てるタグのマップ。
  tags = {
    Environment = "production"
    Purpose     = "live-broadcasting"
  }

  # input_specification - (Required) チャネルのネットワークおよびファイル入力の仕様。
  input_specification {
    # codec - (Required) コーデック。有効な値: AVC, HEVC, MPEG2
    codec = "AVC"

    # input_resolution - (Required) 入力解像度。
    # 有効な値: SD（標準画質）, HD（高画質）, UHD（超高画質）
    input_resolution = "HD"

    # maximum_bitrate - (Required) 最大ビットレート。
    # 有効な値: MAX_10_MBPS, MAX_20_MBPS, MAX_50_MBPS
    maximum_bitrate = "MAX_20_MBPS"
  }

  # destinations - (Required) チャネルの出力先。
  # 少なくとも1つの出力先が必要です。
  destinations {
    # id - (Required) ユーザー指定のID。出力グループまたは出力で使用されます。
    id = "destination1"

    # settings - (Optional) 標準出力の宛先設定。各冗長エンコーダーに1つの宛先。
    # S3、MediaPackage、マルチプレックスなどに出力できます。
    settings {
      # url - (Optional) 宛先を指定するURL。
      # S3の場合: s3://bucket-name/path
      # RTMPの場合: rtmp://server/application
      url = "s3://my-medialive-bucket/output1"
    }

    settings {
      url = "s3://my-medialive-bucket/output2"
    }
  }

  # input_attachments - (Optional) チャネルの入力アタッチメント。
  input_attachments {
    # input_attachment_name - (Optional) アタッチメントのユーザー指定名。
    input_attachment_name = "example-input-attachment"

    # input_id - (Required) 入力のID（aws_medialive_inputリソースのID）。
    input_id = "input-12345678"
  }

  # encoder_settings - (Required) エンコーダー設定。
  # これはMediaLiveチャネルの最も複雑な部分です。
  encoder_settings {
    # timecode_config - (Required) タイムコードの設定。
    timecode_config {
      # source - (Required) タイムコードのソース。
      # 有効な値: EMBEDDED, SYSTEMCLOCK, ZEROBASED
      source = "EMBEDDED"

      # sync_threshold - (Optional) 出力タイムコードが入力タイムコードに再同期されるしきい値（フレーム数）。
      # sync_threshold = 1000000
    }

    # audio_descriptions - (Optional) チャネルのオーディオ説明。
    # 各audio_descriptionは、オーディオセレクターからのオーディオをエンコードする方法を定義します。
    audio_descriptions {
      # name - (Required) このオーディオ説明の名前。
      name = "audio_1"

      # audio_selector_name - (Required) オーディオソースとして使用されるオーディオセレクターの名前。
      audio_selector_name = "default"

      # audio_type_control - (Optional) オーディオタイプの決定方法。
      # audio_type_control = "FOLLOW_INPUT"

      # language_code_control - (Optional) 言語コードの決定方法。
      # language_code_control = "FOLLOW_INPUT"
    }

    # video_descriptions - (Required) ビデオ説明。
    # 各video_descriptionは、ビデオソースをエンコードする方法を定義します。
    video_descriptions {
      # name - (Required) ビデオ説明の名前。
      name = "video_1080p"

      # width - (Optional) 出力ビデオの幅（ピクセル単位）。
      # width = 1920

      # height - (Optional) 出力ビデオの高さ（ピクセル単位）。
      # height = 1080

      # respond_to_afd - (Optional) 入力ビデオに含まれるAFD値への応答方法。
      # respond_to_afd = "NONE"

      # scaling_behavior - (Optional) スケーリングの動作。
      # scaling_behavior = "DEFAULT"

      # sharpness - (Optional) スケーリングに使用されるアンチエイリアスフィルターの強度を変更します。
      # sharpness = 50

      # codec_settings - (Optional) ビデオコーデック設定。
      # H264、H265、フレームキャプチャなどのコーデックを設定できます。
    }

    # output_groups - (Required) 出力グループ。
    # 各output_groupは、特定の出力タイプ（Archive、HLS、MediaPackageなど）を定義します。
    output_groups {
      # output_group_settings - (Required) 出力グループに関連付けられた設定。
      output_group_settings {
        # archive_group_settings - (Optional) アーカイブグループ設定。
        # ファイルベースの出力（S3など）に使用します。
        archive_group_settings {
          # destination - (Required) アーカイブファイルが書き込まれるディレクトリとベースファイル名。
          destination {
            # destination_ref_id - (Required) 宛先の参照ID。
            # destinationsブロックで定義したIDと一致する必要があります。
            destination_ref_id = "destination1"
          }

          # rollover_interval - (Optional) 現在のファイルを閉じて新しいファイルを開始するまでの秒数。
          # rollover_interval = 600
        }
      }

      # outputs - (Required) 出力のリスト。
      outputs {
        # output_name - (Required) 出力を識別するために使用される名前。
        output_name = "output_1"

        # video_description_name - (Optional) ビデオソースとして使用されるビデオ説明の名前。
        video_description_name = "video_1080p"

        # audio_description_names - (Optional) オーディオソースとして使用されるオーディオ説明の名前。
        audio_description_names = ["audio_1"]

        # output_settings - (Required) 出力の設定。
        output_settings {
          # archive_output_settings - (Optional) アーカイブ出力設定。
          archive_output_settings {
            # name_modifier - (Optional) 宛先ファイル名の末尾に連結される文字列。
            # 同じタイプの複数の出力に必要です。
            name_modifier = "_1"

            # extension - (Optional) 出力ファイル拡張子。
            extension = "m2ts"

            # container_settings - (Required) ファイルのコンテナタイプに固有の設定。
            container_settings {
              # m2ts_settings - (Optional) M2TS設定。
              m2ts_settings {
                # audio_buffer_model - (Optional) オーディオバッファモデル。
                # audio_buffer_model = "ATSC"

                # buffer_model - (Optional) バッファモデル。
                # buffer_model = "MULTIPLEX"

                # rate_mode - (Optional) レートモード。
                # rate_mode = "CBR"
              }
            }
          }
        }
      }
    }

    # global_configuration - (Optional) イベント全体に適用される設定。
    # global_configuration {
    #   # input_end_action - (Optional) 現在の入力が完了したときに実行するアクション。
    #   # 有効な値: NONE, SWITCH_AND_LOOP_INPUTS
    #   input_end_action = "NONE"
    #
    #   # output_timing_source - (Optional) フレームの出力レートをペースするソース。
    #   # 有効な値: INPUT_CLOCK, SYSTEM_CLOCK
    #   output_timing_source = "INPUT_CLOCK"
    #
    #   # support_low_framerate_inputs - (Optional) 非常に低いビデオフレームレートのストリームのビデオ入力バッファを調整します。
    #   # support_low_framerate_inputs = "DISABLED"
    # }

    # avail_blanking - (Optional) 広告挿入時のブランキング設定。
    # nielsen_configuration - (Optional) Nielsen設定。
    # motion_graphics_configuration - (Optional) モーショングラフィックス設定。
    # caption_descriptions - (Optional) キャプション説明。
  }

  # cdi_input_specification - (Optional) このチャネルのCDI入力の仕様。
  # cdi_input_specification {
  #   # resolution - (Required) 最大CDI入力解像度。
  #   resolution = "FHD"
  # }

  # maintenance - (Optional) このチャネルのメンテナンス設定。
  # maintenance {
  #   # maintenance_day - (Optional) メンテナンスに使用する曜日。
  #   # 有効な値: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
  #   maintenance_day = "SUNDAY"
  #
  #   # maintenance_start_time - (Optional) メンテナンスが開始される時刻（24時間形式、HH:MM）。
  #   maintenance_start_time = "02:00"
  # }

  # vpc - (Optional) VPC出力の設定。
  # vpc {
  #   # subnet_ids - (Required) VPCサブネットIDのリスト。
  #   # STANDARDチャネルの場合、2つの異なるアベイラビリティゾーン（AZ）にマッピングされたサブネットIDを指定する必要があります。
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # public_address_allocation_ids - (Required) 出力VPCで作成されるENIに関連付けるパブリックアドレス割り当てIDのリスト。
  #   # SINGLE_PIPELINEの場合は1つ、STANDARDチャネルの場合は2つ指定する必要があります。
  #   public_address_allocation_ids = ["eipalloc-12345678", "eipalloc-87654321"]
  #
  #   # security_group_ids - (Optional) 出力VPCネットワークインターフェイスにアタッチする最大5つのEC2 VPCセキュリティグループID。
  #   # 指定しない場合、VPCのデフォルトセキュリティグループが使用されます。
  #   security_group_ids = ["sg-12345678"]
  # }

  # timeouts - タイムアウト設定
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
