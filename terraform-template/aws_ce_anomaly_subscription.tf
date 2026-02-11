#---------------------------------------------------------------
# AWS Cost Explorer Anomaly Subscription
#---------------------------------------------------------------
#
# AWS Cost Explorerの異常検知サブスクリプションをプロビジョニングするリソースです。
# Anomaly Subscriptionは、Anomaly Monitorで検出されたコスト異常に対するアラート
# 通知先（メール、SNS）と通知頻度、閾値条件を設定します。
#
# AWS公式ドキュメント:
#   - Cost Anomaly Detection概要: https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
#   - CreateAnomalySubscription API: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_CreateAnomalySubscription.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
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
  name = "example-anomaly-subscription"

  # frequency (Required)
  # 設定内容: 異常検知レポートの送信頻度を指定します。
  # 設定可能な値:
  #   - "DAILY": 日次で異常レポートを送信
  #   - "IMMEDIATE": 異常検出時に即座に通知
  #   - "WEEKLY": 週次で異常レポートを送信
  frequency = "DAILY"

  #-------------------------------------------------------------
  # モニター設定
  #-------------------------------------------------------------

  # monitor_arn_list (Required)
  # 設定内容: サブスクリプションに関連付けるAnomaly MonitorのARNリストを指定します。
  # 設定可能な値: aws_ce_anomaly_monitorリソースのARN（複数指定可能）
  monitor_arn_list = [
    aws_ce_anomaly_monitor.example.arn,
  ]

  #-------------------------------------------------------------
  # アカウント設定
  #-------------------------------------------------------------

  # account_id (Optional)
  # 設定内容: 異常検知サブスクリプションを作成するAWSアカウントIDを指定します。
  # 省略時: 現在のAWSアカウントIDが使用されます
  account_id = null

  #-------------------------------------------------------------
  # 通知先設定（subscriber）
  #-------------------------------------------------------------
  # 異常検知の通知を受け取るサブスクライバーを設定します。
  # 複数のsubscriberブロックを定義可能です（最低1つ必須）。

  subscriber {
    # type (Required)
    # 設定内容: サブスクライバーのタイプを指定します。
    # 設定可能な値:
    #   - "EMAIL": メールアドレスへの通知
    #   - "SNS": SNSトピックへの通知
    type = "EMAIL"

    # address (Required)
    # 設定内容: 通知先のアドレスを指定します。
    # 設定可能な値:
    #   - typeが "EMAIL" の場合: メールアドレス（例: "alert@example.com"）
    #   - typeが "SNS" の場合: SNSトピックのARN
    address = "alert@example.com"
  }

  # # SNSトピック通知の設定例
  # subscriber {
  #   type    = "SNS"
  #   address = aws_sns_topic.cost_anomaly_updates.arn
  # }

  #-------------------------------------------------------------
  # 閾値条件設定（threshold_expression）
  #-------------------------------------------------------------
  # 異常通知のトリガーとなる閾値条件を設定します。
  # dimension、cost_category、tags、and、or、notを組み合わせてフィルタリングできます。
  # 省略時: デフォルトの閾値（影響額が$100以上のANOMALY_TOTAL_IMPACT_ABSOLUTE条件）が適用されます。

  threshold_expression {

    # dimension (Optional)
    # 設定内容: ディメンションベースの閾値条件を指定します。
    dimension {
      # key (Optional)
      # 設定内容: 閾値に使用するディメンションキーを指定します。
      # 設定可能な値:
      #   - "ANOMALY_TOTAL_IMPACT_ABSOLUTE": 異常による影響の絶対額（ドル）
      #   - "ANOMALY_TOTAL_IMPACT_PERCENTAGE": 異常による影響のパーセンテージ
      key = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"

      # match_options (Optional)
      # 設定内容: フィルタリングに使用するマッチオプションを指定します。
      # 設定可能な値: "EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH",
      #              "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE",
      #              "GREATER_THAN_OR_EQUAL"
      match_options = ["GREATER_THAN_OR_EQUAL"]

      # values (Optional)
      # 設定内容: 閾値の値を文字列のリストとして指定します。
      values = ["100"]
    }

    # # cost_category (Optional)
    # # 設定内容: コストカテゴリベースの閾値条件を指定します。
    # cost_category {
    #   # key (Optional)
    #   # 設定内容: コストカテゴリの名前を指定します。
    #   key = "Environment"
    #
    #   # match_options (Optional)
    #   # 設定内容: マッチオプションを指定します。
    #   # 設定可能な値: "EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH",
    #   #              "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"
    #   match_options = ["EQUALS"]
    #
    #   # values (Optional)
    #   # 設定内容: コストカテゴリの値を指定します。
    #   values = ["production"]
    # }

    # # tags (Optional)
    # # 設定内容: タグベースの閾値条件を指定します。
    # tags {
    #   # key (Optional)
    #   # 設定内容: タグのキーを指定します。
    #   key = "Environment"
    #
    #   # match_options (Optional)
    #   # 設定内容: マッチオプションを指定します。
    #   # 設定可能な値: "EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH",
    #   #              "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"
    #   match_options = ["EQUALS"]
    #
    #   # values (Optional)
    #   # 設定内容: タグの値を指定します。
    #   values = ["production"]
    # }

    # # not (Optional)
    # # 設定内容: 指定した条件に一致しない異常をフィルタリングします。
    # # 内部にdimension、cost_category、tagsブロックを1つ指定可能です。
    # not {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["50"]
    #   }
    # }

    # # and (Optional)
    # # 設定内容: 複数の条件をANDで組み合わせます。複数のandブロックを指定できます。
    # # 内部にdimension、cost_category、tagsブロックを指定可能です。
    # and {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["100"]
    #   }
    # }
    # and {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["50"]
    #   }
    # }

    # # or (Optional)
    # # 設定内容: 複数の条件をORで組み合わせます。複数のorブロックを指定できます。
    # # 内部にdimension、cost_category、tagsブロックを指定可能です。
    # or {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["200"]
    #   }
    # }
    # or {
    #   dimension {
    #     key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
    #     match_options = ["GREATER_THAN_OR_EQUAL"]
    #     values        = ["80"]
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-anomaly-subscription"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------------------------------
# arn: 異常検知サブスクリプションのARN
# id: 異常検知サブスクリプションの一意のID（arnと同じ値）
# tags_all: プロバイダーのdefault_tagsを含む全てのタグのマップ
#---------------------------------------------------------------
