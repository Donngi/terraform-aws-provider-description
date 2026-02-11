#---------------------------------------------------------------
# Amazon SNS Topic
#---------------------------------------------------------------
#
# Amazon Simple Notification Service (SNS) のトピックをプロビジョニングするリソースです。
# トピックは複数のエンドポイント（AWS Lambda、Amazon SQS、HTTP/S、メールアドレスなど）を
# グループ化する論理的なアクセスポイントで、メッセージを複数のサブスクライバーに配信する
# 通信チャネルとして機能します。
#
# AWS公式ドキュメント:
#   - SNSトピックの作成: https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html
#   - SNS入門ガイド: https://docs.aws.amazon.com/sns/latest/dg/sns-getting-started.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_sns_topic" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Optional)
  # 設定内容: トピックの名前を指定します。
  # 設定可能な値: 大文字・小文字のASCII文字、数字、アンダースコア、ハイフンのみ。1-256文字。
  #              FIFOトピックの場合は、名前の最後に `.fifo` サフィックスを付ける必要があります。
  # 省略時: Terraformがランダムで一意の名前を自動生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html
  name = "user-updates-topic"

  # name_prefix (Optional)
  # 設定内容: トピック名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = null

  # display_name (Optional)
  # 設定内容: トピックの表示名を指定します。
  # 設定可能な値: 文字列
  # 用途: メール通知などで表示される名前として使用されます。
  # 注意: メールエンドポイントにサブスクライブする場合、SNSトピックの表示名と
  #      送信元メールアドレス（例: no-reply@sns.amazonaws.com）の合計文字数が
  #      320 UTF-8文字を超えないようにする必要があります。
  display_name = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # FIFO設定
  #-------------------------------------------------------------

  # fifo_topic (Optional)
  # 設定内容: FIFO（先入れ先出し）トピックを作成するかを指定します。
  # 設定可能な値:
  #   - false (デフォルト): 標準トピックを作成
  #   - true: FIFOトピックを作成
  # 注意: FIFOトピックは、メールアドレス、モバイルアプリ、SMS、HTTP(S)エンドポイントなどの
  #      顧客管理エンドポイントにメッセージを配信できません。これらのエンドポイントタイプでは
  #      厳密なメッセージ順序が保証されないためです。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-fifo-topics.html
  fifo_topic = false

  # content_based_deduplication (Optional)
  # 設定内容: FIFOトピックのコンテンツベースの重複排除を有効にするかを指定します。
  # 設定可能な値:
  #   - true: メッセージ本文のSHA-256ハッシュを使用して重複排除IDを自動生成
  #   - false (デフォルト): 無効
  # 用途: FIFOトピックでのみ使用可能。メッセージ発行時に重複排除IDを明示的に指定しない場合に使用されます。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/fifo-message-dedup.html
  content_based_deduplication = false

  # fifo_throughput_scope (Optional)
  # 設定内容: FIFOトピックのスループット調整のための重複排除のスコープを指定します。
  # 設定可能な値:
  #   - "Topic": トピックレベルでの重複排除により、より高いスループットを実現
  #   - "MessageGroup": メッセージグループレベルでの重複排除
  # 用途: FIFOトピックでより高いスループットを有効にするための設定です。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/fifo-high-throughput.html#enable-high-throughput-on-fifo-topic
  fifo_throughput_scope = null

  #-------------------------------------------------------------
  # アーカイブ設定
  #-------------------------------------------------------------

  # archive_policy (Optional)
  # 設定内容: FIFOトピックのメッセージアーカイブポリシーを指定します。
  # 設定可能な値: JSON形式のポリシードキュメント
  # 用途: メッセージのアーカイブと再生機能を設定します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/message-archiving-and-replay-topic-owner.html
  archive_policy = null

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: トピックのアクセス許可を定義するAWS IAMポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式のIAMポリシードキュメント
  # 用途: トピックへのアクセス制御を設定します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-access-policy-use-cases.html
  policy = null

  # delivery_policy (Optional)
  # 設定内容: SNSの配信ポリシーをJSON形式で指定します。
  # 設定可能な値: JSON形式の配信ポリシードキュメント
  # 用途: メッセージ配信の再試行ロジックを定義します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/DeliveryPolicies.html
  delivery_policy = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_master_key_id (Optional)
  # 設定内容: トピックの暗号化に使用するAWS KMSカスタマーマスターキー(CMK)のIDを指定します。
  # 設定可能な値: AWS管理のCMK、またはカスタムCMKのID/ARN
  # 用途: トピックに発行されるメッセージの暗号化を有効にします。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-server-side-encryption.html#sse-key-terms
  kms_master_key_id = null

  #-------------------------------------------------------------
  # 署名設定
  #-------------------------------------------------------------

  # signature_version (Optional)
  # 設定内容: 通知、サブスクリプション確認、またはサブスクリプション解除確認メッセージの署名バージョンを指定します。
  # 設定可能な値:
  #   - 1: SHA1ハッシュアルゴリズムを使用
  #   - 2: SHA256ハッシュアルゴリズムを使用
  # 用途: メッセージの署名生成時に使用されるハッシュアルゴリズムを決定します。
  # 参考: https://docs.aws.amazon.com/sns/latest/dg/sns-verify-signature-of-message.html
  signature_version = null

  #-------------------------------------------------------------
  # トレーシング設定
  #-------------------------------------------------------------

  # tracing_config (Optional)
  # 設定内容: Amazon SNSトピックのトレーシングモードを指定します。
  # 設定可能な値:
  #   - "PassThrough": トレーシング情報を通過させる
  #   - "Active": アクティブトレーシングを有効化
  # 用途: AWS X-Rayを使用したトレーシングを設定します。
  tracing_config = null

  #-------------------------------------------------------------
  # 配信フィードバック設定 - Application
  #-------------------------------------------------------------

  # application_success_feedback_role_arn (Optional)
  # 設定内容: Applicationエンドポイントへの配信成功フィードバックを受信するために許可されたIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  application_success_feedback_role_arn = null

  # application_success_feedback_sample_rate (Optional)
  # 設定内容: Applicationエンドポイントへの配信成功のサンプリング率を指定します。
  # 設定可能な値: 0-100の数値（パーセンテージ）
  application_success_feedback_sample_rate = null

  # application_failure_feedback_role_arn (Optional)
  # 設定内容: Applicationエンドポイントへの配信失敗フィードバックを受信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  application_failure_feedback_role_arn = null

  #-------------------------------------------------------------
  # 配信フィードバック設定 - HTTP/HTTPS
  #-------------------------------------------------------------

  # http_success_feedback_role_arn (Optional)
  # 設定内容: HTTPエンドポイントへの配信成功フィードバックを受信するために許可されたIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  http_success_feedback_role_arn = null

  # http_success_feedback_sample_rate (Optional)
  # 設定内容: HTTPエンドポイントへの配信成功のサンプリング率を指定します。
  # 設定可能な値: 0-100の数値（パーセンテージ）
  http_success_feedback_sample_rate = null

  # http_failure_feedback_role_arn (Optional)
  # 設定内容: HTTPエンドポイントへの配信失敗フィードバックを受信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  http_failure_feedback_role_arn = null

  #-------------------------------------------------------------
  # 配信フィードバック設定 - Lambda
  #-------------------------------------------------------------

  # lambda_success_feedback_role_arn (Optional)
  # 設定内容: Lambdaエンドポイントへの配信成功フィードバックを受信するために許可されたIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  lambda_success_feedback_role_arn = null

  # lambda_success_feedback_sample_rate (Optional)
  # 設定内容: Lambdaエンドポイントへの配信成功のサンプリング率を指定します。
  # 設定可能な値: 0-100の数値（パーセンテージ）
  lambda_success_feedback_sample_rate = null

  # lambda_failure_feedback_role_arn (Optional)
  # 設定内容: Lambdaエンドポイントへの配信失敗フィードバックを受信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  lambda_failure_feedback_role_arn = null

  #-------------------------------------------------------------
  # 配信フィードバック設定 - SQS
  #-------------------------------------------------------------

  # sqs_success_feedback_role_arn (Optional)
  # 設定内容: SQSエンドポイントへの配信成功フィードバックを受信するために許可されたIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  sqs_success_feedback_role_arn = null

  # sqs_success_feedback_sample_rate (Optional)
  # 設定内容: SQSエンドポイントへの配信成功のサンプリング率を指定します。
  # 設定可能な値: 0-100の数値（パーセンテージ）
  sqs_success_feedback_sample_rate = null

  # sqs_failure_feedback_role_arn (Optional)
  # 設定内容: SQSエンドポイントへの配信失敗フィードバックを受信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  sqs_failure_feedback_role_arn = null

  #-------------------------------------------------------------
  # 配信フィードバック設定 - Firehose
  #-------------------------------------------------------------

  # firehose_success_feedback_role_arn (Optional)
  # 設定内容: Firehoseエンドポイントへの配信成功フィードバックを受信するために許可されたIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  firehose_success_feedback_role_arn = null

  # firehose_success_feedback_sample_rate (Optional)
  # 設定内容: Firehoseエンドポイントへの配信成功のサンプリング率を指定します。
  # 設定可能な値: 0-100の数値（パーセンテージ）
  firehose_success_feedback_sample_rate = null

  # firehose_failure_feedback_role_arn (Optional)
  # 設定内容: Firehoseエンドポイントへの配信失敗フィードバックを受信するためのIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN
  firehose_failure_feedback_role_arn = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-sns-topic"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられる全てのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます。
  # 注意: 通常は設定不要です。Terraformが自動的にtagsとdefault_tagsをマージします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # リソース識別子
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 省略時: SNSトピックのARNが自動的に割り当てられます。
  # 注意: 通常は設定不要です。Terraformが自動的に管理します。
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: SNSトピックのARN
#
# - arn: SNSトピックのARN（idのより明示的なプロパティ）
#
# - beginning_archive_time: FIFOトピックのサブスクライバーが再生を開始できる最も古いタイムスタンプ
#
# - owner: SNSトピックオーナーのAWSアカウントID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
