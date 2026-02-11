# ================================================================
# AWS SES Event Destination - 完全リファレンステンプレート
# Provider Version: 6.28.0
# ================================================================
#
# SES Event Destinationは、Amazon SESから送信されたメールイベント（送信、
# バウンス、苦情、配信、開封、クリック、レンダリング失敗など）を、
# Amazon CloudWatch、Amazon Kinesis Firehose、またはAmazon SNSに
# 送信するための設定です。
#
# 主な用途:
# - メール送信の成功/失敗のモニタリング
# - バウンスや苦情の追跡と分析
# - メール開封率やクリック率の測定
# - リアルタイムのメールイベント処理
#
# 重要な注意事項:
# - Event Destinationは必ずConfiguration Setに関連付ける必要があります
# - CloudWatch、Kinesis、SNSのいずれか1つのみを指定できます
#   （複数の宛先には複数のEvent Destinationを作成）
# - matching_typesで指定したイベントタイプのみが送信されます
# - 各宛先タイプには適切なIAM権限が必要です
#
# 参考ドキュメント:
# - https://docs.aws.amazon.com/ses/latest/dg/event-publishing.html
# - https://docs.aws.amazon.com/ses/latest/dg/monitor-using-event-publishing.html
# ================================================================

# ================================================================
# 使用例1: CloudWatch Destinationを使用したイベント追跡
# ================================================================
resource "aws_ses_event_destination" "cloudwatch" {
  # --------------------------------------------------
  # 必須設定項目
  # --------------------------------------------------

  # name - (必須) イベント宛先の名前
  # タイプ: string
  #
  # Event Destinationを識別するための一意の名前を指定します。
  # Configuration Set内で一意である必要があります。
  #
  # 命名規則の推奨:
  # - 宛先タイプを含める（例: cloudwatch-、kinesis-、sns-）
  # - 用途を明確にする（例: bounce-tracking、delivery-monitoring）
  # - 環境を含める（例: -production、-staging）
  #
  # 例:
  # - "cloudwatch-bounce-tracking"
  # - "kinesis-email-analytics"
  # - "sns-complaint-alerts"
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/APIReference/API_EventDestination.html
  name = "event-destination-cloudwatch"

  # configuration_set_name - (必須) Configuration Setの名前
  # タイプ: string
  #
  # このEvent Destinationを関連付けるSES Configuration Setの名前を指定します。
  # Configuration Setは、メール送信時の設定グループで、イベントの
  # パブリッシング先やIPプール設定などを含みます。
  #
  # 重要:
  # - Configuration Setは事前に作成されている必要があります
  # - メール送信時にConfiguration Set名を指定することで、
  #   そのConfiguration Setに関連付けられたEvent Destinationが使用されます
  #
  # 使用例:
  # aws_ses_configuration_set.example.name を参照する場合:
  # configuration_set_name = aws_ses_configuration_set.example.name
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
  configuration_set_name = "example-configuration-set"

  # matching_types - (必須) マッチングするイベントタイプのリスト
  # タイプ: set(string)
  #
  # このEvent Destinationに送信するメールイベントのタイプを指定します。
  #
  # 有効な値:
  # - "send": メール送信試行時（SESがメールを受け入れた時点）
  # - "reject": SESがメールを拒否した時（無効な宛先、送信制限超過など）
  # - "bounce": 配信失敗時（ハードバウンス、ソフトバウンス）
  # - "complaint": 受信者がスパムとして報告した時
  # - "delivery": メールが正常に配信された時
  # - "open": 受信者がメールを開封した時（トラッキングピクセルが必要）
  # - "click": 受信者がメール内のリンクをクリックした時（リンクトラッキングが必要）
  # - "renderingFailure": メールテンプレートのレンダリングに失敗した時
  #
  # イベントタイプの選択ガイド:
  # - 基本的なモニタリング: ["send", "bounce", "complaint", "delivery"]
  # - エンゲージメント分析: ["open", "click"]
  # - トラブルシューティング: ["reject", "renderingFailure"]
  # - 包括的な追跡: 全てのタイプを指定
  #
  # 注意:
  # - "open"と"click"を使用するには、メール送信時にトラッキングを有効化
  #   する必要があります
  # - 複数のイベントタイプを指定できます
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-cloudwatch.html
  matching_types = ["bounce", "send", "complaint", "delivery"]

  # --------------------------------------------------
  # オプション設定
  # --------------------------------------------------

  # enabled - (オプション) イベント宛先を有効化するかどうか
  # タイプ: bool
  # デフォルト: true（API仕様）
  #
  # Event Destinationを有効化または無効化します。
  # 無効化すると、マッチングするイベントはこの宛先に送信されません。
  #
  # 使用例:
  # - 一時的にイベント送信を停止したい場合
  # - テスト環境で本番のイベント収集を停止したい場合
  # - トラブルシューティング時に特定の宛先のみを無効化
  #
  # 注意:
  # - Event Destinationを削除せずに無効化できるため、設定を保持できます
  # - 無効化してもConfiguration Setとの関連付けは維持されます
  enabled = true

  # --------------------------------------------------
  # CloudWatch Destination設定
  # --------------------------------------------------

  # cloudwatch_destination - (オプション) CloudWatch宛先の設定
  # タイプ: set(object)
  #
  # メールイベントをAmazon CloudWatchメトリクスとして送信する設定です。
  # CloudWatchメトリクスを使用することで、以下が可能になります:
  # - ダッシュボードでの可視化
  # - アラームの設定（バウンス率が閾値を超えた場合など）
  # - 履歴データの保存と分析
  #
  # 複数のCloudWatch Destinationを指定することで、複数のメトリクス
  # ディメンションを作成できます（例: メールタイプ別、キャンペーン別）。
  #
  # 重要:
  # - cloudwatch_destination、kinesis_destination、sns_destination
  #   のいずれか1つのみを指定できます
  # - 複数の宛先が必要な場合は、複数のEvent Destinationリソースを
  #   作成してください
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-cloudwatch.html
  cloudwatch_destination {
    # dimension_name - (必須) ディメンションの名前
    # タイプ: string
    #
    # CloudWatchメトリクスのディメンション名を指定します。
    # ディメンションは、メトリクスをグループ化するための名前付きカテゴリです。
    #
    # 推奨されるディメンション名:
    # - "campaign": マーケティングキャンペーン別の分析
    # - "ses:configuration-set": Configuration Set別の分析
    # - "ses:caller-identity": 送信者アイデンティティ別の分析
    # - "ses:from-domain": 送信元ドメイン別の分析
    # - "ses:source-ip": 送信元IP別の分析
    # - カスタム名: "email-type"、"customer-segment" など
    #
    # 注意:
    # - ディメンション名は英数字、ハイフン、アンダースコア、スラッシュ、
    #   ピリオドのみ使用可能
    # - 大文字小文字は区別されます
    #
    # 参考: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#Dimension
    dimension_name = "ses:configuration-set"

    # value_source - (必須) ディメンション値のソース
    # タイプ: string
    # 有効値: "messageTag" | "emailHeader" | "linkTag"
    #
    # CloudWatchメトリクスのディメンション値をどこから取得するかを指定します。
    #
    # オプション詳細:
    #
    # 1. "messageTag":
    #    - メール送信時にAPI経由で渡されるタグから値を取得
    #    - X-SES-MESSAGE-TAGS ヘッダーまたはSESv2 SendEmailリクエストの
    #      EmailTags パラメータで指定
    #    - 最も柔軟性が高く、プログラムから動的に設定可能
    #    - 例: SendEmail時に "campaign=summer-sale" タグを指定
    #
    # 2. "emailHeader":
    #    - メールヘッダーから値を取得
    #    - dimension_name で指定したヘッダー名の値を使用
    #    - 既存のメールヘッダー（From、Subject など）やカスタムヘッダーを
    #      使用可能
    #    - 例: X-Campaign-ID ヘッダーの値をディメンション値として使用
    #
    # 3. "linkTag":
    #    - メール内のリンクに付与されたタグから値を取得
    #    - クリックイベントのトラッキングに使用
    #    - リンクトラッキングが有効な場合のみ使用可能
    #    - 例: リンクに "link-type=cta" タグを付与
    #
    # 選択ガイド:
    # - プログラムから動的に制御したい → "messageTag"
    # - 既存のメールヘッダーを活用したい → "emailHeader"
    # - クリックイベントを分析したい → "linkTag"
    #
    # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-add-event-destination-cloudwatch.html
    value_source = "emailHeader"

    # default_value - (必須) ディメンションのデフォルト値
    # タイプ: string
    #
    # value_source で指定したソースから値が取得できなかった場合に
    # 使用されるデフォルト値を指定します。
    #
    # デフォルト値の使用例:
    # - value_source が "messageTag" で、タグが指定されていない場合
    # - value_source が "emailHeader" で、ヘッダーが存在しない場合
    # - value_source が "linkTag" で、リンクにタグがない場合
    #
    # ベストプラクティス:
    # - "default"、"unspecified"、"unknown" などの明確な値を使用
    # - 未設定の状態を識別できる値を選択
    # - アルファベット順で目立つ位置に来る値を使用（ダッシュボードで見つけやすい）
    #
    # 注意:
    # - 空文字列も有効なデフォルト値として使用可能
    # - デフォルト値が使用された場合、CloudWatchメトリクスには
    #   このデフォルト値でディメンションが設定されます
    #
    # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-add-event-destination-cloudwatch.html
    default_value = "default"
  }

  # 複数のディメンションを設定する例（コメント化）:
  # cloudwatch_destination {
  #   dimension_name = "campaign"
  #   value_source   = "messageTag"
  #   default_value  = "no-campaign"
  # }

  # --------------------------------------------------
  # リージョン設定
  # --------------------------------------------------

  # region - (オプション) このリソースが管理されるリージョン
  # タイプ: string
  # デフォルト: computed（プロバイダー設定のリージョン）
  #
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 重要:
  # - SESはリージョナルサービスです
  # - Configuration SetとEvent Destinationは同じリージョンに
  #   作成する必要があります
  # - SESのサンドボックス設定や送信制限はリージョンごとに管理されます
  #
  # マルチリージョン構成:
  # - 複数のリージョンでメールを送信する場合、各リージョンで
  #   Configuration SetとEvent Destinationを作成する必要があります
  # - CloudWatch、Kinesis、SNSの宛先リソースも同じリージョンに
  #   作成することを推奨
  #
  # 参考: https://docs.aws.amazon.com/general/latest/gr/ses.html
  # region = "us-east-1"
}

