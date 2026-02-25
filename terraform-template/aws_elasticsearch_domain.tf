#-----------------------------------------------------------------------
# Resource: aws_elasticsearch_domain
# Provider Version: 6.28.0
# Generated: 2026-02-17
#-----------------------------------------------------------------------
# 概要:
#   Amazon Elasticsearchドメインを作成・管理するリソースです。
#   マネージド型のElasticsearch（Opensearchの旧世代）環境を提供します。
#
# NOTE:
#   - 本リソースは非推奨です。新規作成にはaws_opensearch_domainの使用を推奨します
#   - VPCオプションの追加・削除は新しいリソースの作成を強制します
#   - Elasticsearch 5.3以降はスナップショットが自動化されておりsnapshot_optionsは非推奨です
#   - 特定のインスタンスタイプのみが暗号化機能をサポートします
#
# 主な用途:
#   - 全文検索エンジンの構築
#   - ログ分析基盤の構築（ELKスタック）
#   - アプリケーション監視・分析
#
# 参考リンク:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain
#   - https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/what-is.html
#-----------------------------------------------------------------------

resource "aws_elasticsearch_domain" "example" {
  #-----------------------------------------------------------------------
  # 基本設定
  #-----------------------------------------------------------------------

  # domain_name - ドメイン名
  # 設定内容: Elasticsearchドメインの一意な識別名
  # 設定可能な値: 3～28文字の小文字英数字とハイフン
  # 必須: はい
  domain_name = "my-elasticsearch-domain"

  # elasticsearch_version - Elasticsearchバージョン
  # 設定内容: デプロイするElasticsearchのバージョン
  # 設定可能な値: 1.5, 2.3, 5.1, 5.3, 5.5, 5.6, 6.0～6.8, 7.1～7.10など
  # 省略時: 1.5
  elasticsearch_version = "7.10"


  #-----------------------------------------------------------------------
  # アクセス制御
  #-----------------------------------------------------------------------

  # access_policies - アクセスポリシー
  # 設定内容: ドメインへのアクセスを制御するIAMポリシードキュメント
  # 設定可能な値: JSON形式のIAMポリシー文字列
  # 省略時: 設定なし
  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "es:*"
        Resource = "arn:aws:es:ap-northeast-1:123456789012:domain/my-domain/*"
      }
    ]
  })

  # region - リージョン
  # 設定内容: リソースが管理されるAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1など有効なリージョンコード
  # 省略時: プロバイダーに設定されたリージョン
  region = "ap-northeast-1"

  #-----------------------------------------------------------------------
  # 高度なセキュリティオプション
  #-----------------------------------------------------------------------

  # advanced_security_options - きめ細かいアクセス制御
  # 設定内容: ドメインへの高度なアクセス制御機能の設定
  # 省略時: 無効
  # advanced_security_options {
  #   # enabled - 有効化フラグ
  #   # 設定内容: 高度なセキュリティオプションを有効にするかどうか
  #   # 設定可能な値: true, false
  #   # 必須: はい（ブロック内）
  #   # 注意: 変更時に新規リソースが作成されます
  #   enabled = true
  #
  #   # internal_user_database_enabled - 内部ユーザーデータベース
  #   # 設定内容: ドメイン内部のユーザーデータベースを使用するかどうか
  #   # 設定可能な値: true, false
  #   # 省略時: false
  #   internal_user_database_enabled = true
  #
  #   # master_user_options - マスターユーザー設定
  #   # 設定内容: マスターユーザーの認証情報
  #   # 省略時: 設定なし
  #   master_user_options {
  #     # master_user_arn - マスターユーザーARN
  #     # 設定内容: IAMユーザーまたはロールのARN
  #     # 省略時: 設定なし
  #     # 注意: internal_user_database_enabledがfalseの場合のみ指定
  #     # master_user_arn = "arn:aws:iam::123456789012:user/master-user"
  #
  #     # master_user_name - マスターユーザー名
  #     # 設定内容: 内部データベースに保存されるマスターユーザーのユーザー名
  #     # 省略時: 設定なし
  #     # 注意: internal_user_database_enabledがtrueの場合のみ指定
  #     master_user_name = "admin"
  #
  #     # master_user_password - マスターユーザーパスワード
  #     # 設定内容: 内部データベースに保存されるマスターユーザーのパスワード
  #     # 省略時: 設定なし
  #     # 注意: internal_user_database_enabledがtrueの場合のみ指定
  #     # 機密情報のため変数化を推奨
  #     master_user_password = "MyPassword123!"
  #   }
  # }

  #-----------------------------------------------------------------------
  # クラスター構成
  #-----------------------------------------------------------------------

  # cluster_config - クラスター設定
  # 設定内容: Elasticsearchクラスターのノード構成
  # 省略時: デフォルト構成（シングルノード）
  cluster_config {
    # instance_type - インスタンスタイプ
    # 設定内容: データノードのインスタンスタイプ
    # 設定可能な値: t2.small.elasticsearch, m5.large.elasticsearch等
    # 省略時: m3.medium.elasticsearch
    instance_type = "r5.large.elasticsearch"

    # instance_count - インスタンス数
    # 設定内容: クラスター内のデータノード数
    # 設定可能な値: 1以上の整数
    # 省略時: 1
    instance_count = 3

    # dedicated_master_enabled - 専用マスターノード有効化
    # 設定内容: 専用マスターノードを使用するかどうか
    # 設定可能な値: true, false
    # 省略時: false
    dedicated_master_enabled = true

    # dedicated_master_type - 専用マスターノードタイプ
    # 設定内容: 専用マスターノードのインスタンスタイプ
    # 設定可能な値: t2.small.elasticsearch, m5.large.elasticsearch等
    # 省略時: 設定なし
    # 注意: dedicated_master_enabledがtrueの場合に指定
    dedicated_master_type = "c5.large.elasticsearch"

    # dedicated_master_count - 専用マスターノード数
    # 設定内容: 専用マスターノードの数
    # 設定可能な値: 3または5を推奨
    # 省略時: 設定なし
    # 注意: dedicated_master_enabledがtrueの場合に指定
    dedicated_master_count = 3

    # zone_awareness_enabled - マルチAZ有効化
    # 設定内容: 複数のアベイラビリティーゾーンへのノード配置
    # 設定可能な値: true, false
    # 省略時: false
    zone_awareness_enabled = true

    # zone_awareness_config - ゾーン認識設定
    # 設定内容: マルチAZ構成の詳細設定
    # 省略時: 2つのAZ
    # 注意: zone_awareness_enabledがtrueの場合のみ有効
    zone_awareness_config {
      # availability_zone_count - AZ数
      # 設定内容: 使用するアベイラビリティーゾーンの数
      # 設定可能な値: 2, 3
      # 省略時: 2
      availability_zone_count = 3
    }

    # warm_enabled - UltraWarmストレージ有効化
    # 設定内容: UltraWarmノードを有効にするかどうか
    # 設定可能な値: true, false
    # 省略時: false
    # warm_enabled = true

    # warm_type - UltraWarmノードタイプ
    # 設定内容: UltraWarmノードのインスタンスタイプ
    # 設定可能な値: ultrawarm1.medium.elasticsearch, ultrawarm1.large.elasticsearch, ultrawarm1.xlarge.elasticsearch
    # 省略時: 設定なし
    # 注意: warm_enabledがtrueの場合のみ指定必須
    # warm_type = "ultrawarm1.medium.elasticsearch"

    # warm_count - UltraWarmノード数
    # 設定内容: UltraWarmノードの数
    # 設定可能な値: 2～150
    # 省略時: 設定なし
    # 注意: warm_enabledがtrueの場合のみ指定必須
    # warm_count = 2

    # cold_storage_options - コールドストレージ設定
    # 設定内容: コールドストレージの有効化設定
    # 省略時: 無効
    # 注意: マスターノードとUltraWarmノードが必要
    # cold_storage_options {
    #   # enabled - 有効化フラグ
    #   # 設定内容: コールドストレージを有効にするかどうか
    #   # 設定可能な値: true, false
    #   # 省略時: false
    #   enabled = true
    # }
  }

  #-----------------------------------------------------------------------
  # ストレージ設定
  #-----------------------------------------------------------------------

  # ebs_options - EBSオプション
  # 設定内容: データノードにアタッチするEBSボリュームの設定
  # 省略時: インスタンスタイプによっては必須
  ebs_options {
    # ebs_enabled - EBS有効化
    # 設定内容: EBSボリュームをデータノードにアタッチするかどうか
    # 設定可能な値: true, false
    # 必須: はい（ブロック内）
    ebs_enabled = true

    # volume_type - ボリュームタイプ
    # 設定内容: EBSボリュームのタイプ
    # 設定可能な値: gp2, gp3, io1, io2, standard
    # 省略時: gp2
    volume_type = "gp3"

    # volume_size - ボリュームサイズ
    # 設定内容: EBSボリュームのサイズ（GiB単位）
    # 設定可能な値: 10～3500（インスタンスタイプにより異なる）
    # 必須: ebs_enabledがtrueの場合
    volume_size = 100

    # iops - IOPS
    # 設定内容: プロビジョニングされるIOPS
    # 設定可能な値: 1000～16000（GP3、Provisioned IOPSタイプの場合）
    # 省略時: ボリュームタイプに応じた自動設定
    # 注意: GP3またはProvisioned IOPSボリュームタイプの場合のみ適用
    # iops = 3000

    # throughput - スループット
    # 設定内容: EBSボリュームのスループット（MiB/s）
    # 設定可能な値: 125～1000
    # 省略時: 125
    # 注意: volume_typeがgp3の場合のみ設定可能
    throughput = 125
  }

  #-----------------------------------------------------------------------
  # 暗号化設定
  #-----------------------------------------------------------------------

  # encrypt_at_rest - 保管時の暗号化
  # 設定内容: データの保管時暗号化設定
  # 省略時: 無効
  # 注意: elasticsearch_version 5.1以降が必要
  encrypt_at_rest {
    # enabled - 有効化フラグ
    # 設定内容: 保管時の暗号化を有効にするかどうか
    # 設定可能な値: true, false
    # 必須: はい（ブロック内）
    # 注意: 特定のインスタンスタイプのみサポート
    enabled = true

    # kms_key_id - KMSキーID
    # 設定内容: 暗号化に使用するKMSキーのARN
    # 設定可能な値: KMSキーのARN
    # 省略時: aws/esサービスキーを使用
    # 注意: キーIDではなくARNの使用を推奨（差分検出を防ぐため）
    # kms_key_id = "arn:aws:kms:ap-northeast-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  # node_to_node_encryption - ノード間暗号化
  # 設定内容: クラスター内のノード間通信の暗号化設定
  # 省略時: 無効
  # 注意: elasticsearch_version 6.0以降が必要
  node_to_node_encryption {
    # enabled - 有効化フラグ
    # 設定内容: ノード間暗号化を有効にするかどうか
    # 設定可能な値: true, false
    # 必須: はい（ブロック内）
    enabled = true
  }

  #-----------------------------------------------------------------------
  # ネットワーク設定
  #-----------------------------------------------------------------------

  # vpc_options - VPCオプション
  # 設定内容: VPC内にドメインをデプロイするための設定
  # 省略時: パブリックエンドポイント
  # 注意: 追加・削除時に新規リソースが作成されます
  # vpc_options {
  #   # subnet_ids - サブネットID
  #   # 設定内容: ドメインエンドポイントを配置するサブネットのIDリスト
  #   # 設定可能な値: VPCサブネットIDのリスト
  #   # 必須: はい（ブロック内）
  #   subnet_ids = [
  #     "subnet-12345678",
  #     "subnet-87654321",
  #   ]
  #
  #   # security_group_ids - セキュリティグループID
  #   # 設定内容: ドメインエンドポイントに適用するセキュリティグループのIDリスト
  #   # 設定可能な値: VPCセキュリティグループIDのリスト
  #   # 省略時: VPCのデフォルトセキュリティグループを使用
  #   security_group_ids = ["sg-12345678"]
  # }

  # domain_endpoint_options - ドメインエンドポイントオプション
  # 設定内容: HTTPSエンドポイント関連の設定
  # 省略時: デフォルト設定
  domain_endpoint_options {
    # enforce_https - HTTPS強制
    # 設定内容: HTTPSの使用を強制するかどうか
    # 設定可能な値: true, false
    # 省略時: true
    enforce_https = true

    # tls_security_policy - TLSセキュリティポリシー
    # 設定内容: HTTPSエンドポイントに適用するTLSセキュリティポリシー
    # 設定可能な値: Policy-Min-TLS-1-0-2019-07, Policy-Min-TLS-1-2-2019-07, Policy-Min-TLS-1-2-PFS-2023-10
    # 省略時: Policy-Min-TLS-1-0-2019-07
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    # custom_endpoint_enabled - カスタムエンドポイント有効化
    # 設定内容: カスタムエンドポイントを有効にするかどうか
    # 設定可能な値: true, false
    # 省略時: false
    # custom_endpoint_enabled = true

    # custom_endpoint - カスタムエンドポイント
    # 設定内容: カスタムエンドポイントの完全修飾ドメイン名
    # 設定可能な値: 有効なFQDN
    # 省略時: 設定なし
    # 注意: custom_endpoint_enabledがtrueの場合に指定
    # custom_endpoint = "search.example.com"

    # custom_endpoint_certificate_arn - カスタムエンドポイント証明書ARN
    # 設定内容: カスタムエンドポイント用のACM証明書ARN
    # 設定可能な値: ACM証明書のARN
    # 省略時: 設定なし
    # 注意: custom_endpoint_enabledがtrueの場合に指定
    # custom_endpoint_certificate_arn = "arn:aws:acm:ap-northeast-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  #-----------------------------------------------------------------------
  # 認証設定
  #-----------------------------------------------------------------------

  # cognito_options - Cognito認証オプション
  # 設定内容: KibanaへのCognito認証設定
  # 省略時: 無効
  # cognito_options {
  #   # enabled - 有効化フラグ
  #   # 設定内容: Cognito認証を有効にするかどうか
  #   # 設定可能な値: true, false
  #   # 省略時: false
  #   enabled = true
  #
  #   # user_pool_id - ユーザープールID
  #   # 設定内容: 使用するCognitoユーザープールのID
  #   # 設定可能な値: Cognitoユーザープールのリソース識別子
  #   # 必須: はい（ブロック内）
  #   user_pool_id = "ap-northeast-1_XXXXXXXXX"
  #
  #   # identity_pool_id - IDプールID
  #   # 設定内容: 使用するCognito IDプールのID
  #   # 設定可能な値: Cognito IDプールのリソース識別子
  #   # 必須: はい（ブロック内）
  #   identity_pool_id = "ap-northeast-1:12345678-1234-1234-1234-123456789012"
  #
  #   # role_arn - ロールARN
  #   # 設定内容: AmazonESCognitoAccessポリシーがアタッチされたIAMロールのARN
  #   # 設定可能な値: IAMロールのARN
  #   # 必須: はい（ブロック内）
  #   role_arn = "arn:aws:iam::123456789012:role/CognitoAccessForAmazonES"
  # }

  #-----------------------------------------------------------------------
  # 高度な設定
  #-----------------------------------------------------------------------

  # advanced_options - 高度なオプション
  # 設定内容: 高度な設定オプションのキー・バリューペア
  # 設定可能な値: 文字列のマップ（値は必ず引用符で囲む）
  # 省略時: 設定なし
  # 注意: 値が文字列でない場合、永続的な差分が発生する可能性があります
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "indices.fielddata.cache.size"            = "20"
  }

  #-----------------------------------------------------------------------
  # 自動チューニング設定
  #-----------------------------------------------------------------------

  # auto_tune_options - Auto-Tuneオプション
  # 設定内容: ドメインの自動チューニング設定
  # 省略時: 設定なし
  # auto_tune_options {
  #   # desired_state - 希望状態
  #   # 設定内容: Auto-Tuneの希望する状態
  #   # 設定可能な値: ENABLED, DISABLED
  #   # 必須: はい（ブロック内）
  #   desired_state = "ENABLED"
  #
  #   # rollback_on_disable - 無効化時のロールバック
  #   # 設定内容: Auto-Tune無効化時にデフォルト設定にロールバックするかどうか
  #   # 設定可能な値: DEFAULT_ROLLBACK, NO_ROLLBACK
  #   # 省略時: 自動設定
  #   rollback_on_disable = "NO_ROLLBACK"
  #
  #   # maintenance_schedule - メンテナンススケジュール
  #   # 設定内容: Auto-Tuneのメンテナンス時間帯
  #   # 省略時: 設定なし
  #   # 注意: rollback_on_disableがDEFAULT_ROLLBACKの場合は必須
  #   maintenance_schedule {
  #     # start_at - 開始日時
  #     # 設定内容: メンテナンス開始日時（RFC3339形式）
  #     # 設定可能な値: RFC3339形式のタイムスタンプ
  #     # 必須: はい（ブロック内）
  #     start_at = "2023-02-01T00:00:00Z"
  #
  #     # cron_expression_for_recurrence - 繰り返しパターン
  #     # 設定内容: メンテナンスの繰り返しパターンを指定するcron式
  #     # 設定可能な値: cron式
  #     # 必須: はい（ブロック内）
  #     cron_expression_for_recurrence = "cron(0 3 ? * MON *)"
  #
  #     # duration - 期間
  #     # 設定内容: メンテナンス時間の長さ
  #     # 必須: はい（ブロック内）
  #     duration {
  #       # value - 期間値
  #       # 設定内容: メンテナンス時間の数値
  #       # 設定可能な値: 正の整数
  #       # 必須: はい（ブロック内）
  #       value = 2
  #
  #       # unit - 単位
  #       # 設定内容: メンテナンス時間の単位
  #       # 設定可能な値: HOURS
  #       # 必須: はい（ブロック内）
  #       unit = "HOURS"
  #     }
  #   }
  # }

  #-----------------------------------------------------------------------
  # ログ設定
  #-----------------------------------------------------------------------

  # log_publishing_options - ログ公開オプション
  # 設定内容: CloudWatch Logsへのログ公開設定（複数指定可能）
  # 省略時: ログ公開なし
  # log_publishing_options {
  #   # log_type - ログタイプ
  #   # 設定内容: 公開するログのタイプ
  #   # 設定可能な値: INDEX_SLOW_LOGS, SEARCH_SLOW_LOGS, ES_APPLICATION_LOGS, AUDIT_LOGS
  #   # 必須: はい（ブロック内）
  #   log_type = "INDEX_SLOW_LOGS"
  #
  #   # cloudwatch_log_group_arn - CloudWatch LogグループARN
  #   # 設定内容: ログを公開するCloudWatch LogグループのARN
  #   # 設定可能な値: CloudWatch LogグループのARN
  #   # 必須: はい（ブロック内）
  #   cloudwatch_log_group_arn = "arn:aws:logs:ap-northeast-1:123456789012:log-group:/aws/elasticsearch/my-domain"
  #
  #   # enabled - 有効化フラグ
  #   # 設定内容: このログ公開オプションを有効にするかどうか
  #   # 設定可能な値: true, false
  #   # 省略時: true
  #   enabled = true
  # }

  #-----------------------------------------------------------------------
  # スナップショット設定（非推奨）
  #-----------------------------------------------------------------------

  # snapshot_options - スナップショットオプション
  # 設定内容: 自動スナップショットの設定
  # 省略時: 設定なし
  # 注意: Elasticsearch 5.3以降では自動スナップショットが標準化されており非推奨
  # snapshot_options {
  #   # automated_snapshot_start_hour - スナップショット開始時刻
  #   # 設定内容: 自動スナップショットを取得する時刻（UTC）
  #   # 設定可能な値: 0～23
  #   # 必須: はい（ブロック内）
  #   automated_snapshot_start_hour = 3
  # }

  #-----------------------------------------------------------------------
  # タグ設定
  #-----------------------------------------------------------------------

  # tags - タグ
  # 設定内容: リソースに付与するタグのマップ
  # 設定可能な値: キー・バリューペアのマップ
  # 省略時: 設定なし
  # 注意: プロバイダーのdefault_tagsと重複するキーは上書きされます
  tags = {
    Name        = "my-elasticsearch-domain"
    Environment = "production"
  }

  # tags_all - 全タグ（参照専用）
  # 設定内容: プロバイダーのdefault_tagsとマージされた全タグ
  # 省略時: 自動計算
  # 注意: このパラメータは参照専用です（直接設定不可）

  #-----------------------------------------------------------------------
  # タイムアウト設定
  #-----------------------------------------------------------------------

  # timeouts - タイムアウト
  # 設定内容: リソース操作のタイムアウト時間
  # 省略時: デフォルト値
  # timeouts {
  #   # create - 作成タイムアウト
  #   # 設定内容: リソース作成時の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m, 2h）
  #   # 省略時: 60m
  #   create = "90m"
  #
  #   # update - 更新タイムアウト
  #   # 設定内容: リソース更新時の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m, 2h）
  #   # 省略時: 180m
  #   update = "180m"
  #
  #   # delete - 削除タイムアウト
  #   # 設定内容: リソース削除時の最大待機時間
  #   # 設定可能な値: 時間文字列（例: 60m, 2h）
  #   # 省略時: 90m
  #   delete = "90m"
  # }
}

#-----------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-----------------------------------------------------------------------
# 以下の属性がリソース作成後に参照可能です:
#
# - arn                                - ドメインのARN
# - domain_id                          - ドメインの一意識別子
# - endpoint                           - インデックス・検索・データアップロード用のドメイン固有エンドポイント
# - kibana_endpoint                    - Kibana用のドメイン固有エンドポイント（httpsスキームなし）
# - tags_all                           - プロバイダーのdefault_tagsを含む全タグのマップ
# - vpc_options.0.availability_zones   - VPC内に作成された場合のサブネットが配置されているAZ名
# - vpc_options.0.vpc_id               - VPC内に作成された場合のVPC ID
#-----------------------------------------------------------------------
