#---------------------------------------------------------------
# AWS Chime SDK Media Pipelines Media Insights Pipeline Configuration
#---------------------------------------------------------------
#
# Amazon Chime SDK Media Pipelines のメディアインサイトパイプライン設定を
# プロビジョニングするリソースです。
# 通話分析（Call Analytics）を実行するための設定を定義し、
# Amazon Transcribe、音声分析、各種シンク（Kinesis、Lambda、S3など）への
# データ配信を構成します。
#
# AWS公式ドキュメント:
#   - Call Analytics開発者ガイド: https://docs.aws.amazon.com/chime-sdk/latest/dg/call-analytics.html
#   - CreateMediaInsightsPipelineConfiguration API: https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_media-pipelines-chime_CreateMediaInsightsPipelineConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chimesdkmediapipelines_media_insights_pipeline_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_chimesdkmediapipelines_media_insights_pipeline_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: メディアインサイトパイプライン設定の名前を指定します。
  # 設定可能な値: 2-64文字の文字列（英数字、ドット、アンダースコア、ハイフンのみ）
  # パターン: ^[0-9a-zA-Z._-]+
  name = "MyMediaInsightsPipelineConfiguration"

  # resource_access_role_arn (Required)
  # 設定内容: サービスがプロセッサやシンクを呼び出すために使用するIAMロールのARNを指定します。
  # 設定可能な値: 有効なIAMロールARN（1-1024文字）
  # 関連機能: Call Analytics Resource Access Role
  #   Amazon Transcribe、Transcribe Call Analytics、その他のAWSリソースに
  #   アクセスするために使用されるサービスリンクロールです。
  #   - https://docs.aws.amazon.com/chime-sdk/latest/dg/call-analytics-resource-access-role.html
  resource_access_role_arn = "arn:aws:iam::123456789012:role/CallAnalyticsRole"

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
  # 要素設定（プロセッサとシンク）
  #-------------------------------------------------------------
  # メディアを変換しデータを配信するためのプロセッサとシンクのコレクションです。
  # 少なくとも1つの要素が必要です。
  #-------------------------------------------------------------

  #---------------------------------------
  # Amazon Transcribe Call Analytics プロセッサ
  #---------------------------------------
  # 通話音声をリアルタイムで文字起こしし、分析を行うプロセッサです。
  elements {
    # type (Required)
    # 設定内容: 要素のタイプを指定します。
    # 設定可能な値:
    #   - "AmazonTranscribeCallAnalyticsProcessor": Transcribe Call Analyticsプロセッサ
    #   - "AmazonTranscribeProcessor": Transcribeプロセッサ
    #   - "VoiceAnalyticsProcessor": 音声分析プロセッサ
    #   - "KinesisDataStreamSink": Kinesis Data Streamシンク
    #   - "LambdaFunctionSink": Lambda関数シンク
    #   - "SnsTopicSink": SNSトピックシンク
    #   - "SqsQueueSink": SQSキューシンク
    #   - "S3RecordingSink": S3録音シンク
    type = "AmazonTranscribeCallAnalyticsProcessor"

    amazon_transcribe_call_analytics_processor_configuration {
      # language_code (Required)
      # 設定内容: 文字起こしに使用する言語コードを指定します。
      # 設定可能な値:
      #   - "en-US": 英語（米国）
      #   - "en-GB": 英語（英国）
      #   - "es-US": スペイン語（米国）
      #   - "fr-CA": フランス語（カナダ）
      #   - "fr-FR": フランス語（フランス）
      #   - "en-AU": 英語（オーストラリア）
      #   - "it-IT": イタリア語
      #   - "de-DE": ドイツ語
      #   - "pt-BR": ポルトガル語（ブラジル）
      language_code = "en-US"

      # call_analytics_stream_categories (Optional)
      # 設定内容: インサイトターゲットに配信するカテゴリイベントのフィルターを指定します。
      # 設定可能な値: 文字列のリスト（Amazon Transcribe Call Analyticsで定義されたカテゴリ名）
      call_analytics_stream_categories = [
        "category_1",
        "category_2"
      ]

      # content_identification_type (Optional)
      # 設定内容: 発話イベントで識別されたすべてのPII（個人識別情報）にラベルを付けるかを指定します。
      # 設定可能な値:
      #   - "PII": PIIを識別してラベル付け
      # 注意: content_redaction_typeと排他的
      content_identification_type = null

      # content_redaction_type (Optional)
      # 設定内容: 発話イベントで識別されたすべてのPIIを墨消しするかを指定します。
      # 設定可能な値:
      #   - "PII": PIIを墨消し
      # 注意: content_identification_typeと排他的
      content_redaction_type = "PII"

      # enable_partial_results_stabilization (Optional)
      # 設定内容: 発話イベントで部分的な結果の安定化を有効にするかを指定します。
      # 設定可能な値:
      #   - true: 部分的な結果の安定化を有効化
      #   - false: 無効化
      enable_partial_results_stabilization = true

      # filter_partial_results (Optional)
      # 設定内容: 部分的な発話イベントをインサイトターゲットへの配信からフィルタリングするかを指定します。
      # 設定可能な値:
      #   - true: 部分結果をフィルタリング
      #   - false: フィルタリングしない
      filter_partial_results = true

      # language_model_name (Optional)
      # 設定内容: 文字起こしに使用するカスタム言語モデルの名前を指定します。
      # 設定可能な値: Amazon Transcribeで作成したカスタム言語モデル名
      language_model_name = "MyLanguageModel"

      # partial_results_stability (Optional)
      # 設定内容: 部分結果の安定化が有効な場合の安定性レベルを指定します。
      # 設定可能な値:
      #   - "high": 高い安定性（遅延が増加）
      #   - "medium": 中程度の安定性
      #   - "low": 低い安定性（より速いレスポンス）
      partial_results_stability = "high"

      # pii_entity_types (Optional)
      # 設定内容: 発話イベントから墨消しするPIIエンティティタイプを指定します。
      # 設定可能な値: カンマ区切りの文字列
      #   - ADDRESS: 住所
      #   - BANK_ACCOUNT_NUMBER: 銀行口座番号
      #   - BANK_ROUTING: 銀行ルーティング番号
      #   - CREDIT_DEBIT_CVV: クレジット/デビットカードCVV
      #   - CREDIT_DEBIT_EXPIRY: クレジット/デビットカード有効期限
      #   - CREDIT_DEBIT_NUMBER: クレジット/デビットカード番号
      #   - EMAIL: メールアドレス
      #   - NAME: 名前
      #   - PHONE: 電話番号
      #   - PIN: 暗証番号
      #   - SSN: 社会保障番号
      #   - ALL: すべてのエンティティタイプ
      pii_entity_types = "ADDRESS,BANK_ACCOUNT_NUMBER"

      # vocabulary_filter_method (Optional)
      # 設定内容: 発話イベントにボキャブラリフィルタを適用する方法を指定します。
      # 設定可能な値:
      #   - "mask": マスク（不適切な単語を***に置換）
      #   - "remove": 削除
      #   - "tag": タグ付け
      vocabulary_filter_method = "mask"

      # vocabulary_filter_name (Optional)
      # 設定内容: 発話イベント処理時に使用するカスタムボキャブラリフィルタの名前を指定します。
      # 設定可能な値: Amazon Transcribeで作成したカスタムボキャブラリフィルタ名
      vocabulary_filter_name = "MyVocabularyFilter"

      # vocabulary_name (Optional)
      # 設定内容: 発話イベント処理時に使用するカスタムボキャブラリの名前を指定します。
      # 設定可能な値: Amazon Transcribeで作成したカスタムボキャブラリ名
      vocabulary_name = "MyVocabulary"

      #-----------------------------------------
      # 通話後分析設定（Post-Call Analytics）
      #-----------------------------------------
      post_call_analytics_settings {
        # data_access_role_arn (Required)
        # 設定内容: AWS Transcribeが通話後分析をアップロードするために使用するロールのARNを指定します。
        # 設定可能な値: 有効なIAMロールARN
        data_access_role_arn = "arn:aws:iam::123456789012:role/PostCallAccessRole"

        # output_location (Required)
        # 設定内容: 通話後のトランスクリプション出力を保存するAmazon S3の場所を指定します。
        # 設定可能な値: S3 URI（例: s3://bucket-name）
        output_location = "s3://my-call-analytics-bucket"

        # content_redaction_output (Optional)
        # 設定内容: 出力を墨消しするかを指定します。
        # 設定可能な値:
        #   - "redacted": 墨消しされた出力
        #   - "redacted_and_unredacted": 墨消しと非墨消し両方の出力
        content_redaction_output = "redacted"

        # output_encryption_kms_key_id (Optional)
        # 設定内容: 出力の暗号化に使用するKMSキーのIDを指定します。
        # 設定可能な値: KMSキーIDまたはARN
        output_encryption_kms_key_id = "alias/my-kms-key"
      }
    }
  }

  #---------------------------------------
  # Amazon Transcribe プロセッサ（代替例）
  #---------------------------------------
  # elements {
  #   type = "AmazonTranscribeProcessor"
  #
  #   amazon_transcribe_processor_configuration {
  #     # language_code (Required)
  #     # 設定内容: 文字起こしに使用する言語コードを指定します。
  #     language_code = "en-US"
  #
  #     # content_identification_type (Optional)
  #     # 設定内容: トランスクリプトイベントで識別されたすべてのPIIにラベルを付けるかを指定します。
  #     content_identification_type = "PII"
  #
  #     # content_redaction_type (Optional)
  #     # 設定内容: トランスクリプトイベントで識別されたすべてのPIIを墨消しするかを指定します。
  #     content_redaction_type = null
  #
  #     # enable_partial_results_stabilization (Optional)
  #     # 設定内容: トランスクリプトイベントで部分的な結果の安定化を有効にするかを指定します。
  #     enable_partial_results_stabilization = true
  #
  #     # filter_partial_results (Optional)
  #     # 設定内容: 部分的な発話イベントをインサイトターゲットへの配信からフィルタリングするかを指定します。
  #     filter_partial_results = true
  #
  #     # language_model_name (Optional)
  #     # 設定内容: 文字起こしに使用するカスタム言語モデルの名前を指定します。
  #     language_model_name = "MyLanguageModel"
  #
  #     # partial_results_stability (Optional)
  #     # 設定内容: 部分結果の安定化が有効な場合の安定性レベルを指定します。
  #     partial_results_stability = "high"
  #
  #     # pii_entity_types (Optional)
  #     # 設定内容: トランスクリプトイベントから墨消しするPIIエンティティタイプを指定します。
  #     pii_entity_types = "ADDRESS,BANK_ACCOUNT_NUMBER"
  #
  #     # show_speaker_label (Optional)
  #     # 設定内容: トランスクリプトイベントで話者分離（ダイアライゼーション）を有効にするかを指定します。
  #     # 設定可能な値:
  #     #   - true: 話者ラベルを表示
  #     #   - false: 話者ラベルを表示しない
  #     show_speaker_label = true
  #
  #     # vocabulary_filter_method (Optional)
  #     # 設定内容: トランスクリプトイベントにボキャブラリフィルタを適用する方法を指定します。
  #     vocabulary_filter_method = "mask"
  #
  #     # vocabulary_filter_name (Optional)
  #     # 設定内容: トランスクリプトイベント処理時に使用するカスタムボキャブラリフィルタの名前を指定します。
  #     vocabulary_filter_name = "MyVocabularyFilter"
  #
  #     # vocabulary_name (Optional)
  #     # 設定内容: トランスクリプトイベント処理時に使用するカスタムボキャブラリの名前を指定します。
  #     vocabulary_name = "MyVocabulary"
  #   }
  # }

  #---------------------------------------
  # Voice Analytics プロセッサ（代替例）
  #---------------------------------------
  # elements {
  #   type = "VoiceAnalyticsProcessor"
  #
  #   voice_analytics_processor_configuration {
  #     # speaker_search_status (Required)
  #     # 設定内容: 話者検索を有効にするかを指定します。
  #     # 設定可能な値:
  #     #   - "Enabled": 有効
  #     #   - "Disabled": 無効
  #     # 関連機能: Speaker Search
  #     #   通話参加者を認識する音声分析機能です。
  #     speaker_search_status = "Enabled"
  #
  #     # voice_tone_analysis_status (Required)
  #     # 設定内容: 音声トーン分析を有効にするかを指定します。
  #     # 設定可能な値:
  #     #   - "Enabled": 有効
  #     #   - "Disabled": 無効
  #     # 関連機能: Voice Tone Analysis
  #     #   発話者の音声を分析し、ポジティブ・ネガティブ・ニュートラルな
  #     #   センチメントを検出する機能です。
  #     voice_tone_analysis_status = "Enabled"
  #   }
  # }

  #---------------------------------------
  # Kinesis Data Stream シンク
  #---------------------------------------
  elements {
    type = "KinesisDataStreamSink"

    kinesis_data_stream_sink_configuration {
      # insights_target (Required)
      # 設定内容: 結果を配信するKinesis Data StreamのARNを指定します。
      # 設定可能な値: 有効なKinesis Data Stream ARN
      insights_target = "arn:aws:kinesis:us-east-1:123456789012:stream/my-stream"
    }
  }

  #---------------------------------------
  # Lambda Function シンク（代替例）
  #---------------------------------------
  # elements {
  #   type = "LambdaFunctionSink"
  #
  #   lambda_function_sink_configuration {
  #     # insights_target (Required)
  #     # 設定内容: 結果を配信するLambda関数のARNを指定します。
  #     # 設定可能な値: 有効なLambda関数ARN
  #     insights_target = "arn:aws:lambda:us-east-1:123456789012:function:MyFunction"
  #   }
  # }

  #---------------------------------------
  # SNS Topic シンク（代替例）
  #---------------------------------------
  # elements {
  #   type = "SnsTopicSink"
  #
  #   sns_topic_sink_configuration {
  #     # insights_target (Required)
  #     # 設定内容: 結果を配信するSNSトピックのARNを指定します。
  #     # 設定可能な値: 有効なSNSトピックARN
  #     insights_target = "arn:aws:sns:us-east-1:123456789012:MyTopic"
  #   }
  # }

  #---------------------------------------
  # SQS Queue シンク（代替例）
  #---------------------------------------
  # elements {
  #   type = "SqsQueueSink"
  #
  #   sqs_queue_sink_configuration {
  #     # insights_target (Required)
  #     # 設定内容: 結果を配信するSQSキューのARNを指定します。
  #     # 設定可能な値: 有効なSQSキューARN
  #     insights_target = "arn:aws:sqs:us-east-1:123456789012:MyQueue"
  #   }
  # }

  #---------------------------------------
  # S3 Recording シンク（代替例）
  #---------------------------------------
  # elements {
  #   type = "S3RecordingSink"
  #
  #   s3_recording_sink_configuration {
  #     # destination (Optional)
  #     # 設定内容: 録音を配信するS3バケットのARNを指定します。
  #     # 設定可能な値: 有効なS3バケットARN
  #     destination = "arn:aws:s3:::my-recording-bucket"
  #   }
  # }

  #-------------------------------------------------------------
  # リアルタイムアラート設定
  #-------------------------------------------------------------
  # 特定の条件が満たされた場合にEventBridge通知を送信するための
  # リアルタイムアラートルールを設定します。
  #-------------------------------------------------------------

  real_time_alert_configuration {
    # disabled (Optional)
    # 設定内容: リアルタイムアラートルールを無効にするかを指定します。
    # 設定可能な値:
    #   - true: アラートを無効化
    #   - false: アラートを有効化
    disabled = false

    #---------------------------------------
    # アラートルール
    #---------------------------------------
    # 最大3つのルールを定義できます。
    #---------------------------------------

    # Issue Detection ルール
    rules {
      # type (Required)
      # 設定内容: ルールのタイプを指定します。
      # 設定可能な値:
      #   - "IssueDetection": 問題検出
      #   - "KeywordMatch": キーワードマッチ
      #   - "Sentiment": センチメント分析
      type = "IssueDetection"

      issue_detection_configuration {
        # rule_name (Required)
        # 設定内容: ルールの名前を指定します。
        # 設定可能な値: 識別可能な任意の文字列
        rule_name = "MyIssueDetectionRule"
      }
    }

    # Keyword Match ルール
    rules {
      type = "KeywordMatch"

      keyword_match_configuration {
        # rule_name (Required)
        # 設定内容: ルールの名前を指定します。
        rule_name = "MyKeywordMatchRule"

        # keywords (Required)
        # 設定内容: マッチするキーワードのコレクションを指定します。
        # 設定可能な値: 文字列のリスト
        keywords = ["complaint", "cancel", "refund"]

        # negate (Optional)
        # 設定内容: ルールを否定するかを指定します。
        # 設定可能な値:
        #   - true: キーワードが含まれていない場合にマッチ
        #   - false: キーワードが含まれている場合にマッチ
        negate = false
      }
    }

    # Sentiment ルール
    rules {
      type = "Sentiment"

      sentiment_configuration {
        # rule_name (Required)
        # 設定内容: ルールの名前を指定します。
        rule_name = "MySentimentRule"

        # sentiment_type (Required)
        # 設定内容: マッチするセンチメントタイプを指定します。
        # 設定可能な値:
        #   - "NEGATIVE": ネガティブなセンチメント
        #   - "POSITIVE": ポジティブなセンチメント
        sentiment_type = "NEGATIVE"

        # time_period (Required)
        # 設定内容: 分析間隔（秒）を指定します。
        # 設定可能な値: 数値（秒単位）
        time_period = 60
      }
    }
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    delete = "30m"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  tags = {
    Name        = "my-media-insights-config"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: メディアインサイトパイプライン設定のAmazon Resource Name (ARN)
#
# - id: メディアインサイトパイプライン設定の一意のID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