# ================================================================
# 使用例2: Kinesis Firehose Destinationを使用したストリーミング
# ================================================================
resource "aws_ses_event_destination" "kinesis" {
  name                   = "event-destination-kinesis"
  configuration_set_name = "example-configuration-set"
  enabled                = true
  matching_types         = ["bounce", "send", "complaint", "delivery"]

  # kinesis_destination - (オプション) Kinesis Firehose宛先の設定
  # タイプ: list(object)
  # 最大項目数: 1
  #
  # メールイベントをAmazon Kinesis Data Firehoseに送信する設定です。
  # Kinesis Firehoseを使用することで、以下が可能になります:
  # - イベントデータのS3への自動保存
  # - Redshift、Elasticsearch、Splunkへのストリーミング
  # - リアルタイムデータ変換とバッチ処理
  # - 大量のイベントデータの効率的な処理
  #
  # 使用例:
  # - メールイベントの長期保存とアーカイブ
  # - ビッグデータ分析基盤への統合
  # - データレイクの構築
  # - リアルタイムアナリティクス
  #
  # 重要:
  # - cloudwatch_destination、kinesis_destination、sns_destination
  #   のいずれか1つのみを指定できます
  # - SESがFirehoseにデータを送信するためのIAMロールが必要です
  #
  # IAM権限要件:
  # - firehose:PutRecord
  # - firehose:PutRecordBatch
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-firehose.html
  kinesis_destination {
    # stream_arn - (必須) Kinesis Firehose配信ストリームのARN
    # タイプ: string
    #
    # メールイベントを送信するKinesis Data Firehose配信ストリームのARNを指定します。
    #
    # フォーマット:
    # arn:aws:firehose:region:account-id:deliverystream/stream-name
    #
    # 使用例:
    # stream_arn = aws_kinesis_firehose_delivery_stream.example.arn
    #
    # 注意:
    # - Firehose配信ストリームは事前に作成されている必要があります
    # - SESと同じリージョンに作成することを推奨（クロスリージョンも可能）
    # - 配信ストリームの宛先（S3、Redshift、Elasticsearch、Splunk）の
    #   容量とスループットを適切に設計してください
    #
    # 参考: https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html
    stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/ses-events"

    # role_arn - (必須) Kinesis FirehoseにアクセスするためのIAMロールのARN
    # タイプ: string
    #
    # SESがKinesis Data Firehoseにイベントを送信するために使用する
    # IAMロールのARNを指定します。
    #
    # フォーマット:
    # arn:aws:iam::account-id:role/role-name
    #
    # 使用例:
    # role_arn = aws_iam_role.ses_kinesis.arn
    #
    # 必要なIAMポリシー:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [
    #     {
    #       "Effect": "Allow",
    #       "Action": [
    #         "firehose:PutRecord",
    #         "firehose:PutRecordBatch"
    #       ],
    #       "Resource": "arn:aws:firehose:region:account-id:deliverystream/stream-name"
    #     }
    #   ]
    # }
    #
    # 信頼関係ポリシー:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [
    #     {
    #       "Effect": "Allow",
    #       "Principal": {
    #         "Service": "ses.amazonaws.com"
    #       },
    #       "Action": "sts:AssumeRole",
    #       "Condition": {
    #         "StringEquals": {
    #           "sts:ExternalId": "YOUR-ACCOUNT-ID"
    #         }
    #       }
    #     }
    #   ]
    # }
    #
    # セキュリティのベストプラクティス:
    # - 最小権限の原則に従い、必要な権限のみを付与
    # - 外部ID（ExternalId）を使用してクロスアカウント攻撃を防止
    # - 定期的にアクセスログを確認
    #
    # 参考: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
    role_arn = "arn:aws:iam::123456789012:role/SESKinesisRole"
  }
}

