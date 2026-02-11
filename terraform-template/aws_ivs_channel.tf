#---------------------------------------------------------------
# Amazon IVS (Interactive Video Service) Channel
#---------------------------------------------------------------
#
# Amazon IVS Channel リソースを管理します。
# IVS は低レイテンシのライブビデオストリーミングサービスで、
# このリソースでストリーム配信用のチャネルを作成・設定できます。
#
# AWS公式ドキュメント:
#   - IVS チャネルの作成 (コンソール): https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/create-channel-console.html
#   - IVS チャネルの作成 (CLI): https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/create-channel-cli.html
#   - IVS ストリーミング設定: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/streaming-config.html
#   - IVS プライベートチャネル: https://docs.aws.amazon.com/ivs/latest/LowLatencyUserGuide/private-channels.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivs_channel
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivs_channel" "example" {
  # (Optional) チャネル名
  # 指定しない場合、AWSが自動的に名前を生成します
  name = "my-channel"

  # (Optional) チャネルタイプ
  # チャネルの解像度とビットレートの上限を決定します
  # 有効な値:
  #   - STANDARD: トランスコーディングが有効。複数の品質レベルで配信可能 (デフォルト)
  #   - BASIC: トランスムックス（再エンコードなし）。入力品質がそのまま配信される
  #
  # STANDARD チャネルは視聴者の回線速度に応じた最適な品質を自動選択できます
  # BASIC チャネルはコストが低いですが、単一品質での配信のみです
  type = "STANDARD"

  # (Optional) レイテンシモード
  # ストリーミングの遅延特性を決定します
  # 有効な値:
  #   - NORMAL: 通常レイテンシ（6-15秒）。より安定した配信
  #   - LOW: 低レイテンシ（2-5秒）。よりリアルタイムに近い配信
  #
  # LOW モードは双方向性が必要な用途（ライブコマース、オークション等）に適しています
  latency_mode = "LOW"

  # (Optional) プライベートチャネルの有効化
  # true に設定すると、再生認証が必要なプライベートチャネルになります
  # 視聴には署名付き JWT トークンが必要となり、アクセス制御が可能です
  # 有料配信や限定配信を実装する場合に使用します
  authorized = false

  # (Optional) レコーディング設定の ARN
  # ストリームを S3 に自動録画する場合に、Recording Configuration の ARN を指定します
  # 事前に aws_ivs_recording_configuration リソースを作成しておく必要があります
  #
  # 例: recording_configuration_arn = aws_ivs_recording_configuration.example.arn
  recording_configuration_arn = null

  # (Optional) リージョン指定
  # このリソースが管理されるリージョンを指定します
  # 未指定の場合、プロバイダー設定のリージョンが使用されます
  #
  # 通常は指定不要ですが、マルチリージョン構成で明示的に指定する場合に使用
  region = null

  # (Optional) タグ
  # リソースに割り当てるタグのマップ
  # プロバイダーの default_tags と併用する場合、ここで指定したタグが優先されます
  tags = {
    Environment = "production"
    Service     = "live-streaming"
  }

  # (Optional) タグ（全て）
  # プロバイダーの default_tags で設定されたタグも含む全タグのマップ
  # 通常は指定不要です（Terraform が自動的に管理します）
  # 明示的な上書きが必要な場合のみ使用してください
  # tags_all = {}

  # (Optional) ID
  # Terraform 管理用のリソース識別子
  # 通常は指定不要です（Terraform が自動的に管理します）
  # Import 時など特殊なケースでのみ使用してください
  # id = null

  # (Optional) タイムアウト設定
  # リソース操作のタイムアウト時間をカスタマイズできます
  # timeouts {
  #   create = "5m"
  #   update = "5m"
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed)
#---------------------------------------------------------------
#
# このリソースは以下の属性を出力します（read-only）:
#
# - arn: チャネルの ARN
#   例: output "channel_arn" { value = aws_ivs_channel.example.arn }
#
# - ingest_endpoint: ストリーム送信用のエンドポイント
#   OBS 等の配信ソフトウェアの設定に使用します
#   形式: rtmps://{endpoint}/app/
#   例: output "ingest_endpoint" { value = aws_ivs_channel.example.ingest_endpoint }
#
# - playback_url: ストリーム視聴用の URL
#   視聴アプリケーションで使用します
#   形式: https://{playback_domain}/v1/...m3u8
#   例: output "playback_url" { value = aws_ivs_channel.example.playback_url }
#
# - tags_all: プロバイダーの default_tags を含む全タグのマップ
#   例: output "all_tags" { value = aws_ivs_channel.example.tags_all }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: プライベートチャネルの構成
#---------------------------------------------------------------
#
# resource "aws_ivs_playback_key_pair" "example" {
#   name       = "my-playback-key"
#   public_key = file("${path.module}/public_key.pem")
# }
#
# resource "aws_ivs_channel" "private" {
#   name       = "private-channel"
#   authorized = true
#   type       = "STANDARD"
#
#   tags = {
#     Type = "Private"
#   }
# }
#
# # アプリケーション側で JWT トークンを生成して視聴URLに付与
# # playback_url?token={signed_jwt_token}
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 録画機能付きチャネル
#---------------------------------------------------------------
#
# resource "aws_s3_bucket" "recording" {
#   bucket = "my-ivs-recordings"
# }
#
# resource "aws_ivs_recording_configuration" "example" {
#   name = "my-recording-config"
#   destination_configuration {
#     s3 {
#       bucket_name = aws_s3_bucket.recording.id
#     }
#   }
# }
#
# resource "aws_ivs_channel" "recorded" {
#   name                        = "recorded-channel"
#   type                        = "STANDARD"
#   recording_configuration_arn = aws_ivs_recording_configuration.example.arn
# }
#
#---------------------------------------------------------------
