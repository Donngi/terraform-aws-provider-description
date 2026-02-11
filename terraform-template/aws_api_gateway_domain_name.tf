#---------------------------------------------------------------
# AWS API Gateway Domain Name
#---------------------------------------------------------------
#
# Amazon API Gatewayにカスタムドメイン名を登録するリソースです。
# カスタムドメインを使用することで、APIを独自のドメイン名（例: api.example.com）
# で公開できます。Edge-optimized（CloudFront経由）またはRegional（リージョン直接）
# の2種類のエンドポイントタイプをサポートします。
#
# AWS公式ドキュメント:
#   - カスタムドメイン名の設定: https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
#   - セキュリティポリシー: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-custom-domain-tls-version.html
#   - 相互TLS認証: https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mutual-tls.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_api_gateway_domain_name" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: 登録する完全修飾ドメイン名（FQDN）を指定します。
  # 設定可能な値: 有効なドメイン名（例: api.example.com）
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
  # Edge-optimized エンドポイント用証明書設定
  # （ACM証明書使用時）
  #-------------------------------------------------------------

  # certificate_arn (Optional)
  # 設定内容: Edge-optimizedドメイン用のAWS管理証明書（ACM）のARNを指定します。
  # 設定可能な値: 有効なACM証明書ARN
  # 注意: Edge-optimizedエンドポイントで使用。CloudFront経由でリクエストをルーティング。
  #       certificate_name, certificate_body, certificate_chain, certificate_private_key,
  #       regional_certificate_arn, regional_certificate_name と排他的。
  # 関連機能: AWS Certificate Manager (ACM)
  #   ACMで発行または管理された証明書を使用することを推奨。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
  certificate_arn = null

  #-------------------------------------------------------------
  # Edge-optimized エンドポイント用証明書設定
  # （IAM証明書アップロード時）
  #-------------------------------------------------------------

  # certificate_name (Optional)
  # 設定内容: IAMサーバー証明書として登録する際の一意な名前を指定します。
  # 設定可能な値: 一意の証明書名文字列
  # 注意: certificate_arn, regional_certificate_arn, regional_certificate_name と排他的。
  #       certificate_arnが未設定の場合は必須。
  certificate_name = null

  # certificate_body (Optional)
  # 設定内容: ドメイン用に発行されたPEM形式の証明書本体を指定します。
  # 設定可能な値: PEM形式の証明書文字列
  # 注意: EDGEエンドポイントタイプでのみ有効。
  #       certificate_arn, regional_certificate_arn, regional_certificate_name と排他的。
  certificate_body = null

  # certificate_chain (Optional)
  # 設定内容: CA証明書と中間CA証明書を含む証明書チェーンを指定します。
  # 設定可能な値: PEM形式の証明書チェーン文字列
  # 注意: EDGEエンドポイントタイプでのみ有効。
  #       certificate_arn, regional_certificate_arn, regional_certificate_name と排他的。
  certificate_chain = null

  # certificate_private_key (Optional, Sensitive)
  # 設定内容: 証明書に関連付けられた秘密鍵を指定します。
  # 設定可能な値: PEM形式の秘密鍵文字列
  # 注意: EDGEエンドポイントタイプでのみ有効。
  #       certificate_arn, regional_certificate_arn, regional_certificate_name と排他的。
  #       この値はTerraformのstateファイルに平文で保存されます。
  certificate_private_key = null

  #-------------------------------------------------------------
  # Regional エンドポイント用証明書設定
  #-------------------------------------------------------------

  # regional_certificate_arn (Optional)
  # 設定内容: Regionalドメイン用のAWS管理証明書（ACM）のARNを指定します。
  # 設定可能な値: 有効なACM証明書ARN
  # 注意: Regionalエンドポイントで使用。CloudFrontを経由せず直接リージョンにルーティング。
  #       certificate_arn, certificate_name, certificate_body, certificate_chain,
  #       certificate_private_key と排他的。
  # 関連機能: AWS Certificate Manager (ACM)
  #   リージョナルAPIには同一リージョンのACM証明書が必要。
  #   - https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html
  regional_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  # regional_certificate_name (Optional)
  # 設定内容: Regionalエンドポイント用のIAM証明書名を指定します。
  # 設定可能な値: 証明書名文字列
  # 注意: certificate_arn, certificate_name, certificate_body, certificate_chain,
  #       certificate_private_key と排他的。
  regional_certificate_name = null

  #-------------------------------------------------------------
  # 所有権検証証明書設定
  #-------------------------------------------------------------

  # ownership_verification_certificate_arn (Optional)
  # 設定内容: カスタムドメインの所有権検証に使用するAWS発行証明書のARNを指定します。
  # 設定可能な値: 有効なACM証明書ARN
  # 用途: certificate_arnがACM Private CAで発行された場合、または
  #       mutual_tls_authenticationがACMインポート証明書で設定されている場合に必要。
  ownership_verification_certificate_arn = null

  #-------------------------------------------------------------
  # セキュリティポリシー設定
  #-------------------------------------------------------------

  # security_policy (Optional)
  # 設定内容: TLSバージョンと暗号スイートの組み合わせを指定します。
  # 設定可能な値:
  #   レガシーポリシー:
  #   - "TLS_1_0": TLS 1.0以上をサポート
  #   - "TLS_1_2": TLS 1.2以上をサポート（デフォルト）
  #   拡張ポリシー（SecurityPolicy_で始まる）:
  #   - "SecurityPolicy_TLS13_1_3_2025_09": TLS 1.3のみ、最新の暗号スイート
  #   - その他多数のポリシーが利用可能
  # 省略時: "TLS_1_2"
  # 関連機能: TLSセキュリティポリシー
  #   拡張ポリシーは高度なセキュリティ機能とポスト量子暗号をサポート。
  #   拡張ポリシー使用時はendpoint_access_modeの設定も必要。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-custom-domain-tls-version.html
  security_policy = "TLS_1_2"

  #-------------------------------------------------------------
  # エンドポイントアクセスモード設定
  #-------------------------------------------------------------

  # endpoint_access_mode (Optional)
  # 設定内容: ドメイン名のエンドポイントアクセスモードを指定します。
  # 設定可能な値:
  #   - "BASIC": 標準的なAPI Gatewayの動作
  #   - "STRICT": リクエストが正しいエンドポイントタイプから発信され、
  #               SNIホストマッチングチェックをパスすることを強制
  # 注意: SecurityPolicy_で始まる拡張セキュリティポリシー使用時のみ利用可能。
  #       STRICTモードはセキュリティを強化するが、一部のアプリケーションアーキテクチャに
  #       制限を与える可能性がある。
  # 関連機能: エンドポイントアクセスモード
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-security-policies.html
  endpoint_access_mode = null

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy (Optional)
  # 設定内容: execute-apiサービスに適用するJSONポリシードキュメントを指定します。
  # 設定可能な値: 有効なIAMポリシーJSON文字列
  # 注意: プライベートカスタムドメイン名でのみサポート。
  #       呼び出し元やメソッド設定に関係なく適用されます。
  policy = null

  #-------------------------------------------------------------
  # エンドポイント設定
  #-------------------------------------------------------------

  # endpoint_configuration (Optional)
  # 設定内容: APIエンドポイントの種類を定義するブロックです。
  endpoint_configuration {
    # types (Required)
    # 設定内容: エンドポイントタイプのリストを指定します。
    # 設定可能な値:
    #   - "EDGE": Edge-optimized API。CloudFront経由でルーティング。
    #   - "REGIONAL": Regional API。リージョン内で直接ルーティング。
    #   - "PRIVATE": Private API。VPCエンドポイント経由でのみアクセス可能。
    types = ["REGIONAL"]

    # ip_address_type (Optional)
    # 設定内容: ドメイン名を呼び出せるIPアドレスタイプを指定します。
    # 設定可能な値:
    #   - "ipv4": IPv4アドレスのみ許可
    #   - "dualstack": IPv4とIPv6の両方を許可
    # 注意: PRIVATEエンドポイントタイプでは"dualstack"のみサポート。
    #       この引数に値が指定された場合のみドリフト検出を実行。
    ip_address_type = null
  }

  #-------------------------------------------------------------
  # 相互TLS認証設定
  #-------------------------------------------------------------

  # mutual_tls_authentication (Optional)
  # 設定内容: ドメイン名の相互TLS認証設定を定義するブロックです。
  # 関連機能: 相互TLS (mTLS) 認証
  #   クライアントがAPIにアクセスする際にX.509証明書の提示を要求。
  #   双方向認証によりセキュリティを強化。
  #   - https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-mutual-tls.html
  mutual_tls_authentication {
    # truststore_uri (Required)
    # 設定内容: 相互TLS認証用のトラストストアを指定するS3 URLです。
    # 設定可能な値: S3 URL（例: s3://bucket-name/key-name）
    # 注意: トラストストアにはパブリックまたはプライベートCAの証明書を含められます。
    #       トラストストアを更新するには、S3に新バージョンをアップロードし、
    #       カスタムドメイン名を更新して新バージョンを使用するよう設定します。
    truststore_uri = "s3://my-bucket/truststore.pem"

    # truststore_version (Optional)
    # 設定内容: トラストストアを含むS3オブジェクトのバージョンを指定します。
    # 設定可能な値: S3オブジェクトのバージョンID
    # 注意: バージョンを指定するには、S3バケットでバージョニングを有効にする必要があります。
    truststore_version = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウトを設定するブロックです。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    update = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "api-example-com"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ドメイン名のAmazon Resource Name (ARN)
#
# - certificate_upload_date: ドメイン証明書に関連付けられたアップロード日
#
# - cloudfront_domain_name: このドメイン名マッピングを実装するCloudFront
#                           ディストリビューションのホスト名。
#                           Edge-optimizedエンドポイントでRoute53エイリアス
#                           レコード作成時に使用。
#
# - cloudfront_zone_id: CloudFrontディストリビューション用のホストゾーンID
#                       (Z2FDTNDATAQYW2)。Route53エイリアスレコード作成時に使用。
#
# - domain_name_id: API Gatewayが割り当てたドメイン名リソースの識別子。
#                   プライベートカスタムドメイン名でのみサポート。
#
# - id: API Gatewayが割り当てたドメイン名の内部識別子
#
# - regional_domain_name: カスタムドメインのリージョナルエンドポイント用ホスト名。
#                         Regionalエンドポイントで Route53エイリアスレコード作成時に使用。
#
#---------------------------------------------------------------
