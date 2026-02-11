#---------------------------------------------------------------
# AWS CloudFront Distribution Tenant
#---------------------------------------------------------------
#
# Amazon CloudFrontのディストリビューションテナントをプロビジョニングするリソースです。
# ディストリビューションテナントは、マルチテナントCloudFrontディストリビューション内で
# 分離された構成を作成します。各テナントは、基盤となるディストリビューションインフラを
# 共有しながら、独自のドメイン、カスタマイズ、パラメータを持つことができます。
#
# AWS公式ドキュメント:
#   - CloudFront マルチテナントディストリビューション: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-config-options.html
#   - ディストリビューションテナントのカスタマイズ: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/tenant-customization.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution_tenant
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_cloudfront_distribution_tenant" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ディストリビューションテナントの名前を指定します。
  # 設定可能な値: 文字列
  name = "example-tenant"

  # distribution_id (Required)
  # 設定内容: このテナントが関連付けられるマルチテナントディストリビューションのIDを指定します。
  # 設定可能な値: 有効なマルチテナントディストリビューションID
  # 関連機能: CloudFront マルチテナントディストリビューション
  #   テナントは指定されたマルチテナントディストリビューションの設定を継承します。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-config-options.html
  distribution_id = aws_cloudfront_multitenant_distribution.example.id

  # enabled (Optional)
  # 設定内容: ディストリビューションテナントを有効にするかどうかを指定します。
  # 設定可能な値:
  #   - true: テナントを有効化（リクエストを受け付ける）
  #   - false: テナントを無効化
  # 省略時: trueが設定されます
  enabled = true

  # connection_group_id (Optional)
  # 設定内容: テナントに関連付けるコネクショングループのIDを指定します。
  # 設定可能な値: 有効なコネクショングループID
  # 省略時: デフォルトのコネクショングループが使用されます
  # 関連機能: CloudFront コネクショングループ
  #   コネクショングループは、ビューアーリクエストがCloudFrontに接続する方法を制御します。
  #   複数のディストリビューションテナントで同じコネクショングループを共有できます。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-config-options.html
  connection_group_id = null

  # wait_for_deployment (Optional)
  # 設定内容: Terraformがディストリビューションテナントのデプロイ完了を待機するかを指定します。
  # 設定可能な値:
  #   - true: デプロイ完了まで待機（ステータスがDeployedになるまで）
  #   - false: デプロイ開始後すぐに次の処理へ進む
  # 省略時: trueが設定されます
  # 注意: falseに設定すると、デプロイが完了する前にTerraformが終了する可能性があります
  wait_for_deployment = true

  #-------------------------------------------------------------
  # ドメイン設定
  #-------------------------------------------------------------

  # domain (Required)
  # 設定内容: ディストリビューションテナントのドメイン設定を指定します。
  # 少なくとも1つのドメインブロックが必要です。
  # 関連機能: カスタムドメイン
  #   各テナントは独自のドメイン名を持ち、DNSレコードでCloudFrontのエンドポイントを指します。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/tenant-customization.html
  domain {
    # domain (Required)
    # 設定内容: テナントのドメイン名を指定します。
    # 設定可能な値: 有効なドメイン名（FQDN）
    domain = "tenant.example.com"
  }

  #-------------------------------------------------------------
  # パラメータ設定
  #-------------------------------------------------------------

  # parameter (Optional)
  # 設定内容: マルチテナントディストリビューションで定義されたパラメータの値を指定します。
  # パラメータはオリジンドメイン名やオリジンパスのプレースホルダー値として使用されます。
  # 関連機能: ディストリビューションテナントパラメータ
  #   マルチテナントディストリビューションで必須として定義されたパラメータは
  #   テナントレベルで値を指定する必要があります。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/tenant-customization.html
  parameter {
    # name (Required)
    # 設定内容: パラメータの名前を指定します。
    # 設定可能な値: マルチテナントディストリビューションで定義されたパラメータ名
    name = "customer-name"

    # value (Required)
    # 設定内容: パラメータの値を指定します。
    # 設定可能な値: パラメータに対応する値
    value = "mycompany"
  }

  #-------------------------------------------------------------
  # カスタマイズ設定
  #-------------------------------------------------------------

  # customizations (Optional)
  # 設定内容: ディストリビューションテナント固有のカスタマイズを指定します。
  # これらの設定はマルチテナントディストリビューションから継承された設定をオーバーライドします。
  # 関連機能: テナントカスタマイズ
  #   地理的制限、証明書、WAF設定をテナントレベルでカスタマイズできます。
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/tenant-customization.html
  customizations {

    #-----------------------------------------------------------
    # 地理的制限設定
    #-----------------------------------------------------------

    # geo_restriction (Optional)
    # 設定内容: テナント固有の地理的制限を設定します。
    # マルチテナントディストリビューションの地理的制限をオーバーライドします。
    # 関連機能: CloudFront 地理的制限
    #   特定の国からのアクセスを許可またはブロックできます。
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/georestrictions.html
    geo_restriction {
      # restriction_type (Optional)
      # 設定内容: 地理的制限のタイプを指定します。
      # 設定可能な値:
      #   - "whitelist": 指定した国のみからのアクセスを許可
      #   - "blacklist": 指定した国からのアクセスをブロック
      #   - "none": 地理的制限なし
      restriction_type = "whitelist"

      # locations (Optional)
      # 設定内容: 制限対象の国コードのリストを指定します。
      # 設定可能な値: ISO 3166-1-alpha-2 国コードのリスト（例: "US", "CA", "JP"）
      # 省略時: 空のリスト
      locations = ["US", "CA", "JP"]
    }

    #-----------------------------------------------------------
    # 証明書設定
    #-----------------------------------------------------------

    # certificate (Optional)
    # 設定内容: テナント固有のTLS証明書を設定します。
    # ACM証明書を指定すると、マルチテナントディストリビューションの証明書に加えて使用されます。
    # 同じドメインが両方の証明書でカバーされている場合、テナント証明書が優先されます。
    # 関連機能: CloudFront カスタムSSL証明書
    #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/managed-cloudfront-certificates.html
    certificate {
      # arn (Optional)
      # 設定内容: ACM証明書のARNを指定します。
      # 設定可能な値: 有効なACM証明書ARN（us-east-1リージョンに存在する必要があります）
      arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }

    #-----------------------------------------------------------
    # WAF設定
    #-----------------------------------------------------------

    # web_acl (Optional)
    # 設定内容: テナント固有のAWS WAF Web ACL設定を指定します。
    # マルチテナントディストリビューションのWeb ACL設定をオーバーライドまたは無効化できます。
    # 関連機能: AWS WAF
    #   - https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html
    web_acl {
      # action (Optional)
      # 設定内容: Web ACLに対するアクションを指定します。
      # 設定可能な値:
      #   - "override": テナント固有のWeb ACLでマルチテナントディストリビューションの設定をオーバーライド
      #   - "disable": このテナントではWeb ACL保護を無効化
      action = "override"

      # arn (Optional)
      # 設定内容: AWS WAF V2 Web ACLのARNを指定します。
      # 設定可能な値: 有効なWAFv2 Web ACL ARN
      # 注意: actionが"override"の場合に必要
      arn = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/example/12345678-1234-1234-1234-123456789012"
    }
  }

  #-------------------------------------------------------------
  # マネージド証明書リクエスト設定
  #-------------------------------------------------------------

  # managed_certificate_request (Optional)
  # 設定内容: CloudFrontマネージド証明書のリクエスト設定を指定します。
  # CloudFrontが自動的に証明書を発行・管理します。
  # 関連機能: CloudFrontマネージド証明書
  #   - https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/managed-cloudfront-certificates.html
  managed_certificate_request {
    # primary_domain_name (Optional)
    # 設定内容: 証明書のプライマリドメイン名を指定します。
    # 設定可能な値: 有効なドメイン名
    primary_domain_name = "tenant.example.com"

    # certificate_transparency_logging_preference (Optional)
    # 設定内容: 証明書の透明性ログへの記録設定を指定します。
    # 設定可能な値:
    #   - "ENABLED": 証明書の透明性ログに記録する
    #   - "DISABLED": 証明書の透明性ログに記録しない
    certificate_transparency_logging_preference = "ENABLED"

    # validation_token_host (Optional)
    # 設定内容: ドメイン検証トークンのホスト設定を指定します。
    # 設定可能な値: 有効なホスト名
    validation_token_host = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を設定します。
  timeouts {
    # create (Optional)
    # 設定内容: 作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    create = "30m"

    # update (Optional)
    # 設定内容: 更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "30m"

    # delete (Optional)
    # 設定内容: 削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = "30m"
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
    Name        = "example-tenant"
    Environment = "production"
    Tenant      = "customer-a"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディストリビューションテナントのID
#
# - arn: ディストリビューションテナントのAmazon Resource Name (ARN)
#
# - status: ディストリビューションテナントの現在のステータス
#
# - etag: ディストリビューションテナントの現在のバージョン（ETag）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - domain.*.status: 各ドメインのステータス
#---------------------------------------------------------------
