#---------------------------------------------------------------
# AWS Elemental MediaLive チャンネル
#---------------------------------------------------------------
#
# AWS Elemental MediaLive のライブビデオチャンネルをプロビジョニングするリソースです。
# MediaLive チャンネルは、入力ソースを受信し、エンコーダー設定に基づいてビデオを
# トランスコードして出力先へ配信します。HLS、RTMP、アーカイブなど複数の出力形式と
# 配信先に対応しています。
#
# AWS公式ドキュメント:
#   - MediaLive チャンネル: https://docs.aws.amazon.com/medialive/latest/ug/channels.html
#   - チャンネルの作成: https://docs.aws.amazon.com/medialive/latest/ug/creating-channel-scratch.html
#   - エンコーダー設定: https://docs.aws.amazon.com/medialive/latest/ug/encoder-settings.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/medialive_channel
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_medialive_channel" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: チャンネルの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-channel"

  # channel_class (Required)
  # 設定内容: チャンネルクラスを指定します。冗長性とコストに影響します。
  # 設定可能な値:
  #   - "STANDARD": 2つのパイプラインを持つ標準チャンネル（冗長性あり）
  #   - "SINGLE_PIPELINE": 1つのパイプラインを持つシングルパイプラインチャンネル（低コスト）
  channel_class = "STANDARD"

  # role_arn (Optional)
  # 設定内容: MediaLive がリソースにアクセスするために引き受けるIAMロールのARNを指定します。
  # 設定可能な値: IAMロールのARN
  role_arn = "arn:aws:iam::123456789012:role/MediaLiveAccessRole"

  # log_level (Optional)
  # 設定内容: MediaLive がCloudWatch Logsに送信するログのレベルを指定します。
  # 設定可能な値:
  #   - "DISABLED": ログを送信しない
  #   - "ERROR": エラーのみ
  #   - "WARNING": 警告以上
  #   - "INFO": 情報以上
  #   - "DEBUG": デバッグ以上（詳細）
  # 省略時: AWSのデフォルト値が適用されます
  log_level = "ERROR"

  # start_channel (Optional)
  # 設定内容: Terraformリソース作成後にチャンネルを自動的に開始するかどうかを指定します。
  # 設定可能な値: true, false
  # 省略時: false（チャンネルは停止状態で作成されます）
  start_channel = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "example-channel"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # CDI入力仕様
  #-------------------------------------------------------------

  # cdi_input_specification (Optional)
  # 設定内容: CDI（クラウドデジタルインターフェース）入力の仕様を指定します。
  #          CDI入力を使用する場合にのみ必要です。
  cdi_input_specification {
    # resolution (Required)
    # 設定内容: CDI入力の最大解像度を指定します。
    # 設定可能な値:
    #   - "SD": 標準解像度（480p以下）
    #   - "HD": 高解像度（1080p以下）
    #   - "FHD": フルHD（1080p）
    #   - "UHD": 超高解像度（2160p/4K）
    resolution = "HD"
  }

  #-------------------------------------------------------------
  # 入力仕様
  #-------------------------------------------------------------

  # input_specification (Optional)
  # 設定内容: チャンネルが受け付ける入力の最大仕様を指定します。
  #          課金はこの仕様に基づいて行われます。
  input_specification {
    # codec (Required)
    # 設定内容: 入力に使用するコーデックを指定します。
    # 設定可能な値:
    #   - "MPEG2": MPEG-2 コーデック
    #   - "AVC": H.264/AVC コーデック
    #   - "HEVC": H.265/HEVC コーデック
    codec = "AVC"

    # input_resolution (Required)
    # 設定内容: 入力の最大解像度を指定します。
    # 設定可能な値:
    #   - "SD": 標準解像度（480p以下）
    #   - "HD": 高解像度（720p〜1080p）
    #   - "UHD": 超高解像度（2160p/4K）
    input_resolution = "HD"

    # maximum_bitrate (Required)
    # 設定内容: 入力の最大ビットレートを指定します。
    # 設定可能な値:
    #   - "MAX_10_MBPS": 最大10Mbps
    #   - "MAX_20_MBPS": 最大20Mbps
    #   - "MAX_50_MBPS": 最大50Mbps
    maximum_bitrate = "MAX_20_MBPS"
  }

  #-------------------------------------------------------------
  # メンテナンス設定
  #-------------------------------------------------------------

  # maintenance (Optional)
  # 設定内容: チャンネルのメンテナンスウィンドウを指定します。
  #          Standardチャンネルのみ設定可能です。
  maintenance {
    # maintenance_day (Required)
    # 設定内容: メンテナンスを行う曜日を指定します。
    # 設定可能な値:
    #   - "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    maintenance_day = "MONDAY"

    # maintenance_start_time (Required)
    # 設定内容: メンテナンスを開始するUTC時刻を指定します。
    # 設定可能な値: "HH:MM" 形式の時刻文字列（例: "01:00"）
    maintenance_start_time = "01:00"
  }

  #-------------------------------------------------------------
  # 出力先設定
  #-------------------------------------------------------------

  # destinations (Required, min_items: 1)
  # 設定内容: チャンネルの出力先を指定します。
  #          複数の出力先を定義できます。
  destinations {
    # id (Required)
    # 設定内容: この出力先の一意の識別子を指定します。
    #          encoder_settings 内の出力設定から参照されます。
    # 設定可能な値: 任意の文字列
    id = "destination1"

    # settings (Optional)
    # 設定内容: 出力先のURL設定を指定します。
    #          STANDARDクラスでは2つのsettingsブロックが必要です。
    settings {
      # url (Optional)
      # 設定内容: 出力先のURLを指定します。
      # 設定可能な値: 有効なURL文字列（例: rtmp://example.com/live/stream）
      url = "s3://my-bucket/output/"

      # stream_name (Optional)
      # 設定内容: RTMPストリーム名を指定します（RTMP出力時に使用）。
      # 設定可能な値: 文字列
      stream_name = null

      # username (Optional)
      # 設定内容: 認証が必要な場合のユーザー名を指定します。
      # 設定可能な値: 文字列
      username = null

      # password_param (Optional)
      # 設定内容: AWS Systems Manager パラメータストアのパラメータ名を指定します。
      #          パスワードはパラメータストアから安全に取得されます。
      # 設定可能な値: SSMパラメータ名（例: /medialive/stream-password）
      password_param = null
    }

    settings {
      url      = "s3://my-bucket-secondary/output/"
      username = null
    }

    # media_package_settings (Optional)
    # 設定内容: MediaPackageチャンネルへの出力設定を指定します。
    # media_package_settings {
    #   # channel_id (Required)
    #   # 設定内容: MediaPackageチャンネルのIDを指定します。
    #   channel_id = "my-mediapackage-channel"
    # }

    # multiplex_settings (Optional, max_items: 1)
    # 設定内容: MediaLive Multiplexへの出力設定を指定します。
    # multiplex_settings {
    #   # multiplex_id (Required)
    #   # 設定内容: 出力先のMultiplex IDを指定します。
    #   multiplex_id = "multiplex-12345"
    #
    #   # program_name (Required)
    #   # 設定内容: Multiplex内のプログラム名を指定します。
    #   program_name = "my-program"
    # }
  }

  #-------------------------------------------------------------
  # 入力接続設定
  #-------------------------------------------------------------

  # input_attachments (Optional)
  # 設定内容: チャンネルに接続する入力ソースを指定します。
  input_attachments {
    # input_attachment_name (Required)
    # 設定内容: この入力接続の名前を指定します。チャンネル内で一意である必要があります。
    # 設定可能な値: 文字列
    input_attachment_name = "primary-input"

    # input_id (Required)
    # 設定内容: 接続するMediaLive入力リソースのIDを指定します。
    # 設定可能な値: aws_medialive_input リソースのID
    input_id = "input-12345678"

    # input_settings (Optional, max_items: 1)
    # 設定内容: 入力の処理設定を指定します。
    input_settings {
      # source_end_behavior (Optional)
      # 設定内容: 入力ソースが終了した場合の動作を指定します。
      # 設定可能な値:
      #   - "CONTINUE": 次のスケジュールアクションまで待機
      #   - "LOOP": 入力を最初から繰り返す
      source_end_behavior = "CONTINUE"

      # input_filter (Optional)
      # 設定内容: 入力フィルターの適用方法を指定します。
      # 設定可能な値:
      #   - "AUTO": 自動適用
      #   - "DISABLED": フィルター無効
      #   - "FORCED": 強制適用
      # 省略時: AUTO
      input_filter = "AUTO"

      # filter_strength (Optional)
      # 設定内容: 入力フィルターの強度を指定します（input_filter が "FORCED" の場合に有効）。
      # 設定可能な値: 1〜5 の整数
      filter_strength = 1

      # deblock_filter (Optional)
      # 設定内容: デブロックフィルターの有効化を指定します。
      # 設定可能な値: "DISABLED", "ENABLED"
      deblock_filter = "DISABLED"

      # denoise_filter (Optional)
      # 設定内容: デノイズフィルターの有効化を指定します。
      # 設定可能な値: "DISABLED", "ENABLED"
      denoise_filter = "DISABLED"

      # smpte2038_data_preference (Optional)
      # 設定内容: SMPTE-2038データの処理設定を指定します。
      # 設定可能な値: "IGNORE", "PREFER"
      smpte2038_data_preference = null

      # scte35_pid (Optional)
      # 設定内容: SCTE-35メッセージを含むPIDを指定します。
      # 設定可能な値: 整数値のPID番号
      scte35_pid = null

      # audio_selector (Optional)
      # 設定内容: 入力から選択するオーディオストリームの設定を指定します。
      audio_selector {
        # name (Required)
        # 設定内容: このオーディオセレクターの名前を指定します。
        #          audio_descriptions の audio_selector_name から参照されます。
        name = "audio-selector-1"

        # selector_settings (Optional, max_items: 1)
        # 設定内容: オーディオストリームの選択方法を指定します。
        # selector_settings {
        #   # audio_language_selection (max_items: 1)
        #   audio_language_selection {
        #     language_code = "jpn"
        #     language_selection_policy = "STRICT"
        #   }
        #   # audio_pid_selection (max_items: 1)
        #   audio_pid_selection {
        #     pid = 101
        #   }
        #   # audio_track_selection (max_items: 1)
        #   audio_track_selection {
        #     tracks { track = 1 }
        #   }
        # }
      }
    }

    # automatic_input_failover_settings (Optional, max_items: 1)
    # 設定内容: 自動入力フェイルオーバーの設定を指定します。
    #          プライマリ入力に障害が発生した場合にセカンダリ入力に自動切り替えします。
    # automatic_input_failover_settings {
    #   # secondary_input_id (Required)
    #   # 設定内容: フェイルオーバー先のセカンダリ入力IDを指定します。
    #   secondary_input_id = "input-secondary"
    #
    #   # error_clear_time_msec (Optional)
    #   # 設定内容: エラークリアまでの時間（ミリ秒）を指定します。
    #   error_clear_time_msec = 1000
    #
    #   # input_preference (Optional)
    #   # 設定内容: 入力優先設定を指定します。
    #   # 設定可能な値: "EQUAL_INPUT_PREFERENCE", "PRIMARY_INPUT_PREFERRED"
    #   input_preference = "EQUAL_INPUT_PREFERENCE"
    #
    #   # failover_condition (Optional)
    #   # 設定内容: フェイルオーバーをトリガーする条件を指定します。
    #   failover_condition {
    #     failover_condition_settings {
    #       input_loss_settings { input_loss_threshold_msec = 3000 }
    #       audio_silence_settings {
    #         audio_selector_name = "audio-selector-1"
    #         audio_silence_threshold_msec = 5000
    #       }
    #       video_black_settings {
    #         black_detect_threshold = 0.1
    #         video_black_threshold_msec = 3000
    #       }
    #     }
    #   }
    # }
  }

  #-------------------------------------------------------------
  # エンコーダー設定
  #-------------------------------------------------------------

  # encoder_settings (Optional, max_items: 1)
  # 設定内容: チャンネルのエンコーダー設定を指定します。
  #          映像・音声・キャプションの出力設定を定義します。
  encoder_settings {
    #-----------------------------------------------------------
    # タイムコード設定
    #-----------------------------------------------------------
    # timecode_config (Required)
    # 設定内容: 出力のタイムコード設定を指定します。
    timecode_config {
      # source (Required)
      # 設定内容: タイムコードのソースを指定します。
      # 設定可能な値:
      #   - "EMBEDDED": 入力ストリームに埋め込まれたタイムコードを使用
      #   - "SYSTEMCLOCK": システムクロックを使用
      #   - "ZEROBASED": ゼローベースのタイムコードを使用
      source = "EMBEDDED"

      # sync_threshold (Optional)
      # 設定内容: タイムコードの同期しきい値（フレーム数）を指定します。
      # 設定可能な値: 整数（フレーム数）
      # 省略時: AWSのデフォルト値が適用されます
      sync_threshold = null
    }

    #-----------------------------------------------------------
    # 音声説明設定
    #-----------------------------------------------------------
    # audio_descriptions (Optional)
    # 設定内容: 出力に含める音声トラックの設定を指定します。
    audio_descriptions {
      # name (Required)
      # 設定内容: この音声説明の名前を指定します。outputs から参照されます。
      name = "audio-description-1"

      # audio_selector_name (Required)
      # 設定内容: input_attachments の audio_selector から参照する名前を指定します。
      audio_selector_name = "audio-selector-1"

      # audio_type (Optional)
      # 設定内容: 音声タイプを指定します。
      # 設定可能な値:
      #   - "CLEAN_EFFECTS": クリーンエフェクト
      #   - "HEARING_IMPAIRED": 聴覚障害者向け
      #   - "UNDEFINED": 未定義
      #   - "VISUAL_IMPAIRED_COMMENTARY": 視覚障害者向けコメンタリー
      audio_type = null

      # audio_type_control (Optional)
      # 設定内容: 音声タイプ制御を指定します。
      # 設定可能な値:
      #   - "FOLLOW_INPUT": 入力の音声タイプに従う
      #   - "USE_CONFIGURED": 設定値を使用
      audio_type_control = null

      # language_code (Optional)
      # 設定内容: 音声の言語コードを指定します（ISO 639-2/B形式）。
      # 設定可能な値: 例 "jpn", "eng", "fra"
      language_code = "jpn"

      # language_code_control (Optional)
      # 設定内容: 言語コードの制御方法を指定します。
      # 設定可能な値:
      #   - "FOLLOW_INPUT": 入力の言語コードに従う
      #   - "USE_CONFIGURED": 設定値を使用
      language_code_control = "USE_CONFIGURED"

      # stream_name (Optional)
      # 設定内容: 音声ストリームの名前を指定します。
      stream_name = null

      # codec_settings (Optional, max_items: 1)
      # 設定内容: 音声コーデック設定を指定します。
      codec_settings {
        # aac_settings (Optional, max_items: 1)
        # 設定内容: AAC音声エンコーディング設定を指定します。
        aac_settings {
          # bitrate (Optional)
          # 設定内容: 音声ビットレート（bps）を指定します。
          # 設定可能な値: 例 64000, 96000, 128000, 192000, 256000, 320000
          bitrate = 192000

          # coding_mode (Optional)
          # 設定内容: チャンネルコーディングモードを指定します。
          # 設定可能な値:
          #   - "AD_RECEIVER_MIX": AD受信ミックス
          #   - "CODING_MODE_1_0": モノラル
          #   - "CODING_MODE_1_1": デュアルモノ
          #   - "CODING_MODE_2_0": ステレオ
          #   - "CODING_MODE_5_1": 5.1チャンネル
          coding_mode = "CODING_MODE_2_0"

          # sample_rate (Optional)
          # 設定内容: サンプリングレート（Hz）を指定します。
          # 設定可能な値: 例 44100, 48000
          sample_rate = 48000

          # profile (Optional)
          # 設定内容: AACプロファイルを指定します。
          # 設定可能な値: "HEV1", "HEV2", "LC"
          profile = null

          # rate_control_mode (Optional)
          # 設定内容: ビットレート制御モードを指定します。
          # 設定可能な値: "CBR", "VBR"
          rate_control_mode = null

          # raw_format (Optional)
          # 設定内容: RAWフォーマット設定を指定します。
          # 設定可能な値: "LATM_LOAS", "NONE"
          raw_format = null

          # spec (Optional)
          # 設定内容: AACスペックを指定します。
          # 設定可能な値: "MPEG2", "MPEG4"
          spec = null

          # vbr_quality (Optional)
          # 設定内容: VBR品質を指定します（rate_control_mode が "VBR" の場合）。
          # 設定可能な値: "HIGH", "LOW", "MEDIUM_HIGH", "MEDIUM_LOW"
          vbr_quality = null

          # input_type (Optional)
          # 設定内容: 入力タイプを指定します。
          # 設定可能な値: "BROADCASTER_MIXED_AD", "NORMAL"
          input_type = null
        }
      }

      # audio_normalization_settings (Optional, max_items: 1)
      # 設定内容: 音声ノーマライゼーション設定を指定します。
      # audio_normalization_settings {
      #   algorithm = "ITU_1770_1"
      #   algorithm_control = "CORRECT_AUDIO"
      #   target_lkfs = -23.0
      # }
    }

    #-----------------------------------------------------------
    # 映像説明設定
    #-----------------------------------------------------------
    # video_descriptions (Optional)
    # 設定内容: 出力に含める映像トラックの設定を指定します。
    video_descriptions {
      # name (Required)
      # 設定内容: この映像説明の名前を指定します。outputs から参照されます。
      name = "video-description-1"

      # width (Optional)
      # 設定内容: 出力映像の幅（ピクセル）を指定します。
      # 設定可能な値: 正の整数
      # 省略時: 入力の幅を使用
      width = 1920

      # height (Optional)
      # 設定内容: 出力映像の高さ（ピクセル）を指定します。
      # 設定可能な値: 正の整数
      # 省略時: 入力の高さを使用
      height = 1080

      # respond_to_afd (Optional)
      # 設定内容: アクティブフォーマット記述子（AFD）への応答を指定します。
      # 設定可能な値: "NONE", "PASSTHROUGH", "RESPOND"
      # 省略時: AWSのデフォルト値が適用されます
      respond_to_afd = null

      # scaling_behavior (Optional)
      # 設定内容: スケーリング動作を指定します。
      # 設定可能な値:
      #   - "DEFAULT": デフォルトのスケーリング
      #   - "STRETCH_TO_OUTPUT": 出力サイズに引き伸ばす
      scaling_behavior = null

      # sharpness (Optional)
      # 設定内容: シャープネスフィルターの強度を指定します。
      # 設定可能な値: 0〜100 の整数
      sharpness = null

      # codec_settings (Optional, max_items: 1)
      # 設定内容: 映像コーデック設定を指定します。
      codec_settings {
        # h264_settings (Optional, max_items: 1)
        # 設定内容: H.264/AVC エンコーディング設定を指定します。
        h264_settings {
          # bitrate (Optional)
          # 設定内容: 映像ビットレート（bps）を指定します。
          # 設定可能な値: 正の整数
          bitrate = 5000000

          # framerate_control (Optional)
          # 設定内容: フレームレート制御方法を指定します。
          # 設定可能な値:
          #   - "INITIALIZE_FROM_SOURCE": 入力のフレームレートを使用
          #   - "SPECIFIED": 指定値を使用（framerate_numerator/denominator が必要）
          framerate_control = "SPECIFIED"

          # framerate_numerator (Optional)
          # 設定内容: フレームレートの分子を指定します（例: 30000/1001 = 29.97fps）。
          framerate_numerator = 30

          # framerate_denominator (Optional)
          # 設定内容: フレームレートの分母を指定します。
          framerate_denominator = 1

          # gop_size (Optional)
          # 設定内容: GOP（グループオブピクチャ）のサイズを指定します。
          # 設定可能な値: 正の数値
          gop_size = 60

          # gop_size_units (Optional)
          # 設定内容: gop_size の単位を指定します。
          # 設定可能な値: "FRAMES", "SECONDS"
          gop_size_units = null

          # rate_control_mode (Optional)
          # 設定内容: レート制御モードを指定します。
          # 設定可能な値: "CBR", "MULTIPLEX", "QVBR", "VBR"
          rate_control_mode = "CBR"

          # profile (Optional)
          # 設定内容: H.264 プロファイルを指定します。
          # 設定可能な値: "BASELINE", "HIGH", "HIGH_10BIT", "HIGH_422", "HIGH_422_10BIT", "MAIN"
          profile = "HIGH"

          # level (Optional)
          # 設定内容: H.264 レベルを指定します。
          # 設定可能な値: "H264_LEVEL_1", "H264_LEVEL_1_1", ..., "H264_LEVEL_5_2", "H264_LEVEL_AUTO"
          level = null

          # entropy_encoding (Optional)
          # 設定内容: エントロピーエンコーディング方式を指定します。
          # 設定可能な値: "CABAC", "CAVLC"
          entropy_encoding = "CABAC"

          # color_metadata (Optional)
          # 設定内容: カラーメタデータの出力設定を指定します。
          # 設定可能な値: "IGNORE", "INSERT"
          color_metadata = null

          # adaptive_quantization (Optional)
          # 設定内容: アダプティブ量子化の強度を指定します。
          # 設定可能な値: "AUTO", "HIGH", "HIGHER", "LOW", "MAX", "MEDIUM", "OFF"
          adaptive_quantization = null

          # afd_signaling (Optional)
          # 設定内容: AFDシグナリングの設定を指定します。
          # 設定可能な値: "AUTO", "FIXED", "NONE"
          afd_signaling = null

          # scan_type (Optional)
          # 設定内容: スキャンタイプを指定します。
          # 設定可能な値: "INTERLACED", "PROGRESSIVE"
          scan_type = null

          # num_ref_frames (Optional)
          # 設定内容: 参照フレーム数を指定します。
          # 設定可能な値: 1〜6 の整数
          num_ref_frames = null
        }
      }
    }

    #-----------------------------------------------------------
    # 出力グループ設定
    #-----------------------------------------------------------
    # output_groups (Optional)
    # 設定内容: 出力グループを指定します。各グループが1つの出力先に対応します。
    output_groups {
      # output_name_modifier (Optional)
      # 設定内容: 出力名に追加するサフィックスを指定します。
      # output_name_modifier = "-1"

      # output_group_settings (Required, max_items: 1)
      # 設定内容: 出力グループの種類と設定を指定します。
      output_group_settings {
        #---------------------------------------------------------
        # HLS出力グループ設定
        #---------------------------------------------------------
        # hls_group_settings (Optional, max_items: 1)
        # 設定内容: HLS（HTTP Live Streaming）出力の設定を指定します。
        hls_group_settings {
          # destination (Required, max_items: 1)
          # 設定内容: HLS出力先の参照IDを指定します。
          destination {
            # destination_ref_id (Required)
            # 設定内容: destinations ブロックの id を参照します。
            destination_ref_id = "destination1"
          }

          # segment_length (Optional)
          # 設定内容: HLSセグメントの長さ（秒）を指定します。
          # 設定可能な値: 正の整数
          # 省略時: AWSのデフォルト値が適用されます
          segment_length = 6

          # index_n_segments (Optional)
          # 設定内容: プレイリストに含めるセグメント数を指定します。
          # 設定可能な値: 正の整数
          index_n_segments = 10

          # keep_segments (Optional)
          # 設定内容: 保持するセグメント数を指定します。
          # 設定可能な値: 正の整数
          keep_segments = 21

          # mode (Optional)
          # 設定内容: HLSライブモードを指定します。
          # 設定可能な値:
          #   - "LIVE": ライブストリーム
          #   - "VOD": VOD（ビデオオンデマンド）
          mode = "LIVE"

          # ts_file_mode (Optional)
          # 設定内容: TSファイルモードを指定します。
          # 設定可能な値:
          #   - "SEGMENTED_FILES": セグメント化されたファイル
          #   - "SINGLE_FILE": 単一ファイル
          ts_file_mode = "SEGMENTED_FILES"

          # manifest_compression (Optional)
          # 設定内容: マニフェストファイルの圧縮設定を指定します。
          # 設定可能な値: "GZIP", "NONE"
          manifest_compression = null

          # manifest_duration_format (Optional)
          # 設定内容: マニフェスト内の時間表現形式を指定します。
          # 設定可能な値: "FLOATING_POINT", "INTEGER"
          manifest_duration_format = null

          # output_selection (Optional)
          # 設定内容: 出力ファイルの選択設定を指定します。
          # 設定可能な値:
          #   - "MANIFESTS_AND_SEGMENTS": マニフェストとセグメント
          #   - "SEGMENTS_ONLY": セグメントのみ
          #   - "VARIANT_MANIFESTS_AND_SEGMENTS": バリアントマニフェストとセグメント
          output_selection = null

          # redundant_manifest (Optional)
          # 設定内容: 冗長マニフェストの有効化を指定します。
          # 設定可能な値: "DISABLED", "ENABLED"
          redundant_manifest = null

          # stream_inf_resolution (Optional)
          # 設定内容: STREAM-INF タグの解像度情報を指定します。
          # 設定可能な値: "EXCLUDE", "INCLUDE"
          stream_inf_resolution = null

          # program_date_time (Optional)
          # 設定内容: EXT-X-PROGRAM-DATE-TIME タグの挿入設定を指定します。
          # 設定可能な値: "EXCLUDE", "INCLUDE"
          program_date_time = null

          # program_date_time_clock (Optional)
          # 設定内容: プログラム日時クロックの設定を指定します。
          # 設定可能な値: "INITIALIZE_FROM_OUTPUT_TIMECODE", "SYSTEM_CLOCK"
          program_date_time_clock = null

          # program_date_time_period (Optional)
          # 設定内容: EXT-X-PROGRAM-DATE-TIME タグの挿入間隔（秒）を指定します。
          program_date_time_period = null

          # input_loss_action (Optional)
          # 設定内容: 入力ロス時の動作を指定します。
          # 設定可能な値:
          #   - "EMIT_OUTPUT": 出力を継続（ブラックフレームまたは前回フレームを使用）
          #   - "PAUSE_OUTPUT": 出力を一時停止
          input_loss_action = null

          # hls_cdn_settings (Optional, max_items: 1)
          # 設定内容: HLS CDN配信設定を指定します。
          # hls_cdn_settings {
          #   hls_s3_settings {
          #     canned_acl = "public-read"
          #   }
          # }
        }
      }

      # outputs (Optional)
      # 設定内容: 出力グループ内の個別の出力設定を指定します。
      outputs {
        # output_name (Optional)
        # 設定内容: この出力の名前を指定します。
        output_name = "output-1"

        # video_description_name (Optional)
        # 設定内容: 使用する映像説明の名前を指定します。
        #          video_descriptions ブロックの name を参照します。
        video_description_name = "video-description-1"

        # audio_description_names (Optional)
        # 設定内容: 使用する音声説明の名前セットを指定します。
        #          audio_descriptions ブロックの name を参照します。
        audio_description_names = ["audio-description-1"]

        # caption_description_names (Optional)
        # 設定内容: 使用するキャプション説明の名前セットを指定します。
        caption_description_names = []

        # output_settings (Required, max_items: 1)
        # 設定内容: 出力フォーマット設定を指定します。
        output_settings {
          # hls_output_settings (Optional, max_items: 1)
          # 設定内容: HLS出力のフォーマット設定を指定します。
          hls_output_settings {
            # name_modifier (Optional)
            # 設定内容: 出力ファイル名に追加する修飾子を指定します。
            name_modifier = "_1"

            # h265_packaging_type (Optional)
            # 設定内容: H.265 パッケージタイプを指定します。
            # 設定可能な値: "HEV1", "HVC1"
            h265_packaging_type = null

            # segment_modifier (Optional)
            # 設定内容: セグメントファイル名に追加する修飾子を指定します。
            segment_modifier = null

            # hls_settings (Required, max_items: 1)
            # 設定内容: HLS固有の出力設定を指定します。
            hls_settings {
              # standard_hls_settings (Optional, max_items: 1)
              # 設定内容: 標準HLS出力設定を指定します。
              standard_hls_settings {
                # audio_rendition_sets (Optional)
                # 設定内容: 音声レンディションセット名を指定します。
                audio_rendition_sets = null

                # m3u8_settings (Required, max_items: 1)
                # 設定内容: M3U8セグメントの設定を指定します。
                m3u8_settings {
                  # audio_frames_per_pes (Optional)
                  # 設定内容: PESパケットあたりの音声フレーム数を指定します。
                  audio_frames_per_pes = null

                  # audio_pids (Optional)
                  # 設定内容: 音声PIDを指定します。
                  audio_pids = null

                  # scte35_behavior (Optional)
                  # 設定内容: SCTE-35の動作を指定します。
                  # 設定可能な値: "NO_PASSTHROUGH", "PASSTHROUGH"
                  scte35_behavior = null

                  # video_pid (Optional)
                  # 設定内容: 映像PIDを指定します。
                  video_pid = null

                  # timed_metadata_behavior (Optional)
                  # 設定内容: タイムドメタデータの動作を指定します。
                  # 設定可能な値: "NO_PASSTHROUGH", "PASSTHROUGH"
                  timed_metadata_behavior = null
                }
              }
            }
          }
        }
      }
    }

    #-----------------------------------------------------------
    # グローバル設定
    #-----------------------------------------------------------
    # global_configuration (Optional, max_items: 1)
    # 設定内容: チャンネル全体のグローバル設定を指定します。
    global_configuration {
      # initial_audio_gain (Optional)
      # 設定内容: 初期音声ゲイン（dB）を指定します。
      # 設定可能な値: -60〜60 の整数
      initial_audio_gain = 0

      # input_end_action (Optional)
      # 設定内容: 入力終了時の動作を指定します。
      # 設定可能な値:
      #   - "NONE": 何もしない
      #   - "SWITCH_AND_LOOP_INPUTS": 入力を切り替えてループ
      input_end_action = "NONE"

      # output_locking_mode (Optional)
      # 設定内容: 出力ロッキングモードを指定します。
      # 設定可能な値:
      #   - "EPOCH_LOCKING": エポックロッキング
      #   - "PIPELINE_LOCKING": パイプラインロッキング
      output_locking_mode = null

      # output_timing_source (Optional)
      # 設定内容: 出力タイミングソースを指定します。
      # 設定可能な値:
      #   - "INPUT_CLOCK": 入力クロック
      #   - "SYSTEM_CLOCK": システムクロック
      output_timing_source = null

      # support_low_framerate_inputs (Optional)
      # 設定内容: 低フレームレート入力のサポートを指定します。
      # 設定可能な値: "DISABLED", "ENABLED"
      support_low_framerate_inputs = null

      # input_loss_behavior (Optional, max_items: 1)
      # 設定内容: 入力ロス時の映像出力動作を指定します。
      input_loss_behavior {
        # black_frame_msec (Optional)
        # 設定内容: ブラックフレームを表示する時間（ミリ秒）を指定します。
        # 設定可能な値: 0〜1000000 の整数
        black_frame_msec = null

        # repeat_frame_msec (Optional)
        # 設定内容: 最後のフレームを繰り返す時間（ミリ秒）を指定します。
        # 設定可能な値: 0〜1000000 の整数
        repeat_frame_msec = null

        # input_loss_image_type (Optional)
        # 設定内容: 入力ロス時に表示する画像タイプを指定します。
        # 設定可能な値: "COLOR", "SLATE"
        input_loss_image_type = null

        # input_loss_image_color (Optional)
        # 設定内容: 入力ロス時に表示する色（HEX形式）を指定します。
        # 設定可能な値: 6文字の16進数カラーコード（例: "000000"）
        input_loss_image_color = null

        # input_loss_image_slate (Optional, max_items: 1)
        # 設定内容: 入力ロス時に表示するスレート画像を指定します。
        # input_loss_image_slate {
        #   uri          = "s3://my-bucket/slate.jpg"
        #   username     = null
        #   password_param = null
        # }
      }
    }

    #-----------------------------------------------------------
    # アベイルブランキング設定
    #-----------------------------------------------------------
    # avail_blanking (Optional, max_items: 1)
    # 設定内容: 広告挿入（SCTE-35）の際の映像ブランキング設定を指定します。
    avail_blanking {
      # state (Optional)
      # 設定内容: アベイルブランキングの有効化を指定します。
      # 設定可能な値: "DISABLED", "ENABLED"
      # 省略時: AWSのデフォルト値が適用されます
      state = "DISABLED"

      # avail_blanking_image (Optional, max_items: 1)
      # 設定内容: ブランキング時に表示する画像を指定します。
      # avail_blanking_image {
      #   uri          = "s3://my-bucket/blanking.jpg"
      #   username     = null
      #   password_param = null
      # }
    }

    #-----------------------------------------------------------
    # キャプション説明設定
    #-----------------------------------------------------------
    # caption_descriptions (Optional)
    # 設定内容: 出力に含めるキャプション（字幕）の設定を指定します。
    # caption_descriptions {
    #   name                  = "caption-1"
    #   caption_selector_name = "caption-selector-1"
    #   language_code         = "jpn"
    #   language_description  = "Japanese"
    #   accessibility         = null
    #   destination_settings {
    #     dvb_sub_destination_settings { ... }
    #   }
    # }

    #-----------------------------------------------------------
    # ニールセン設定
    #-----------------------------------------------------------
    # nielsen_configuration (Optional, max_items: 1)
    # 設定内容: Nielsen ウォーターマーキングのグローバル設定を指定します。
    # nielsen_configuration {
    #   distributor_id            = "my-distributor-id"
    #   nielsen_pcm_to_id3_tagging = "DISABLED"
    # }

    #-----------------------------------------------------------
    # モーショングラフィクス設定
    #-----------------------------------------------------------
    # motion_graphics_configuration (Optional, max_items: 1)
    # 設定内容: HTML モーショングラフィクスの設定を指定します。
    # motion_graphics_configuration {
    #   motion_graphics_insertion = "DISABLED"
    #   motion_graphics_settings {
    #     html_motion_graphics_settings {}
    #   }
    # }
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc (Optional, max_items: 1)
  # 設定内容: チャンネルをVPC内で実行するための設定を指定します。
  #          VPC内チャンネルは作成後に変更できません。
  # vpc {
  #   # subnet_ids (Required)
  #   # 設定内容: チャンネルを配置するサブネットIDのセットを指定します。
  #   # 設定可能な値: VPCサブネットIDのリスト
  #   # 注意: STANDARDクラスでは2つのAZのサブネットが必要です
  #   subnet_ids = ["subnet-12345678", "subnet-87654321"]
  #
  #   # public_address_allocation_ids (Required)
  #   # 設定内容: Elastic IPのアロケーションIDリストを指定します。
  #   # 設定可能な値: Elastic IPアロケーションIDのリスト
  #   public_address_allocation_ids = ["eipalloc-12345678", "eipalloc-87654321"]
  #
  #   # security_group_ids (Optional)
  #   # 設定内容: 適用するセキュリティグループIDのセットを指定します（最大5個）。
  #   # 省略時: VPCのデフォルトセキュリティグループが使用されます
  #   security_group_ids = ["sg-12345678"]
  # }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "30m" などの時間文字列
    # 省略時: デフォルトのタイムアウトが適用されます
    create = "20m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    update = "20m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: チャンネルのARN
#
# - channel_id: チャンネルのID
#
# - id: チャンネルのID（channel_id と同値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vpc.availability_zones: チャンネルが配置されているアベイラビリティゾーンのセット（VPC使用時）
#
# - vpc.network_interface_ids: チャンネルのネットワークインターフェースIDのセット（VPC使用時）
#---------------------------------------------------------------
