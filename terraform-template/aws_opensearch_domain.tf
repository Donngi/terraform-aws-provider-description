# aws_opensearch_domain
# Amazon OpenSearch Service のドメインを管理するリソース
#
# Amazon OpenSearch Service は、ログ分析、リアルタイムアプリケーションモニタリング、
# 全文検索などのユースケース向けのマネージド検索・分析エンジン
# ドメインはOpenSearch（またはElasticsearch）クラスターに相当する
#
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。

#---------------------------------------
# aws_opensearch_domain リソース定義
#---------------------------------------

resource "aws_opensearch_domain" "example" {

  #---------------------------------------
  # 基本設定
  #---------------------------------------

  # 設定内容: ドメイン名（変更不可）
  # 設定可能な値: 3〜28文字、英小文字で開始、英小文字・数字・ハイフンのみ使用可能
  # 省略時: 省略不可（必須）
  domain_name = "example-domain"

  # 設定内容: OpenSearch/Elasticsearch エンジンバージョン
  # 設定可能な値: "OpenSearch_2.15", "OpenSearch_2.11", "Elasticsearch_7.10" など
  # 省略時: AWSが最新のOpenSearchバージョンを自動選択
  engine_version = "OpenSearch_2.11"

  # 設定内容: ドメインのIPアドレスタイプ
  # 設定可能な値: "ipv4", "dualstack"（IPv4/IPv6両対応、endpoint_v2を利用）
  # 省略時: AWSがデフォルト設定を使用
  ip_address_type = "ipv4"

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  # 設定内容: ドメインのアクセスポリシー（IAMポリシーJSONドキュメント）
  # 設定可能な値: JSON形式のIAMポリシードキュメント文字列
  # 省略時: AWSがデフォルト設定を使用
  access_policies = null

  # 設定内容: 詳細設定オプション（キーと値のマップ）
  # 設定可能な値: "rest.action.multi.allow_explicit_index", "indices.fielddata.cache.size",
  #               "indices.query.bool.max_clause_count", "override_main_response_version" など
  # 省略時: AWSのデフォルト設定を使用（値は必ず文字列で指定する）
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  # 設定内容: タグ
  # 設定可能な値: キーと値のペア
  # 省略時: タグなし
  tags = {
    Name        = "example-domain"
    Environment = "production"
  }

  #---------------------------------------
  # クラスター設定
  #---------------------------------------

  cluster_config {
    # 設定内容: データノードのインスタンスタイプ
    # 設定可能な値: "t3.small.search", "m6g.large.search", "r6g.large.search" など
    # 省略時: AWSがデフォルト設定を使用
    instance_type = "t3.small.search"

    # 設定内容: データノード数
    # 設定可能な値: 正の整数（1〜80）
    # 省略時: AWSがデフォルト設定を使用
    instance_count = 1

    # 設定内容: ゾーン分散（マルチAZ配置）を有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    zone_awareness_enabled = false

    # 設定内容: 専用マスターノードを有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    dedicated_master_enabled = false

    # 設定内容: 専用マスターノード数（dedicated_master_enabled=true時）
    # 設定可能な値: 3 または 5
    # 省略時: AWSがデフォルト設定を使用
    # dedicated_master_count = 3

    # 設定内容: 専用マスターノードのインスタンスタイプ（dedicated_master_enabled=true時）
    # 設定可能な値: "m6g.large.search", "r6g.large.search" など
    # 省略時: AWSがデフォルト設定を使用
    # dedicated_master_type = "m6g.large.search"

    # 設定内容: UltraWarmストレージを有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    warm_enabled = false

    # 設定内容: ウォームノード数（warm_enabled=true時に必須）
    # 設定可能な値: 2〜150
    # 省略時: AWSがデフォルト設定を使用
    # warm_count = 2

    # 設定内容: ウォームノードのインスタンスタイプ（warm_enabled=true時に必須）
    # 設定可能な値: "ultrawarm1.medium.search", "ultrawarm1.large.search", "ultrawarm1.xlarge.search"
    # 省略時: AWSがデフォルト設定を使用
    # warm_type = "ultrawarm1.medium.search"

    # 設定内容: スタンバイAZを持つMulti-AZ構成を有効化するか
    # 設定可能な値: true / false（有効時はzone_awareness_enabledも必須）
    # 省略時: false
    multi_az_with_standby_enabled = false

    # ゾーン分散設定（zone_awareness_enabled=true時に有効）
    zone_awareness_config {
      # 設定内容: アベイラビリティゾーン数
      # 設定可能な値: 2 または 3
      # 省略時: 2
      availability_zone_count = 2
    }

    # コールドストレージ設定（専用マスターノードとUltraWarm有効時のみ使用可能）
    cold_storage_options {
      # 設定内容: コールドストレージを有効化するか
      # 設定可能な値: true / false
      # 省略時: AWSがデフォルト設定を使用
      enabled = false
    }

    # ノードオプション設定（特定ノードタイプの追加設定）
    node_options {
      # 設定内容: ノードタイプ
      # 設定可能な値: "coordinator"
      # 省略時: AWSがデフォルト設定を使用
      node_type = "coordinator"

      node_config {
        # 設定内容: ノードを有効化するか
        # 設定可能な値: true / false
        # 省略時: AWSがデフォルト設定を使用
        enabled = false

        # 設定内容: ノードのインスタンスタイプ
        # 設定可能な値: サポートされているインスタンスタイプ
        # 省略時: AWSがデフォルト設定を使用
        # type = "m6g.large.search"

        # 設定内容: ノード数
        # 設定可能な値: 正の整数
        # 省略時: AWSがデフォルト設定を使用
        # count = 2
      }
    }
  }

  #---------------------------------------
  # EBSストレージ設定
  #---------------------------------------

  ebs_options {
    # 設定内容: EBSストレージを有効化するか
    # 設定可能な値: true / false（t2/t3インスタンスはEBS必須）
    # 省略時: 省略不可（必須）
    ebs_enabled = true

    # 設定内容: EBSボリュームタイプ
    # 設定可能な値: "gp2", "gp3", "io1", "standard"
    # 省略時: AWSがデフォルト設定を使用
    volume_type = "gp3"

    # 設定内容: EBSボリュームサイズ（GiB）
    # 設定可能な値: ボリュームタイプとインスタンスタイプにより異なる
    # 省略時: AWSがデフォルト設定を使用
    volume_size = 20

    # 設定内容: IOPS（gp3/io1ボリュームタイプ時に適用）
    # 設定可能な値: gp3は3000〜16000、io1は1000以上
    # 省略時: AWSがデフォルト設定を使用
    iops = 3000

    # 設定内容: スループット（MiB/s）（gp3ボリュームタイプ時のみ適用）
    # 設定可能な値: 125〜1000
    # 省略時: AWSがデフォルト設定を使用
    throughput = 125
  }

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------

  # 保存データの暗号化
  encrypt_at_rest {
    # 設定内容: 保存データの暗号化を有効化するか
    # 設定可能な値: true / false
    # 省略時: 省略不可（必須）
    enabled = true

    # 設定内容: KMSキーID（省略時はAWSマネージドキーを使用）
    # 設定可能な値: KMSキーのARN（IDではなくARNを指定すること）
    # 省略時: AWSマネージドキー（aws/es）を使用
    kms_key_id = null
  }

  # ノード間の通信暗号化
  node_to_node_encryption {
    # 設定内容: ノード間暗号化を有効化するか
    # 設定可能な値: true / false（OpenSearch_X.Y または Elasticsearch_6.0以降が必要）
    # 省略時: 省略不可（必須）
    enabled = true
  }

  #---------------------------------------
  # エンドポイント設定
  #---------------------------------------

  domain_endpoint_options {
    # 設定内容: HTTPSを強制するか
    # 設定可能な値: true / false
    # 省略時: true
    enforce_https = true

    # 設定内容: TLSセキュリティポリシー
    # 設定可能な値: "Policy-Min-TLS-1-0-2019-07", "Policy-Min-TLS-1-2-2019-07",
    #               "Policy-Min-TLS-1-2-PFS-2023-10"
    # 省略時: AWSがデフォルトポリシーを使用
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    # 設定内容: カスタムエンドポイントを有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    custom_endpoint_enabled = false

    # 設定内容: カスタムエンドポイントのFQDN（custom_endpoint_enabled=true時）
    # 設定可能な値: 有効なFQDN文字列
    # 省略時: AWSがデフォルト設定を使用
    # custom_endpoint = "search.example.com"

    # 設定内容: カスタムエンドポイント用ACM証明書ARN（custom_endpoint_enabled=true時）
    # 設定可能な値: ACM証明書のARN
    # 省略時: AWSがデフォルト設定を使用
    # custom_endpoint_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/example"
  }

  #---------------------------------------
  # VPC設定
  #---------------------------------------

  # 注意: vpc_options ブロックの追加・削除はリソースの再作成を強制する
  # vpc_options {
  #   # 設定内容: OpenSearch Serviceエンドポイントを作成するサブネットIDリスト
  #   # 設定可能な値: 有効なサブネットIDの集合
  #   # 省略時: AWSがデフォルト設定を使用
  #   subnet_ids = ["subnet-0123456789abcdef0"]
  #
  #   # 設定内容: エンドポイントに適用するセキュリティグループIDリスト
  #   # 設定可能な値: 有効なセキュリティグループIDの集合
  #   # 省略時: VPCのデフォルトセキュリティグループを使用
  #   security_group_ids = ["sg-0123456789abcdef0"]
  #
  #   # computed のみ（参照専用）
  #   # availability_zones - ドメインが配置されているAZ一覧
  #   # vpc_id            - ドメインが配置されているVPC ID
  # }

  #---------------------------------------
  # 高度なセキュリティ設定（Fine-grained access control）
  #---------------------------------------

  advanced_security_options {
    # 設定内容: Fine-grained access controlを有効化するか
    # 設定可能な値: true / false（有効時はnode_to_node_encryption、encrypt_at_rest、enforce_httpsも必須）
    # 省略時: 省略不可（必須）、trueからfalseへの変更はリソースの再作成を強制
    enabled = true

    # 設定内容: 匿名認証を有効化するか（既存ドメインでのFGAC有効化移行期間に使用）
    # 設定可能な値: true / false
    # 省略時: AWSがデフォルト設定を使用
    anonymous_auth_enabled = false

    # 設定内容: 内部ユーザーデータベースを有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    internal_user_database_enabled = true

    master_user_options {
      # 設定内容: マスターユーザーのIAM ARN（IAM認証使用時、internal_user_database_enabled=false時に使用）
      # 設定可能な値: IAMユーザーまたはロールのARN
      # 省略時: AWSがデフォルト設定を使用
      # master_user_arn = "arn:aws:iam::123456789012:user/master-user"

      # 設定内容: マスターユーザー名（internal_user_database_enabled=true時に使用）
      # 設定可能な値: 文字列
      # 省略時: AWSがデフォルト設定を使用
      master_user_name = "admin"

      # 設定内容: マスターユーザーパスワード（internal_user_database_enabled=true時、センシティブ値）
      # 設定可能な値: 大文字・小文字・数字・特殊文字を含む8文字以上
      # 省略時: AWSがデフォルト設定を使用
      master_user_password = "YourSecurePassword1!"
    }

    # JWT認証設定（OpenSearch 2.11以降で使用可能）
    jwt_options {
      # 設定内容: JWT認証を有効化するか
      # 設定可能な値: true / false
      # 省略時: AWSがデフォルト設定を使用
      enabled = false

      # 設定内容: JWT署名検証用のPEMエンコード公開鍵
      # 設定可能な値: PEM形式の公開鍵文字列
      # 省略時: AWSがデフォルト設定を使用
      # public_key = null

      # 設定内容: JWTアサーション内のロール情報要素
      # 設定可能な値: JWTクレームキー文字列
      # 省略時: "roles"
      # roles_key = "roles"

      # 設定内容: JWTアサーション内のユーザー名要素
      # 設定可能な値: JWTクレームキー文字列
      # 省略時: "sub"
      # subject_key = "sub"
    }
  }

  #---------------------------------------
  # Cognito認証設定（OpenSearch Dashboards認証用）
  #---------------------------------------

  cognito_options {
    # 設定内容: Cognito認証を有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    enabled = false

    # 設定内容: Cognito IDプールID
    # 設定可能な値: 有効なCognito IDプールID
    # 省略時: 省略不可（必須）
    identity_pool_id = "ap-northeast-1:12345678-1234-1234-1234-123456789012"

    # 設定内容: Cognitoユーザープールのid
    # 設定可能な値: 有効なCognitoユーザープールID
    # 省略時: 省略不可（必須）
    user_pool_id = "ap-northeast-1_XXXXXXXXX"

    # 設定内容: OpenSearch ServiceがCognitoにアクセスするためのIAMロールARN
    # 設定可能な値: AmazonOpenSearchServiceCognitoAccessポリシーが付与されたIAMロールのARN
    # 省略時: 省略不可（必須）
    role_arn = "arn:aws:iam::123456789012:role/opensearch-cognito-role"
  }

  #---------------------------------------
  # ログ設定（複数のlog_typeに対して複数ブロックを宣言可能）
  #---------------------------------------

  log_publishing_options {
    # 設定内容: 発行するログの種類
    # 設定可能な値: "INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS",
    #               "AUDIT_LOGS"（AUDIT_LOGSはFine-grained access control有効時のみ）
    # 省略時: 省略不可（必須）
    log_type = "INDEX_SLOW_LOGS"

    # 設定内容: ログ送信先CloudWatch Logs グループのARN
    # 設定可能な値: CloudWatch LogsグループのARN
    # 省略時: 省略不可（必須）
    cloudwatch_log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/opensearch/example"

    # 設定内容: このログ設定を有効化するか
    # 設定可能な値: true / false
    # 省略時: true
    enabled = true
  }

  #---------------------------------------
  # Auto-Tune設定
  #---------------------------------------

  auto_tune_options {
    # 設定内容: Auto-Tuneの希望状態
    # 設定可能な値: "ENABLED", "DISABLED"
    # 省略時: 省略不可（必須）
    desired_state = "ENABLED"

    # 設定内容: Auto-Tune無効化時のロールバック設定
    # 設定可能な値: "NO_ROLLBACK", "DEFAULT_ROLLBACK"
    # 省略時: AWSがデフォルト設定を使用
    rollback_on_disable = "NO_ROLLBACK"

    # 設定内容: オフピーク時間枠を使用するか（true時はmaintenance_scheduleブロックは指定不可）
    # 設定可能な値: true / false
    # 省略時: false
    use_off_peak_window = true

    # メンテナンススケジュール（use_off_peak_window=false時に使用、複数指定可能）
    # maintenance_schedule {
    #   # 設定内容: メンテナンス開始時刻（RFC3339形式）
    #   # 省略時: 省略不可（必須）
    #   start_at = "2026-01-01T00:00:00Z"
    #
    #   # 設定内容: 繰り返しのCron式
    #   # 省略時: 省略不可（必須）
    #   cron_expression_for_recurrence = "cron(0 0 ? * 1 *)"
    #
    #   duration {
    #     # 設定内容: メンテナンス時間の単位
    #     # 設定可能な値: "HOURS"
    #     # 省略時: 省略不可（必須）
    #     unit = "HOURS"
    #
    #     # 設定内容: メンテナンス時間の値
    #     # 設定可能な値: 正の数値
    #     # 省略時: 省略不可（必須）
    #     value = 2
    #   }
    # }
  }

  #---------------------------------------
  # オフピーク時間枠設定
  #---------------------------------------

  off_peak_window_options {
    # 設定内容: オフピーク時間枠を有効化するか
    # 設定可能な値: true / false
    # 省略時: AWSがデフォルト設定を使用
    enabled = true

    off_peak_window {
      window_start_time {
        # 設定内容: オフピーク開始時刻の時（UTC）
        # 設定可能な値: 0〜23
        # 省略時: AWSがデフォルト設定を使用
        hours = 0

        # 設定内容: オフピーク開始時刻の分（UTC）
        # 設定可能な値: 0〜59
        # 省略時: AWSがデフォルト設定を使用
        minutes = 0
      }
    }
  }

  #---------------------------------------
  # AI/ML設定
  #---------------------------------------

  aiml_options {
    natural_language_query_generation_options {
      # 設定内容: 自然言語クエリ生成の希望状態
      # 設定可能な値: "ENABLED", "DISABLED"
      # 省略時: AWSがデフォルト設定を使用
      desired_state = "DISABLED"
    }

    s3_vectors_engine {
      # 設定内容: S3ベクターエンジンを有効化するか
      # 設定可能な値: true / false
      # 省略時: AWSがデフォルト設定を使用
      enabled = false
    }

    serverless_vector_acceleration {
      # 設定内容: GPU高速化ベクター検索を有効化するか
      # 設定可能な値: true / false
      # 省略時: AWSがデフォルト設定を使用
      enabled = false
    }
  }

  #---------------------------------------
  # IAM Identity Center統合設定
  #---------------------------------------

  identity_center_options {
    # 設定内容: Identity Center APIアクセスを有効化するか
    # 設定可能な値: true / false
    # 省略時: AWSがデフォルト設定を使用
    enabled_api_access = false

    # 設定内容: 統合するIAM Identity CenterインスタンスのARN
    # 設定可能な値: IAM Identity CenterインスタンスのARN
    # 省略時: AWSがデフォルト設定を使用
    identity_center_instance_arn = null

    # 設定内容: OpenSearchのロールマッピングに使用されるJWTクレームキー
    # 設定可能な値: JWTクレームキー文字列
    # 省略時: AWSがデフォルト設定を使用
    # roles_key = null

    # 設定内容: OpenSearchのユーザー識別に使用されるJWTクレームキー
    # 設定可能な値: JWTクレームキー文字列
    # 省略時: AWSがデフォルト設定を使用
    # subject_key = null
  }

  #---------------------------------------
  # ソフトウェアアップデート設定
  #---------------------------------------

  software_update_options {
    # 設定内容: 自動ソフトウェアアップデートを有効化するか
    # 設定可能な値: true / false
    # 省略時: false
    auto_software_update_enabled = false
  }

  #---------------------------------------
  # スナップショット設定（Elasticsearch 5.3以前向け、非推奨）
  #---------------------------------------

  snapshot_options {
    # 設定内容: 自動日次スナップショット開始時刻（UTC時）
    # 設定可能な値: 0〜23（OpenSearch_X.Y および Elasticsearch 5.3以降では時間ごとに自動取得されるため無効）
    # 省略時: 省略不可（必須）
    automated_snapshot_start_hour = 0
  }

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------

  timeouts {
    # 設定内容: リソース作成のタイムアウト
    # 設定可能な値: "60m", "2h" などのDuration文字列
    # 省略時: 60分
    create = "60m"

    # 設定内容: リソース更新のタイムアウト
    # 設定可能な値: "60m", "2h" などのDuration文字列
    # 省略時: 60分
    update = "60m"

    # 設定内容: リソース削除のタイムアウト
    # 設定可能な値: "60m", "2h" などのDuration文字列
    # 省略時: 90分
    delete = "90m"
  }
}

#---------------------------------------
# Attributes Reference（参照専用）
#---------------------------------------

# aws_opensearch_domain.example.arn                                 - ドメインのARN
# aws_opensearch_domain.example.domain_id                           - ドメインの一意識別子
# aws_opensearch_domain.example.endpoint                            - HTTPSスキームなしのドメインエンドポイント
# aws_opensearch_domain.example.endpoint_v2                         - デュアルスタックエンドポイント（dualstack時）
# aws_opensearch_domain.example.dashboard_endpoint                  - OpenSearch Dashboardsエンドポイント
# aws_opensearch_domain.example.dashboard_endpoint_v2               - デュアルスタックDashboardsエンドポイント
# aws_opensearch_domain.example.domain_endpoint_v2_hosted_zone_id   - デュアルスタックのRoute 53ホストゾーンID
# aws_opensearch_domain.example.tags_all                            - 継承タグ含むすべてのタグ
# aws_opensearch_domain.example.vpc_options[0].vpc_id               - VPC配置時のVPC ID
# aws_opensearch_domain.example.vpc_options[0].availability_zones   - VPC配置時のAZセット
