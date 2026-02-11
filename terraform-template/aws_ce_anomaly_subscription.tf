#---------------------------------------------------------------
# AWS Cost Explorer Anomaly Subscription
#---------------------------------------------------------------
#
# AWS Cost Anomaly Detectionのサブスクリプション（アラートサブスクリプション）を
# プロビジョニングするリソースです。
# サブスクリプションは、異常検出モニターで検出されたコスト異常に対して、
# メールやSNSトピック経由で通知を受け取るための設定を定義します。
#
# AWS公式ドキュメント:
#   - Cost Anomaly Detection概要: https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
#   - AnomalySubscription API: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_AnomalySubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ce_anomaly_subscription" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: サブスクリプションの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "my-anomaly-subscription"

  # frequency (Required)
  # 設定内容: 異常レポートの送信頻度を指定します。
  # 設定可能な値:
  #   - "DAILY": 日次でレポートを送信
  #   - "IMMEDIATE": 異常検出時に即座に通知
  #   - "WEEKLY": 週次でレポートを送信
  # 注意: IMMEDIATEを使用すると、異常検出時にリアルタイムで通知を受け取れます。
  frequency = "DAILY"

  # monitor_arn_list (Required)
  # 設定内容: サブスクライブする異常検出モニターのARNリストを指定します。
  # 設定可能な値: aws_ce_anomaly_monitorリソースのARNのリスト
  # 注意: 複数のモニターを1つのサブスクリプションに関連付けることができます。
  monitor_arn_list = [
    "arn:aws:ce::123456789012:anomalymonitor/abc12345-1234-1234-1234-abc123456789"
  ]

  # account_id (Optional)
  # 設定内容: 異常サブスクリプションを作成するAWSアカウントの一意識別子を指定します。
  # 設定可能な値: 有効なAWSアカウントID（12桁の数字）
  # 省略時: 現在のアカウントが使用されます
  # account_id = "123456789012"

  #-------------------------------------------------------------
  # サブスクライバー設定
  #-------------------------------------------------------------

  # subscriber (Required)
  # 設定内容: 通知を受け取るサブスクライバーの設定を指定します。
  # 注意: 複数のsubscriberブロックを定義することで、複数の宛先に通知できます。

  subscriber {
    # type (Required)
    # 設定内容: サブスクリプションのタイプを指定します。
    # 設定可能な値:
    #   - "EMAIL": メールで通知を受信
    #   - "SNS": Amazon SNSトピック経由で通知を受信
    type = "EMAIL"

    # address (Required)
    # 設定内容: サブスクライバーのアドレスを指定します。
    # 設定可能な値:
    #   - typeが"EMAIL"の場合: 送信先のメールアドレス
    #   - typeが"SNS"の場合: SNSトピックのARN
    # 注意: SNSを使用する場合、SNSトピックにcostalerts.amazonaws.comからの
    #       Publish権限を付与するポリシーが必要です。
    address = "alerts@example.com"
  }

  # SNSトピックを使用する場合の例:
  # subscriber {
  #   type    = "SNS"
  #   address = "arn:aws:sns:ap-northeast-1:123456789012:cost-anomaly-alerts"
  # }

  #-------------------------------------------------------------
  # 閾値式設定
  #-------------------------------------------------------------

  # threshold_expression (Optional)
  # 設定内容: アラートを生成する異常の条件を指定する式を定義します。
  # 省略時: すべての検出された異常に対してアラートが生成されます。
  # 関連機能: 閾値式を使用することで、特定の条件を満たす異常のみ通知できます。
  #   - https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_AnomalySubscription.html

  threshold_expression {
    # 以下のいずれかを使用して条件を指定:
    # - dimension: 単一のディメンション条件
    # - cost_category: コストカテゴリによる条件
    # - tags: タグによる条件
    # - and: 複数条件のAND結合
    # - or: 複数条件のOR結合
    # - not: 条件の否定

    #-----------------------------------------------------------
    # dimension (Optional)
    # 設定内容: ディメンションベースのフィルタ条件を指定します。
    #-----------------------------------------------------------

    dimension {
      # key (Optional)
      # 設定内容: フィルタに使用するディメンションのキーを指定します。
      # 設定可能な値:
      #   - "ANOMALY_TOTAL_IMPACT_ABSOLUTE": 異常の絶対的な影響額（ドル）
      #   - "ANOMALY_TOTAL_IMPACT_PERCENTAGE": 異常の影響割合（パーセント）
      key = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"

      # match_options (Optional)
      # 設定内容: マッチングオプションを指定します。
      # 設定可能な値:
      #   - "EQUALS": 等しい
      #   - "ABSENT": 存在しない
      #   - "STARTS_WITH": 指定値で始まる
      #   - "ENDS_WITH": 指定値で終わる
      #   - "CONTAINS": 指定値を含む
      #   - "CASE_SENSITIVE": 大文字小文字を区別
      #   - "CASE_INSENSITIVE": 大文字小文字を区別しない
      #   - "GREATER_THAN_OR_EQUAL": 以上（閾値比較で使用）
      # 省略時: "EQUALS" と "CASE_SENSITIVE"
      match_options = ["GREATER_THAN_OR_EQUAL"]

      # values (Optional)
      # 設定内容: フィルタに使用する値を指定します。
      # 設定可能な値: 文字列のリスト
      # 例: 影響額が100ドル以上の異常のみアラート
      values = ["100"]
    }

    #-----------------------------------------------------------
    # cost_category (Optional)
    # 設定内容: コストカテゴリベースのフィルタ条件を指定します。
    #-----------------------------------------------------------

    # cost_category {
    #   # key (Optional)
    #   # 設定内容: コストカテゴリの名前を指定します。
    #   key = "Environment"
    #
    #   # match_options (Optional)
    #   # 設定内容: マッチングオプションを指定します。
    #   # 設定可能な値: "EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH",
    #   #               "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"
    #   match_options = ["EQUALS", "CASE_SENSITIVE"]
    #
    #   # values (Optional)
    #   # 設定内容: コストカテゴリの値を指定します。
    #   values = ["Production"]
    # }

    #-----------------------------------------------------------
    # tags (Optional)
    # 設定内容: タグベースのフィルタ条件を指定します。
    # 注意: これはthreshold_expression内のtagsブロックであり、
    #       リソースタグの設定とは異なります。
    #-----------------------------------------------------------

    # tags {
    #   # key (Optional)
    #   # 設定内容: タグのキーを指定します。
    #   key = "Project"
    #
    #   # match_options (Optional)
    #   # 設定内容: マッチングオプションを指定します。
    #   match_options = ["EQUALS", "CASE_SENSITIVE"]
    #
    #   # values (Optional)
    #   # 設定内容: タグの値を指定します。
    #   values = ["MyProject"]
    # }

    #-----------------------------------------------------------
    # and (Optional)
    # 設定内容: 複数の条件をAND結合します。
    # 注意: 複数のandブロックを指定すると、すべての条件を満たす必要があります。
    #-----------------------------------------------------------

    # and {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["100"]
    #   }
    # }
    #
    # and {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["50"]
    #   }
    # }

    #-----------------------------------------------------------
    # or (Optional)
    # 設定内容: 複数の条件をOR結合します。
    # 注意: 複数のorブロックを指定すると、いずれかの条件を満たせばアラートされます。
    #-----------------------------------------------------------

    # or {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["1000"]
    #   }
    # }
    #
    # or {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["100"]
    #   }
    # }

    #-----------------------------------------------------------
    # not (Optional)
    # 設定内容: 条件の否定を指定します。
    # 注意: 指定した条件に一致しない異常のみアラートされます。
    #-----------------------------------------------------------

    # not {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["10"]
    #   }
    # }
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-anomaly-subscription"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: 異常サブスクリプションのAmazon Resource Name (ARN)
#
# - id: 異常サブスクリプションの一意のID。arnと同じ値です。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: SNSトピックと組み合わせたリアルタイム通知
#---------------------------------------------------------------
#
# resource "aws_sns_topic" "cost_anomaly_updates" {
#   name = "CostAnomalyUpdates"
# }
#
# data "aws_iam_policy_document" "sns_topic_policy" {
#   statement {
#     sid     = "AWSAnomalyDetectionSNSPublishingPermissions"
#     actions = ["SNS:Publish"]
#     effect  = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["costalerts.amazonaws.com"]
#     }
#
#     resources = [aws_sns_topic.cost_anomaly_updates.arn]
#   }
# }
#
# resource "aws_sns_topic_policy" "default" {
#   arn    = aws_sns_topic.cost_anomaly_updates.arn
#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }
#
# resource "aws_ce_anomaly_monitor" "service_monitor" {
#   name              = "AWSServiceMonitor"
#   monitor_type      = "DIMENSIONAL"
#   monitor_dimension = "SERVICE"
# }
#
# resource "aws_ce_anomaly_subscription" "realtime" {
#   name      = "RealtimeAnomalySubscription"
#   frequency = "IMMEDIATE"
#
#   monitor_arn_list = [aws_ce_anomaly_monitor.service_monitor.arn]
#
#   subscriber {
#     type    = "SNS"
#     address = aws_sns_topic.cost_anomaly_updates.arn
#   }
#
#   depends_on = [aws_sns_topic_policy.default]
# }
#---------------------------------------------------------------
