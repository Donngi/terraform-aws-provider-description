#---------------------------------------------------------------
# AWS WAF Web ACL (Classic)
#---------------------------------------------------------------
#
# AWS WAF Classic の Web ACL（Web Access Control List）をプロビジョニングするリソースです。
# Web ACLはルールのコレクションであり、Webリクエストを許可・ブロック・カウントする
# 条件を定義します。CloudFrontディストリビューションまたはApplication Load Balancerに
# 関連付けることができます。
#
# 注意: このリソースはAWS WAF Classicリソースです。
#       新規構築にはAWS WAFv2（aws_wafv2_web_acl）の使用を推奨します。
#
# AWS公式ドキュメント:
#   - AWS WAF Classic Web ACL: https://docs.aws.amazon.com/waf/latest/developerguide/classic-web-acl-creating.html
#   - AWS WAF Classic Developer Guide: https://docs.aws.amazon.com/waf/latest/developerguide/classic-waf-chapter.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_waf_web_acl" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: Web ACLの名前または説明を指定します。
  # 設定可能な値: 1-128文字の英数字およびハイフン
  # 注意: AWS WAF全体で一意である必要があります。
  name = "example-web-acl"

  # metric_name (Required)
  # 設定内容: CloudWatchメトリクスに使用されるフレンドリー名を指定します。
  # 設定可能な値: 英数字のみ、128文字以内（スペースやハイフン不可）
  # 関連機能: CloudWatch メトリクス
  #   Web ACLに関連付けられたメトリクスを識別するために使用されます。
  metric_name = "exampleWebAcl"

  #-------------------------------------------------------------
  # デフォルトアクション設定
  #-------------------------------------------------------------

  # default_action (Required)
  # 設定内容: どのルールにも一致しないリクエストに対するデフォルトアクションを指定します。
  # 関連機能: AWS WAF アクション
  #   ルールに一致しなかったリクエストに対して適用されるフォールバックアクションです。
  default_action {
    # type (Required)
    # 設定内容: デフォルトアクションのタイプを指定します。
    # 設定可能な値:
    #   - "ALLOW": ルールに一致しないリクエストを許可する
    #   - "BLOCK": ルールに一致しないリクエストをブロックする
    # 注意: 通常は "ALLOW" を設定し、ブロックしたいリクエストをルールで定義します。
    #       セキュリティを優先する場合は "BLOCK" を設定し、許可するリクエストをルールで定義します。
    type = "ALLOW"
  }

  #-------------------------------------------------------------
  # ルール設定
  #-------------------------------------------------------------

  # rules (Optional)
  # 設定内容: Web ACLに関連付けるルールのセットを指定します。
  # 関連機能: AWS WAF ルール / ルールグループ
  #   各ルールには優先度とアクションを設定します。優先度の値が小さいほど先に評価されます。
  #   typeにGROUPを指定する場合はactionの代わりにoverride_actionを使用します。
  rules {
    # priority (Required)
    # 設定内容: ルールの評価優先度を指定します。
    # 設定可能な値: 正の整数
    # 注意: 同一Web ACL内で一意である必要があります。値が小さいほど優先度が高くなります。
    priority = 1

    # rule_id (Required)
    # 設定内容: 関連付けるAWS WAFルールまたはルールグループのIDを指定します。
    # 設定可能な値: 有効なAWS WAFルールID
    # 注意: aws_waf_rule または aws_waf_rule_group リソースのIDを参照します。
    rule_id = aws_waf_rule_group.example.id

    # type (Optional)
    # 設定内容: 関連付けるルールのタイプを指定します。
    # 設定可能な値:
    #   - "REGULAR": 通常のルール（デフォルト）
    #   - "RATE_BASED": レートベースのルール
    #   - "GROUP": ルールグループ
    # 省略時: "REGULAR"
    type = "GROUP"

    # override_action (Optional)
    # 設定内容: typeが"GROUP"の場合に、ルールグループのアクションを上書きするアクションを指定します。
    # 注意: typeが"GROUP"の場合はactionではなくoverride_actionを使用する必要があります。
    override_action {
      # type (Required)
      # 設定内容: 上書きアクションのタイプを指定します。
      # 設定可能な値:
      #   - "NONE": ルールグループのアクションをそのまま使用する
      #   - "COUNT": ルールグループのアクションを上書きしてカウントのみを実行する
      type = "NONE"
    }

    # action (Optional)
    # 設定内容: typeが"REGULAR"または"RATE_BASED"の場合に適用するアクションを指定します。
    # 注意: typeが"GROUP"の場合はoverride_actionを使用します。
    # action {
    #   # type (Required)
    #   # 設定内容: 実行するアクションのタイプを指定します。
    #   # 設定可能な値:
    #   #   - "ALLOW": リクエストを許可
    #   #   - "BLOCK": リクエストをブロック
    #   #   - "COUNT": リクエストをカウントのみ（ブロックも許可もしない）
    #   type = "COUNT"
    # }
  }

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # logging_configuration (Optional)
  # 設定内容: Web ACLのアクセスログ設定を指定します。
  # 関連機能: Amazon Kinesis Data Firehose
  #   ログはKinesis Data Firehoseを通じてS3やElasticsearchなどに配信されます。
  #   Firehoseデリバリーストリームの名前は "aws-waf-logs-" で始まる必要があります。
  logging_configuration {
    # log_destination (Required)
    # 設定内容: ログの送信先であるKinesis Data Firehoseデリバリーストリームの
    #           Amazon Resource Name (ARN) を指定します。
    # 設定可能な値: 有効なKinesis Data Firehose デリバリーストリームのARN
    # 注意: デリバリーストリーム名は "aws-waf-logs-" プレフィックスで始まる必要があります。
    log_destination = aws_kinesis_firehose_delivery_stream.example.arn

    # redacted_fields (Optional)
    # 設定内容: ログから除外するリクエストフィールドを指定します。
    # 関連機能: センシティブデータ保護
    #   パスワードや認証トークンなど、ログに記録すべきでないフィールドを除外できます。
    redacted_fields {
      # field_to_match (Required)
      # 設定内容: ログから除外するフィールドを指定します。複数指定可能です。
      field_to_match {
        # type (Required)
        # 設定内容: 照合するフィールドのタイプを指定します。
        # 設定可能な値:
        #   - "URI": リクエストのURIパート
        #   - "QUERY_STRING": クエリ文字列
        #   - "HEADER": HTTPヘッダー（dataでヘッダー名を指定）
        #   - "METHOD": HTTPメソッド
        #   - "BODY": リクエストボディ
        #   - "SINGLE_QUERY_ARG": 特定のクエリパラメーター（dataで名前を指定）
        #   - "ALL_QUERY_ARGS": すべてのクエリパラメーター
        type = "HEADER"

        # data (Optional)
        # 設定内容: typeが"HEADER"または"SINGLE_QUERY_ARG"の場合に、
        #           対象となるヘッダー名またはクエリパラメーター名を指定します。
        # 設定可能な値: 小文字のヘッダー名またはクエリパラメーター名
        # 省略時: type が HEADER や SINGLE_QUERY_ARG 以外の場合は不要
        data = "authorization"
      }
    }
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
    Name        = "example-web-acl"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: WAF Web ACLのID。
#
# - arn: WAF Web ACLのAmazon Resource Name (ARN)。
#        CloudFrontやALBへの関連付けに使用します。
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
