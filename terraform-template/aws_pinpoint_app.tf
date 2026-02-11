################################################################################
# AWS Pinpoint App
################################################################################
# aws_pinpoint_app は Amazon Pinpoint のアプリケーション（プロジェクト）を作成します。
# Pinpoint はモバイルプッシュ、アプリ内メッセージ、Email、SMS などのチャネルを
# 通じて、特定のオーディエンスセグメントに対してカスタマイズされたメッセージを
# 送信するためのマーケティング・分析サービスです。
#
# 主なユースケース:
# - モバイルアプリのプッシュ通知キャンペーン
# - Email/SMS マーケティングキャンペーン
# - ユーザーエンゲージメント分析
# - A/Bテストによるメッセージング最適化
# - イベントベースのメッセージング（トリガー配信）
#
# 注意: 2026年10月30日以降、Amazon Pinpoint のコンソールとリソースのサポート
# は終了予定です。ただし、SMS、音声、モバイルプッシュ、OTP、電話番号検証に
# 関連する API は AWS End User Messaging として引き続きサポートされます。
#
# AWS ドキュメント:
# https://docs.aws.amazon.com/pinpoint/latest/userguide/campaigns.html
# https://docs.aws.amazon.com/pinpoint/latest/apireference/apps-application-id.html
#
# Terraform ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/pinpoint_app