# ================================================================
# 使用例3: SNS Destinationを使用したアラート通知
# ================================================================
resource "aws_ses_event_destination" "sns" {
  name                   = "event-destination-sns"
  configuration_set_name = "example-configuration-set"
  enabled                = true

  # バウンスと苦情のみをSNSに通知する設定例
  matching_types = ["bounce", "complaint"]

  # sns_destination - (オプション) SNS宛先の設定
  # タイプ: list(object)
  # 最大項目数: 1
  #
  # メールイベントをAmazon SNSトピックに送信する設定です。
  # SNSを使用することで、以下が可能になります:
  # - リアルタイムのメール通知とアラート
  # - Lambda関数の自動トリガー（イベント駆動処理）
  # - 複数のサブスクライバーへの同時通知（Eメール、SMS、HTTP/S、SQS）
  # - 重要なイベント（バウンス、苦情）の即時対応
  #
  # 使用例:
  # - バウンス発生時の管理者への即時通知
  # - 苦情受信時の自動的な送信リストからの削除
  # - Lambda関数を使用した自動リトライロジック
  # - 外部システムへのWebhook通知
  #
  # 重要:
  # - cloudwatch_destination、kinesis_destination、sns_destination
  #   のいずれか1つのみを指定できます
  # - SNSトピックに適切なアクセスポリシーが必要です
  #
  # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-sns.html
  sns_destination {
    # topic_arn - (必須) SNSトピックのARN
    # タイプ: string
    #
    # メールイベントを送信するAmazon SNSトピックのARNを指定します。
    #
    # フォーマット:
    # arn:aws:sns:region:account-id:topic-name
    #
    # 使用例:
    # topic_arn = aws_sns_topic.example.arn
    #
    # SNSトピックのアクセスポリシー例:
    # {
    #   "Version": "2012-10-17",
    #   "Statement": [
    #     {
    #       "Effect": "Allow",
    #       "Principal": {
    #         "Service": "ses.amazonaws.com"
    #       },
    #       "Action": "SNS:Publish",
    #       "Resource": "arn:aws:sns:region:account-id:topic-name",
    #       "Condition": {
    #         "StringEquals": {
    #           "AWS:SourceAccount": "YOUR-ACCOUNT-ID"
    #         },
    #         "StringLike": {
    #           "AWS:SourceArn": "arn:aws:ses:region:account-id:*"
    #         }
    #       }
    #     }
    #   ]
    # }
    #
    # 注意:
    # - SNSトピックは事前に作成されている必要があります
    # - SESと同じリージョンに作成することを推奨（クロスリージョンも可能）
    # - SNSトピックのサブスクリプション（Eメール、Lambda、SQSなど）を
    #   設定する必要があります
    # - SNSトピックの配信ポリシーとリトライポリシーを適切に設定
    #
    # イベントデータ形式:
    # SNSに送信されるメールイベントはJSON形式で、以下のような構造です:
    # {
    #   "eventType": "Bounce",
    #   "bounce": {
    #     "bounceType": "Permanent",
    #     "bounceSubType": "General",
    #     "bouncedRecipients": [...],
    #     "timestamp": "2024-01-15T10:30:00.000Z"
    #   },
    #   "mail": {
    #     "timestamp": "2024-01-15T10:29:50.000Z",
    #     "source": "sender@example.com",
    #     "destination": ["recipient@example.com"],
    #     "messageId": "..."
    #   }
    # }
    #
    # 参考: https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-sns-examples.html
    topic_arn = "arn:aws:sns:us-east-1:123456789012:ses-events-topic"
  }
}

