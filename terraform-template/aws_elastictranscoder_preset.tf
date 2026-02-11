#---------------------------------------------------------------
# Amazon Elastic Transcoder Preset
#---------------------------------------------------------------
#
# Amazon Elastic Transcoder プリセットを定義します。
# プリセットはトランスコーディングジョブで使用する出力ファイルの
# オーディオ・ビデオ・サムネイルの設定をまとめたテンプレートです。
#
# ⚠️ 重要: このリソースは非推奨（deprecated）です。
# AWS Elemental MediaConvertへの移行を推奨します。
# Amazon Elastic Transcoderのサポートは2025年11月13日に終了します。
#
# AWS公式ドキュメント:
#   - Amazon Elastic Transcoder詳細: https://aws.amazon.com/elastictranscoder/details/
#   - MediaConvertへの移行ガイド: https://aws.amazon.com/blogs/media/migrating-workflows-from-elastic-transcoder-to-amazon-elemental-mediaconvert/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastictranscoder_preset
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elastictranscoder_preset" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # container - (必須) 出力ファイルのコンテナタイプ
  # 有効な値: flac, flv, fmp4, gif, mp3, mp4, mpg, mxf, oga, ogg, ts, webm
  # 例: "mp4", "webm", "gif"
  # 変更時は強制的に新規リソースが作成されます
  container = "mp4"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # name - (オプション) プリセットの名前（最大40文字）
  # 指定しない場合はAWSが自動生成します
  # 変更時は強制的に新規リソースが作成されます
  name = "my-preset"

  # description - (オプション) プリセットの説明（最大255文字）
  # 変更時は強制的に新規リソースが作成されます
  description = "Sample preset for video transcoding"

  # video_codec_options - (オプション) ビデオコーデックの追加オプション
  # H.264/VP8/VP9/MPEG2などのコーデック固有の設定をキーバリューで指定します
  # 主なオプション:
  #   - Profile: コーデックプロファイル（H.264/VP8のみ）
  #   - Level: H.264レベル（1, 1b, 1.1, 1.2, 1.3, 2, 2.1, 2.2, 3, 3.1, 3.2, 4, 4.1）
  #   - MaxReferenceFrames: 参照フレームの最大数（0-16, H.264のみ）
  #   - MaxBitRate: 最大ビットレート（16-62500 kbps）
  #   - BufferSize: バッファサイズ（キロビット）
  #   - InterlacedMode: インターレースモード（H.264/MPEG2のみ）
  #   - ColorSpaceConversionMode: 色空間変換（None, Bt709toBt601, Bt601toBt709, Auto）
  #   - ChromaSubsampling: クロマサブサンプリング（yuv420p, yuv422p）
  #   - LoopCount: ループ回数（GIFのみ）
  video_codec_options = {
    Profile                  = "main"
    Level                    = "2.2"
    MaxReferenceFrames       = "3"
    InterlacedMode           = "Progressive"
    ColorSpaceConversionMode = "None"
  }

  # region - (オプション) このリソースを管理するAWSリージョン
  # 指定しない場合はプロバイダー設定のリージョンが使用されます
  # 指定しない場合は自動計算されます
  # region = "us-east-1"

  # type - (オプション) プリセットのタイプ
  # 指定しない場合は自動計算されます
  # type = "Custom"

  # id - (オプション) プリセットのID
  # 指定しない場合は自動計算されます
  # 通常は指定不要で、Terraformが自動生成された値を使用します
  # id = "custom-id"

  #---------------------------------------------------------------
  # オーディオ設定ブロック
  #---------------------------------------------------------------

  # audio - (オプション) オーディオパラメータの設定
  # 変更時は強制的に新規リソースが作成されます
  audio {
    # codec - (オプション) オーディオコーデック
    # 有効な値: AAC, flac, mp2, mp3, pcm, vorbis
    codec = "AAC"

    # sample_rate - (オプション) サンプリングレート（Hz）
    # 有効な値: auto, 22050, 32000, 44100, 48000, 96000
    sample_rate = "44100"

    # bit_rate - (オプション) ビットレート（kbps）
    # 64から320の間の整数を指定
    # 指定しない場合はElastic Transcoderがコーデックに基づいて自動設定
    bit_rate = "96"

    # channels - (オプション) オーディオチャンネル数
    # 例: "1"（モノラル）、"2"（ステレオ）
    channels = "2"

    # audio_packing_mode - (オプション) オーディオチャンネルとトラックの編成方法
    # AudioPackingModeを指定しない場合はSingleTrackが使用されます
    # 有効な値: SingleTrack など
    audio_packing_mode = "SingleTrack"
  }

  #---------------------------------------------------------------
  # オーディオコーデックオプションブロック
  #---------------------------------------------------------------

  # audio_codec_options - (オプション) オーディオコーデックのオプション設定
  # 変更時は強制的に新規リソースが作成されます
  audio_codec_options {
    # profile - (オプション) AACプロファイル
    # codec="AAC"を指定した場合に使用
    # 例: AAC-LC, HE-AAC, HE-AACv2
    profile = "AAC-LC"

    # bit_depth - (オプション) サンプルのビット深度
    # 有効な値: 16, 24（FLAC/PCMのみ）
    # bit_depth = "16"

    # bit_order - (オプション) PCMサンプルのビット順序
    # サポートされる値: LittleEndian（PCMのみ）
    # bit_order = "LittleEndian"

    # signed - (オプション) オーディオサンプルの符号
    # オーディオサンプルを負数と正数（signed）または正数のみ（unsigned）で表現するか
    # サポートされる値: Signed（PCMのみ）
    # signed = "Signed"
  }

  #---------------------------------------------------------------
  # ビデオ設定ブロック
  #---------------------------------------------------------------

  # video - (オプション) ビデオパラメータの設定
  # 変更時は強制的に新規リソースが作成されます
  video {
    # codec - (オプション) ビデオコーデック
    # 有効な値: gif, H.264, mpeg2, vp8, vp9
    codec = "H.264"

    # bit_rate - (オプション) ビデオストリームのビットレート（kbps）
    # 可変ビットレートまたは固定ビットレートを設定可能
    # 指定しない場合はElastic Transcoderが自動設定
    bit_rate = "1600"

    # frame_rate - (オプション) フレームレート（fps）
    # 有効な値: auto, 10, 15, 23.97, 24, 25, 29.97, 30, 50, 60
    frame_rate = "auto"

    # max_frame_rate - (オプション) 最大フレームレート
    # frame_rate="auto"を指定した場合、入力ビデオのフレームレートを使用（最大値まで）
    # 指定しない場合はデフォルトで30が使用されます
    max_frame_rate = "60"

    # max_width - (オプション) 出力ビデオの最大幅（ピクセル）
    # autoを指定するとElastic Transcoderは1920（Full HD）をデフォルト値として使用
    # 数値を指定する場合は128から4096の間の偶数を指定
    max_width = "auto"

    # max_height - (オプション) 出力ビデオの最大高さ（ピクセル）
    # autoを指定するとElastic Transcoderは1080（Full HD）をデフォルト値として使用
    # 数値を指定する場合は96から3072の間の偶数を指定
    max_height = "auto"

    # sizing_policy - (オプション) ビデオのスケーリング方法
    # 有効な値: Fit, Fill, Stretch, Keep, ShrinkToFit, ShrinkToFill
    sizing_policy = "Fit"

    # padding_policy - (オプション) パディングポリシー
    # Padに設定すると、max_widthとmax_heightに合わせるために黒いバーが追加される場合があります
    # 有効な値: Pad, NoPad
    padding_policy = "Pad"

    # display_aspect_ratio - (オプション) 出力ファイルのディスプレイアスペクト比
    # autoに設定すると、Elastic Transcoderは正方形ピクセルを保証するアスペクト比を選択
    # その他のオプションを指定すると、その値が出力ファイルに設定されます
    display_aspect_ratio = "16:9"

    # fixed_gop - (オプション) Video:FixedGOPに固定値を使用するかどうか
    # GIFコンテナには適用されません
    # 有効な値: true, false（キーフレーム間の固定フレーム数）
    fixed_gop = "false"

    # keyframes_max_dist - (オプション) キーフレーム間の最大フレーム数
    # GIFコンテナには適用されません
    keyframes_max_dist = "240"

    # aspect_ratio - (オプション) 出力ファイルのビデオのディスプレイアスペクト比
    # 有効な値: auto, 1:1, 4:3, 3:2, 16:9
    # 注: 出力ビデオの解像度とアスペクト比をより適切に制御するには、
    # resolutionとaspect_ratioの代わりに、max_width, max_height, sizing_policy,
    # padding_policy, display_aspect_ratioの値を使用することを推奨
    # aspect_ratio = "auto"

    # resolution - (オプション) 出力ファイルのビデオの幅と高さ（ピクセル）
    # 有効な値: auto, widthxheight（例: 1920x1080）
    # 注: aspect_ratioの注記を参照
    # resolution = "auto"
  }

  #---------------------------------------------------------------
  # ビデオウォーターマーク設定ブロック
  #---------------------------------------------------------------

  # video_watermarks - (オプション) ビデオパラメータのウォーターマーク設定
  # 最大4つまでのウォーターマーク設定を指定可能
  # 変更時は強制的に新規リソースが作成されます
  video_watermarks {
    # id - (オプション) ウォーターマーク設定の一意な識別子
    # 最大40文字まで指定可能
    id = "Terraform Test"

    # max_width - (オプション) ウォーターマークの最大幅
    # ピクセル数または%で指定（例: "20%", "100px"）
    max_width = "20%"

    # max_height - (オプション) ウォーターマークの最大高さ
    # ピクセル数または%で指定（例: "20%", "100px"）
    max_height = "20%"

    # sizing_policy - (オプション) ウォーターマークのスケーリング方法
    # 有効な値: Fit, Stretch, ShrinkToFit
    sizing_policy = "ShrinkToFit"

    # horizontal_align - (オプション) ウォーターマークの水平位置
    # horizontal_offsetに0以外の値を指定しない限り使用されます
    # 有効な値: Left, Right, Center
    horizontal_align = "Right"

    # horizontal_offset - (オプション) 水平位置のオフセット
    # horizontal_alignで指定した位置からのオフセット量
    # ピクセル数または%で指定（例: "10px", "5%"）
    horizontal_offset = "10px"

    # vertical_align - (オプション) ウォーターマークの垂直位置
    # vertical_offsetに0以外の値を指定しない限り使用されます
    # 有効な値: Top, Bottom, Center
    vertical_align = "Bottom"

    # vertical_offset - (オプション) 垂直位置のオフセット
    # vertical_alignで指定した位置からのオフセット量
    # ピクセル数または%で指定（例: "10px", "5%"）
    vertical_offset = "10px"

    # opacity - (オプション) ウォーターマークの不透明度
    # ウォーターマークが表示される場所でビデオをどの程度隠すかのパーセンテージ
    # 0（完全に透明）から100（完全に不透明）の間の値を指定
    opacity = "55.5"

    # target - (オプション) Elastic Transcoderが値を解釈する方法
    # horizontal_offset, vertical_offset, max_width, max_heightの解釈方法を決定
    # 有効な値: Content, Frame
    target = "Content"
  }

  #---------------------------------------------------------------
  # サムネイル設定ブロック
  #---------------------------------------------------------------

  # thumbnails - (オプション) サムネイルパラメータの設定
  # 変更時は強制的に新規リソースが作成されます
  thumbnails {
    # format - (オプション) サムネイルのフォーマット
    # 有効な値: jpg, png
    format = "png"

    # interval - (オプション) サムネイル間の秒数（おおよその値）
    # 整数値を指定する必要があります
    # 実際の間隔はサムネイルごとに数秒変動する可能性があります
    interval = "120"

    # max_width - (オプション) サムネイルの最大幅（ピクセル）
    # autoを指定するとElastic Transcoderは1920（Full HD）をデフォルト値として使用
    # 数値を指定する場合は32から4096の間の偶数を指定
    max_width = "auto"

    # max_height - (オプション) サムネイルの最大高さ（ピクセル）
    # autoを指定するとElastic Transcoderは1080（Full HD）をデフォルト値として使用
    # 数値を指定する場合は32から3072の間の偶数を指定
    max_height = "auto"

    # sizing_policy - (オプション) サムネイルのスケーリング方法
    # 有効な値: Fit, Fill, Stretch, Keep, ShrinkToFit, ShrinkToFill
    sizing_policy = "Fit"

    # padding_policy - (オプション) パディングポリシー
    # Padに設定すると、max_widthとmax_heightに合わせるために
    # 黒いバーが追加される場合があります
    # 有効な値: Pad, NoPad
    padding_policy = "Pad"

    # aspect_ratio - (オプション) サムネイルのアスペクト比
    # 有効な値: auto, 1:1, 4:3, 3:2, 16:9
    # aspect_ratio = "auto"

    # resolution - (オプション) サムネイルの幅と高さ（ピクセル）
    # WidthxHeight形式で指定（両方とも偶数）
    # videoオブジェクトで指定した幅と高さを超えることはできません
    # 注: サムネイルの解像度とアスペクト比をより適切に制御するには、
    # resolutionとaspect_ratioの代わりに、max_width, max_height,
    # sizing_policy, padding_policyの値を使用することを推奨
    # resolution = "auto"
  }
}

#---------------------------------------------------------------
# Attributes Reference（読み取り専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です:
#
# - arn - Elastic Transcoder PresetのAmazon Resource Name (ARN)
# - id - プリセットのID（指定しない場合は自動生成）
# - name - プリセット名（指定しない場合は自動生成）
# - type - プリセットのタイプ（指定しない場合は自動生成）
#
# 使用例:
# output "preset_arn" {
#   value = aws_elastictranscoder_preset.example.arn
# }
#---------------------------------------------------------------