resource "aws_pinpoint_app" "example" {
  ################################################################################
  # 基本設定
  ################################################################################

  # name - (オプション) アプリケーション名
  # Terraform によって自動生成されるデフォルトの名前を使用することもできます。
  # name_prefix と競合するため、どちらか一方のみを指定してください。
  #
  # 使用例:
  # - "my-mobile-app" - モバイルアプリ用
  # - "marketing-campaign-app" - マーケティングキャンペーン用
  # - "customer-engagement" - カスタマーエンゲージメント用
  name = "test-app"

  # name_prefix - (オプション) Pinpoint アプリケーション名のプレフィックス
  # Terraform がユニークな名前を自動生成する際のプレフィックスとして使用されます。
  # name と競合するため、どちらか一方のみを指定してください。
  #
  # 使用例:
  # name_prefix = "prod-app-"  # 結果: prod-app-20230101123456 のような名前
  # name_prefix = "dev-"        # 開発環境用のプレフィックス
  # name_prefix = null

  # region - (オプション) このリソースを管理するリージョン
  # プロバイダー設定のリージョンがデフォルトとして使用されます。
  # 異なるリージョンに Pinpoint アプリケーションを作成したい場合に指定します。
  #
  # 利用可能なリージョン:
  # - us-east-1 (バージニア北部) - 最も一般的
  # - us-west-2 (オレゴン)
  # - eu-west-1 (アイルランド)
  # - ap-southeast-1 (シンガポール)
  # - ap-northeast-1 (東京)
  # など
  #
  # 注意: Pinpoint は一部のリージョンでのみ利用可能です。
  # region = "us-east-1"

  ################################################################################
  # Campaign Hook - キャンペーンフック設定
  ################################################################################
  # campaign_hook - (オプション) キャンペーン用にセグメントをカスタマイズする
  # AWS Lambda 関数を呼び出すための設定。
  # キャンペーン配信前にセグメントのフィルタリングやカスタマイズを行う場合に使用します。
  #
  # 使用例:
  # - ユーザー属性の動的フィルタリング
  # - 配信前のコンテンツパーソナライゼーション
  # - サードパーティシステムとの統合

  # campaign_hook {
  #   # lambda_function_name - (オプション) 配信時に呼び出される Lambda 関数名または ARN
  #   # web_url と競合するため、どちらか一方のみを指定してください。
  #   #
  #   # 使用例:
  #   # lambda_function_name = "arn:aws:lambda:us-east-1:123456789012:function:pinpoint-segment-filter"
  #   # lambda_function_name = "pinpoint-campaign-hook"
  #   lambda_function_name = "my-campaign-hook-function"
  #
  #   # mode - (必須 - lambda_function_name または web_url を指定した場合)
  #   # Lambda の呼び出しモード。
  #   #
  #   # 有効な値:
  #   # - "DELIVERY" - メッセージ配信時に Lambda を呼び出す
  #   # - "FILTER"   - セグメントフィルタリング時に Lambda を呼び出す
  #   #
  #   # DELIVERY モード: メッセージコンテンツのカスタマイズや配信判定に使用
  #   # FILTER モード: セグメントメンバーのフィルタリングに使用
  #   mode = "DELIVERY"
  #
  #   # web_url - (オプション) フック用に呼び出す Web URL
  #   # URL に認証情報が含まれている場合、リクエストに認証として追加されます。
  #   # lambda_function_name と競合するため、どちらか一方のみを指定してください。
  #   #
  #   # 使用例:
  #   # web_url = "https://api.example.com/pinpoint/webhook"
  #   # web_url = "https://username:password@api.example.com/hook"
  #   # web_url = null
  # }

  ################################################################################
  # Limits - キャンペーン制限設定
  ################################################################################
  # limits - (オプション) アプリケーションのデフォルトキャンペーン制限
  # 各キャンペーンに適用される制限で、キャンペーン個別の設定で上書き可能です。
  # メッセージ送信の過剰配信を防ぎ、コスト管理とユーザーエクスペリエンスの
  # 向上に役立ちます。

  limits {
    # daily - (オプション) キャンペーンが1日に送信できる最大メッセージ数
    #
    # 使用例:
    # daily = 10000   # 1日最大10,000メッセージ
    # daily = 50000   # 高頻度キャンペーン用
    # daily = 1000    # 控えめな配信量
    # daily = null

    # maximum_duration - (オプション) キャンペーンが実行できる最大時間（秒）
    # スケジュールされた開始時刻から計測されます。
    # 最小値: 60秒
    #
    # 使用例:
    # maximum_duration = 3600    # 1時間 (3600秒)
    # maximum_duration = 86400   # 24時間
    # maximum_duration = 604800  # 1週間
    maximum_duration = 600 # 10分間

    # messages_per_second - (オプション) キャンペーンが1秒あたりに送信できる
    # メッセージ数。スループット制限に使用します。
    # 最小値: 50
    # 最大値: 20000
    #
    # 使用例:
    # messages_per_second = 100   # 低速配信
    # messages_per_second = 1000  # 中速配信
    # messages_per_second = 5000  # 高速配信
    # messages_per_second = null

    # total - (オプション) キャンペーンが送信できる最大メッセージ総数
    # キャンペーン全体の上限を設定します。
    #
    # 使用例:
    # total = 100000   # キャンペーン全体で10万メッセージまで
    # total = 1000000  # 大規模キャンペーン
    # total = 5000     # 小規模テストキャンペーン
    # total = null
  }

  ################################################################################
  # Quiet Time - 配信停止時間設定
  ################################################################################
  # quiet_time - (オプション) アプリケーションのデフォルト配信停止時間
  # この時間帯はメッセージが送信されません。キャンペーン個別の設定で上書き可能です。
  # ユーザーの生活リズムを考慮した配信時間の最適化に使用します。

  quiet_time {
    # start - (オプション) 配信停止時間の開始時刻（ISO 8601 形式、HH:MM）
    # end が設定されている場合は必須です。
    #
    # 使用例:
    # start = "22:00"  # 午後10時から配信停止
    # start = "23:00"  # 午後11時から配信停止
    # start = "21:30"  # 午後9時30分から配信停止
    start = "00:00"

    # end - (オプション) 配信停止時間の終了時刻（ISO 8601 形式、HH:MM）
    # start が設定されている場合は必須です。
    #
    # 使用例:
    # end = "08:00"  # 午前8時まで配信停止
    # end = "09:00"  # 午前9時まで配信停止
    # end = "07:00"  # 午前7時まで配信停止
    end = "06:00"
  }

  ################################################################################
  # タグ
  ################################################################################

  # tags - (オプション) リソースタグのキー・バリューマップ
  # プロバイダーの default_tags 設定ブロックが存在する場合、同じキーを持つタグは
  # プロバイダーレベルで定義されたものを上書きします。
  #
  # 使用例:
  # tags = {
  #   Name        = "MyPinpointApp"
  #   Environment = "Production"
  #   Application = "MobileApp"
  #   CostCenter  = "Marketing"
  #   ManagedBy   = "Terraform"
  # }
  tags = {
    Name        = "example-pinpoint-app"
    Environment = "development"
  }
}

