#---------------------------------------------------------------
# AWS API Gateway V2 Domain Name
#---------------------------------------------------------------
#
# Amazon API Gateway Version 2 (HTTP API/WebSocket API) の
# カスタムドメイン名をプロビジョニングするリソースです。
# 特定のドメイン名の所有権とTLS設定を確立します。
# APIステージとの関連付けには aws_apigatewayv2_api_mapping リソースを使用します。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名の設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
#   - TLSセキュリティポリシー: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-custom-domain-tls-version.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_apigatewayv2_domain_name" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required, Forces new resource)
  # 設定内容: カスタムドメイン名を指定します。
  # 設定可能な値: 1-512文字のドメイン名文字列
  # 注意: ドメイン名の変更は新しいリソースの作成を強制します。
  domain_name = "api.example.com"

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
  # ルーティング設定
  #-------------------------------------------------------------

  # routing_mode (Optional)
  # 設定内容: ドメイン名のトラフィックルーティングモードを指定します。
  # 設定可能な値:
  #   - "API_MAPPING_ONLY": APIマッピングのみでルーティング（従来の動作）
  #   - "ROUTING_RULE_ONLY": ルーティングルールのみでルーティング
  #   - "ROUTING_RULE_THEN_API_MAPPING": ルーティングルールを優先し、マッチしない場合はAPIマッピングにフォールバック
  # 省略時: "API_MAPPING_ONLY"
  # 注意: ルーティングルール（aws_apigatewayv2_routing_rule）を使用する場合は
  #       "ROUTING_RULE_ONLY" または "ROUTING_RULE_THEN_API_MAPPING" を指定してください。
  routing_mode = null

  #-------------------------------------------------------------
  # ドメイン名設定 (Required)
  #-------------------------------------------------------------

  # domain_name_configuration (Required)
  # 設定内容: ドメイン名のTLS証明書、エンドポイント、セキュリティ設定を指定します。
  # 注意: 必須ブロックです。1つのみ指定可能。
  domain_name_configuration {
    # certificate_arn (Required)
    # 設定内容: エンドポイントで使用するACM証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    # 注意: AWS Certificate Manager (ACM) のみサポート。
    #       aws_acm_certificate リソースで証明書を設定してください。
    # 参考: https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
    certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

    # endpoint_type (Required)
    # 設定内容: エンドポイントタイプを指定します。
    # 設定可能な値:
    #   - "REGIONAL": リージョナルエンドポイント（現在唯一サポートされている値）
    # 注意: HTTP API と WebSocket API は REGIONAL エンドポイントのみサポート。
    endpoint_type = "REGIONAL"

    # security_policy (Required)
    # 設定内容: セキュリティポリシー（TLSバージョン）を指定します。
    # 設定可能な値:
    #   - "TLS_1_2": TLS 1.2（現在唯一サポートされている値）
    # 関連機能: API Gateway TLS セキュリティポリシー
    #   カスタムドメイン名のTLSバージョンと暗号スイートを定義します。
    #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-custom-domain-tls-version.html
    security_policy = "TLS_1_2"

    # ip_address_type (Optional)
    # 設定内容: ドメイン名を呼び出せるIPアドレスタイプを指定します。
    # 設定可能な値:
    #   - "ipv4": IPv4アドレスのみ許可
    #   - "dualstack": IPv4とIPv6の両方を許可
    # 省略時: "ipv4"
    ip_address_type = "ipv4"

    # ownership_verification_certificate_arn (Optional)
    # 設定内容: カスタムドメインの所有権検証に使用するAWS発行証明書のARNを指定します。
    # 設定可能な値: 有効なACM証明書ARN
    # 用途: 以下の場合に必要:
    #   - certificate_arn が ACM Private CA で発行された証明書の場合
    #   - mutual_tls_authentication で ACM インポート証明書を使用する場合
    ownership_verification_certificate_arn = null
  }

  #-------------------------------------------------------------
  # 相互TLS認証設定 (Optional)
  #-------------------------------------------------------------

  # mutual_tls_authentication (Optional)
  # 設定内容: ドメイン名の相互TLS (mTLS) 認証設定を指定します。
  # 関連機能: API Gateway 相互TLS認証
  #   クライアント証明書による双方向認証を実現します。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-mutual-tls.html
  mutual_tls_authentication {
    # truststore_uri (Required)
    # 設定内容: 相互TLS認証用のトラストストアを含むS3 URLを指定します。
    # 設定可能な値: S3 URL形式（例: s3://bucket-name/key-name）
    # 注意: トラストストアには公開または非公開認証局の証明書を含めることができます。
    #       更新するには、新しいバージョンをS3にアップロードし、
    #       カスタムドメイン名を新しいバージョンを使用するよう更新します。
    truststore_uri = "s3://my-bucket/truststore.pem"

    # truststore_version (Optional)
    # 設定内容: トラストストアを含むS3オブジェクトのバージョンを指定します。
    # 設定可能な値: S3オブジェクトのバージョンID
    # 注意: バージョンを指定するには、S3バケットでバージョニングが
    #       有効になっている必要があります。
    truststore_version = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルの default_tags 設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "api-example-com"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定 (Optional)
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト値を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "10m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト値を指定します。
    # 設定可能な値: 時間を表す文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメイン名の識別子
#
# - arn: ドメイン名のAmazon Resource Name (ARN)
#
# - api_mapping_selection_expression: ドメイン名のAPIマッピング選択式
#   https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-selection-expressions.html#apigateway-websocket-api-mapping-selection-expressions
#
# - tags_all: プロバイダーの default_tags 設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#
# domain_name_configuration 内:
# - hosted_zone_id: エンドポイントの Amazon Route 53 ホストゾーンID
#                   Route 53エイリアスレコード作成時に使用します。
#
# - target_domain_name: ターゲットドメイン名
#                       Route 53エイリアスレコード作成時に使用します。
#---------------------------------------------------------------
