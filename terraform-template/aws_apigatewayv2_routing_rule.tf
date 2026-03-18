#---------------------------------------------------------------
# AWS API Gateway V2 Routing Rule
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2 のルーティングルールをプロビジョニングするリソースです。
# カスタムドメイン名に対して、リクエストのヘッダーやベースパスに基づいて
# 特定のAPIステージにルーティングするルールを定義します。
# REST APIのみがサポートされています。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名のルーティング: https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-custom-domain-names.html
#   - API Gateway V2の概念: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_routing_rule
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_routing_rule" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required, Forces new resource)
  # 設定内容: ルーティングルールを関連付けるカスタムドメイン名を指定します。
  # 設定可能な値: 1-512文字のドメイン名文字列
  # 注意: ドメイン名の変更は新しいリソースの作成を強制します。
  domain_name = "api.example.com"

  # priority (Required)
  # 設定内容: ルール評価の優先順位を指定します。
  # 設定可能な値: 1-1,000,000 の整数（小さい値ほど高優先）
  # 注意: 同一ドメイン内でルール間の優先度は重複できません。
  priority = 1

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
  # 条件設定 (Required)
  #-------------------------------------------------------------

  # condition (Required)
  # 設定内容: ルーティングルールの条件を指定します。
  # 注意: match_base_paths または match_headers のいずれか、もしくは両方を指定できます。
  condition {
    # match_base_paths (Optional)
    # 設定内容: リクエストのベースパスに基づくマッチング条件を指定します。
    # 注意: ベースパスのいずれかに一致した場合に条件が満たされます。
    match_base_paths {
      # any_of (Required)
      # 設定内容: マッチングするベースパスのリストを指定します。
      # 設定可能な値: 大文字小文字を区別するパス文字列のセット
      any_of = ["example-path", "another-path"]
    }

    # match_headers (Optional)
    # 設定内容: リクエストヘッダーに基づくマッチング条件を指定します。
    # 注意: いずれかのヘッダー名とヘッダー値のグロブが一致した場合に条件が満たされます。
    match_headers {
      # any_of (Required, Multiple)
      # 設定内容: マッチングするヘッダー条件を指定します。
      # 注意: 複数指定でき、いずれかに一致すればマッチとなります。
      any_of {
        # header (Required)
        # 設定内容: マッチング対象のヘッダー名を指定します。
        # 設定可能な値: 40文字以下の大文字小文字を区別しないヘッダー名
        #   使用可能な文字: a-z, A-Z, 0-9, *?-!#$%&'.^_`|~
        header = "X-Example-Header"

        # value_glob (Required)
        # 設定内容: ヘッダー値に対するグロブパターンを指定します。
        # 設定可能な値: 128文字以下の大文字小文字を区別するグロブパターン
        #   使用可能な文字: a-z, A-Z, 0-9, *?-!#$%&'.^_`|~
        #   ワイルドカード: *prefix-match, suffix-match*, *infix*-match
        value_glob = "example-value-*"
      }
    }
  }

  #-------------------------------------------------------------
  # アクション設定 (Required)
  #-------------------------------------------------------------

  # action (Required)
  # 設定内容: ルーティング条件が一致した場合に実行するアクションを指定します。
  action {
    # invoke_api (Required)
    # 設定内容: 呼び出すターゲットAPIのステージ設定を指定します。
    # 注意: REST APIのみがサポートされています。
    invoke_api {
      # api_id (Required)
      # 設定内容: 呼び出すターゲットAPIのIDを指定します。
      # 設定可能な値: 有効なAPI Gateway REST APIのID
      api_id = "example-api-id"

      # stage (Required)
      # 設定内容: 呼び出すAPIステージを指定します。
      # 設定可能な値: 有効なステージ名の文字列
      stage = "production"

      # strip_base_path (Optional)
      # 設定内容: ベースパスのストリップを有効にするかどうかを指定します。
      # 設定可能な値:
      #   - true: マッチしたベースパスをリクエストURIから除去してからAPIに転送
      #   - false: ベースパスをそのまま維持
      strip_base_path = true
    }
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - routing_rule_arn: ルーティングルールのAmazon Resource Name (ARN)
#
# - routing_rule_id: ルーティングルールの識別子
#
#---------------------------------------------------------------