# ================================================================
# 使用例4: 複数のEvent Destinationで異なるイベントタイプを処理
# ================================================================

# CloudWatchで全てのイベントをモニタリング
resource "aws_ses_event_destination" "monitoring" {
  name                   = "monitoring-all-events"
  configuration_set_name = "example-configuration-set"
  enabled                = true
  matching_types         = ["send", "reject", "bounce", "complaint", "delivery", "open", "click", "renderingFailure"]

  cloudwatch_destination {
    dimension_name = "event-type"
    value_source   = "messageTag"
    default_value  = "untagged"
  }
}

# SNSでクリティカルなイベント（バウンス、苦情）のみをアラート通知
resource "aws_ses_event_destination" "critical_alerts" {
  name                   = "critical-event-alerts"
  configuration_set_name = "example-configuration-set"
  enabled                = true
  matching_types         = ["bounce", "complaint", "reject"]

  sns_destination {
    topic_arn = "arn:aws:sns:us-east-1:123456789012:critical-ses-events"
  }
}

# Kinesis Firehoseで全てのイベントを長期保存
resource "aws_ses_event_destination" "archival" {
  name                   = "event-archival"
  configuration_set_name = "example-configuration-set"
  enabled                = true
  matching_types         = ["send", "bounce", "complaint", "delivery", "open", "click"]

  kinesis_destination {
    stream_arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/ses-archive"
    role_arn   = "arn:aws:iam::123456789012:role/SESKinesisArchiveRole"
  }
}

