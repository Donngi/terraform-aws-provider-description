#---------------------------------------------------------------
# Amazon Elasticsearch Service Domain
#---------------------------------------------------------------
#
# Amazon Elasticsearch Service（Amazon ES）ドメインを管理するリソース。
# Elasticsearchクラスターのプロビジョニング、設定、管理を行います。
#
# 主な機能:
# - フルテキスト検索、ログ分析、アプリケーション監視に使用
# - クラスター構成（インスタンスタイプ、ノード数、ゾーン分散）の設定
# - VPCベースのプライベートアクセスまたはパブリックエンドポイント
# - きめ細かなアクセス制御（Fine-grained Access Control）
# - 保管時の暗号化およびノード間暗号化
# - CloudWatch Logsへのログ公開
# - Cognitoを使用したKibanaの認証
# - 自動スナップショットとバックアップ
#
# AWS公式ドキュメント:
#   - Creating and managing Amazon OpenSearch Service domains: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createupdatedomains.html
#   - Fine-grained access control: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elasticsearch_domain" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ドメイン名（必須）
  # - 3～28文字の小文字英数字、ハイフン（-）のみ使用可能
  # - 小文字で始まる必要がある
  # - 同一アカウント・リージョン内で一意である必要がある
  domain_name = "example-domain"

  #---------------------------------------------------------------
  # 基本設定
  #---------------------------------------------------------------

  # Elasticsearchのバージョン
  # - 指定しない場合、デフォルトは1.5
  # - 推奨: 7.10以降（最新の機能とセキュリティアップデート）
  # - 例: "7.10", "7.9", "6.8", "5.6"
  elasticsearch_version = "7.10"

  # リージョン
  # - このリソースが管理されるAWSリージョン
  # - 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用される
  # region = "us-east-1"

  #---------------------------------------------------------------
  # アクセスポリシー
  #---------------------------------------------------------------

  # IAMアクセスポリシー
  # - ドメインへのアクセスを制御するIAMポリシードキュメント（JSON形式）
  # - IPアドレス制限、IAMユーザー/ロールベースのアクセス制御に使用
  # - Fine-grained Access Controlと組み合わせて使用可能
  # access_policies = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [{
  #     Effect = "Allow"
  #     Principal = {
  #       AWS = "*"
  #     }
  #     Action   = "es:*"
  #     Resource = "arn:aws:es:us-east-1:123456789012:domain/example-domain/*"
  #     Condition = {
  #       IpAddress = {
  #         "aws:SourceIp" = ["192.0.2.0/24"]
  #       }
  #     }
  #   }]
  # })

  #---------------------------------------------------------------
  # 詳細オプション
  #---------------------------------------------------------------

  # 高度な設定オプション
  # - Elasticsearchの詳細な動作を制御するキー・バリューペア
  # - 値は必ず文字列（引用符で囲む）にすること
  # - 一般的なオプション:
  #   * rest.action.multi.allow_explicit_index: マルチインデックスAPIでの明示的なインデックス指定を許可 ("true"/"false")
  #   * indices.fielddata.cache.size: フィールドデータキャッシュのサイズ (例: "40")
  #   * indices.query.bool.max_clause_count: ブール検索での最大clause数 (デフォルト: "1024")
  # advanced_options = {
  #   "rest.action.multi.allow_explicit_index" = "true"
  #   "indices.fielddata.cache.size"           = "40"
  # }

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # リソースタグ
  # - コスト管理、リソース整理、アクセス制御に使用
  # - provider default_tagsと統合可能
  tags = {
    Environment = "production"
    Application = "search"
    ManagedBy   = "terraform"
  }

  # すべてのタグ（provider default_tagsを含む）
  # - 通常は自動的に管理されるため、明示的な設定は不要
  # - provider設定でdefault_tagsを使用している場合、それらのタグがここにマージされる
  # tags_all = {
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  # Terraform内部で使用されるID
  # - 通常は設定不要（自動生成される）
  # - インポート時のみ明示的に使用される場合がある
  # id = "arn:aws:es:us-east-1:123456789012:domain/example-domain"

  #---------------------------------------------------------------
  # クラスター構成
  #---------------------------------------------------------------

  cluster_config {
    # インスタンスタイプ
    # - データノードのインスタンスタイプ
    # - 例: "t3.small.elasticsearch", "m5.large.elasticsearch", "r5.xlarge.elasticsearch"
    # - 検索負荷とデータサイズに応じて選択
    instance_type = "r5.large.elasticsearch"

    # インスタンス数
    # - クラスター内のデータノード数
    # - 高可用性のため、本番環境では最低2台推奨
    # - ゾーン分散を有効にする場合、ゾーン数の倍数にする
    instance_count = 3

    # 専用マスターノードの有効化
    # - クラスター管理専用のマスターノードを使用するかどうか
    # - 本番環境では推奨（クラスターの安定性向上）
    dedicated_master_enabled = true

    # 専用マスターノードのタイプ
    # - マスターノード用のインスタンスタイプ
    # - 例: "c5.large.elasticsearch", "m5.large.elasticsearch"
    # - dedicated_master_enabled = true の場合のみ設定
    dedicated_master_type = "c5.large.elasticsearch"

    # 専用マスターノード数
    # - クラスター内のマスターノード数
    # - 推奨: 3台（高可用性のため）
    # - dedicated_master_enabled = true の場合のみ設定
    dedicated_master_count = 3

    # ゾーン分散の有効化
    # - マルチAZ配置でクラスターを展開するかどうか
    # - 高可用性を実現するために推奨
    # - VPC内の場合、複数のサブネットが必要
    zone_awareness_enabled = true

    # ゾーン分散設定
    zone_awareness_config {
      # アベイラビリティゾーン数
      # - ドメインが使用するAZ数
      # - 有効な値: 2 または 3
      # - デフォルト: 2
      # - zone_awareness_enabled = true の場合のみ設定
      availability_zone_count = 3
    }

    # ウォームストレージの有効化
    # - アクセス頻度の低いデータ用のウォームノードを使用するかどうか
    # - ログ分析などで古いデータのコスト削減に有効
    # warm_enabled = true

    # ウォームノード数
    # - ウォームストレージ用のノード数
    # - 有効な値: 2～150
    # - warm_enabled = true の場合のみ設定必須
    # warm_count = 2

    # ウォームノードタイプ
    # - ウォームノード用のインスタンスタイプ
    # - 有効な値: "ultrawarm1.medium.elasticsearch", "ultrawarm1.large.elasticsearch", "ultrawarm1.xlarge.elasticsearch"
    # - warm_enabled = true の場合のみ設定必須
    # warm_type = "ultrawarm1.medium.elasticsearch"

    # コールドストレージオプション
    cold_storage_options {
      # コールドストレージの有効化
      # - 最もアクセス頻度の低いデータ用のコールドストレージを使用するかどうか
      # - S3ベースのストレージでさらにコスト削減
      # - マスターノードとウォームノードが有効な場合のみ使用可能
      # - デフォルト: false
      enabled = false
    }
  }

  #---------------------------------------------------------------
  # EBSストレージオプション
  #---------------------------------------------------------------

  ebs_options {
    # EBSの有効化（必須）
    # - データノードにEBSボリュームをアタッチするかどうか
    # - ほとんどのインスタンスタイプで必須
    # - 一部のインスタンスタイプ（i3系など）はインスタンスストアを使用
    ebs_enabled = true

    # ボリュームサイズ（GiB）
    # - データノードごとのEBSボリュームサイズ
    # - ebs_enabled = true の場合は必須
    # - データ量とインデックスサイズに応じて設定
    volume_size = 100

    # ボリュームタイプ
    # - EBSボリュームのタイプ
    # - 有効な値: "gp2" (汎用SSD), "gp3" (次世代汎用SSD), "io1" (プロビジョンドIOPS SSD)
    # - 推奨: gp3（コストパフォーマンスが高い）
    volume_type = "gp3"

    # IOPS
    # - ベースラインI/Oパフォーマンス
    # - gp3またはio1ボリュームタイプの場合のみ適用
    # - gp3: 3,000～16,000 IOPS
    # - io1: 100～64,000 IOPS（ボリュームサイズに依存）
    # iops = 3000

    # スループット（MiB/s）
    # - EBSボリュームのスループット
    # - volume_type = "gp3" の場合は必須
    # - 有効な値: 125～1000 MiB/s
    # throughput = 125
  }

  #---------------------------------------------------------------
  # VPCオプション
  #---------------------------------------------------------------

  # VPC設定
  # - VPC内にElasticsearchドメインを配置
  # - 追加または削除すると、リソースが強制的に再作成される
  # vpc_options {
  #   # サブネットID（必須）
  #   # - Elasticsearchドメインエンドポイントを作成するVPCサブネットIDのリスト
  #   # - マルチAZの場合、各AZに1つずつサブネットを指定
  #   # - zone_awareness_config.availability_zone_count と一致する数が必要
  #   subnet_ids = [
  #     "subnet-12345678",
  #     "subnet-87654321",
  #   ]
  #
  #   # セキュリティグループID
  #   # - Elasticsearchドメインエンドポイントに適用するセキュリティグループIDのリスト
  #   # - 指定しない場合、VPCのデフォルトセキュリティグループが使用される
  #   # - 通常、443ポート（HTTPS）へのインバウンドを許可する設定が必要
  #   security_group_ids = ["sg-12345678"]
  # }

  #---------------------------------------------------------------
  # 暗号化設定
  #---------------------------------------------------------------

  # 保管時の暗号化
  encrypt_at_rest {
    # 暗号化の有効化（必須）
    # - 保管時のデータ暗号化を有効にするかどうか
    # - elasticsearch_version 5.1以降が必要
    # - ブロック未指定の場合、デフォルトはfalse
    enabled = true

    # KMSキーID
    # - Elasticsearchドメインの暗号化に使用するKMSキーのARN
    # - 指定しない場合、AWS管理キー（aws/es）が使用される
    # - KMS Key IDも受け入れるが、ARNを返すため、ARNの使用を推奨（差分検出を防ぐため）
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # ノード間暗号化
  node_to_node_encryption {
    # 暗号化の有効化（必須）
    # - ノード間通信の暗号化を有効にするかどうか
    # - elasticsearch_version 6.0以降が必要
    # - ブロック未指定の場合、デフォルトはfalse
    enabled = true
  }

  #---------------------------------------------------------------
  # ドメインエンドポイントオプション
  #---------------------------------------------------------------

  domain_endpoint_options {
    # HTTPS強制
    # - HTTPSの使用を必須にするかどうか
    # - デフォルト: true
    # - セキュリティのため、trueを推奨
    enforce_https = true

    # TLSセキュリティポリシー
    # - HTTPSエンドポイントに適用するTLSセキュリティポリシーの名前
    # - 有効な値:
    #   * Policy-Min-TLS-1-0-2019-07 (TLS 1.0以降)
    #   * Policy-Min-TLS-1-2-2019-07 (TLS 1.2以降、推奨)
    #   * Policy-Min-TLS-1-2-PFS-2023-10 (TLS 1.2以降、Perfect Forward Secrecy)
    # - 設定値が指定されている場合のみ、Terraformはドリフト検出を実行
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    # カスタムエンドポイントの有効化
    # - Elasticsearchドメインのカスタムエンドポイントを有効にするかどうか
    # - 独自ドメイン名でアクセスする場合に使用
    # custom_endpoint_enabled = true

    # カスタムエンドポイント
    # - カスタムエンドポイントの完全修飾ドメイン名（FQDN）
    # - custom_endpoint_enabled = true の場合のみ設定
    # - 例: "search.example.com"
    # custom_endpoint = "search.example.com"

    # カスタムエンドポイント証明書ARN
    # - カスタムエンドポイント用のACM証明書ARN
    # - custom_endpoint_enabled = true の場合のみ設定
    # - カスタムエンドポイントのドメイン名と一致する証明書が必要
    # custom_endpoint_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  #---------------------------------------------------------------
  # きめ細かなアクセス制御（Fine-grained Access Control）
  #---------------------------------------------------------------

  # 高度なセキュリティオプション
  advanced_security_options {
    # 有効化（必須、新リソースを強制）
    # - きめ細かなアクセス制御を有効にするかどうか
    # - ロールベースのアクセス制御、インデックス/ドキュメント/フィールドレベルのセキュリティを提供
    # - 変更すると新しいリソースが作成される
    enabled = true

    # 内部ユーザーデータベースの有効化
    # - Elasticsearch内部のユーザーデータベースを使用するかどうか
    # - デフォルト: false（AWS APIによる）
    # - false の場合、IAM ARNでマスターユーザーを指定
    # - true の場合、ユーザー名とパスワードでマスターユーザーを作成
    internal_user_database_enabled = false

    # マスターユーザーオプション
    master_user_options {
      # マスターユーザーARN
      # - マスターユーザーのIAM ARN
      # - internal_user_database_enabled = false の場合のみ指定
      # - IAMユーザーまたはロールのARNを指定
      master_user_arn = "arn:aws:iam::123456789012:role/ElasticsearchMasterRole"

      # マスターユーザー名
      # - マスターユーザーのユーザー名（Elasticsearch内部データベースに保存）
      # - internal_user_database_enabled = true の場合のみ指定
      # master_user_name = "admin"

      # マスターユーザーパスワード
      # - マスターユーザーのパスワード（Elasticsearch内部データベースに保存）
      # - internal_user_database_enabled = true の場合のみ指定
      # - 最小8文字、大文字・小文字・数字・特殊文字を含む必要がある
      # master_user_password = "ExamplePassword123!"
    }
  }

  #---------------------------------------------------------------
  # Auto-Tuneオプション
  #---------------------------------------------------------------

  # 自動チューニング設定
  auto_tune_options {
    # 希望する状態（必須）
    # - Auto-Tuneの有効/無効状態
    # - 有効な値: "ENABLED", "DISABLED"
    # - ENABLEDにすると、Elasticsearchがパフォーマンス最適化のための設定を自動調整
    desired_state = "ENABLED"

    # 無効化時のロールバック
    # - Auto-Tuneを無効にする際のロールバック動作
    # - 有効な値:
    #   * DEFAULT_ROLLBACK: Auto-Tuneによる変更を元に戻す
    #   * NO_ROLLBACK: Auto-Tuneによる変更を保持
    rollback_on_disable = "DEFAULT_ROLLBACK"

    # メンテナンススケジュール
    # - Auto-Tuneのメンテナンスウィンドウ設定
    # - rollback_on_disable = "DEFAULT_ROLLBACK" の場合は必須
    # - 複数指定可能
    maintenance_schedule {
      # 開始日時（必須）
      # - メンテナンススケジュールの開始日時
      # - RFC3339形式で指定（例: "2024-01-15T03:00:00Z"）
      start_at = "2024-01-15T03:00:00Z"

      # Cron式（必須）
      # - メンテナンススケジュールの繰り返しパターンを指定するCron式
      # - 例: "0 3 * * MON" (毎週月曜日午前3時)
      cron_expression_for_recurrence = "0 3 * * MON"

      # 期間（必須）
      duration {
        # 値（必須）
        # - メンテナンスウィンドウの期間を示す整数値
        value = 2

        # 単位（必須）
        # - メンテナンスウィンドウの期間の単位
        # - 有効な値: "HOURS"
        unit = "HOURS"
      }
    }
  }

  #---------------------------------------------------------------
  # Cognitoオプション
  #---------------------------------------------------------------

  # Cognito認証設定
  # - Kibanaダッシュボードへのアクセス認証にAmazon Cognitoを使用
  # cognito_options {
  #   # 有効化
  #   # - Kibanaへのamazon Cognito認証を有効にするかどうか
  #   # - デフォルト: false
  #   enabled = true
  #
  #   # ユーザープールID（必須）
  #   # - 使用するCognito User PoolのID
  #   user_pool_id = "us-east-1_XXXXXXXXX"
  #
  #   # IDプールID（必須）
  #   # - 使用するCognito Identity PoolのID
  #   identity_pool_id = "us-east-1:12345678-1234-1234-1234-123456789012"
  #
  #   # ロールARN（必須）
  #   # - AmazonESCognitoAccessポリシーがアタッチされたIAMロールのARN
  #   # - ElasticsearchがCognitoと連携するために必要
  #   role_arn = "arn:aws:iam::123456789012:role/CognitoAccessForAmazonES"
  # }

  #---------------------------------------------------------------
  # ログ公開オプション
  #---------------------------------------------------------------

  # CloudWatch Logsへのログ公開
  # - インデックススローログ、検索スローログ、アプリケーションログ、監査ログをCloudWatch Logsに公開
  # - log_typeごとに複数のブロックを宣言可能
  # log_publishing_options {
  #   # ログタイプ（必須）
  #   # - 公開するElasticsearchログのタイプ
  #   # - 有効な値:
  #   #   * INDEX_SLOW_LOGS: インデックス操作のスローログ
  #   #   * SEARCH_SLOW_LOGS: 検索操作のスローログ
  #   #   * ES_APPLICATION_LOGS: アプリケーションログ
  #   #   * AUDIT_LOGS: 監査ログ（fine-grained access control有効時のみ）
  #   log_type = "INDEX_SLOW_LOGS"
  #
  #   # CloudWatch LogグループARN（必須）
  #   # - ログを公開するCloudWatch LogグループのARN
  #   cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/example:*"
  #
  #   # 有効化
  #   # - 指定したログ公開オプションを有効にするかどうか
  #   # - デフォルト: true
  #   enabled = true
  # }
  #
  # # 検索スローログの公開例
  # log_publishing_options {
  #   log_type                 = "SEARCH_SLOW_LOGS"
  #   cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/example-search:*"
  # }

  #---------------------------------------------------------------
  # スナップショットオプション（非推奨）
  #---------------------------------------------------------------

  # 自動スナップショット設定
  # - 注意: Elasticsearch 5.3以降では、Amazon ESが自動的に1時間ごとにスナップショットを取得するため、この設定は無関係
  # - 古いバージョン（5.3未満）では、日次の自動スナップショットに使用
  # snapshot_options {
  #   # 自動スナップショット開始時刻（必須）
  #   # - インデックスの自動日次スナップショットを取得する時刻（UTC、0～23）
  #   # - 例: 3 = UTC午前3時
  #   automated_snapshot_start_hour = 3
  # }

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  # タイムアウト設定
  # - リソース操作のタイムアウト時間をカスタマイズ
  # timeouts {
  #   create = "60m"
  #   update = "180m"
  #   delete = "90m"
  # }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能ですが、設定はできません（computed only）:
#
# - arn
#   ドメインのARN
#   例: arn:aws:es:us-east-1:123456789012:domain/example-domain
#
# - domain_id
#   ドメインの一意識別子
#
# - endpoint
#   インデックス、検索、データアップロードリクエストを送信するためのドメイン固有エンドポイント
#   例: search-example-domain-abc123.us-east-1.es.amazonaws.com
#
# - kibana_endpoint
#   Kibana用のドメイン固有エンドポイント（httpsスキームなし）
#   例: search-example-domain-abc123.us-east-1.es.amazonaws.com/_plugin/kibana/
#
# - tags_all
#   provider default_tagsを含む、リソースに割り当てられたすべてのタグのマップ
#
# - vpc_options.0.availability_zones
#   VPC内に作成された場合、設定されたsubnet_idsが配置されているアベイラビリティゾーンの名前
#
# - vpc_options.0.vpc_id
#   VPC内に作成された場合、VPCのID
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------

# 出力例: エンドポイントの参照
# output "elasticsearch_endpoint" {
#   description = "Elasticsearch domain endpoint"
#   value       = aws_elasticsearch_domain.example.endpoint
# }
#
# output "kibana_endpoint" {
#   description = "Kibana endpoint"
#   value       = "https://${aws_elasticsearch_domain.example.kibana_endpoint}"
# }
#
# output "elasticsearch_arn" {
#   description = "Elasticsearch domain ARN"
#   value       = aws_elasticsearch_domain.example.arn
# }
