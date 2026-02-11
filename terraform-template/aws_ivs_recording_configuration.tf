#---------------------------------------------------------------
# AWS IVS (Interactive Video Service) Recording Configuration
#---------------------------------------------------------------
#
# Amazon IVS のストリーム録画設定を管理するリソースです。
# チャンネルのストリームを自動的に Amazon S3 に録画するための設定を提供します。
#
# IVS 録画設定の主要な機能:
#   - チャンネルストリームの自動録画
#   - S3 バケットへの録画データ保存
#   - 再接続ウィンドウによる録画の継続性管理
#   - サムネイル画像の自動生成
#
# AWS公式ドキュメント:
#   - IVS 録画設定: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/create-channel-auto-r2s3.html
#   - IVS API リファレンス: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_RecordingConfiguration.html
#   - IVS CreateRecordingConfiguration: https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_CreateRecordingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivs_recording_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivs_recording_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional, Computed)
  # 設定内容: 録画設定の名前を指定します。
  # 設定可能な値: 0〜128文字の文字列。英数字、ハイフン、アンダースコアを含めることができます
  # 省略時: AWS により自動的に名前が生成されます
  # 用途: 録画設定を識別するための分かりやすい名前を指定
  # 関連機能: IVS Recording Configuration Name
  #   複数の録画設定を管理する場合、わかりやすい名前を付けることで識別が容易になります。
  #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_RecordingConfiguration.html
  name = "recording_configuration-1"

  #-------------------------------------------------------------
  # 録画先設定 (必須)
  #-------------------------------------------------------------

  # destination_configuration (Required)
  # 設定内容: 録画されたビデオの保存先となる Amazon S3 バケットの情報を指定します。
  # 用途: チャンネルストリームの録画データを保存する S3 バケットを指定
  # 注意:
  #   - S3 バケットは録画設定と同じリージョンに存在する必要があります
  #   - バケット作成時のアカウントが録画設定を作成するアカウントと一致する必要があります
  #   - IVS サービスリンクロールが自動的に作成され、バケットへの書き込み権限が付与されます
  # 関連機能: IVS Destination Configuration
  #   録画データは HLS 形式で S3 バケットに保存されます。複数のチャンネルで同じ録画設定を共有可能。
  #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_DestinationConfiguration.html
  destination_configuration {
    # s3 (Required)
    # 設定内容: S3 の保存先設定を指定します。
    s3 {
      # bucket_name (Required)
      # 設定内容: 録画されたビデオを保存する S3 バケット名を指定します。
      # 設定可能な値: 有効な S3 バケット名
      # 注意:
      #   - バケットは事前に作成しておく必要があります
      #   - バケットは録画設定と同じリージョンに存在する必要があります
      #   - us-east-1 リージョンで作成する場合、S3 バケットも us-east-1 に配置してください
      # 関連機能: IVS S3 Destination
      #   IVS は指定されたバケットに録画データを自動的にアップロードします。
      #   バケットポリシーは IVS サービスリンクロールにより自動的に設定されます。
      #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/create-channel-auto-r2s3.html
      bucket_name = "ivs-stream-archive"
    }
  }

  #-------------------------------------------------------------
  # 録画再接続ウィンドウ設定
  #-------------------------------------------------------------

  # recording_reconnect_window_seconds (Optional, Computed)
  # 設定内容: ブロードキャストが切断され、指定された間隔内に再接続された場合に、
  #          複数のストリームを単一のブロードキャストとして結合する時間間隔を秒単位で指定します。
  # 設定可能な値: 0〜300 秒
  # 省略時: 0 秒 (再接続時に新しい録画ファイルが作成されます)
  # 用途: ネットワーク問題などによる一時的な切断時に録画の継続性を保つために使用
  # 関連機能: IVS Recording Reconnect Window
  #   配信者の接続が一時的に切断された場合でも、指定時間内に再接続すれば
  #   同じ録画ファイルに継続して記録されます。これにより録画の分断を防ぎます。
  #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_RecordingConfiguration.html
  recording_reconnect_window_seconds = 0

  #-------------------------------------------------------------
  # サムネイル設定
  #-------------------------------------------------------------

  # thumbnail_configuration (Optional)
  # 設定内容: ライブセッションのサムネイル画像の記録を有効/無効化し、
  #          サムネイル生成の間隔を変更するための設定を指定します。
  # 用途: 録画と同時にサムネイル画像を定期的に生成する場合に使用
  # 省略時: サムネイル生成は無効化されます
  # 関連機能: IVS Thumbnail Configuration
  #   サムネイル画像は録画データと同じ S3 バケットに保存されます。
  #   プレビュー画像やタイムラインのサムネイル表示に利用できます。
  #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyAPIReference/API_ThumbnailConfiguration.html
  thumbnail_configuration {
    # recording_mode (Optional, Computed)
    # 設定内容: サムネイル記録モードを指定します。
    # 設定可能な値:
    #   - "DISABLED": サムネイル記録を無効化 (デフォルト)
    #   - "INTERVAL": 定期的にサムネイルを生成
    # 省略時: "DISABLED" が設定されます
    # 注意: "INTERVAL" を指定する場合は target_interval_seconds も設定する必要があります
    recording_mode = "INTERVAL"

    # target_interval_seconds (Optional, Computed)
    # 設定内容: サムネイル生成の目標間隔を秒単位で指定します。
    # 設定可能な値: 1〜86400 秒 (1秒〜24時間)
    # 必須条件: recording_mode が "INTERVAL" の場合のみ設定可能で必須
    # 用途: サムネイル画像の生成頻度を制御
    # 例:
    #   - 60: 1分ごとにサムネイルを生成
    #   - 300: 5分ごとにサムネイルを生成
    #   - 3600: 1時間ごとにサムネイルを生成
    # 関連機能: IVS Thumbnail Interval
    #   指定した間隔でストリームからサムネイル画像が抽出され、S3 に保存されます。
    #   間隔を短くすると詳細なタイムラインを作成できますが、ストレージコストが増加します。
    target_interval_seconds = 60
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード (例: us-east-1, ap-northeast-1, eu-west-1)
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - S3 バケットも同じリージョンに配置する必要があります
  #   - us-east-1 で録画設定を作成する場合、S3 バケットが別リージョンにあると
  #     CREATE_FAILED 状態になる既知の問題があります
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
  #   - https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/tagging.html
  tags = {
    Name        = "example-recording-config"
    Environment = "production"
    Service     = "ivs"
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
  # 設定内容: リソースの作成・削除時のタイムアウト時間を指定します。
  # 用途: 長時間かかる操作のタイムアウトをカスタマイズする場合に使用
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列 (例: "10m", "1h")
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = null

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
# - arn: 録画設定の Amazon Resource Name (ARN)
#   録画設定を一意に識別する ARN。チャンネルへの録画設定の関連付けに使用されます。
#
# - state: 録画設定の現在の状態
#   設定可能な値:
#     - "CREATING": 作成中
#     - "CREATE_FAILED": 作成失敗 (S3 バケットのリージョン不一致などが原因)
#     - "ACTIVE": アクティブ (使用可能)
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#   リソースに割り当てられたすべてのタグのマップ
#
#---------------------------------------------------------------
#
# 1. S3 バケットの準備:
#    録画設定を作成する前に、録画データを保存する S3 バケットを
#    同じリージョンに作成しておく必要があります。
#
# 2. チャンネルへの関連付け:
#    録画設定の ARN を使用して、IVS チャンネルに録画設定を関連付けます:
#---------------------------------------------------------------