# ================================================================
# 読み取り専用属性（computed attributes）
# ================================================================
# 以下の属性は自動的に計算され、outputs や他のリソースで参照できます

# id - Event Destinationの識別子
# タイプ: string
# 読み取り専用: はい
#
# SES Event Destinationの識別子。通常はEvent Destination名と同じです。
# Terraformリソースの一意識別子として使用されます。
#
# 参照方法: aws_ses_event_destination.cloudwatch.id

# arn - Event DestinationのAmazon Resource Name
# タイプ: string
# 読み取り専用: はい
#
# Event DestinationのAmazon Resource Name（ARN）。
# IAMポリシーやリソースベースのポリシーで使用されます。
#
# フォーマット:
# arn:aws:ses:region:account-id:configuration-set/config-set-name:event-destination/event-destination-name
#
# 使用例:
# - IAMポリシーでのリソース指定
# - CloudFormationスタック間の参照
# - リソースの一意識別
#
# 参照方法: aws_ses_event_destination.cloudwatch.arn

# ================================================================
# Outputs - 他のモジュールやリソースで使用可能
# ================================================================
output "event_destination_cloudwatch_id" {
  description = "CloudWatch Event DestinationのID"
  value       = aws_ses_event_destination.cloudwatch.id
}

output "event_destination_cloudwatch_arn" {
  description = "CloudWatch Event DestinationのARN"
  value       = aws_ses_event_destination.cloudwatch.arn
}

output "event_destination_kinesis_id" {
  description = "Kinesis Event DestinationのID"
  value       = aws_ses_event_destination.kinesis.id
}

output "event_destination_kinesis_arn" {
  description = "Kinesis Event DestinationのARN"
  value       = aws_ses_event_destination.kinesis.arn
}

output "event_destination_sns_id" {
  description = "SNS Event DestinationのID"
  value       = aws_ses_event_destination.sns.id
}

output "event_destination_sns_arn" {
  description = "SNS Event DestinationのARN"
  value       = aws_ses_event_destination.sns.arn
}

# ================================================================
# 完全な構成例: Configuration Setと関連リソース
# ================================================================

# Configuration Set（Event Destinationの前提リソース）
# resource "aws_ses_configuration_set" "example" {
#   name = "example-configuration-set"
#
#   # 配信オプションの設定（オプション）
#   delivery_options {
#     tls_policy = "Require"
#   }
#
#   # レピュテーションメトリクスの有効化（オプション）
#   reputation_metrics_enabled = true
#
#   # 送信の有効化（オプション）
#   sending_enabled = true
# }

