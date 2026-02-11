#---------------------------------------------------------------
# AWS Verified Access Endpoint
#---------------------------------------------------------------
#
# AWS Verified Accessのエンドポイントをプロビジョニングするリソースです。
# Verified Accessエンドポイントは、AWS Verified Accessがアクセスを提供する
# アプリケーションを指定し、Verified Accessグループに関連付ける必要があります。
# エンドポイントタイプとして、ロードバランサー、ネットワークインターフェイス、
# CIDR、RDSの4種類をサポートしています。
#
# AWS公式ドキュメント:
#   - Verified Access エンドポイント: https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
#   - API リファレンス: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VerifiedAccessEndpoint.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/verifiedaccess_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_verifiedaccess_endpoint" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # attachment_type (Required)
  # 設定内容: アタッチメントのタイプを指定します。
  # 設定可能な値:
  #   - "vpc": VPCアタッチメント（現在サポートされている唯一のタイプ）
  # 関連機能: Verified Access エンドポイントアタッチメント
  #   エンドポイントをVPCに関連付けることで、VPC内のリソースへのアクセスを提供します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  attachment_type = "vpc"

  # endpoint_type (Required)
  # 設定内容: 作成するVerified Accessエンドポイントのタイプを指定します。
  # 設定可能な値:
  #   - "load-balancer": ロードバランサーエンドポイント（ALB/NLBへの接続）
  #   - "network-interface": ネットワークインターフェイスエンドポイント（ENIへの接続）
  #   - "cidr": CIDRエンドポイント（指定したCIDRブロックへの接続）
  #   - "rds": RDSエンドポイント（RDSインスタンス/クラスター/プロキシへの接続）
  # 関連機能: Verified Access エンドポイントタイプ
  #   エンドポイントタイプに応じて、対応するオプションブロック（load_balancer_options、
  #   network_interface_options、cidr_options、rds_options）の設定が必要です。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  endpoint_type = "load-balancer"

  # verified_access_group_id (Required)
  # 設定内容: エンドポイントを関連付けるVerified AccessグループのIDを指定します。
  # 設定可能な値: 有効なVerified Access グループID
  # 関連機能: Verified Access グループ
  #   エンドポイントは必ずVerified Accessグループに関連付けられ、
  #   グループのアクセスポリシーを継承します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-groups.html
  verified_access_group_id = "vagr-1234567890abcdef0"

  #-------------------------------------------------------------
  # アプリケーション設定
  #-------------------------------------------------------------

  # application_domain (Optional)
  # 設定内容: ユーザーがアプリケーションに到達するためのDNS名を指定します。
  # 設定可能な値: 有効なドメイン名（例: example.com）
  # 注意: endpoint_typeが"load-balancer"または"network-interface"の場合は必須です。
  # 関連機能: Verified Access アプリケーションドメイン
  #   エンドユーザーがアクセスする際に使用するドメイン名を定義します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  application_domain = "example.com"

  # endpoint_domain_prefix (Optional)
  # 設定内容: エンドポイント用に生成されるDNS名の前に追加されるカスタム識別子を指定します。
  # 設定可能な値: 文字列（DNS命名規則に従う）
  # 関連機能: Verified Access エンドポイントドメイン
  #   AWSが生成するエンドポイントドメイン名にカスタムプレフィックスを付与できます。
  #   完全なエンドポイントドメイン名は、このプレフィックスとAWSが生成するサフィックスで構成されます。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  endpoint_domain_prefix = "my-app"

  # description (Optional)
  # 設定内容: Verified Accessエンドポイントの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example Verified Access Endpoint for production application"

  #-------------------------------------------------------------
  # 証明書設定
  #-------------------------------------------------------------

  # domain_certificate_arn (Optional)
  # 設定内容: エンドポイントに関連付けるAWS Certificate ManagerのパブリックTLS/SSL証明書のARNを指定します。
  # 設定可能な値: 有効なACM証明書ARN
  # 注意: endpoint_typeが"load-balancer"または"network-interface"の場合は必須です。
  #       証明書のCNは、エンドユーザーがアプリケーションに到達するために使用するDNS名と一致する必要があります。
  # 関連機能: Verified Access エンドポイント証明書
  #   エンドポイントへのHTTPS接続を有効にするために、ACM証明書が必要です。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  domain_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: Verified Accessエンドポイントに関連付けるセキュリティグループIDのリストを指定します。
  # 設定可能な値: 有効なセキュリティグループIDのセット
  # 省略時: デフォルトのセキュリティグループが使用される
  # 関連機能: Verified Access エンドポイントセキュリティグループ
  #   エンドポイントへのトラフィックを制御するためにセキュリティグループを使用します。
  #   アプリケーションのセキュリティグループには、エンドポイントからのトラフィックを許可するルールが必要です。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/configure-endpoint-security-group.html
  security_group_ids = ["sg-1234567890abcdef0"]

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ポリシー設定
  #-------------------------------------------------------------

  # policy_document (Optional)
  # 設定内容: このリソースに関連付けるポリシードキュメントを指定します。
  # 設定可能な値: JSON形式のポリシードキュメント文字列
  # 省略時: ポリシーなし（グループレベルのポリシーのみが適用される）
  # 関連機能: Verified Access エンドポイントレベルアクセスポリシー
  #   エンドポイントレベルでアクセスポリシーを定義し、より細かいアクセス制御を提供します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-policy.html
  policy_document = null

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------

  # load_balancer_options (Optional)
  # 設定内容: ロードバランサーの詳細設定を指定します。
  # 注意: endpoint_typeが"load-balancer"の場合は必須です。
  # 関連機能: Verified Access ロードバランサーエンドポイント
  #   Application Load BalancerまたはNetwork Load Balancerへのリクエストを
  #   分散するエンドポイントを構成します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  load_balancer_options {
    # load_balancer_arn (Optional)
    # 設定内容: ターゲットとなるロードバランサーのARNを指定します。
    # 設定可能な値: 有効なALBまたはNLBのARN
    load_balancer_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/my-alb/1234567890abcdef"

    # port (Optional)
    # 設定内容: ロードバランサーへの接続に使用するポート番号を指定します。
    # 設定可能な値: 1-65535の整数
    # 省略時: プロトコルのデフォルトポート（HTTPSの場合は443）
    port = 443

    # protocol (Optional)
    # 設定内容: ロードバランサーへの接続に使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "http": HTTP接続
    #   - "https": HTTPS接続
    # 省略時: https
    protocol = "https"

    # subnet_ids (Optional)
    # 設定内容: エンドポイントが配置されるサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    # 関連機能: Verified Access エンドポイントサブネット配置
    #   エンドポイントをVPC内の特定のサブネットに配置します。
    subnet_ids = ["subnet-1234567890abcdef0", "subnet-0987654321fedcba0"]

    # port_range (Optional, Min items: 1)
    # 設定内容: 許可するポート範囲を指定します。
    # 注意: 複数のポート範囲を指定可能です。
    port_range {
      # from_port (Required)
      # 設定内容: ポート範囲の開始ポート番号を指定します。
      # 設定可能な値: 1-65535の整数
      from_port = 443

      # to_port (Required)
      # 設定内容: ポート範囲の終了ポート番号を指定します。
      # 設定可能な値: 1-65535の整数（from_port以上である必要があります）
      to_port = 443
    }
  }

  #-------------------------------------------------------------
  # ネットワークインターフェイス設定
  #-------------------------------------------------------------

  # network_interface_options (Optional)
  # 設定内容: ネットワークインターフェイスの詳細設定を指定します。
  # 注意: endpoint_typeが"network-interface"の場合は必須です。
  # 関連機能: Verified Access ネットワークインターフェイスエンドポイント
  #   特定のElastic Network Interface（ENI）への接続を提供するエンドポイントを構成します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  network_interface_options {
    # network_interface_id (Optional)
    # 設定内容: ターゲットとなるネットワークインターフェイスのIDを指定します。
    # 設定可能な値: 有効なENI ID
    network_interface_id = "eni-1234567890abcdef0"

    # port (Optional)
    # 設定内容: ネットワークインターフェイスへの接続に使用するポート番号を指定します。
    # 設定可能な値: 1-65535の整数
    # 省略時: プロトコルのデフォルトポート
    port = 443

    # protocol (Optional)
    # 設定内容: ネットワークインターフェイスへの接続に使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "http": HTTP接続
    #   - "https": HTTPS接続
    # 省略時: https
    protocol = "https"

    # port_range (Optional)
    # 設定内容: 許可するポート範囲を指定します。
    # 注意: 複数のポート範囲を指定可能です。
    port_range {
      # from_port (Required)
      # 設定内容: ポート範囲の開始ポート番号を指定します。
      # 設定可能な値: 1-65535の整数
      from_port = 443

      # to_port (Required)
      # 設定内容: ポート範囲の終了ポート番号を指定します。
      # 設定可能な値: 1-65535の整数（from_port以上である必要があります）
      to_port = 443
    }
  }

  #-------------------------------------------------------------
  # CIDR設定
  #-------------------------------------------------------------

  # cidr_options (Optional)
  # 設定内容: CIDRブロックの詳細設定を指定します。
  # 注意: endpoint_typeが"cidr"の場合は必須です。
  # 関連機能: Verified Access CIDRエンドポイント
  #   指定したCIDRブロックへのリクエストを送信するエンドポイントを構成します。
  #   ネットワークセグメント全体へのアクセスを制御する場合に使用します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  cidr_options {
    # cidr (Required)
    # 設定内容: ターゲットとなるCIDRブロックを指定します。
    # 設定可能な値: 有効なCIDR表記（例: 10.0.1.0/24）
    cidr = "10.0.1.0/24"

    # protocol (Optional)
    # 設定内容: 使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "tcp": TCP接続
    #   - "udp": UDP接続
    # 省略時: tcp
    protocol = "tcp"

    # subnet_ids (Optional)
    # 設定内容: エンドポイントが配置されるサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnet_ids = ["subnet-1234567890abcdef0"]

    # port_range (Required, Min items: 1)
    # 設定内容: 許可するポート範囲を指定します。
    # 注意: 少なくとも1つのポート範囲が必須です。複数のポート範囲を指定可能です。
    port_range {
      # from_port (Required)
      # 設定内容: ポート範囲の開始ポート番号を指定します。
      # 設定可能な値: 1-65535の整数
      from_port = 443

      # to_port (Required)
      # 設定内容: ポート範囲の終了ポート番号を指定します。
      # 設定可能な値: 1-65535の整数（from_port以上である必要があります）
      to_port = 443
    }
  }

  #-------------------------------------------------------------
  # RDS設定
  #-------------------------------------------------------------

  # rds_options (Optional)
  # 設定内容: RDSの詳細設定を指定します。
  # 注意: endpoint_typeが"rds"の場合は必須です。
  # 関連機能: Verified Access RDSエンドポイント
  #   Amazon RDSインスタンス、クラスター、またはDBプロキシへのリクエストを
  #   送信するエンドポイントを構成します。
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/verified-access-endpoints.html
  rds_options {
    # port (Optional)
    # 設定内容: RDSへの接続に使用するポート番号を指定します。
    # 設定可能な値: 1-65535の整数
    # 省略時: データベースエンジンのデフォルトポート
    port = 3306

    # protocol (Optional)
    # 設定内容: RDSへの接続に使用するプロトコルを指定します。
    # 設定可能な値:
    #   - "tcp": TCP接続（データベース接続用）
    # 省略時: tcp
    protocol = "tcp"

    # rds_db_cluster_arn (Optional)
    # 設定内容: ターゲットとなるRDSデータベースクラスターのARNを指定します。
    # 設定可能な値: 有効なRDS DBクラスターARN
    # 注意: rds_db_instance_arn、rds_db_proxy_arn、rds_endpointのいずれかと排他的です。
    rds_db_cluster_arn = "arn:aws:rds:ap-northeast-1:123456789012:cluster:my-cluster"

    # rds_db_instance_arn (Optional)
    # 設定内容: ターゲットとなるRDSデータベースインスタンスのARNを指定します。
    # 設定可能な値: 有効なRDS DBインスタンスARN
    # 注意: rds_db_cluster_arn、rds_db_proxy_arn、rds_endpointのいずれかと排他的です。
    rds_db_instance_arn = null

    # rds_db_proxy_arn (Optional)
    # 設定内容: ターゲットとなるRDS Proxyのエンドポイント、DBプロキシ、またはDBプロキシターゲットのARNを指定します。
    # 設定可能な値: 有効なRDS ProxyのARN
    # 注意: rds_db_cluster_arn、rds_db_instance_arn、rds_endpointのいずれかと排他的です。
    rds_db_proxy_arn = null

    # rds_endpoint (Optional)
    # 設定内容: ターゲットとなるRDSカスタムエンドポイントのDNS名を指定します。
    # 設定可能な値: 有効なRDSエンドポイントのDNS名
    # 注意: rds_db_cluster_arn、rds_db_instance_arn、rds_db_proxy_arnのいずれかと排他的です。
    rds_endpoint = null

    # subnet_ids (Optional)
    # 設定内容: エンドポイントが配置されるサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    subnet_ids = ["subnet-1234567890abcdef0"]
  }

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # sse_specification (Optional)
  # 設定内容: サーバー側暗号化のオプションを指定します。
  # 関連機能: Verified Access サーバー側暗号化
  #   エンドポイントに関連するデータの暗号化オプションを構成します。
  sse_specification {
    # customer_managed_key_enabled (Optional)
    # 設定内容: カスタマー管理キー（CMK）を使用した暗号化を有効にするかを指定します。
    # 設定可能な値:
    #   - true: CMKを使用した暗号化を有効化
    #   - false: CMKを使用しない（AWSマネージド暗号化キーを使用）
    # 省略時: false
    customer_managed_key_enabled = true

    # kms_key_arn (Optional)
    # 設定内容: 暗号化に使用するKMSキーのARNを指定します。
    # 設定可能な値: 有効なKMSキーARN
    # 注意: customer_managed_key_enabledがtrueの場合に指定が推奨されます。
    kms_key_arn = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
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
  #   - https://docs.aws.amazon.com/verified-access/latest/ug/working-with-tags.html
  tags = {
    Name        = "example-verified-access-endpoint"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間（通常30分）
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間（通常30分）
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト時間（通常30分）
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: AWS Verified AccessエンドポイントのID
#
# - device_validation_domain: デバイストラストプロバイダーが
#        エンドポイントにアタッチされている場合に返されるドメイン
#
# - endpoint_domain: エンドポイント用に生成されるDNS名
#
# - verified_access_instance_id: Verified AccessインスタンスのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
