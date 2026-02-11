#---------------------------------------------------------------
# AWS WAFv2 Web ACL Logging Configuration
#---------------------------------------------------------------
#
# AWS WAFv2 Web ACLのログ記録設定をプロビジョニングするリソースです。
# Web ACLが検査するトラフィックのログを、Amazon CloudWatch Logs ロググループ、
# Amazon S3バケット、またはAmazon Kinesis Data Firehoseに配信する設定を行います。
# 1つのWeb ACLに対して1つのログ配信先を関連付けることができます。
#
# AWS公式ドキュメント:
#   - WAFv2 ログ記録: https://docs.aws.amazon.com/waf/latest/developerguide/logging.html
#   - ログ記録の設定: https://docs.aws.amazon.com/waf/latest/developerguide/logging-management-configure.html
#   - LoggingConfiguration API: https://docs.aws.amazon.com/waf/latest/APIReference/API_LoggingConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-06
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafv2_web_acl_logging_configuration" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: ログ記録を関連付けるWeb ACLのARNを指定します。
  # 設定可能な値: 有効なAWS WAFv2 Web ACLのARN
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/logging.html
  resource_arn = aws_wafv2_web_acl.example.arn

  # log_destination_configs (Required)
  # 設定内容: ログの配信先となるリソースのARNを指定します。
  # 設定可能な値: 以下のいずれかのARN（1つのみ指定可能）
  #   - Amazon Kinesis Data Firehose配信ストリームのARN
  #   - Amazon CloudWatch Logsロググループのarn
  #   - Amazon S3バケットのARN
  # 注意: 配信先リソースの名前は必ず "aws-waf-logs-" で始まる必要があります。
  #   例: aws-waf-logs-example-firehose, aws-waf-logs-example-log-group, aws-waf-logs-example-bucket
  # 注意: CloudWatch Logsロググループを使用する場合、多数のWeb ACLが存在するか
  #   頻繁にWeb ACLの作成・削除を行うと、汎用ログリソースポリシー"AWSWAF-LOGS"が
  #   最大ポリシーサイズを超過してリソース作成に失敗する場合があります。
  #   この問題を回避するには、aws_cloudwatch_log_resource_policyで個別のポリシーを管理してください。
  # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/logging.html
  log_destination_configs = [aws_cloudwatch_log_group.example.arn]

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
  # ログフィルタリング設定
  #-------------------------------------------------------------

  # logging_filter (Optional, 最大1ブロック)
  # 設定内容: ログに保持するリクエストとドロップするリクエストを制御するフィルタ設定です。
  # ルールアクションやWeb ACL評価中に適用されたラベルに基づいてフィルタリングできます。
  # 省略時: すべてのWebリクエストがログに記録されます。
  # 関連機能: WAFv2 ログフィルタリング
  #   Web ACL評価の結果に基づいて、特定のリクエストのみをログに記録することで
  #   ログの量とコストを最適化できます。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/logging.html
  logging_filter {

    # default_behavior (Required)
    # 設定内容: フィルタ条件に一致しないログのデフォルト処理を指定します。
    # 設定可能な値:
    #   - "KEEP": フィルタに一致しないログを保持
    #   - "DROP": フィルタに一致しないログを破棄
    default_behavior = "KEEP"

    # filter (Required, 1つ以上)
    # 設定内容: ログに適用するフィルタを定義します。
    # 複数のfilterブロックを指定できます。
    filter {

      # behavior (Required)
      # 設定内容: フィルタ条件に一致したログの処理方法を指定します。
      # 設定可能な値:
      #   - "KEEP": 条件に一致したログを保持
      #   - "DROP": 条件に一致したログを破棄
      behavior = "DROP"

      # requirement (Required)
      # 設定内容: フィルタ条件の評価ロジックを指定します。
      # 設定可能な値:
      #   - "MEETS_ALL": すべての条件に一致した場合にフィルタを適用（AND条件）
      #   - "MEETS_ANY": いずれかの条件に一致した場合にフィルタを適用（OR条件）
      requirement = "MEETS_ALL"

      # condition (Required, 1つ以上)
      # 設定内容: フィルタのマッチ条件を定義します。
      # 複数のconditionブロックを指定できます。
      # 各conditionには action_condition または label_name_condition のいずれかを指定します。
      condition {

        # action_condition (Optional, 最大1ブロック)
        # 設定内容: ルールアクションに基づくフィルタ条件を指定します。
        # 注意: label_name_conditionと排他的（conditionブロック内でどちらか一方のみ指定）
        action_condition {

          # action (Required)
          # 設定内容: ログレコードが含む必要があるアクション設定を指定します。
          # 設定可能な値:
          #   - "ALLOW": 許可アクション
          #   - "BLOCK": ブロックアクション
          #   - "COUNT": カウントアクション
          #   - "CAPTCHA": CAPTCHAアクション
          #   - "CHALLENGE": チャレンジアクション
          #   - "EXCLUDED_AS_COUNT": 除外（カウントとして扱い）アクション
          action = "COUNT"
        }
      }

      condition {

        # label_name_condition (Optional, 最大1ブロック)
        # 設定内容: ラベル名に基づくフィルタ条件を指定します。
        # 注意: action_conditionと排他的（conditionブロック内でどちらか一方のみ指定）
        label_name_condition {

          # label_name (Required)
          # 設定内容: ログレコードが含む必要があるラベルの完全修飾名を指定します。
          # 設定可能な値: 完全修飾ラベル名（プレフィックス、オプションの名前空間、ラベル名を含む）
          # 例: "awswaf:111122223333:rulegroup:testRules:LabelNameZ"
          # 参考: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-label-requirements.html#waf-rule-label-syntax
          label_name = "awswaf:111122223333:rulegroup:testRules:LabelNameZ"
        }
      }
    }
  }

  #-------------------------------------------------------------
  # フィールド墨消し設定
  #-------------------------------------------------------------

  # redacted_fields (Optional, 最大100ブロック)
  # 設定内容: ログから除外（墨消し）するリクエストの部分を指定します。
  # 墨消しされたフィールドはログ内で "REDACTED" と表示されます。
  # 省略時: リクエストのすべてのフィールドがログに記録されます。
  # 注意: 墨消し可能なフィールドは method, query_string, single_header, uri_path の4種類のみです。
  # 注意: 各redacted_fieldsブロックには上記のいずれか1つのみを指定します。
  #   複数のフィールドを墨消しする場合は、複数のredacted_fieldsブロックを記述します。
  # 関連機能: WAFv2 ログフィールド墨消し
  #   個人情報やセキュリティ上重要な情報をログから除外するために使用します。
  #   - https://docs.aws.amazon.com/waf/latest/developerguide/logging.html
  redacted_fields {

    # single_header (Optional, 最大1ブロック)
    # 設定内容: 墨消しする単一のHTTPヘッダーを指定します。
    single_header {

      # name (Required)
      # 設定内容: 墨消しするHTTPヘッダーの名前を指定します。
      # 設定可能な値: HTTPヘッダー名（小文字で指定する必要があります）
      # 例: "user-agent", "authorization", "cookie"
      name = "user-agent"
    }
  }

  redacted_fields {

    # method (Optional, 最大1ブロック)
    # 設定内容: HTTPメソッドを墨消しします。
    # 注意: 空のブロック {} として指定します。
    method {}
  }

  redacted_fields {

    # query_string (Optional, 最大1ブロック)
    # 設定内容: クエリ文字列を墨消しします。
    # クエリ文字列はURLの "?" 以降の部分です。
    # 注意: 空のブロック {} として指定します。
    query_string {}
  }

  redacted_fields {

    # uri_path (Optional, 最大1ブロック)
    # 設定内容: URIパスを墨消しします。
    # URIパスはリソースを識別するWebリクエストの一部です（例: /images/daily-ad.jpg）。
    # 注意: 空のブロック {} として指定します。
    uri_path {}
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAFv2 Web ACLのAmazon Resource Name (ARN)
#---------------------------------------------------------------