# CloudWatchメトリクスの可視化用ダッシュボード例
# resource "aws_cloudwatch_dashboard" "ses_metrics" {
#   dashboard_name = "ses-email-metrics"
#
#   dashboard_body = jsonencode({
#     widgets = [
#       {
#         type = "metric"
#         properties = {
#           metrics = [
#             ["AWS/SES", "Send"],
#             [".", "Bounce"],
#             [".", "Complaint"],
#             [".", "Delivery"]
#           ]
#           period = 300
#           stat   = "Sum"
#           region = "us-east-1"
#           title  = "SES Email Events"
#         }
#       }
#     ]
#   })
# }

# CloudWatchアラームの例（バウンス率の監視）
# resource "aws_cloudwatch_metric_alarm" "high_bounce_rate" {
#   alarm_name          = "ses-high-bounce-rate"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "Bounce"
#   namespace           = "AWS/SES"
#   period              = 300
#   statistic           = "Sum"
#   threshold           = 10
#   alarm_description   = "This metric monitors SES bounce rate"
#   alarm_actions       = [aws_sns_topic.alerts.arn]
#
#   dimensions = {
#     "ses:configuration-set" = aws_ses_configuration_set.example.name
#   }
# }

# Kinesis Firehose配信ストリームの例（S3への保存）
# resource "aws_kinesis_firehose_delivery_stream" "ses_events" {
#   name        = "ses-events-stream"
#   destination = "extended_s3"
#
#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.ses_events.arn
#
#     # データ変換の設定（オプション）
#     processing_configuration {
#       enabled = true
#
#       processors {
#         type = "Lambda"
#
#         parameters {
#           parameter_name  = "LambdaArn"
#           parameter_value = "${aws_lambda_function.transform.arn}:$LATEST"
#         }
#       }
#     }
#
#     # バッファリング設定
#     buffering_size     = 5  # MB
#     buffering_interval = 300 # 秒
#
#     # 圧縮設定
#     compression_format = "GZIP"
#
#     # S3バケットのプレフィックス設定
#     prefix              = "ses-events/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
#     error_output_prefix = "ses-events-errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
#   }
# }

# SNSトピックの例
# resource "aws_sns_topic" "ses_events" {
#   name = "ses-events-topic"
#
#   # 配信ポリシーの設定
#   delivery_policy = jsonencode({
#     http = {
#       defaultHealthyRetryPolicy = {
#         minDelayTarget     = 20
#         maxDelayTarget     = 20
#         numRetries         = 3
#         numMaxDelayRetries = 0
#         numNoDelayRetries  = 0
#         numMinDelayRetries = 0
#         backoffFunction    = "linear"
#       }
#       disableSubscriptionOverrides = false
#     }
#   })
# }

# SNSトピックのアクセスポリシー
# resource "aws_sns_topic_policy" "ses_events" {
#   arn = aws_sns_topic.ses_events.arn
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ses.amazonaws.com"
#         }
#         Action   = "SNS:Publish"
#         Resource = aws_sns_topic.ses_events.arn
#         Condition = {
#           StringEquals = {
#             "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
#           }
#           StringLike = {
#             "AWS:SourceArn" = "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
#           }
#         }
#       }
#     ]
#   })
# }

# SNSトピックのサブスクリプション例（Eメール）
# resource "aws_sns_topic_subscription" "email" {
#   topic_arn = aws_sns_topic.ses_events.arn
#   protocol  = "email"
#   endpoint  = "alerts@example.com"
# }

# SNSトピックのサブスクリプション例（Lambda）
# resource "aws_sns_topic_subscription" "lambda" {
#   topic_arn = aws_sns_topic.ses_events.arn
#   protocol  = "lambda"
#   endpoint  = aws_lambda_function.process_ses_event.arn
# }

# Lambda関数の例（SNSからのイベント処理）
# resource "aws_lambda_function" "process_ses_event" {
#   filename      = "lambda_function_payload.zip"
#   function_name = "process-ses-event"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "index.handler"
#   runtime       = "python3.11"
#
#   environment {
#     variables = {
#       DYNAMODB_TABLE = aws_dynamodb_table.email_events.name
#     }
#   }
# }