################################################################################
# Outputs - 出力値
################################################################################

# application_id - Pinpoint アプリケーション ID
# 他のリソース（キャンペーン、セグメントなど）で参照する際に使用します。
output "pinpoint_application_id" {
  description = "The Application ID of the Pinpoint App"
  value       = aws_pinpoint_app.example.application_id
}

# arn - Amazon Resource Name (ARN)
# IAM ポリシーやリソースベースポリシーで使用します。
output "pinpoint_app_arn" {
  description = "Amazon Resource Name (ARN) of the PinPoint Application"
  value       = aws_pinpoint_app.example.arn
}

# tags_all - 全てのタグ（プロバイダーの default_tags を含む）
# リソースに最終的に適用されたタグの完全なセットを確認できます。
output "pinpoint_app_tags" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_pinpoint_app.example.tags_all
}

################################################################################
# 関連リソースの使用例
################################################################################

# Pinpoint アプリケーションと組み合わせて使用する関連リソース:
#
# 1. aws_pinpoint_event_stream
#    - イベントデータを Kinesis Streams にストリーミング
#    - リアルタイム分析やデータウェアハウスへの統合に使用
#
# 2. aws_pinpoint_adm_channel
#    - Amazon Device Messaging (ADM) チャネル設定
#    - Amazon デバイスへのプッシュ通知配信
#
# 3. aws_pinpoint_apns_channel
#    - Apple Push Notification Service (APNS) チャネル設定
#    - iOS デバイスへのプッシュ通知配信
#
# 4. aws_pinpoint_baidu_channel
#    - Baidu Cloud Push チャネル設定
#    - 中国市場向けの Android プッシュ通知
#
# 5. aws_pinpoint_email_channel
#    - Email チャネル設定
#    - SES を使用した Email キャンペーン配信
#
# 6. aws_pinpoint_gcm_channel
#    - Firebase Cloud Messaging (FCM) チャネル設定
#    - Android デバイスへのプッシュ通知配信
#
# 7. aws_pinpoint_sms_channel
#    - SMS チャネル設定
#    - SMS メッセージキャンペーン配信
#
# 8. IAM Role & Policy
#    - campaign_hook で Lambda を使用する場合、Pinpoint が Lambda を
#      呼び出すための IAM ロールとポリシーが必要
#
# 使用例:
# resource "aws_pinpoint_apns_channel" "apns" {
#   application_id = aws_pinpoint_app.example.application_id
#   certificate    = file("path/to/certificate.p12")
#   private_key    = file("path/to/private_key.pem")
# }
#
# resource "aws_pinpoint_gcm_channel" "gcm" {
#   application_id = aws_pinpoint_app.example.application_id
#   api_key        = var.fcm_api_key
# }

################################################################################
# ベストプラクティス
################################################################################
#
# 1. Limits の設定
#    - 予期しないコスト増加を防ぐため、必ず limits を設定する
#    - 本番環境では daily と total の両方を設定することを推奨
#    - messages_per_second を設定してスループットを制御
#
# 2. Quiet Time の活用
#    - ユーザーの睡眠時間を考慮した配信停止時間を設定
#    - タイムゾーンを考慮してグローバル展開の場合は注意が必要
#
# 3. Campaign Hook の使用
#    - 複雑なセグメンテーションロジックには Lambda を活用
#    - Lambda 関数には適切なタイムアウト設定が必要
#    - Lambda 実行コストも考慮してモードを選択
#
# 4. タグ付け戦略
#    - コスト配分のため Environment、CostCenter タグを付与
#    - 自動化のため ManagedBy タグで Terraform 管理を明示
#
# 5. モニタリング
#    - CloudWatch メトリクスでキャンペーンパフォーマンスを監視
#    - Event Stream を設定してユーザーエンゲージメントを分析
#
# 6. セキュリティ
#    - IAM ポリシーで最小権限の原則を適用
#    - API キーや認証情報は Secrets Manager で管理
#
# 7. サービス終了への対応
#    - 2026年10月30日のサポート終了を考慮
#    - SMS、音声、プッシュ通知は AWS End User Messaging への移行を検討
