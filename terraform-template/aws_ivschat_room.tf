#---------------------------------------------------------------
# Amazon IVS (Interactive Video Service) Chat Room
#---------------------------------------------------------------
#
# Amazon IVS Chat Roomをプロビジョニングします。
# Amazon IVS Chatは、ライブ動画ストリームと併用または独立して使用できる
# マネージド型のライブチャット機能で、チャットルームの作成と
# 参加者間のメッセージング機能を提供します。
#
# AWS公式ドキュメント:
#   - Getting Started with Amazon IVS Chat: https://docs.aws.amazon.com/ivs/latest/ChatUserGuide/getting-started-chat.html
#   - Creating an IVS Chat Room (Console): https://docs.aws.amazon.com/ivs/latest/ChatUserGuide/create-room-console.html
#   - Creating an IVS Chat Room (CLI): https://docs.aws.amazon.com/ivs/latest/ChatUserGuide/create-room-cli.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ivschat_room
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ivschat_room" "example" {
  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # name - (Optional) チャットルームの名前
  # チャットルームを識別するための名前です。
  # 指定しない場合、AWSが自動生成します。
  name = "example-chat-room"

  # region - (Optional) このリソースを管理するAWSリージョン
  # デフォルトではプロバイダー設定で指定されたリージョンが使用されます。
  # 特定のリージョンでリソースを作成したい場合に明示的に指定します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-west-2"

  #---------------------------------------------------------------
  # メッセージ制限設定
  #---------------------------------------------------------------

  # maximum_message_length - (Optional) 単一メッセージの最大文字数
  # メッセージはUTF-8エンコードされることが期待され、
  # この制限はバイト数ではなくrune/コードポイント数に適用されます。
  # デフォルト値が設定されているため、明示的に指定しない場合はデフォルトが使用されます。
  # maximum_message_length = 500

  # maximum_message_rate_per_second - (Optional) 1秒あたりの最大メッセージ送信数
  # すべてのクライアントがルームに送信できる1秒あたりのメッセージ数の上限です。
  # レート制限により、スパムや過剰な負荷を防ぐことができます。
  # デフォルト値が設定されているため、明示的に指定しない場合はデフォルトが使用されます。
  # maximum_message_rate_per_second = 10

  #---------------------------------------------------------------
  # ロギング設定
  #---------------------------------------------------------------

  # logging_configuration_identifiers - (Optional) ロギング設定ARNのリスト
  # チャットルームに関連付けるロギング設定のARNを指定します。
  # Amazon S3、CloudWatch Logs、Kinesis Data Firehoseにメッセージをログ出力できます。
  # 複数のロギング先を指定することが可能です。
  # logging_configuration_identifiers = [
  #   "arn:aws:ivschat:us-west-2:123456789012:logging-configuration/abcd1234efgh5678"
  # ]

  #---------------------------------------------------------------
  # メッセージレビューハンドラー
  #---------------------------------------------------------------

  # message_review_handler - (Optional) メッセージの任意レビュー設定
  # Lambda関数を使用してメッセージをレビューし、許可または拒否する機能を提供します。
  # コンテンツモデレーションやフィルタリングに使用できます。
  # message_review_handler {
  #   # uri - (Optional) メッセージレビューハンドラーLambda関数のARN
  #   # メッセージを処理するLambda関数のARNを指定します。
  #   uri = "arn:aws:lambda:us-west-2:123456789012:function:chat-message-review"
  #
  #   # fallback_result - (Optional) フォールバック時の動作
  #   # Lambda関数が有効なレスポンスを返さない場合、エラーが発生した場合、
  #   # またはタイムアウトした場合のフォールバック動作を指定します。
  #   # 有効な値: ALLOW (メッセージを許可), DENY (メッセージを拒否)
  #   fallback_result = "DENY"
  # }

  #---------------------------------------------------------------
  # タグ設定
  #---------------------------------------------------------------

  # tags - (Optional) リソースに割り当てるタグのマップ
  # リソースの整理、コスト配分、アクセス制御などに使用します。
  # プロバイダーレベルでdefault_tagsが設定されている場合、
  # 同じキーを持つタグはここで指定した値で上書きされます。
  tags = {
    Environment = "production"
    Application = "live-chat"
    ManagedBy   = "terraform"
  }

  # tags_all - (Optional) リソースに割り当てられる全タグのマップ
  # プロバイダーのdefault_tagsとリソースのtagsを結合したものです。
  # 通常、明示的に設定する必要はありません。Terraformが自動的に管理します。
  # tags_all は computed 属性として扱われることが多いため、コメントアウトしています。

  # id - (Optional) リソースのID
  # Terraformが自動的に管理するため、通常は明示的に設定する必要はありません。
  # インポート時など特殊なケースでのみ使用されます。

  #---------------------------------------------------------------
  # タイムアウト設定
  #---------------------------------------------------------------

  # timeouts - (Optional) リソース操作のタイムアウト設定
  # Terraformがリソースの作成、更新、削除を待機する最大時間を指定します。
  # timeouts {
  #   # create - (Optional) リソース作成のタイムアウト
  #   create = "5m"
  #
  #   # update - (Optional) リソース更新のタイムアウト
  #   update = "5m"
  #
  #   # delete - (Optional) リソース削除のタイムアウト
  #   delete = "5m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (computed only - 出力専用属性)
#---------------------------------------------------------------
#
# このセクションの属性は、リソース作成後にTerraformによって自動的に設定されます。
# これらの値は入力として設定できず、出力としてのみ参照可能です。
#
# - arn
#   チャットルームのARN (Amazon Resource Name)
#   例: arn:aws:ivschat:us-west-2:123456789012:room/abcd1234efgh5678
#   他のAWSリソースでこのチャットルームを参照する際に使用します。
#
#---------------------------------------------------------------
# Output例
#---------------------------------------------------------------
#
# output "ivschat_room_arn" {
#   description = "The ARN of the IVS Chat Room"
#   value       = aws_ivschat_room.example.arn
# }
#
# output "ivschat_room_id" {
#   description = "The ID of the IVS Chat Room"
#   value       = aws_ivschat_room.example.id
# }
#
#---------------------------------------------------------------
