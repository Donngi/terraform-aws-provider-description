#---------------------------------------------------------------
# AWS OpenSearch Domain
#---------------------------------------------------------------
#
# Amazon OpenSearch Serviceのドメインをプロビジョニングするリソースです。
# OpenSearchドメインは、ログ分析、リアルタイムアプリケーションモニタリング、
# クリックストリーム分析、全文検索などのユースケース向けの
# マネージド検索・分析クラスターを提供します。
#
# AWS公式ドキュメント:
#   - Amazon OpenSearch Service概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html
#   - OpenSearchドメインの作成と管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createupdatedomains.html
#   - OpenSearch Service の制限: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/limits.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain
#
# Provider Version: 6.43.0
# Generated: 2026-04-30
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # domain_name (Required, Forces new resource)
  # 設定内容: OpenSearchドメインの名前を指定します。
  # 設定可能な値: 3〜28文字。英小文字で開始し、英小文字・数字・ハイフンのみ使用可能。
  # 注意: 作成後の変更不可。リソースの再作成が必要。
  # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomains.html
  domain_name = "example-domain"

  # engine_version (Optional)
  # 設定内容: OpenSearchまたはElasticsearchのエンジンバージョンを指定します。
  # 設定可能な値:
  #   - "OpenSearch_X.Y" 形式（例: "OpenSearch_2.17", "OpenSearch_2.11"）
  #   - "Elasticsearch_X.Y" 形式（例: "Elasticsearch_7.10"）
  # 省略時: AWSが利用可能な最新のOpenSearchバージョンを使用
  # 関連機能: OpenSearch Serviceでサポートされているバージョン
  #   サービスソフトウェアと連動した特定エンジンバージョンを指定可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html#choosing-version
  engine_version = "OpenSearch_2.17"

  # ip_address_type (Optional)
  # 設定内容: ドメインのIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4のみ対応
  #   - "dualstack": IPv4とIPv6の両方対応
  # 省略時: AWSのデフォルト動作（通常 "ipv4"）
  # 関連機能: OpenSearch デュアルスタックサポート
  #   IPv4/IPv6両方のクライアントからのアクセスを受け付けるエンドポイントを提供。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomain-dualstack.html
  ip_address_type = "ipv4"

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
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # access_policies (Optional)
  # 設定内容: OpenSearchドメインへのアクセスを制御するIAMポリシードキュメントを指定します。
  # 設定可能な値: JSON形式のIAMポリシー文字列
  # 省略時: アクセスポリシーが設定されない（VPC内アクセスのみまたは細粒度アクセス制御のみで制御）
  # 関連機能: OpenSearch Service のアクセスポリシー
  #   ドメインレベルのアクセス制御。リソースベースポリシー、IDベースポリシー、
  #   IPベースポリシーで制御可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action    = "es:*"
        Resource  = "arn:aws:es:ap-northeast-1:123456789012:domain/example-domain/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["192.0.2.0/24"]
          }
        }
      }
    ]
  })

  #-------------------------------------------------------------
  # 高度なオプション
  #-------------------------------------------------------------

  # advanced_options (Optional)
  # 設定内容: OpenSearchの高度な設定オプションをマップ形式で指定します。
  # 設定可能な値:
  #   - "rest.action.multi.allow_explicit_index": "true" / "false"（_mklパスへの明示的なインデックス指定許可）
  #   - "indices.fielddata.cache.size": "20"（フィールドデータキャッシュサイズの上限%）
  #   - "indices.query.bool.max_clause_count": "1024"（boolクエリのclause最大数）
  #   - "override_main_response_version": "true" / "false"
  # 省略時: AWSのデフォルト設定
  # 関連機能: OpenSearch advanced options
  #   一部の値の更新時にはドメインの再起動が発生する場合あり。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomain-configure-advanced-options.html
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  #-------------------------------------------------------------
  # クラスター構成
  #-------------------------------------------------------------

  # cluster_config (Optional)
  # 設定内容: ドメインのクラスター（インスタンス、ノード、AZ等）の設定ブロックです。
  # 関連機能: OpenSearch クラスター構成
  #   インスタンスタイプ・台数、専用マスタノード、UltraWarm/Coldノード、
  #   マルチAZ構成等を指定。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-dedicatedmasternodes.html
  cluster_config {

    # instance_type (Optional)
    # 設定内容: データノードのインスタンスタイプを指定します。
    # 設定可能な値: OpenSearchサポート対象インスタンスタイプ（例: "r6g.large.search", "m6g.large.search", "t3.small.search"）
    # 省略時: "m4.large.search"（プロバイダーデフォルト）
    # 参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/supported-instance-types.html
    instance_type = "r6g.large.search"

    # instance_count (Optional)
    # 設定内容: クラスター内のデータノード（インスタンス）数を指定します。
    # 設定可能な値: 1以上の整数
    # 省略時: 1
    instance_count = 3

    # dedicated_master_enabled (Optional)
    # 設定内容: 専用マスタノードを有効化するかを指定します。
    # 設定可能な値:
    #   - true: 専用マスタノードを有効化（クラスター安定性が向上）
    #   - false: 専用マスタノード無効
    # 省略時: false
    # 推奨: 本番環境では有効化を推奨
    dedicated_master_enabled = true

    # dedicated_master_count (Optional)
    # 設定内容: 専用マスタノードの数を指定します。
    # 設定可能な値: 3 または 5（推奨は3、大規模クラスターでは5）
    # 省略時: 設定なし（dedicated_master_enabled=falseの場合）
    dedicated_master_count = 3

    # dedicated_master_type (Optional)
    # 設定内容: 専用マスタノードのインスタンスタイプを指定します。
    # 設定可能な値: OpenSearchサポート対象インスタンスタイプ（例: "c6g.large.search", "m6g.large.search"）
    # 省略時: 設定なし（dedicated_master_enabled=trueの場合は明示指定推奨）
    dedicated_master_type = "c6g.large.search"

    # zone_awareness_enabled (Optional)
    # 設定内容: マルチAZ配置（Zone Awareness）を有効化するかを指定します。
    # 設定可能な値:
    #   - true: 複数AZにノードを分散配置
    #   - false: 単一AZ配置
    # 省略時: false
    # 推奨: 本番環境では有効化を推奨
    zone_awareness_enabled = true

    # zone_awareness_config (Optional)
    # 設定内容: Zone Awarenessの詳細設定ブロックです。
    # 注意: zone_awareness_enabled = true の場合に有効
    zone_awareness_config {

      # availability_zone_count (Optional)
      # 設定内容: クラスターを分散させるAZの数を指定します。
      # 設定可能な値: 2 または 3
      # 省略時: 2
      availability_zone_count = 3
    }

    # multi_az_with_standby_enabled (Optional)
    # 設定内容: スタンバイ付きマルチAZ機能を有効化するかを指定します。
    # 設定可能な値:
    #   - true: 3AZ構成でスタンバイAZを設定（耐障害性が向上）
    #   - false: スタンバイ無効
    # 省略時: false
    # 関連機能: OpenSearch Multi-AZ with Standby
    #   3つのAZを使用しスタンバイAZを設定。AZ障害時の自動フェイルオーバーを高速化。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-multiaz.html
    multi_az_with_standby_enabled = false

    # warm_enabled (Optional)
    # 設定内容: UltraWarmストレージを有効化するかを指定します。
    # 設定可能な値:
    #   - true: UltraWarmノードを利用（読み取り専用ログ等の低コスト保管に最適）
    #   - false: UltraWarm無効
    # 省略時: false
    # 関連機能: OpenSearch UltraWarm
    #   読み取り専用データを低コストで保管。S3バックエンドのストレージを使用。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ultrawarm.html
    warm_enabled = false

    # warm_count (Optional)
    # 設定内容: UltraWarmノードの数を指定します。
    # 設定可能な値: 2〜150の整数
    # 省略時: 設定なし（warm_enabled=falseの場合）
    warm_count = null

    # warm_type (Optional)
    # 設定内容: UltraWarmノードのインスタンスタイプを指定します。
    # 設定可能な値: "ultrawarm1.medium.search", "ultrawarm1.large.search", "ultrawarm1.xlarge.search"
    # 省略時: 設定なし（warm_enabled=falseの場合）
    warm_type = null

    # cold_storage_options (Optional)
    # 設定内容: コールドストレージの設定ブロックです。
    # 関連機能: OpenSearch Cold Storage
    #   アクセス頻度の低い古いデータを最も低コストで保管。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cold-storage.html
    # 注意: warm_enabledがtrueでなければ利用不可
    cold_storage_options {

      # enabled (Optional)
      # 設定内容: コールドストレージを有効化するかを指定します。
      # 設定可能な値:
      #   - true: コールドストレージ有効
      #   - false: コールドストレージ無効
      # 省略時: false
      enabled = false
    }

    # node_options (Optional)
    # 設定内容: コーディネーターノード等の追加ノードタイプの設定ブロックです。
    # 関連機能: OpenSearch コーディネーターノード
    #   検索リクエストやインデックス処理を分散しデータノード負荷を軽減する専用ノード。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-coordinator-nodes.html
    node_options {

      # node_type (Optional)
      # 設定内容: 追加ノードのタイプを指定します。
      # 設定可能な値: "coordinator" 等
      # 省略時: 設定なし
      node_type = "coordinator"

      # node_config (Optional)
      # 設定内容: ノードタイプ別の詳細構成ブロックです。
      node_config {

        # enabled (Optional)
        # 設定内容: 当該ノードタイプを有効化するかを指定します。
        # 設定可能な値:
        #   - true: 有効化
        #   - false: 無効化
        # 省略時: false
        enabled = true

        # type (Optional)
        # 設定内容: ノードのインスタンスタイプを指定します。
        # 設定可能な値: OpenSearchサポート対象インスタンスタイプ
        # 省略時: 設定なし
        type = "m6g.large.search"

        # count (Optional)
        # 設定内容: 当該タイプのノード数を指定します。
        # 設定可能な値: 1以上の整数
        # 省略時: 設定なし
        count = 2
      }
    }
  }

  #-------------------------------------------------------------
  # EBSストレージ設定
  #-------------------------------------------------------------

  # ebs_options (Optional)
  # 設定内容: データノードに割り当てるEBSボリュームの設定ブロックです。
  # 関連機能: OpenSearch EBSストレージ
  #   データノードのストレージとしてEBSボリュームを使用。インスタンスストア使用時は無効化。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomain-configure-ebs.html
  ebs_options {

    # ebs_enabled (Required)
    # 設定内容: EBSボリュームを使用するかを指定します。
    # 設定可能な値:
    #   - true: EBSボリュームを使用
    #   - false: インスタンスストアを使用（i3.* 等のインスタンスのみ）
    ebs_enabled = true

    # volume_type (Optional)
    # 設定内容: EBSボリュームの種類を指定します。
    # 設定可能な値: "standard", "gp2", "gp3", "io1"
    # 省略時: AWSのデフォルト値（通常 "gp2"）
    volume_type = "gp3"

    # volume_size (Optional)
    # 設定内容: 各データノードに割り当てるEBSボリュームのサイズ（GiB）を指定します。
    # 設定可能な値: インスタンスタイプによる範囲制限あり
    # 省略時: 設定なし（ebs_enabled=trueの場合は必須）
    volume_size = 100

    # iops (Optional)
    # 設定内容: EBSボリュームに対するIOPSのベースラインを指定します。
    # 設定可能な値: gp3/io1の場合に指定可能。範囲はvolume_typeに依存
    # 省略時: AWSのデフォルト値
    iops = 3000

    # throughput (Optional)
    # 設定内容: EBSボリュームのスループット（MiB/s）を指定します。
    # 設定可能な値: gp3のみ。125〜1000
    # 省略時: AWSのデフォルト値（通常125）
    throughput = 125
  }

  #-------------------------------------------------------------
  # 保存時の暗号化設定
  #-------------------------------------------------------------

  # encrypt_at_rest (Optional)
  # 設定内容: 保存データの暗号化設定ブロックです。
  # 関連機能: OpenSearch 保存時暗号化
  #   AWS KMSキーを使ってドメインのデータを暗号化。一度有効化すると無効化不可。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/encryption-at-rest.html
  encrypt_at_rest {

    # enabled (Required)
    # 設定内容: 保存時暗号化を有効化するかを指定します。
    # 設定可能な値:
    #   - true: 暗号化有効
    #   - false: 暗号化無効
    # 注意: 一度trueにすると、ドメインの再作成なしでfalseに変更不可
    enabled = true

    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用するKMSキーのIDまたはARNを指定します。
    # 設定可能な値: KMSキーID、ARN、エイリアス名、エイリアスARN
    # 省略時: AWS管理のデフォルトキー（aws/es）を使用
    kms_key_id = "alias/aws/es"
  }

  #-------------------------------------------------------------
  # ノード間通信の暗号化設定
  #-------------------------------------------------------------

  # node_to_node_encryption (Optional)
  # 設定内容: ノード間通信の暗号化設定ブロックです。
  # 関連機能: OpenSearch ノード間暗号化
  #   クラスター内のノード間TLS通信を有効化。一度有効化すると無効化不可。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ntn.html
  node_to_node_encryption {

    # enabled (Required)
    # 設定内容: ノード間暗号化を有効化するかを指定します。
    # 設定可能な値:
    #   - true: ノード間暗号化有効
    #   - false: ノード間暗号化無効
    # 注意: 一度trueにすると、ドメインの再作成なしでfalseに変更不可
    enabled = true
  }

  #-------------------------------------------------------------
  # ドメインエンドポイント設定
  #-------------------------------------------------------------

  # domain_endpoint_options (Optional)
  # 設定内容: ドメインのエンドポイントに関する設定ブロック（HTTPS強制、TLSポリシー、カスタムエンドポイント等）です。
  # 関連機能: OpenSearch カスタムエンドポイント
  #   独自ドメイン名・証明書によるカスタムエンドポイントを設定可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/customendpoint.html
  domain_endpoint_options {

    # enforce_https (Optional)
    # 設定内容: HTTPSアクセスを強制するかを指定します。
    # 設定可能な値:
    #   - true: HTTPSアクセスのみ許可（推奨）
    #   - false: HTTP/HTTPS両方許可
    # 省略時: AWSのデフォルト値
    # 注意: advanced_security_optionsを有効化する場合はtrue必須
    enforce_https = true

    # tls_security_policy (Optional)
    # 設定内容: 接続時のTLSセキュリティポリシーを指定します。
    # 設定可能な値:
    #   - "Policy-Min-TLS-1-0-2019-07": TLS 1.0以上を許容
    #   - "Policy-Min-TLS-1-2-2019-07": TLS 1.2以上を許容
    #   - "Policy-Min-TLS-1-2-PFS-2023-10": TLS 1.2以上(PFS)
    # 省略時: AWSのデフォルトポリシー
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    # custom_endpoint_enabled (Optional)
    # 設定内容: カスタムエンドポイントを有効化するかを指定します。
    # 設定可能な値:
    #   - true: カスタムエンドポイント有効化
    #   - false: 標準エンドポイントを使用
    # 省略時: false
    custom_endpoint_enabled = false

    # custom_endpoint (Optional)
    # 設定内容: カスタムエンドポイントの完全修飾ドメイン名（FQDN）を指定します。
    # 設定可能な値: 有効なFQDN文字列
    # 省略時: 設定なし
    # 注意: custom_endpoint_enabled=trueの場合は必須
    custom_endpoint = null

    # custom_endpoint_certificate_arn (Optional)
    # 設定内容: カスタムエンドポイントに使用するACM証明書のARNを指定します。
    # 設定可能な値: ACM管理のSSL/TLS証明書ARN
    # 省略時: 設定なし
    # 注意: custom_endpoint_enabled=trueの場合は必須
    custom_endpoint_certificate_arn = null
  }

  #-------------------------------------------------------------
  # VPC設定
  #-------------------------------------------------------------

  # vpc_options (Optional)
  # 設定内容: ドメインをVPC内に配置する場合の設定ブロックです。
  # 関連機能: OpenSearch VPCサポート
  #   インターネットを経由せず、VPC内のリソースから安全にアクセス可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
  # 注意: 一度パブリックエンドポイントで作成すると、VPC配置への変更不可（再作成必要）
  vpc_options {

    # subnet_ids (Optional)
    # 設定内容: ドメインを配置するサブネットIDのセットを指定します。
    # 設定可能な値: 有効なサブネットIDのセット
    # 省略時: 設定なし
    # 注意: zone_awareness_enabled=trueの場合は複数AZのサブネット指定必須
    subnet_ids = ["subnet-12345678", "subnet-87654321"]

    # security_group_ids (Optional)
    # 設定内容: ドメインに関連付けるセキュリティグループIDのセットを指定します。
    # 設定可能な値: 有効なセキュリティグループIDのセット
    # 省略時: VPCのデフォルトセキュリティグループ
    security_group_ids = ["sg-0123456789abcdef0"]
  }

  #-------------------------------------------------------------
  # 高度なセキュリティ設定（細粒度アクセス制御）
  #-------------------------------------------------------------

  # advanced_security_options (Optional)
  # 設定内容: 細粒度アクセス制御（Fine-Grained Access Control）の設定ブロックです。
  # 関連機能: OpenSearch Fine-Grained Access Control
  #   インデックス・ドキュメント・フィールドレベルのアクセス制御、
  #   OpenSearch Dashboardsへのマルチテナント、SAML/JWT/Cognito認証等を提供。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
  # 注意: 有効化には encrypt_at_rest, node_to_node_encryption, enforce_https=true が必要
  advanced_security_options {

    # enabled (Required)
    # 設定内容: 細粒度アクセス制御を有効化するかを指定します。
    # 設定可能な値:
    #   - true: 細粒度アクセス制御を有効化
    #   - false: 無効化
    enabled = true

    # internal_user_database_enabled (Optional)
    # 設定内容: 内部ユーザーデータベースを使用するかを指定します。
    # 設定可能な値:
    #   - true: ユーザー名・パスワードで認証する内部DBを使用（master_user_options でユーザー作成）
    #   - false: IAMユーザー/ロール等の外部認証を使用
    # 省略時: false
    internal_user_database_enabled = true

    # anonymous_auth_enabled (Optional)
    # 設定内容: 匿名認証を許可するかを指定します。
    # 設定可能な値:
    #   - true: 匿名アクセス許可
    #   - false: 匿名アクセス不許可
    # 省略時: false
    anonymous_auth_enabled = false

    # master_user_options (Optional)
    # 設定内容: マスターユーザーの設定ブロックです。
    master_user_options {

      # master_user_name (Optional)
      # 設定内容: 内部DBで作成するマスターユーザー名を指定します。
      # 設定可能な値: 文字列
      # 省略時: 設定なし
      # 注意: internal_user_database_enabled=trueの場合に使用
      master_user_name = "admin"

      # master_user_password (Optional, Sensitive)
      # 設定内容: 内部DBで作成するマスターユーザーのパスワードを指定します。
      # 設定可能な値: 8文字以上、大文字・小文字・数字・記号を各1文字以上含む
      # 省略時: 設定なし
      # 注意: 機密情報のためAWS Secrets Manager等で管理推奨
      master_user_password = "ChangeMe!StrongP@ssw0rd"

      # master_user_arn (Optional)
      # 設定内容: マスターユーザーとして使用するIAMユーザー/ロールのARNを指定します。
      # 設定可能な値: 有効なIAM ARN
      # 省略時: 設定なし
      # 注意: internal_user_database_enabled=falseの場合に使用
      master_user_arn = null
    }

    # jwt_options (Optional)
    # 設定内容: JWT認証の設定ブロックです。
    # 関連機能: OpenSearch JWT認証
    #   外部IdPで発行したJWTトークンによる認証連携。
    #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html#fgac-jwt
    jwt_options {

      # enabled (Optional)
      # 設定内容: JWT認証を有効化するかを指定します。
      # 設定可能な値:
      #   - true: JWT認証有効
      #   - false: JWT認証無効
      # 省略時: false
      enabled = false

      # public_key (Optional)
      # 設定内容: JWTトークンの署名検証に使用する公開鍵（PEM形式）を指定します。
      # 設定可能な値: PEM形式公開鍵文字列
      # 省略時: 設定なし
      public_key = null

      # subject_key (Optional)
      # 設定内容: JWTのサブジェクト（ユーザー識別子）を保持するクレーム名を指定します。
      # 設定可能な値: クレーム名文字列（例: "sub"）
      # 省略時: AWSのデフォルト値（"sub"）
      subject_key = "sub"

      # roles_key (Optional)
      # 設定内容: JWTのロール情報を保持するクレーム名を指定します。
      # 設定可能な値: クレーム名文字列（例: "roles"）
      # 省略時: 設定なし
      roles_key = "roles"
    }
  }

  #-------------------------------------------------------------
  # AI/ML機能設定
  #-------------------------------------------------------------

  # aiml_options (Optional)
  # 設定内容: OpenSearchのAI/ML関連機能の設定ブロックです。
  # 関連機能: OpenSearch AI/ML統合
  #   自然言語クエリ生成、ベクトル検索アクセラレーション等のAI/ML機能を有効化。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ml-amazon-connector.html
  aiml_options {

    # natural_language_query_generation_options (Optional)
    # 設定内容: 自然言語クエリ生成機能の設定ブロックです。
    natural_language_query_generation_options {

      # desired_state (Optional)
      # 設定内容: 自然言語クエリ生成機能の希望状態を指定します。
      # 設定可能な値:
      #   - "ENABLED": 有効化
      #   - "DISABLED": 無効化
      # 省略時: AWSのデフォルト値
      desired_state = "DISABLED"
    }

    # s3_vectors_engine (Optional)
    # 設定内容: S3ベクターエンジンの設定ブロックです。
    s3_vectors_engine {

      # enabled (Optional)
      # 設定内容: S3ベクターエンジンを有効化するかを指定します。
      # 設定可能な値:
      #   - true: 有効化
      #   - false: 無効化
      # 省略時: AWSのデフォルト値
      enabled = false
    }

    # serverless_vector_acceleration (Optional)
    # 設定内容: サーバーレスベクターアクセラレーションの設定ブロックです。
    serverless_vector_acceleration {

      # enabled (Optional)
      # 設定内容: サーバーレスベクターアクセラレーションを有効化するかを指定します。
      # 設定可能な値:
      #   - true: 有効化
      #   - false: 無効化
      # 省略時: AWSのデフォルト値
      enabled = false
    }
  }

  #-------------------------------------------------------------
  # Auto-Tune設定
  #-------------------------------------------------------------

  # auto_tune_options (Optional)
  # 設定内容: OpenSearch Auto-Tuneの設定ブロックです。
  # 関連機能: OpenSearch Auto-Tune
  #   ワークロードに応じてクラスターのリソース使用率を自動最適化。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/auto-tune.html
  auto_tune_options {

    # desired_state (Required)
    # 設定内容: Auto-Tuneの希望状態を指定します。
    # 設定可能な値:
    #   - "ENABLED": Auto-Tune有効
    #   - "DISABLED": Auto-Tune無効
    desired_state = "ENABLED"

    # rollback_on_disable (Optional)
    # 設定内容: Auto-Tune無効化時のロールバック動作を指定します。
    # 設定可能な値:
    #   - "NO_ROLLBACK": ロールバックしない
    #   - "DEFAULT_ROLLBACK": デフォルト設定にロールバック
    # 省略時: AWSのデフォルト値
    rollback_on_disable = "NO_ROLLBACK"

    # use_off_peak_window (Optional)
    # 設定内容: Auto-Tuneのメンテナンスをオフピークウィンドウで実行するかを指定します。
    # 設定可能な値:
    #   - true: オフピークウィンドウを使用
    #   - false: maintenance_scheduleを使用
    # 省略時: 設定なし
    use_off_peak_window = true

    # maintenance_schedule (Optional)
    # 設定内容: Auto-Tuneのメンテナンススケジュールの設定ブロックです。
    # 注意: use_off_peak_window=falseの場合に使用。複数指定可能。
    maintenance_schedule {

      # start_at (Required)
      # 設定内容: メンテナンス開始日時（ISO 8601形式UTC）を指定します。
      # 設定可能な値: タイムスタンプ文字列（例: "2025-12-01T01:00:00Z"）
      start_at = "2025-12-01T01:00:00Z"

      # cron_expression_for_recurrence (Required)
      # 設定内容: メンテナンスの繰り返しを指定するcron式です。
      # 設定可能な値: 標準cron式
      cron_expression_for_recurrence = "cron(0 1 ? * SUN *)"

      # duration (Required)
      # 設定内容: メンテナンスウィンドウの持続時間の設定ブロックです。
      duration {

        # value (Required)
        # 設定内容: 持続時間の値を指定します。
        # 設定可能な値: 1〜24（unitがHOURSの場合）
        value = 2

        # unit (Required)
        # 設定内容: 持続時間の単位を指定します。
        # 設定可能な値: "HOURS"
        unit = "HOURS"
      }
    }
  }

  #-------------------------------------------------------------
  # オフピークウィンドウ設定
  #-------------------------------------------------------------

  # off_peak_window_options (Optional)
  # 設定内容: オフピークウィンドウの設定ブロックです。
  # 関連機能: OpenSearch オフピークウィンドウ
  #   メンテナンス・サービスソフトウェア更新・Auto-Tune等の管理オペレーションを
  #   トラフィックの少ない時間帯に集約。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/off-peak.html
  off_peak_window_options {

    # enabled (Optional)
    # 設定内容: オフピークウィンドウを有効化するかを指定します。
    # 設定可能な値:
    #   - true: オフピークウィンドウ有効
    #   - false: 無効
    # 省略時: AWSのデフォルト値
    enabled = true

    # off_peak_window (Optional)
    # 設定内容: オフピークウィンドウの開始時刻設定ブロックです。
    off_peak_window {

      # window_start_time (Optional)
      # 設定内容: オフピークウィンドウの開始時刻ブロックです（ローカル時刻）。
      window_start_time {

        # hours (Optional)
        # 設定内容: オフピークウィンドウ開始時刻の「時」を指定します。
        # 設定可能な値: 0〜23
        # 省略時: AWSのデフォルト値
        hours = 2

        # minutes (Optional)
        # 設定内容: オフピークウィンドウ開始時刻の「分」を指定します。
        # 設定可能な値: 0〜59
        # 省略時: AWSのデフォルト値
        minutes = 0
      }
    }
  }

  #-------------------------------------------------------------
  # 自動スナップショット設定
  #-------------------------------------------------------------

  # snapshot_options (Optional)
  # 設定内容: 自動スナップショットの設定ブロックです。
  # 関連機能: OpenSearch 自動スナップショット
  #   毎日1回の自動スナップショットの実行時刻を設定。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-snapshots.html
  snapshot_options {

    # automated_snapshot_start_hour (Required)
    # 設定内容: 自動スナップショットを開始する時刻（UTC, 0〜23時）を指定します。
    # 設定可能な値: 0〜23の整数
    automated_snapshot_start_hour = 23
  }

  #-------------------------------------------------------------
  # ソフトウェア更新設定
  #-------------------------------------------------------------

  # software_update_options (Optional)
  # 設定内容: サービスソフトウェアの自動更新設定ブロックです。
  # 関連機能: OpenSearch サービスソフトウェア更新
  #   セキュリティパッチ・バグ修正・新機能のサービスソフトウェアを自動適用するかを制御。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/service-software.html
  software_update_options {

    # auto_software_update_enabled (Optional)
    # 設定内容: サービスソフトウェアの自動更新を有効化するかを指定します。
    # 設定可能な値:
    #   - true: 自動更新有効
    #   - false: 自動更新無効
    # 省略時: AWSのデフォルト値
    auto_software_update_enabled = true
  }

  #-------------------------------------------------------------
  # ログ出力設定
  #-------------------------------------------------------------

  # log_publishing_options (Optional)
  # 設定内容: OpenSearchの各種ログをCloudWatch Logsに出力するかの設定ブロックです。
  #           複数指定可能（INDEX_SLOW_LOGS / SEARCH_SLOW_LOGS / ES_APPLICATION_LOGS / AUDIT_LOGS）。
  # 関連機能: OpenSearch ログ出力
  #   インデックス/検索スローログ、エラーログ、監査ログ等をCloudWatch Logsに発行可能。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomain-configure-slow-logs.html
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/audit-logs.html
  log_publishing_options {

    # log_type (Required)
    # 設定内容: 出力するログの種類を指定します。
    # 設定可能な値:
    #   - "INDEX_SLOW_LOGS": インデックス操作のスローログ
    #   - "SEARCH_SLOW_LOGS": 検索操作のスローログ
    #   - "ES_APPLICATION_LOGS": OpenSearchアプリケーションログ（エラー等）
    #   - "AUDIT_LOGS": 監査ログ（advanced_security_options有効時のみ）
    log_type = "INDEX_SLOW_LOGS"

    # cloudwatch_log_group_arn (Required)
    # 設定内容: ログの出力先となるCloudWatch LogsロググループのARNを指定します。
    # 設定可能な値: 有効なCloudWatch LogsロググループARN
    # 注意: OpenSearchサービスがロググループにログを送信できるリソースベースポリシー設定が必要
    cloudwatch_log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/opensearch/example-domain"

    # enabled (Optional)
    # 設定内容: 当該ログ出力を有効化するかを指定します。
    # 設定可能な値:
    #   - true: ログ出力有効
    #   - false: ログ出力無効
    # 省略時: true
    enabled = true
  }

  #-------------------------------------------------------------
  # Cognito認証設定
  #-------------------------------------------------------------

  # cognito_options (Optional)
  # 設定内容: OpenSearch DashboardsのCognito認証設定ブロックです。
  # 関連機能: OpenSearch Cognito認証
  #   Amazon CognitoユーザープールとIDプールを使用しOpenSearch Dashboards認証を実装。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cognito-auth.html
  cognito_options {

    # enabled (Optional)
    # 設定内容: Cognito認証を有効化するかを指定します。
    # 設定可能な値:
    #   - true: Cognito認証有効
    #   - false: Cognito認証無効
    # 省略時: false
    enabled = false

    # user_pool_id (Required)
    # 設定内容: Cognitoユーザープールの IDを指定します。
    # 設定可能な値: 有効なCognitoユーザープールID
    user_pool_id = "ap-northeast-1_xxxxxxxxx"

    # identity_pool_id (Required)
    # 設定内容: CognitoアイデンティティプールのIDを指定します。
    # 設定可能な値: 有効なCognitoアイデンティティプールID
    identity_pool_id = "ap-northeast-1:00000000-0000-0000-0000-000000000000"

    # role_arn (Required)
    # 設定内容: OpenSearchがCognito連携に使用するIAMロールのARNを指定します。
    # 設定可能な値: AmazonOpenSearchServiceCognitoAccess相当のポリシーがアタッチされたIAMロールARN
    role_arn = "arn:aws:iam::123456789012:role/service-role/CognitoAccessForAmazonOpenSearch"
  }

  #-------------------------------------------------------------
  # IAM Identity Center連携設定
  #-------------------------------------------------------------

  # identity_center_options (Optional)
  # 設定内容: AWS IAM Identity Centerとの連携設定ブロックです。
  # 関連機能: OpenSearch IAM Identity Center連携
  #   IAM Identity CenterユーザーでOpenSearch Dashboardsへのシングルサインオンを提供。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/identity-center.html
  identity_center_options {

    # enabled_api_access (Optional)
    # 設定内容: IAM Identity Center連携によるAPIアクセスを有効化するかを指定します。
    # 設定可能な値:
    #   - true: 有効化
    #   - false: 無効化
    # 省略時: 設定なし
    enabled_api_access = false

    # identity_center_instance_arn (Optional)
    # 設定内容: 連携先IAM Identity CenterインスタンスのARNを指定します。
    # 設定可能な値: 有効なIdentity CenterインスタンスARN
    # 省略時: 設定なし
    identity_center_instance_arn = null

    # subject_key (Optional)
    # 設定内容: 認証時のサブジェクト（ユーザー識別子）として使用する属性を指定します。
    # 設定可能な値: "UserName", "UserId" 等
    # 省略時: AWSのデフォルト値
    subject_key = "UserName"

    # roles_key (Optional)
    # 設定内容: 認証時のロール情報として使用する属性を指定します。
    # 設定可能な値: "GroupName", "GroupId" 等
    # 省略時: AWSのデフォルト値
    roles_key = "GroupName"
  }

  #-------------------------------------------------------------
  # デプロイメント戦略設定
  #-------------------------------------------------------------

  # deployment_strategy_options (Optional)
  # 設定内容: 設定変更時のデプロイメント戦略の設定ブロックです。
  # 関連機能: OpenSearch ブルー/グリーンデプロイメント
  #   ドメイン設定変更時のクラスター更新方式（ブルー/グリーン or インプレース）を制御。
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-configuration-changes.html
  deployment_strategy_options {

    # deployment_strategy (Required)
    # 設定内容: ドメイン構成変更時のデプロイ戦略を指定します。
    # 設定可能な値:
    #   - "BLUE_GREEN": ブルー/グリーンデプロイで更新（既定）
    #   - "ROLLING_UPDATE": ローリングアップデートで更新
    #   - "OPENSEARCH_NATIVE_ROLLING_UPDATE": OpenSearchネイティブのローリングアップデート
    deployment_strategy = "BLUE_GREEN"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト設定ブロックです。
  # 関連機能: Terraform timeouts
  #   - https://developer.hashicorp.com/terraform/language/resources/syntax#operation-timeouts
  timeouts {

    # create (Optional)
    # 設定内容: ドメイン作成のタイムアウトを指定します。
    # 設定可能な値: Go duration形式の文字列（例: "60m", "2h"）
    # 省略時: プロバイダーデフォルト
    create = "60m"

    # update (Optional)
    # 設定内容: ドメイン更新のタイムアウトを指定します。
    # 設定可能な値: Go duration形式の文字列
    # 省略時: プロバイダーデフォルト
    update = "180m"

    # delete (Optional)
    # 設定内容: ドメイン削除のタイムアウトを指定します。
    # 設定可能な値: Go duration形式の文字列
    # 省略時: プロバイダーデフォルト
    delete = "90m"
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
  #   - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-awsresourcetagging.html
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ドメインのID
# - arn: ドメインのAmazon Resource Name (ARN)
# - domain_id: AWS内部のドメイン一意識別子
# - endpoint: ドメインサービス固有のエンドポイントFQDN
# - endpoint_v2: デュアルスタック対応エンドポイントFQDN
# - domain_endpoint_v2_hosted_zone_id: endpoint_v2のホストゾーンID
# - dashboard_endpoint: OpenSearch DashboardsのエンドポイントFQDN
# - dashboard_endpoint_v2: OpenSearch Dashboardsのデュアルスタック対応エンドポイント
# - vpc_options.availability_zones: VPC配置時のAZリスト
# - vpc_options.vpc_id: VPC ID
# - tags_all: 継承タグを含む全タグマップ
#---------------------------------------------------------------
