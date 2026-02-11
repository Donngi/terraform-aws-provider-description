#---------------------------------------------------------------
# AWS OpenSearch Domain
#---------------------------------------------------------------
#
# Amazon OpenSearch Service ドメインを管理するリソースです。
# OpenSearch は、ログ分析、リアルタイムアプリケーション監視、
# クリックストリーム分析などに使用できるフルマネージド検索・分析エンジンです。
# Elasticsearch および OpenSearch の両方のエンジンバージョンをサポートします。
#
# 主な機能:
#   - フルマネージド型の検索・分析エンジン
#   - Elasticsearch および OpenSearch エンジンのサポート
#   - 自動スケーリングとマルチ AZ 配置のサポート
#   - VPC 内への配置によるネットワーク分離
#   - きめ細かいアクセス制御（Fine-Grained Access Control）
#   - 保存時の暗号化とノード間暗号化
#   - CloudWatch Logs への統合ログ出力
#   - 自動スナップショットとバックアップ
#   - Cognito または IAM Identity Center による認証
#   - カスタムエンドポイントのサポート
#
# NOTE:
#   - ドメインの作成には通常 15〜30 分かかります
#   - VPC 内に配置したドメインは後から VPC 外に移動できません
#   - 特定の設定変更（暗号化、VPC など）には Blue/Green デプロイが必要です
#   - OpenSearch 5.3 以降では、1時間ごとに自動スナップショットが作成されます
#
# AWS公式ドキュメント:
#   - OpenSearch Service 概要: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html
#   - ドメインの作成と管理: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createupdatedomains.html
#   - Fine-Grained Access Control: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
#   - VPC サポート: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain
#
# Provider Version: 6.28.0
# Generated: 2026-02-02
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_opensearch_domain" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # domain_name (Required)
  # 設定内容: OpenSearch ドメインの名前を指定します。
  # 設定可能な値: 3〜28 文字の小文字英数字とハイフン（先頭は英字）
  # 注意:
  #   - 一度作成すると変更できません（変更すると新規作成になります）
  #   - AWS アカウント内でリージョンごとに一意である必要があります
  #   - ドメイン名はエンドポイント URL の一部として使用されます
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createupdatedomains.html
  domain_name = "example-domain"

  #-------------------------------------------------------------
  # エンジンバージョン設定
  #-------------------------------------------------------------

  # engine_version (Optional)
  # 設定内容: OpenSearch または Elasticsearch のエンジンバージョンを指定します。
  # 設定可能な値:
  #   - OpenSearch_X.Y 形式（例: OpenSearch_2.11, OpenSearch_2.9, OpenSearch_1.3）
  #   - Elasticsearch_X.Y 形式（例: Elasticsearch_7.10）
  # 省略時: 最新の OpenSearch バージョンがデフォルトとして使用されます。
  # 注意:
  #   - メジャーバージョンアップグレードには Blue/Green デプロイが必要
  #   - アップグレードは可能ですが、ダウングレードはできません
  #   - 暗号化を有効にする場合は OpenSearch_X.Y または Elasticsearch_5.1 以降が必要
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html#choosing-version
  engine_version = "OpenSearch_2.11"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このドメインが管理されるリージョンを指定します。
  # 設定可能な値: 有効な AWS リージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトとして使用されます。
  # AWS参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # IP アドレスタイプ設定
  #-------------------------------------------------------------

  # ip_address_type (Optional)
  # 設定内容: ドメインエンドポイントの IP アドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4": IPv4 のみをサポート
  #   - "dualstack": IPv4 と IPv6 の両方をサポート
  # 省略時: "ipv4" がデフォルトとして使用されます。
  # 注意:
  #   - dualstack を使用する場合、endpoint_v2 と dashboard_endpoint_v2 が利用可能になります
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
  ip_address_type = null

  #-------------------------------------------------------------
  # アクセスポリシー設定
  #-------------------------------------------------------------

  # access_policies (Optional)
  # 設定内容: ドメインへのアクセスを制御する IAM ポリシードキュメントを JSON 形式で指定します。
  # 設定可能な値: 有効な IAM ポリシードキュメント JSON
  # 省略時: すべてのアクセスが許可されます（推奨されません）。
  # 注意:
  #   - Fine-Grained Access Control と組み合わせて使用できます
  #   - IP アドレス制限やプリンシパル制限を設定可能
  #   - data.aws_iam_policy_document を使用して定義することを推奨
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ac.html
  # 例:
  # access_policies = data.aws_iam_policy_document.example.json
  access_policies = null

  #-------------------------------------------------------------
  # 高度なオプション設定
  #-------------------------------------------------------------

  # advanced_options (Optional)
  # 設定内容: OpenSearch の高度な設定オプションを指定します。
  # 設定可能な値: キーと値のペアのマップ（値は文字列で指定）
  # 省略時: デフォルト値が使用されます。
  # 注意:
  #   - 値は必ず文字列（引用符で囲む）で指定する必要があります
  #   - 文字列で指定しないと、永続的な差分が発生し毎回再作成が試行されます
  # よく使用されるオプション:
  #   - "rest.action.multi.allow_explicit_index": "true" - 明示的なインデックス指定を許可
  #   - "indices.fielddata.cache.size": "20" - フィールドデータキャッシュサイズ（%）
  #   - "indices.query.bool.max_clause_count": "1024" - ブール検索の最大句数
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createupdatedomains.html#createdomain-configure-advanced-options
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグは設定されません。
  # 注意:
  #   - プロバイダーレベルで default_tags が設定されている場合、
  #     同じキーのタグはリソースレベルの値で上書きされます。
  #   - タグはコスト配分、リソース管理、アクセス制御に役立ちます。
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-awsresourcetagging.html
  tags = {
    Name        = "example-opensearch-domain"
    Environment = "production"
    ManagedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # クラスター構成
  #-------------------------------------------------------------

  cluster_config {
    # instance_type (Optional)
    # 設定内容: データノードのインスタンスタイプを指定します。
    # 設定可能な値: OpenSearch インスタンスタイプ
    #   - 汎用: t3.small.search, t3.medium.search, m5.large.search, m6g.large.search など
    #   - メモリ最適化: r5.large.search, r6g.large.search など
    #   - ストレージ最適化: i3.large.search, i3.xlarge.search など
    # 省略時: m5.large.search がデフォルトとして使用されます。
    # 注意:
    #   - 本番環境では t2/t3 インスタンスは推奨されません
    #   - ワークロードに応じて適切なインスタンスタイプを選択してください
    # AWS参考: https://aws.amazon.com/opensearch-service/pricing/
    instance_type = "r5.large.search"

    # instance_count (Optional)
    # 設定内容: クラスター内のデータノード数を指定します。
    # 設定可能な値: 1 以上の整数
    # 省略時: 1 がデフォルトとして使用されます。
    # 注意:
    #   - 高可用性のためには少なくとも 3 ノードを推奨
    #   - マルチ AZ を有効にする場合は、AZ 数の倍数にする必要があります
    #   - 専用マスターノードを使用する場合は、データノードは 3 以上を推奨
    instance_count = 3

    # dedicated_master_enabled (Optional)
    # 設定内容: 専用マスターノードを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - 本番環境では有効にすることを強く推奨
    #   - クラスターの安定性と管理操作のパフォーマンスが向上
    #   - データノードが 10 以上の場合は必須
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-dedicatedmasternodes.html
    dedicated_master_enabled = true

    # dedicated_master_type (Optional)
    # 設定内容: 専用マスターノードのインスタンスタイプを指定します。
    # 設定可能な値: OpenSearch インスタンスタイプ（通常は c5.large.search 以上）
    # 省略時: dedicated_master_enabled が true の場合に必要です。
    # 注意:
    #   - dedicated_master_enabled が true の場合のみ指定可能
    #   - マスターノードは検索・インデックス処理を行わないため、
    #     データノードより小さいインスタンスタイプでも問題ありません
    dedicated_master_type = "c5.large.search"

    # dedicated_master_count (Optional)
    # 設定内容: 専用マスターノードの数を指定します。
    # 設定可能な値: 3 または 5（推奨: 3）
    # 省略時: dedicated_master_enabled が true の場合、3 がデフォルトです。
    # 注意:
    #   - 奇数個である必要があります（クォーラムのため）
    #   - 通常は 3 ノードで十分です
    dedicated_master_count = 3

    # zone_awareness_enabled (Optional)
    # 設定内容: ゾーン認識（マルチ AZ 配置）を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - 高可用性のためには有効にすることを推奨
    #   - instance_count は AZ 数の倍数である必要があります
    #   - 3 つの AZ に配置する場合は zone_awareness_config で指定
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-multiaz.html
    zone_awareness_enabled = true

    # zone_awareness_config (Optional)
    # 設定内容: ゾーン認識の詳細設定を指定します。
    # 注意: zone_awareness_enabled が true の場合のみ有効
    zone_awareness_config {
      # availability_zone_count (Optional)
      # 設定内容: ドメインで使用する Availability Zone の数を指定します。
      # 設定可能な値: 2 または 3
      # 省略時: 2 がデフォルトとして使用されます。
      # 注意:
      #   - instance_count は この値の倍数である必要があります
      #   - VPC 配置の場合、subnet_ids の数と一致させる必要があります
      availability_zone_count = 3
    }

    # multi_az_with_standby_enabled (Optional)
    # 設定内容: スタンバイ AZ を持つマルチ AZ ドメインを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - より高い可用性を実現するための機能
    #   - 通常のマルチ AZ よりもコストが高くなります
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/managedomains-multiaz.html
    multi_az_with_standby_enabled = false

    # warm_enabled (Optional)
    # 設定内容: ウォームストレージを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - 古いログデータなどをコスト効率よく保存するための機能
    #   - UltraWarm インスタンスを使用
    #   - 有効にする場合は warm_type と warm_count の指定が必須
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ultrawarm.html
    warm_enabled = false

    # warm_type (Optional)
    # 設定内容: ウォームノードのインスタンスタイプを指定します。
    # 設定可能な値:
    #   - ultrawarm1.medium.search
    #   - ultrawarm1.large.search
    #   - ultrawarm1.xlarge.search
    # 注意: warm_enabled が true の場合のみ、かつ必須
    # warm_type = "ultrawarm1.medium.search"

    # warm_count (Optional)
    # 設定内容: クラスター内のウォームノードの数を指定します。
    # 設定可能な値: 2 〜 150 の整数
    # 注意: warm_enabled が true の場合のみ、かつ必須
    # warm_count = 2

    # cold_storage_options (Optional)
    # 設定内容: コールドストレージオプションの設定を指定します。
    # 注意: マスターノードと UltraWarm ノードが有効である必要があります
    # cold_storage_options {
    #   enabled (Optional)
    #   設定内容: コールドストレージを有効にするかどうかを指定します。
    #   設定可能な値: true または false
    #   省略時: false がデフォルトとして使用されます。
    #   enabled = false
    # }

    # node_options (Optional)
    # 設定内容: ノードタイプごとの設定を指定します。
    # 注意: コーディネーターノードなど、特定のノードタイプを設定する場合に使用
    # node_options {
    #   node_type (Optional)
    #   設定内容: ノードのタイプを指定します。
    #   設定可能な値: "coordinator"（現在サポートされているのはこのみ）
    #   node_type = "coordinator"
    #
    #   node_config {
    #     enabled (Optional)
    #     設定内容: このノードタイプを有効にするかどうかを指定します。
    #     enabled = true
    #
    #     count (Optional)
    #     設定内容: このノードタイプのノード数を指定します。
    #     count = 2
    #
    #     type (Optional)
    #     設定内容: このノードタイプのインスタンスタイプを指定します。
    #     type = "c5.large.search"
    #   }
    # }
  }

  #-------------------------------------------------------------
  # EBS オプション設定
  #-------------------------------------------------------------

  ebs_options {
    # ebs_enabled (Required)
    # 設定内容: データノードに EBS ボリュームをアタッチするかどうかを指定します。
    # 設定可能な値: true または false
    # 注意:
    #   - ほとんどのインスタンスタイプでは true が必要です
    #   - i3 などのインスタンスストレージタイプでは false を指定可能
    ebs_enabled = true

    # volume_type (Optional)
    # 設定内容: EBS ボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "gp3": 汎用 SSD（最新、コスト効率が良い）
    #   - "gp2": 汎用 SSD（従来型）
    #   - "io1": プロビジョンド IOPS SSD
    #   - "standard": マグネティック（非推奨）
    # 省略時: "gp2" がデフォルトとして使用されます。
    # 注意:
    #   - 本番環境では gp3 または io1 を推奨
    #   - gp3 は gp2 より最大 20% コストが低く、パフォーマンスも向上
    volume_type = "gp3"

    # volume_size (Optional/Required)
    # 設定内容: データノードにアタッチする EBS ボリュームのサイズを GiB 単位で指定します。
    # 設定可能な値: 10 〜 16384（インスタンスタイプにより異なる）
    # 注意:
    #   - ebs_enabled が true の場合は必須
    #   - データ量とレプリカ数を考慮してサイズを決定してください
    #   - 容量の 75% を超えると警告が発生します
    volume_size = 100

    # iops (Optional)
    # 設定内容: EBS ボリュームのベースライン I/O パフォーマンスを指定します。
    # 設定可能な値:
    #   - gp3: 3,000 〜 16,000
    #   - io1: 100 〜 64,000（ボリュームサイズにより制限あり）
    # 注意:
    #   - volume_type が gp3 または io1 の場合のみ適用可能
    #   - gp3 のデフォルトは 3,000 IOPS
    iops = 3000

    # throughput (Optional/Required)
    # 設定内容: EBS ボリュームのスループットを MiB/s 単位で指定します。
    # 設定可能な値: 125 〜 1000
    # 注意:
    #   - volume_type が gp3 の場合のみ適用可能
    #   - volume_type が gp3 の場合は必須
    #   - デフォルトは 125 MiB/s
    throughput = 125
  }

  #-------------------------------------------------------------
  # 暗号化設定: 保存時の暗号化
  #-------------------------------------------------------------

  encrypt_at_rest {
    # enabled (Required)
    # 設定内容: 保存時の暗号化を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 注意:
    #   - 本番環境では有効にすることを強く推奨
    #   - OpenSearch_X.Y または Elasticsearch_5.1 以降が必要
    #   - 一度有効にすると無効にできません
    #   - 新規ドメインでのみ有効化可能（既存ドメインでは不可）
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/encryption-at-rest.html
    enabled = true

    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用する KMS キーの ARN を指定します。
    # 設定可能な値: 有効な KMS キー ARN
    # 省略時: AWS マネージドキー（aws/es）が使用されます。
    # 注意:
    #   - KMS キー ID ではなく ARN を使用することを推奨（差分検出を防ぐため）
    #   - カスタマーマネージドキーを使用する場合は、適切な権限が必要
    # kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # 暗号化設定: ノード間暗号化
  #-------------------------------------------------------------

  node_to_node_encryption {
    # enabled (Required)
    # 設定内容: ノード間暗号化を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 注意:
    #   - 本番環境では有効にすることを強く推奨
    #   - OpenSearch_X.Y または Elasticsearch_6.0 以降が必要
    #   - 一度有効にすると無効にできません
    #   - 新規ドメインでのみ有効化可能（既存ドメインでは不可）
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/ntn.html
    enabled = true
  }

  #-------------------------------------------------------------
  # ドメインエンドポイント設定
  #-------------------------------------------------------------

  domain_endpoint_options {
    # enforce_https (Optional)
    # 設定内容: HTTPS を必須にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: true がデフォルトとして使用されます。
    # 注意:
    #   - セキュリティのため常に true を推奨
    enforce_https = true

    # tls_security_policy (Optional)
    # 設定内容: HTTPS エンドポイントに適用する TLS セキュリティポリシーを指定します。
    # 設定可能な値:
    #   - "Policy-Min-TLS-1-0-2019-07": TLS 1.0 以降（非推奨）
    #   - "Policy-Min-TLS-1-2-2019-07": TLS 1.2 以降（推奨）
    #   - "Policy-Min-TLS-1-2-PFS-2023-10": TLS 1.2 以降 + Perfect Forward Secrecy
    # 省略時: "Policy-Min-TLS-1-0-2019-07" がデフォルトです。
    # 注意:
    #   - セキュリティのため TLS 1.2 以降を推奨
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/data-protection.html
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    # custom_endpoint_enabled (Optional)
    # 設定内容: カスタムエンドポイントを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - 独自のドメイン名を使用したい場合に有効化
    custom_endpoint_enabled = false

    # custom_endpoint (Optional)
    # 設定内容: カスタムエンドポイントの完全修飾ドメイン名を指定します。
    # 設定可能な値: 有効な FQDN（例: opensearch.example.com）
    # 注意: custom_endpoint_enabled が true の場合は必須
    # custom_endpoint = "opensearch.example.com"

    # custom_endpoint_certificate_arn (Optional)
    # 設定内容: カスタムエンドポイント用の ACM 証明書 ARN を指定します。
    # 設定可能な値: 有効な ACM 証明書 ARN
    # 注意: custom_endpoint_enabled が true の場合は必須
    # custom_endpoint_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }

  #-------------------------------------------------------------
  # Fine-Grained Access Control（きめ細かいアクセス制御）
  #-------------------------------------------------------------

  advanced_security_options {
    # enabled (Required)
    # 設定内容: Fine-Grained Access Control を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 注意:
    #   - true から false に変更すると新しいリソースが強制的に作成されます
    #   - 有効にすると、より詳細なアクセス制御とセキュリティ機能が利用可能
    #   - node_to_node_encryption と encrypt_at_rest が必要
    #   - enforce_https も true である必要があります
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/fgac.html
    enabled = true

    # internal_user_database_enabled (Optional)
    # 設定内容: 内部ユーザーデータベースを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - true の場合、OpenSearch の内部データベースでユーザーを管理
    #   - false の場合、IAM または SAML で認証
    internal_user_database_enabled = true

    # anonymous_auth_enabled (Optional)
    # 設定内容: 匿名認証を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - 既存のドメインでのみ有効化可能
    #   - advanced_security_options が有効でない場合は無視されます
    # anonymous_auth_enabled = false

    # master_user_options (Optional)
    # 設定内容: マスターユーザーの設定を指定します。
    # 注意: advanced_security_options.enabled が true の場合に設定を推奨
    master_user_options {
      # master_user_arn (Optional)
      # 設定内容: マスターユーザーの IAM ARN を指定します。
      # 設定可能な値: 有効な IAM ユーザーまたはロールの ARN
      # 注意:
      #   - internal_user_database_enabled が false の場合のみ指定
      #   - master_user_name/master_user_password とは排他的
      # master_user_arn = "arn:aws:iam::123456789012:user/opensearch-admin"

      # master_user_name (Optional)
      # 設定内容: マスターユーザーのユーザー名を指定します。
      # 設定可能な値: 任意の文字列
      # 注意:
      #   - internal_user_database_enabled が true の場合のみ指定
      #   - master_user_arn とは排他的
      master_user_name = "admin"

      # master_user_password (Optional, Sensitive)
      # 設定内容: マスターユーザーのパスワードを指定します。
      # 設定可能な値: 8 文字以上で、大文字、小文字、数字、特殊文字を含む
      # 注意:
      #   - internal_user_database_enabled が true の場合のみ指定
      #   - センシティブな情報のため、変数や Secrets Manager の使用を推奨
      #   - パスワードは Terraform の状態ファイルに保存されます
      master_user_password = "YourSecurePassword123!"
    }
  }

  #-------------------------------------------------------------
  # Auto-Tune 設定
  #-------------------------------------------------------------

  auto_tune_options {
    # desired_state (Required)
    # 設定内容: Auto-Tune の希望する状態を指定します。
    # 設定可能な値:
    #   - "ENABLED": Auto-Tune を有効化
    #   - "DISABLED": Auto-Tune を無効化
    # 注意:
    #   - Auto-Tune はクラスターのパフォーマンスを自動的に最適化
    #   - Blue/Green デプロイが必要な場合があります
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/auto-tune.html
    desired_state = "ENABLED"

    # rollback_on_disable (Optional)
    # 設定内容: Auto-Tune を無効にする際にデフォルト設定にロールバックするかを指定します。
    # 設定可能な値:
    #   - "DEFAULT_ROLLBACK": デフォルト設定にロールバック
    #   - "NO_ROLLBACK": 現在の設定を維持
    # 省略時: "DEFAULT_ROLLBACK" がデフォルトです。
    rollback_on_disable = "NO_ROLLBACK"

    # use_off_peak_window (Optional)
    # 設定内容: Blue/Green デプロイが必要な Auto-Tune 最適化を
    #          オフピークウィンドウ中にスケジュールするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - true の場合、off_peak_window_options の設定が必要
    use_off_peak_window = false

    # maintenance_schedule (Optional/Deprecated)
    # 設定内容: Auto-Tune のメンテナンススケジュールを指定します（非推奨）。
    # 注意:
    #   - メンテナンスウィンドウは非推奨で、オフピークウィンドウに置き換えられました
    #   - use_off_peak_window が true の場合は指定できません
    #   - rollback_on_disable が DEFAULT_ROLLBACK の場合は必須
    # maintenance_schedule {
    #   start_at (Required)
    #   設定内容: メンテナンススケジュールの開始日時を RFC3339 形式で指定します。
    #   start_at = "2024-02-01T00:00:00Z"
    #
    #   duration (Required)
    #   設定内容: メンテナンスウィンドウの期間を指定します。
    #   duration {
    #     value (Required)
    #     設定内容: 期間の値を整数で指定します。
    #     value = 2
    #
    #     unit (Required)
    #     設定内容: 期間の単位を指定します。
    #     設定可能な値: "HOURS"
    #     unit = "HOURS"
    #   }
    #
    #   cron_expression_for_recurrence (Required)
    #   設定内容: 繰り返しパターンを cron 式で指定します。
    #   cron_expression_for_recurrence = "0 0 * * ? *"
    # }
  }

  #-------------------------------------------------------------
  # オフピークウィンドウ設定
  #-------------------------------------------------------------

  off_peak_window_options {
    # enabled (Optional)
    # 設定内容: オフピークウィンドウを有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - Auto-Tune や更新処理をオフピーク時間に実行するための設定
    # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/off-peak.html
    enabled = false

    # off_peak_window (Optional)
    # 設定内容: 10 時間のオフピークウィンドウを定義します。
    # 注意: enabled が true の場合に設定を推奨
    # off_peak_window {
    #   window_start_time (Optional)
    #   設定内容: オフピークウィンドウの開始時刻を指定します。
    #   window_start_time {
    #     hours (Required)
    #     設定内容: 開始時刻の時（0〜23）を指定します。
    #     hours = 2
    #
    #     minutes (Required)
    #     設定内容: 開始時刻の分（0〜59）を指定します。
    #     minutes = 0
    #   }
    # }
  }

  #-------------------------------------------------------------
  # ログ発行設定
  #-------------------------------------------------------------

  # log_publishing_options (Optional)
  # 設定内容: CloudWatch Logs へのログ発行設定を指定します。
  # 注意:
  #   - ログタイプごとに複数のブロックを宣言可能
  #   - CloudWatch Logs のロググループを事前に作成する必要があります
  #   - リソースポリシーで OpenSearch からの書き込みを許可する必要があります
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/createdomain-configure-slow-logs.html
  #
  # log_publishing_options {
  #   log_type (Required)
  #   設定内容: 発行するログのタイプを指定します。
  #   設定可能な値:
  #     - "INDEX_SLOW_LOGS": インデックス処理の遅いログ
  #     - "SEARCH_SLOW_LOGS": 検索処理の遅いログ
  #     - "ES_APPLICATION_LOGS": アプリケーションログ
  #     - "AUDIT_LOGS": 監査ログ（Fine-Grained Access Control が必要）
  #   log_type = "INDEX_SLOW_LOGS"
  #
  #   cloudwatch_log_group_arn (Required)
  #   設定内容: ログを発行する CloudWatch Logs ロググループの ARN を指定します。
  #   cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
  #
  #   enabled (Optional)
  #   設定内容: このログ発行オプションを有効にするかどうかを指定します。
  #   設定可能な値: true または false
  #   省略時: true がデフォルトとして使用されます。
  #   enabled = true
  # }

  #-------------------------------------------------------------
  # VPC 設定
  #-------------------------------------------------------------

  # vpc_options (Optional)
  # 設定内容: VPC 関連のオプションを指定します。
  # 注意:
  #   - 追加または削除すると新しいリソースが強制的に作成されます
  #   - VPC 内に配置すると、パブリックエンドポイントは利用できなくなります
  #   - VPC 内ドメインは後から VPC 外に移動できません
  #   - サービスリンクロール（AWSServiceRoleForAmazonOpenSearchService）が必要
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/vpc.html
  #
  # vpc_options {
  #   subnet_ids (Required)
  #   設定内容: ドメインエンドポイントを作成するサブネット ID のリストを指定します。
  #   設定可能な値: 有効なサブネット ID のリスト
  #   注意:
  #     - マルチ AZ の場合、AZ 数と同じ数のサブネットが必要
  #     - プライベートサブネットの使用を推奨
  #   subnet_ids = [
  #     "subnet-12345678",
  #     "subnet-87654321",
  #   ]
  #
  #   security_group_ids (Optional)
  #   設定内容: ドメインエンドポイントに適用するセキュリティグループ ID のリストを指定します。
  #   設定可能な値: 有効なセキュリティグループ ID のリスト
  #   省略時: VPC のデフォルトセキュリティグループが使用されます。
  #   注意:
  #     - ポート 443（HTTPS）へのインバウンドアクセスを許可する必要があります
  #   security_group_ids = [aws_security_group.opensearch.id]
  # }

  #-------------------------------------------------------------
  # Cognito 認証設定
  #-------------------------------------------------------------

  # cognito_options (Optional)
  # 設定内容: Amazon Cognito による Dashboard 認証の設定を指定します。
  # 注意:
  #   - Cognito ユーザープールと ID プールを事前に作成する必要があります
  #   - Fine-Grained Access Control と併用可能
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/cognito-auth.html
  #
  # cognito_options {
  #   enabled (Optional)
  #   設定内容: Cognito 認証を有効にするかどうかを指定します。
  #   設定可能な値: true または false
  #   省略時: false がデフォルトとして使用されます。
  #   enabled = true
  #
  #   user_pool_id (Required)
  #   設定内容: 使用する Cognito ユーザープールの ID を指定します。
  #   user_pool_id = aws_cognito_user_pool.example.id
  #
  #   identity_pool_id (Required)
  #   設定内容: 使用する Cognito ID プールの ID を指定します。
  #   identity_pool_id = aws_cognito_identity_pool.example.id
  #
  #   role_arn (Required)
  #   設定内容: AmazonOpenSearchServiceCognitoAccess ポリシーが
  #            アタッチされた IAM ロールの ARN を指定します。
  #   role_arn = aws_iam_role.cognito_access.arn
  # }

  #-------------------------------------------------------------
  # IAM Identity Center 設定
  #-------------------------------------------------------------

  # identity_center_options (Optional)
  # 設定内容: IAM Identity Center 統合の設定を指定します。
  # 注意:
  #   - Fine-Grained Access Control が有効である必要があります
  # AWS参考: https://docs.aws.amazon.com/opensearch-service/latest/developerguide/idp-authentication.html
  #
  # identity_center_options {
  #   enabled_api_access (Optional)
  #   設定内容: API アクセスを有効にするかどうかを指定します。
  #   enabled_api_access = true
  #
  #   identity_center_instance_arn (Optional)
  #   設定内容: IAM Identity Center インスタンスの ARN を指定します。
  #   identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-1234567890abcdef"
  #
  #   subject_key (Optional)
  #   設定内容: SAML アサーションのサブジェクトキーを指定します。
  #   subject_key = "email"
  #
  #   roles_key (Optional)
  #   設定内容: SAML アサーションのロールキーを指定します。
  #   roles_key = "roles"
  # }

  #-------------------------------------------------------------
  # AI/ML オプション設定
  #-------------------------------------------------------------

  # aiml_options (Optional)
  # 設定内容: 機械学習機能を有効にするための設定を指定します。
  # 注意: OpenSearch の機械学習機能を使用する場合に設定
  #
  # aiml_options {
  #   natural_language_query_generation_options (Optional)
  #   設定内容: 自然言語クエリ生成機能の設定を指定します。
  #   natural_language_query_generation_options {
  #     desired_state (Optional)
  #     設定内容: 自然言語クエリ生成機能の希望する状態を指定します。
  #     設定可能な値: "ENABLED" または "DISABLED"
  #     desired_state = "ENABLED"
  #   }
  #
  #   s3_vectors_engine (Optional)
  #   設定内容: S3 ベクトルエンジン機能の設定を指定します。
  #   s3_vectors_engine {
  #     enabled (Optional)
  #     設定内容: S3 ベクトルエンジン機能を有効にするかどうかを指定します。
  #     enabled = true
  #   }
  # }

  #-------------------------------------------------------------
  # スナップショット設定（非推奨）
  #-------------------------------------------------------------

  # snapshot_options (Optional, Deprecated)
  # 設定内容: スナップショット関連のオプションを指定します。
  # 注意:
  #   - OpenSearch 5.3 以降では、1時間ごとに自動スナップショットが作成されるため、
  #     この設定は無関係になっています
  #   - それより前のバージョンでは、日次の自動スナップショットが作成されます
  #
  # snapshot_options {
  #   automated_snapshot_start_hour (Required)
  #   設定内容: 自動日次スナップショットを取得する時刻（UTC）を指定します。
  #   設定可能な値: 0〜23 の整数
  #   automated_snapshot_start_hour = 3
  # }

  #-------------------------------------------------------------
  # ソフトウェア更新設定
  #-------------------------------------------------------------

  software_update_options {
    # auto_software_update_enabled (Optional)
    # 設定内容: 自動サービスソフトウェア更新を有効にするかどうかを指定します。
    # 設定可能な値: true または false
    # 省略時: false がデフォルトとして使用されます。
    # 注意:
    #   - セキュリティパッチや重要な更新が自動的に適用されます
    #   - 本番環境では慎重に有効化を検討してください
    auto_software_update_enabled = false
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースのタイムアウト時間を指定します。
  # 注意: ドメインの作成・更新・削除には時間がかかるため、適切に設定してください
  #
  # timeouts {
  #   create (Optional)
  #   設定内容: ドメイン作成のタイムアウト時間を指定します。
  #   設定可能な値: 時間文字列（例: "60m", "2h"）
  #   省略時: デフォルトのタイムアウト時間が使用されます。
  #   create = "60m"
  #
  #   update (Optional)
  #   設定内容: ドメイン更新のタイムアウト時間を指定します。
  #   update = "180m"
  #
  #   delete (Optional)
  #   設定内容: ドメイン削除のタイムアウト時間を指定します。
  #   delete = "90m"
  # }

  #-------------------------------------------------------------
  # 依存関係の推奨事項
  #-------------------------------------------------------------
  #
  # VPC 内にドメインを配置する場合、サービスリンクロールが必要です:
  #
  # resource "aws_iam_service_linked_role" "opensearch" {
  #   aws_service_name = "opensearchservice.amazonaws.com"
  # }
  #
  # resource "aws_opensearch_domain" "example" {
  #   # ... その他の設定 ...
  #   depends_on = [aws_iam_service_linked_role.opensearch]
  # }
  #
  # CloudWatch Logs にログを発行する場合、リソースポリシーが必要です:
  #
  # data "aws_iam_policy_document" "opensearch_log_publishing_policy" {
  #   statement {
  #     effect = "Allow"
  #     principals {
  #       type        = "Service"
  #       identifiers = ["es.amazonaws.com"]
  #     }
  #     actions = [
  #       "logs:PutLogEvents",
  #       "logs:PutLogEventsBatch",
  #       "logs:CreateLogStream",
  #     ]
  #     resources = ["arn:aws:logs:*"]
  #   }
  # }
  #
  # resource "aws_cloudwatch_log_resource_policy" "opensearch" {
  #   policy_name     = "opensearch-log-publishing-policy"
  #   policy_document = data.aws_iam_policy_document.opensearch_log_publishing_policy.json
  # }
  #
}

#---------------------------------------------------------------
# アウトプット例
#---------------------------------------------------------------
#
# OpenSearch ドメインの情報を出力する場合の例:
#
# output "opensearch_domain_id" {
#   description = "OpenSearch ドメインの一意の識別子"
#   value       = aws_opensearch_domain.example.domain_id
# }
#
# output "opensearch_domain_arn" {
#   description = "OpenSearch ドメインの ARN"
#   value       = aws_opensearch_domain.example.arn
# }
#
# output "opensearch_domain_endpoint" {
#   description = "OpenSearch ドメインのエンドポイント"
#   value       = aws_opensearch_domain.example.endpoint
# }
#
# output "opensearch_domain_endpoint_v2" {
#   description = "OpenSearch ドメインの IPv4/IPv6 対応エンドポイント"
#   value       = aws_opensearch_domain.example.endpoint_v2
# }
#
# output "opensearch_dashboard_endpoint" {
#   description = "OpenSearch Dashboards のエンドポイント（https スキームなし）"
#   value       = aws_opensearch_domain.example.dashboard_endpoint
# }
#
# output "opensearch_dashboard_endpoint_v2" {
#   description = "OpenSearch Dashboards の IPv4/IPv6 対応エンドポイント"
#   value       = aws_opensearch_domain.example.dashboard_endpoint_v2
# }
#
# output "opensearch_domain_vpc_id" {
#   description = "VPC 内に作成された場合の VPC ID"
#   value       = try(aws_opensearch_domain.example.vpc_options[0].vpc_id, null)
# }
#
# output "opensearch_domain_availability_zones" {
#   description = "VPC 内に作成された場合の Availability Zone"
#   value       = try(aws_opensearch_domain.example.vpc_options[0].availability_zones, [])
# }
#
# output "opensearch_domain_tags_all" {
#   description = "プロバイダーの default_tags を含むすべてのタグ"
#   value       = aws_opensearch_domain.example.tags_all
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 属性リファレンス
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - arn
#   説明: ドメインの ARN
#   用途: IAM ポリシーでのリソース指定、クロスアカウント参照など
#
# - domain_id
#   説明: ドメインの一意の識別子
#   用途: API 呼び出し、リソース識別など
#
# - domain_name
#   説明: OpenSearch ドメインの名前
#   用途: 参照、ログ出力など
#
# - endpoint
#   説明: ドメイン固有のエンドポイント（インデックス、検索、データアップロード用）
#   用途: アプリケーションからの接続、API 呼び出しなど
#   形式: search-ドメイン名-ランダム文字列.リージョン.es.amazonaws.com
#
# - endpoint_v2
#   説明: IPv4 と IPv6 の両方に対応した V2 ドメインエンドポイント
#   用途: デュアルスタック環境での接続
#   注意: ip_address_type が "dualstack" の場合に利用可能
#
# - dashboard_endpoint
#   説明: Dashboard 固有のエンドポイント（https スキームなし）
#   用途: OpenSearch Dashboards へのアクセス
#   形式: search-ドメイン名-ランダム文字列.リージョン.es.amazonaws.com/_dashboards
#
# - dashboard_endpoint_v2
#   説明: IPv4 と IPv6 に対応した V2 Dashboard エンドポイント
#   用途: デュアルスタック環境での Dashboard アクセス
#   注意: ip_address_type が "dualstack" の場合に利用可能
#
# - domain_endpoint_v2_hosted_zone_id
#   説明: デュアルスタックエンドポイント用のホステッドゾーン ID
#   用途: Route 53 エイリアスレコードの作成など
#
# - tags_all
#   説明: リソースに割り当てられたすべてのタグのマップ
#          （プロバイダーの default_tags から継承されたタグを含む）
#   用途: タグの完全なリストの取得、他のリソースへのタグの伝播など
#
# - vpc_options.0.availability_zones
#   説明: VPC 内に作成された場合、設定された subnet_ids が作成された AZ の名前
#   用途: マルチ AZ 配置の確認など
#
# - vpc_options.0.vpc_id
#   説明: VPC 内に作成された場合の VPC ID
#   用途: ネットワーク設定の確認、セキュリティグループの参照など
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_opensearch_domain" "basic" {
#   domain_name    = "basic-example"
#   engine_version = "OpenSearch_2.11"
#
#   cluster_config {
#     instance_type = "r5.large.search"
#     instance_count = 1
#   }
#
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#     volume_type = "gp3"
#   }
#
#   tags = {
#     Name = "basic-opensearch"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_security_group" "opensearch" {
#   name        = "opensearch-sg"
#   description = "Security group for OpenSearch domain"
#   vpc_id      = aws_vpc.main.id
#
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.main.cidr_block]
#   }
# }
#
# resource "aws_iam_service_linked_role" "opensearch" {
#   aws_service_name = "opensearchservice.amazonaws.com"
# }
#
# resource "aws_opensearch_domain" "vpc_domain" {
#   domain_name    = "vpc-example"
#   engine_version = "OpenSearch_2.11"
#
#   cluster_config {
#     instance_type          = "r5.large.search"
#     instance_count         = 3
#     zone_awareness_enabled = true
#     zone_awareness_config {
#       availability_zone_count = 3
#     }
#     dedicated_master_enabled = true
#     dedicated_master_type    = "c5.large.search"
#     dedicated_master_count   = 3
#   }
#
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 100
#     volume_type = "gp3"
#     iops        = 3000
#     throughput  = 125
#   }
#
#   encrypt_at_rest {
#     enabled = true
#   }
#
#   node_to_node_encryption {
#     enabled = true
#   }
#
#   domain_endpoint_options {
#     enforce_https       = true
#     tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
#   }
#
#   advanced_security_options {
#     enabled                        = true
#     internal_user_database_enabled = true
#     master_user_options {
#       master_user_name     = "admin"
#       master_user_password = "YourSecurePassword123!"
#     }
#   }
#
#   vpc_options {
#     subnet_ids = [
#       aws_subnet.private_1.id,
#       aws_subnet.private_2.id,
#       aws_subnet.private_3.id,
#     ]
#     security_group_ids = [aws_security_group.opensearch.id]
#   }
#
#   depends_on = [aws_iam_service_linked_role.opensearch]
#
#   tags = {
#     Name        = "vpc-opensearch"
#     Environment = "production"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# data "aws_region" "current" {}
# data "aws_caller_identity" "current" {}
#
# data "aws_iam_policy_document" "opensearch_access_policy" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#     actions   = ["es:*"]
#     resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/example-domain/*"]
#
#     condition {
#       test     = "IpAddress"
#       variable = "aws:SourceIp"
#       values   = ["203.0.113.0/24"]
#     }
#   }
# }
#
# resource "aws_opensearch_domain" "with_policy" {
#   domain_name = "policy-example"
#   # ... その他の設定 ...
#   access_policies = data.aws_iam_policy_document.opensearch_access_policy.json
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# resource "aws_cloudwatch_log_group" "opensearch_logs" {
#   name              = "/aws/opensearch/domains/example-domain/application-logs"
#   retention_in_days = 14
# }
#
# data "aws_iam_policy_document" "opensearch_log_publishing_policy" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["es.amazonaws.com"]
#     }
#     actions = [
#       "logs:PutLogEvents",
#       "logs:PutLogEventsBatch",
#       "logs:CreateLogStream",
#     ]
#     resources = ["arn:aws:logs:*"]
#   }
# }
#
# resource "aws_cloudwatch_log_resource_policy" "opensearch" {
#   policy_name     = "opensearch-log-publishing-policy"
#   policy_document = data.aws_iam_policy_document.opensearch_log_publishing_policy.json
# }
#
# resource "aws_opensearch_domain" "with_logs" {
#   domain_name = "logs-example"
#   # ... その他の設定 ...
#
#   log_publishing_options {
#     cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
#     log_type                 = "ES_APPLICATION_LOGS"
#     enabled                  = true
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
#
# 1. セキュリティ
#    - 本番環境では必ず暗号化（保存時・転送中）を有効化
#    - Fine-Grained Access Control を有効化してアクセス制御を強化
#    - VPC 内に配置してネットワークレベルで隔離
#    - TLS 1.2 以降を使用（tls_security_policy）
#    - マスターユーザーのパスワードは変数や Secrets Manager で管理
#
# 2. 高可用性
#    - マルチ AZ 構成を使用（zone_awareness_enabled = true）
#    - 専用マスターノードを使用（dedicated_master_enabled = true）
#    - データノードは少なくとも 3 ノード以上を推奨
#    - レプリカを適切に設定（インデックス設定）
#
# 3. パフォーマンス
#    - ワークロードに応じた適切なインスタンスタイプを選択
#    - Auto-Tune を有効化して自動最適化
#    - EBS ボリュームは gp3 を使用してコストとパフォーマンスを最適化
#    - ウォームストレージやコールドストレージで古いデータのコストを削減
#
# 4. 監視とログ
#    - CloudWatch メトリクスを監視
#    - CloudWatch Logs にログを発行して分析
#    - アラームを設定して異常を検知
#
# 5. コスト最適化
#    - 本番以外の環境では小規模な構成を使用
#    - UltraWarm でアクセス頻度の低いデータのコストを削減
#    - 不要なログ発行を無効化
#    - リザーブドインスタンスの利用を検討
#
# 6. バージョン管理
#    - 定期的なアップグレードでセキュリティを維持
#    - アップグレード前にスナップショットを取得
#    - テスト環境で事前に検証
#
# 7. 依存関係とタイミング
#    - VPC 配置の場合、サービスリンクロールを depends_on で指定
#    - ログ発行の場合、リソースポリシーを事前に作成
#    - 作成には時間がかかるため、適切なタイムアウトを設定
#
# 8. インポート
#    - 既存の OpenSearch ドメインは以下でインポート可能:
#      terraform import aws_opensearch_domain.example domain-name
#
#---------------------------------------------------------------