# IAMロールの例（Kinesis Firehose用）
# resource "aws_iam_role" "ses_kinesis" {
#   name = "ses-kinesis-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ses.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#         Condition = {
#           StringEquals = {
#             "sts:ExternalId" = data.aws_caller_identity.current.account_id
#           }
#         }
#       }
#     ]
#   })
# }

# IAMポリシーの例（Kinesis Firehose用）
# resource "aws_iam_role_policy" "ses_kinesis" {
#   name = "ses-kinesis-policy"
#   role = aws_iam_role.ses_kinesis.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "firehose:PutRecord",
#           "firehose:PutRecordBatch"
#         ]
#         Resource = aws_kinesis_firehose_delivery_stream.ses_events.arn
#       }
#     ]
#   })
# }

# ================================================================
# ベストプラクティスと注意事項
# ================================================================
#
# 1. イベントタイプの選択
#    - 必要なイベントタイプのみを指定してコストと処理負荷を最適化
#    - クリティカルなイベント（bounce、complaint）は必ず監視
#    - エンゲージメント分析が必要な場合のみ open と click を有効化
#    - renderingFailure はテンプレート使用時に有効化を推奨
#
# 2. 宛先の選択
#    - CloudWatch: リアルタイムモニタリングとアラートに最適
#    - Kinesis Firehose: 大量データの長期保存と分析に最適
#    - SNS: 即時通知とイベント駆動処理に最適
#    - 複数の宛先が必要な場合は、複数のEvent Destinationを作成
#
# 3. Configuration Setの設計
#    - 用途別にConfiguration Setを分ける（トランザクション、マーケティング等）
#    - 各Configuration Setに適切なEvent Destinationを関連付け
#    - メール送信時に適切なConfiguration Set名を指定
#
# 4. IAM権限の管理
#    - 最小権限の原則に従う
#    - Kinesis使用時は専用のIAMロールを作成
#    - SNS使用時はトピックポリシーで適切にアクセス制御
#    - 定期的に権限を見直し、不要な権限を削除
#
# 5. モニタリングとアラート
#    - バウンス率と苦情率を常に監視
#    - 閾値を超えた場合の自動アラートを設定
#    - CloudWatchダッシュボードで可視化
#    - 定期的にメトリクスをレビューして送信品質を改善
#
# 6. データ保持とコンプライアンス
#    - メールイベントデータの保持期間を定義
#    - 個人情報を含む場合は適切に暗号化
#    - GDPRやその他のデータ保護規制に準拠
#    - S3バケットのライフサイクルポリシーを設定して古いデータを自動削除
#
# 7. コスト最適化
#    - 不要なイベントタイプの無効化
#    - Firehoseのバッファリング設定を最適化
#    - S3のストレージクラスを適切に設定（Intelligent-Tiering等）
#    - CloudWatchメトリクスの保持期間を調整
#
# 8. パフォーマンス
#    - Kinesis Firehoseのシャード数を適切に設定
#    - Lambda関数のタイムアウトと同時実行数を最適化
#    - SNSのリトライポリシーを調整
#    - バッチ処理を活用して効率化
#
# 9. セキュリティ
#    - 宛先リソース（S3、SNS、Kinesis）への不正アクセスを防止
#    - VPCエンドポイントを使用してトラフィックをAWSネットワーク内に留める
#    - CloudTrailでAPI呼び出しを監査
#    - データ転送時の暗号化を有効化
#
# 10. トラブルシューティング
#     - Event Destinationが有効化されているか確認
#     - IAMロールと権限が正しく設定されているか確認
#     - Configuration Setがメール送信時に指定されているか確認
#     - CloudWatch Logsでエラーメッセージを確認
#     - SESの送信統計とレピュテーションメトリクスを確認
#
# 11. テストとバリデーション
#     - 本番環境に適用する前にテスト環境で検証
#     - 各イベントタイプが正しく送信されることを確認
#     - アラートが正しくトリガーされることを確認
#     - データフォーマットが期待通りであることを確認
#
# 12. メール送信の品質管理
#     - バウンス率を5%以下に維持（AWSの推奨）
#     - 苦情率を0.1%以下に維持（AWSの推奨）
#     - 高いバウンス率や苦情率はSESの評価に悪影響を与え、
#       最悪の場合、アカウントが一時停止される可能性があります
#     - 定期的に送信リストをクリーニング
#     - ダブルオプトインを実装して送信許可を確認
#
# ================================================================
