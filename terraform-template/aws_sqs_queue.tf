#---------------------------------------------------------------
# Amazon SQS Queue
#---------------------------------------------------------------
#
# Amazon SQS (Simple Queue Service) のキューをプロビジョニングするリソースです。
# SQSは、マイクロサービス、分散システム、サーバーレスアプリケーションの
# 疎結合とスケーリングを実現する、フルマネージド型メッセージキューサービスです。
# Standard（標準）キューとFIFO（先入先出）キューの2種類があり、用途に応じて選択できます。
#
# AWS公式ドキュメント:
#   - Amazon SQS概要: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html
#   - キュータイプ: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-queue-types.html
#   - キュー設定パラメータ: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-queue-parameters.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sqs_queue" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: キューの名前を指定します。
  # 設定可能な値: 大文字・小文字のASCII文字、数字、アンダースコア、ハイフンのみ使用可能。1～80文字。
  #              FIFOキューの場合、名前は `.fifo` サフィックスで終わる必要があります。
  # 省略時: Terraformがランダムで一意な名前を割り当てます。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  # 参考: http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-queue-parameters.html
  name = "terraform-example-queue"

  # name_prefix (Optional)
  # 設定内容: キュー名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

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
  # キュータイプ設定
  #-------------------------------------------------------------

  # fifo_queue (Optional)
  # 設定内容: FIFOキューとして作成するかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): 標準キューとして作成
  #   - true: FIFOキューとして作成。メッセージの順序保証と重複排除が可能
  # 関連機能: FIFO queues
  #   FIFOキューは、メッセージが送信された順序での配信と、exactly-once処理を保証します。
  #   標準キューは、無制限のスループット、at-least-once配信、ベストエフォート順序を提供します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-fifo-queues.html
  fifo_queue = false

  #-------------------------------------------------------------
  # FIFO設定（fifo_queue = true の場合のみ有効）
  #-------------------------------------------------------------

  # content_based_deduplication (Optional)
  # 設定内容: FIFOキューでコンテンツベースの重複排除を有効にするかを指定します。
  # 設定可能な値:
  #   - true: メッセージ本文のSHA-256ハッシュを使用して重複排除IDを自動生成
  #   - false (デフォルト): 送信時に明示的な重複排除IDが必要
  # 関連機能: Exactly-once processing
  #   5分間の重複排除間隔内で、重複メッセージの送信を防止します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/FIFO-queues-exactly-once-processing.html
  # 注意: FIFOキューでのみ有効な設定です。
  content_based_deduplication = null

  # deduplication_scope (Optional)
  # 設定内容: メッセージの重複排除がメッセージグループレベルまたはキューレベルで行われるかを指定します。
  # 設定可能な値:
  #   - "queue" (デフォルト): キュー全体で重複排除
  #   - "messageGroup": メッセージグループごとに重複排除
  # 関連機能: High throughput for FIFO queues
  #   ハイスループットモードで使用される設定です。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/high-throughput-fifo.html
  # 注意: FIFOキューでのみ有効な設定です。
  deduplication_scope = null

  # fifo_throughput_limit (Optional)
  # 設定内容: FIFOキューのスループット制限がキュー全体またはメッセージグループごとに適用されるかを指定します。
  # 設定可能な値:
  #   - "perQueue" (デフォルト): キュー全体にスループット制限を適用
  #   - "perMessageGroupId": メッセージグループごとにスループット制限を適用
  # 関連機能: High throughput for FIFO queues
  #   ハイスループットモードでは、メッセージグループごとに制限を適用することで、
  #   より高いスループットを実現できます。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/high-throughput-fifo.html
  # 注意: FIFOキューでのみ有効な設定です。
  fifo_throughput_limit = null

  #-------------------------------------------------------------
  # メッセージ配信設定
  #-------------------------------------------------------------

  # delay_seconds (Optional)
  # 設定内容: キュー内の全メッセージの配信を遅延させる時間（秒）を指定します。
  # 設定可能な値: 0～900（15分）の整数
  # 省略時: 0秒（遅延なし）
  # 参考: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-delay-queues.html
  delay_seconds = null

  # receive_wait_time_seconds (Optional)
  # 設定内容: ReceiveMessageコールがメッセージを待機する時間（秒）を指定します。
  # 設定可能な値: 0～20（秒）の整数
  # 省略時: 0秒（ロングポーリングなし。即座に返却）
  # 関連機能: Long polling
  #   ロングポーリングを使用することで、空のレスポンスを削減し、コストを削減できます。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-short-and-long-polling.html
  receive_wait_time_seconds = null

  # visibility_timeout_seconds (Optional)
  # 設定内容: メッセージが受信された後、他の受信者から見えなくなる時間（秒）を指定します。
  # 設定可能な値: 0～43200（12時間）の整数
  # 省略時: 30秒
  # 関連機能: Visibility timeout
  #   メッセージ処理中に他のコンシューマーが同じメッセージを受信しないようにします。
  #   処理時間に応じて適切な値を設定することが重要です。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/AboutVT.html
  visibility_timeout_seconds = null

  #-------------------------------------------------------------
  # メッセージサイズと保持期間設定
  #-------------------------------------------------------------

  # max_message_size (Optional)
  # 設定内容: Amazon SQSが受け入れるメッセージの最大サイズ（バイト）を指定します。
  # 設定可能な値: 1024バイト（1 KiB）～1048576バイト（1024 KiB）の整数
  # 省略時: 262144バイト（256 KiB）
  # 参考: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-quotas.html
  max_message_size = null

  # message_retention_seconds (Optional)
  # 設定内容: Amazon SQSがメッセージを保持する時間（秒）を指定します。
  # 設定可能な値: 60（1分）～1209600（14日）の整数
  # 省略時: 345600秒（4日）
  # 参考: https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-queue-parameters.html
  message_retention_seconds = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_master_key_id (Optional)
  # 設定内容: メッセージの暗号化に使用するKMSカスタマーマスターキー（CMK）のIDを指定します。
  # 設定可能な値: AWS管理のCMKまたはカスタムCMKのID/ARN/エイリアス
  # 省略時: 暗号化なし（sqs_managed_sse_enabledがtrueでない限り）
  # 関連機能: Server-side encryption (SSE)
  #   AWS KMS CMKを使用してメッセージを暗号化し、データを保護します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-server-side-encryption.html
  kms_master_key_id = null

  # kms_data_key_reuse_period_seconds (Optional)
  # 設定内容: Amazon SQSがKMSを再度呼び出す前に、データキーを再利用できる時間（秒）を指定します。
  # 設定可能な値: 60（1分）～86400（24時間）の整数
  # 省略時: 300秒（5分）
  # 関連機能: KMS data key reuse
  #   データキーの再利用により、KMS APIコールを削減し、コストを削減できます。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-server-side-encryption.html
  # 注意: kms_master_key_idが設定されている場合のみ有効です。
  kms_data_key_reuse_period_seconds = null

  # sqs_managed_sse_enabled (Optional)
  # 設定内容: SQS所有の暗号化キーを使用したサーバー側暗号化（SSE）を有効にするかを指定します。
  # 設定可能な値:
  #   - true: SQS管理の暗号化を有効化
  #   - false: SQS管理の暗号化を無効化
  # 関連機能: SQS-managed encryption
  #   追加コストなしでメッセージを暗号化します。KMS CMKを使用する必要がない場合に有用です。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-server-side-encryption.html
  # 注意: Terraformは設定ファイルに存在する場合のみドリフト検出を実行します。
  sqs_managed_sse_enabled = null

  #-------------------------------------------------------------
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: SQSキューのIAMポリシーをJSON形式で指定します。
  # 設定可能な値: 有効なIAMポリシードキュメント（JSON形式）
  # 省略時: デフォルトのアクセスポリシー
  # 関連機能: SQS Access Control
  #   他のAWSサービスやアカウントからのアクセスを制御します。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-authentication-and-access-control.html
  # 注意: Terraformは設定ファイルに存在する場合のみドリフト検出を実行します。
  #      aws_sqs_queue_policyリソースの使用が推奨されます。
  policy = null

  #-------------------------------------------------------------
  # Dead Letter Queue設定
  #-------------------------------------------------------------

  # redrive_policy (Optional)
  # 設定内容: Dead Letter Queue（DLQ）の設定をJSON形式で指定します。
  # 設定可能な値: JSON形式のポリシー。以下のパラメータを含みます:
  #   - deadLetterTargetArn: DLQとして使用するキューのARN
  #   - maxReceiveCount: メッセージがDLQに移動されるまでの最大受信回数（整数値として指定）
  # 省略時: DLQなし
  # 関連機能: Dead Letter Queues
  #   処理に失敗したメッセージを別のキューに移動し、分析や再処理を可能にします。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html
  # 注意: Terraformは設定ファイルに存在する場合のみドリフト検出を実行します。
  #      aws_sqs_queue_redrive_policyリソースの使用が推奨されます。
  #      maxReceiveCountは文字列ではなく整数値として指定する必要があります。
  redrive_policy = null

  # redrive_allow_policy (Optional)
  # 設定内容: Dead Letter Queueのredriveアクセス許可ポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式のポリシー。どのソースキューがこのキューをDLQとして使用できるかを制御します。
  # 省略時: 制限なし
  # 関連機能: Dead Letter Queue redrive permission
  #   DLQへのアクセスを制御し、特定のキューのみがDLQとして使用できるようにします。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html
  # 注意: Terraformは設定ファイルに存在する場合のみドリフト検出を実行します。
  #      aws_sqs_queue_redrive_allow_policyリソースの使用が推奨されます。
  redrive_allow_policy = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-queue-tags.html
  tags = {
    Name        = "example-queue"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsから継承されたタグを含む、すべてのタグのマップを指定します。
  # 注意: 通常はプロバイダーレベルのdefault_tagsを使用し、この属性は明示的に設定しません。
  tags_all = null

  # id (Optional)
  # 設定内容: キューのURL。通常は明示的に設定せず、Terraformが自動的に管理します。
  # 注意: この属性はcomputed属性として使用されることが一般的です。
  id = null

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列表現（例: "60s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列表現（例: "60s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    update = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間の文字列表現（例: "60s", "5m", "1h"）
    # 省略時: デフォルトのタイムアウト時間を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: SQSキューのAmazon Resource Name (ARN)
#
# - url: 作成されたAmazon SQSキューのURL（idと同じ値）
#---------------------------------------------------------------
