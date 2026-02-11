#---------------------------------------------------------------
# AWS SNS Platform Application
#---------------------------------------------------------------
#
# Amazon SNS (Simple Notification Service)のプラットフォームアプリケーションを
# プロビジョニングするリソースです。プラットフォームアプリケーションは、
# モバイルプッシュ通知サービス（APNS、FCM/GCM等）とSNSの間の接続を確立し、
# モバイルデバイスへのプッシュ通知配信を可能にします。
#
# AWS公式ドキュメント:
#   - SNS概要: https://docs.aws.amazon.com/sns/latest/dg/welcome.html
#   - モバイルプッシュ通知: https://docs.aws.amazon.com/sns/latest/dg/sns-mobile-application-as-subscriber.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_platform_application
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_platform_application" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: SNSプラットフォームアプリケーションのフレンドリー名を指定します。
  # 設定可能な値: 文字列（アプリケーションを識別する任意の名前）
  # 注意: この名前はAWSアカウント内で一意である必要があります。
  name = "my-mobile-app"

  # platform (Required)
  # 設定内容: アプリケーションが登録されているプラットフォームを指定します。
  # 設定可能な値:
  #   - "APNS": Apple Push Notification Service（iOS）
  #   - "APNS_SANDBOX": APNS サンドボックス環境（iOS開発用）
  #   - "GCM": Google Cloud Messaging（Android、非推奨）
  #   - "FCM": Firebase Cloud Messaging（Android推奨）
  #   - "ADM": Amazon Device Messaging（Fireタブレット等）
  #   - "BAIDU": Baidu Cloud Push（中国向けAndroid）
  #   - "MPNS": Microsoft Push Notification Service（Windows Phone）
  #   - "WNS": Windows Push Notification Services（Windows）
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-supported-platforms-prerequisites.html
  platform = "APNS"

  # platform_credential (Required)
  # 設定内容: プラットフォームの認証情報を指定します。
  # 設定可能な値: プラットフォームごとに異なる認証情報
  #   - APNS（証明書ベース）: APNSプライベートキー（.p12ファイルの内容）
  #   - APNS（トークンベース）: APNS署名キー（.p8ファイルの内容）
  #   - FCM/GCM: サーバーAPIキーまたはサービスアカウントJSON
  #   - ADM: Client Secret
  #   - Baidu: API Key
  #   - WNS: Secret Key
  # 注意: この値はTerraform stateにハッシュ化されて保存されます。
  #       実際の値は機密情報として適切に管理してください。
  #       variables、環境変数、またはSecrets Managerの使用を推奨します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/mobile-push-send.html
  platform_credential = "<APNS PRIVATE KEY>"

  # platform_principal (Optional)
  # 設定内容: プラットフォームのプリンシパル情報を指定します。
  # 設定可能な値: プラットフォームごとに異なるプリンシパル情報
  #   - APNS（証明書ベース）: SSL証明書（.pemまたは.cerファイルの内容）
  #   - APNS（トークンベース）: 署名キーID（10文字の英数字）
  #   - 他のプラットフォーム: 通常は不要
  # 省略時: プラットフォームによっては必須となる場合があります（APNSなど）
  # 注意: この値もTerraform stateにハッシュ化されて保存されます。
  platform_principal = "<APNS CERTIFICATE>"

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
  # APNS トークンベース認証設定（APNS使用時のみ）
  #-------------------------------------------------------------

  # apple_platform_team_id (Required for APNS token-based auth)
  # 設定内容: Apple開発者アカウントチームに割り当てられた識別子を指定します。
  # 設定可能な値: 10文字の英数字
  # 省略時: APNSでトークンベース認証を使用する場合は必須
  # 注意: APNSで証明書ベース認証を使用する場合は不要です。
  # 関連機能: APNSトークンベース認証
  #   Apple Developer Programに登録したチームIDを使用してAPNSに接続します。
  #   トークンベース認証は証明書ベースより管理が容易で推奨されます。
  #   - https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns
  apple_platform_team_id = null

  # apple_platform_bundle_id (Required for APNS token-based auth)
  # 設定内容: iOSアプリに割り当てられたバンドル識別子を指定します。
  # 設定可能な値: 英数字、ハイフン（-）、ピリオド（.）のみ含む文字列
  # 省略時: APNSでトークンベース認証を使用する場合は必須
  # 注意: APNSで証明書ベース認証を使用する場合は不要です。
  #       バンドルIDはXcodeプロジェクトで設定されたものと一致する必要があります。
  apple_platform_bundle_id = null

  #-------------------------------------------------------------
  # イベント通知設定
  #-------------------------------------------------------------

  # event_delivery_failure_topic_arn (Optional)
  # 設定内容: プラットフォームエンドポイントへの配信が永続的に失敗した際に
  #          トリガーされるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 省略時: 配信失敗イベントは通知されません
  # 関連機能: SNSイベント通知
  #   プッシュ通知の配信状態を監視し、失敗時にアクションを実行できます。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-msg-status.html
  event_delivery_failure_topic_arn = null

  # event_endpoint_created_topic_arn (Optional)
  # 設定内容: プラットフォームアプリケーションに新しいエンドポイントが追加された際に
  #          トリガーされるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 省略時: エンドポイント作成イベントは通知されません
  event_endpoint_created_topic_arn = null

  # event_endpoint_deleted_topic_arn (Optional)
  # 設定内容: プラットフォームアプリケーションから既存のエンドポイントが削除された際に
  #          トリガーされるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 省略時: エンドポイント削除イベントは通知されません
  event_endpoint_deleted_topic_arn = null

  # event_endpoint_updated_topic_arn (Optional)
  # 設定内容: プラットフォームアプリケーションの既存エンドポイントが変更された際に
  #          トリガーされるSNSトピックのARNを指定します。
  # 設定可能な値: 有効なSNSトピックのARN
  # 省略時: エンドポイント更新イベントは通知されません
  event_endpoint_updated_topic_arn = null

  #-------------------------------------------------------------
  # フィードバック設定
  #-------------------------------------------------------------

  # failure_feedback_role_arn (Optional)
  # 設定内容: 失敗フィードバックを受信し、CloudWatch Logsへの書き込み権限を
  #          SNSに付与するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: 失敗フィードバックはCloudWatch Logsに記録されません
  # 関連機能: CloudWatch Logsとの統合
  #   プッシュ通知の配信失敗をCloudWatch Logsに記録し、詳細な分析を可能にします。
  #   - https://docs.aws.amazon.com/sns/latest/dg/sns-msg-status.html
  # 注意: IAMロールには適切なCloudWatch Logs書き込み権限が必要です。
  failure_feedback_role_arn = null

  # success_feedback_role_arn (Optional)
  # 設定内容: 成功フィードバックを受信し、CloudWatch Logsへの書き込み権限を
  #          SNSに付与するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  # 省略時: 成功フィードバックはCloudWatch Logsに記録されません
  # 注意: 成功フィードバックを有効にすると、大量のログが生成される可能性があります。
  success_feedback_role_arn = null

  # success_feedback_sample_rate (Optional)
  # 設定内容: 正常に配信されたメッセージのサンプリングレート（パーセンテージ）を指定します。
  # 設定可能な値: 0-100の整数
  #   - 0: 成功フィードバックを記録しない
  #   - 100: すべての成功を記録（大量のログが生成される可能性あり）
  #   - 1-99: 指定した割合でサンプリング
  # 省略時: サンプリングは行われません（0として扱われます）
  # 注意: success_feedback_role_arnが設定されている場合のみ有効です。
  #       本番環境では低い値（1-10%）を推奨します。
  success_feedback_sample_rate = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: SNSプラットフォームアプリケーションのARN
#
# - arn: SNSプラットフォームアプリケーションのARN
#       他のリソース（SNSトピックサブスクリプション等）から参照する際に使用
#---------------------------------------------------------------
