#---------------------------------------------------------------
# AWS WAF Regional Web ACL
#---------------------------------------------------------------
#
# AWS WAF Regional Web ACL (アクセスコントロールリスト) をプロビジョニングするリソースです。
# Web ACLは、Webリクエストを許可・ブロック・カウントするルールのコレクションです。
# リージョナルWeb ACLは、Application Load Balancer (ALB) や
# API Gatewayなどのリージョナルリソースをトラフィックの検査から保護するために使用されます。
#
# 注意: このリソースはAWS WAF Classicを使用しています。
#       AWS WAF Classicは2025年9月30日にサポート終了が予定されています。
#       新規の実装にはAWS WAFv2 (aws_wafv2_web_acl) の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic概要: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#   - Web ACL: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_web_acl
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_wafregional_web_acl" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Web ACLのフレンドリーな名前を指定します。
  # 設定可能な値: 文字列
  # 注意: Web ACLを識別するための名前です。
  name = "example-web-acl"

  # metric_name (Required)
  # 設定内容: Web ACLのAmazon CloudWatchメトリクス用の名前を指定します。
  # 設定可能な値: 英数字のみの文字列（特殊文字不可）
  # 注意: CloudWatchメトリクスで使用される名前です。
  #       スペースやハイフンなどの特殊文字は使用できません。
  metric_name = "exampleWebAcl"

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
  # デフォルトアクション設定
  #-------------------------------------------------------------

  # default_action (Required)
  # 設定内容: どのルールにも一致しなかったリクエストに対するデフォルトアクションを指定します。
  # 注意: Web ACLの最後に評価されるアクションです。
  #       ルールにマッチしたリクエストはルールのアクションに従い処理されます。
  default_action {
    # type (Required)
    # 設定内容: デフォルトアクションのタイプを指定します。
    # 設定可能な値:
    #   - "ALLOW": リクエストを許可（ホワイトリスト方式の場合はBLOCKを推奨）
    #   - "BLOCK": リクエストをブロック（ブラックリスト方式の場合はALLOWを推奨）
    # 注意: ALLOWはデフォルトでリクエストを通過させ、特定のルールでブロックする場合に使用します。
    #       BLOCKはデフォルトでリクエストをブロックし、特定のルールで許可する場合に使用します。
    type = "ALLOW"
  }

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rule (Optional)
  # 設定内容: Web ACLに関連付けるルールのセットを指定します。
  # 注意: 複数のruleブロックを指定可能です。
  #       各ルールはpriorityの値に従って評価されます（小さい値から優先）。
  #       最大100件のルールを追加できます。
  rule {
    # priority (Required)
    # 設定内容: ルールの評価順序を指定します。
    # 設定可能な値: 数値（小さい値ほど優先度が高い）
    # 注意: Web ACL内で一意である必要があります。
    #       AWS WAFは優先度の低い（数値が小さい）ルールから評価します。
    priority = 1

    # rule_id (Required)
    # 設定内容: Web ACLに追加するWAFルールのIDを指定します。
    # 設定可能な値: 有効なaws_wafregional_ruleまたはaws_wafregional_rule_groupリソースのID
    # 注意: aws_wafregional_ruleまたはaws_wafregional_rule_groupで作成したリソースのIDを指定します。
    rule_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    # type (Optional)
    # 設定内容: ルールのタイプを指定します。
    # 設定可能な値:
    #   - "REGULAR": 通常のルール（デフォルト）
    #   - "RATE_BASED": レートベースのルール
    #   - "GROUP": ルールグループ
    # 省略時: "REGULAR"
    type = "REGULAR"

    # action (Optional)
    # 設定内容: ルールに一致したリクエストに対するアクションを指定します。
    # 注意: typeが"REGULAR"または"RATE_BASED"の場合に使用します。
    #       typeが"GROUP"の場合は、actionの代わりにoverride_actionを使用します。
    action {
      # type (Required)
      # 設定内容: アクションのタイプを指定します。
      # 設定可能な値:
      #   - "ALLOW": リクエストを許可
      #   - "BLOCK": リクエストをブロック
      #   - "COUNT": リクエストをカウント（許可/ブロックせず統計のみ取得）
      # 注意: COUNTアクションはルールのテストやモニタリングに有用です。
      type = "BLOCK"
    }

    # override_action (Optional)
    # 設定内容: ルールグループのアクションを上書きするアクションを指定します。
    # 注意: typeが"GROUP"の場合に使用します。actionと排他的です。
    # override_action {
    #   # type (Required)
    #   # 設定内容: 上書きアクションのタイプを指定します。
    #   # 設定可能な値:
    #   #   - "NONE": ルールグループのアクションをそのまま使用
    #   #   - "COUNT": ルールグループのアクションを上書きしてカウントのみ行う
    #   type = "NONE"
    # }
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: Web ACLのログ記録設定を指定します。
  # 注意: ログ記録にはKinesis Data Firehoseの設定が必要です。
  #       Firehoseのデリバリーストリーム名は"aws-waf-logs-"で始まる必要があります。
  # logging_configuration {
  #   # log_destination (Required)
  #   # 設定内容: ログの送信先となるKinesis Data FirehoseデリバリーストリームのARNを指定します。
  #   # 設定可能な値: 有効なKinesis Data FirehoseデリバリーストリームのARN
  #   # 注意: Firehoseストリーム名は"aws-waf-logs-"プレフィックスが必要です。
  #   log_destination = "arn:aws:firehose:us-east-1:123456789012:deliverystream/aws-waf-logs-example"
  #
  #   # redacted_fields (Optional)
  #   # 設定内容: ログから除外（マスキング）するフィールドを指定します。
  #   # 注意: 機密情報を含むフィールドをログから除外する際に使用します。
  #   redacted_fields {
  #     # field_to_match (Required)
  #     # 設定内容: マスキング対象のフィールドを指定します。
  #     # 注意: 1つ以上のfield_to_matchブロックが必要です。
  #     field_to_match {
  #       # type (Required)
  #       # 設定内容: マスキング対象のリクエストコンポーネントのタイプを指定します。
  #       # 設定可能な値:
  #       #   - "URI": URIパス
  #       #   - "QUERY_STRING": クエリ文字列
  #       #   - "HEADER": HTTPヘッダー（dataにヘッダー名が必要）
  #       #   - "METHOD": HTTPメソッド
  #       #   - "BODY": リクエストボディ
  #       type = "HEADER"
  #
  #       # data (Optional)
  #       # 設定内容: typeが"HEADER"の場合に、対象のヘッダー名を指定します。
  #       # 設定可能な値: HTTPヘッダー名（例: "authorization", "cookie"）
  #       # 省略時: typeがHEADER以外の場合は省略可能
  #       data = "authorization"
  #     }
  #   }
  # }

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
    Name        = "example-web-acl"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Regional Web ACLのID
#
# - arn: WAF Regional Web ACLのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
