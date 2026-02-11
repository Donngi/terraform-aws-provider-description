################################################################################
# AWS Prometheus Workspace
################################################################################
# Amazon Managed Service for Prometheus (AMP) ワークスペースを管理します。
# ワークスペースは、Prometheusメトリクスを保存・クエリするための専用スペースです。
#
# 主な機能:
# - Prometheusメトリクスの保存とクエリ専用のワークスペース
# - きめ細かいアクセス制御のサポート
# - リージョンごとに複数のワークスペースを作成可能
# - カスタマーマネージド KMS キーによる暗号化オプション
# - CloudWatch Logs への統合ログ機能
# - 自動スケーリングと高可用性
# - PromQL によるメトリクスクエリ
# - Prometheus サーバーからのリモート書き込みサポート
#
# ユースケース:
# - Kubernetes クラスター (EKS) からのメトリクス収集
# - コンテナ化されたアプリケーションとインフラストラクチャの監視
# - マイクロサービスアーキテクチャの監視
# - マルチテナントメトリクス管理（複数ワークスペース利用）
# - Grafana との統合によるメトリクス可視化
# - 長期間のメトリクス保存（デフォルト150日）
#
# 重要な考慮事項:
# - カスタマーマネージドキーで作成したワークスペースは、
#   AWS マネージドコレクターを使用した取り込みができません
# - カスタマーマネージドキーと AWS 所有キーの間での変換は不可
# - ワークスペース削除は取り消せないため注意が必要
# - エイリアスは一意である必要はありませんが、識別のため推奨
# - データは複数のアベイラビリティーゾーンにレプリケートされます
# - KMS キーへのアクセスが取り消されると、データにアクセスできなくなります
#
# 関連リソース:
# - aws_prometheus_rule_group_namespace: ルールグループの定義
# - aws_prometheus_alert_manager_definition: アラートマネージャー設定
# - aws_grafana_workspace: Grafana 統合
# - aws_cloudwatch_log_group: ログ出力先
# - aws_kms_key: カスタマーマネージド暗号化キー
# - aws_iam_role: Prometheus リモート書き込み用 IAM ロール
# - aws_eks_cluster: Amazon EKS クラスター統合
#
# 参考ドキュメント:
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_workspace
# https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html
# https://docs.aws.amazon.com/prometheus/latest/userguide/encryption-at-rest-Amazon-Service-Prometheus.html

resource "aws_prometheus_workspace" "example" {
  ################################################################################
  # 基本設定
  ################################################################################

  # ワークスペースのエイリアス（オプション）
  # - ワークスペースの識別に使用する人間が読みやすい名前
  # - エイリアスは一意である必要はありませんが、識別のため推奨
  # - 未指定の場合、ワークスペース ID のみで識別
  # - 最大 100 文字
  # - 後から変更可能（リソースの再作成は不要）
  #
  # 命名のベストプラクティス:
  # - 環境名を含める: "production-metrics", "staging-monitoring"
  # - 用途を明記: "eks-cluster-metrics", "microservices-monitoring"
  # - チーム/プロジェクト識別: "platform-team-workspace"
  # - リージョン情報（マルチリージョンの場合）: "prod-us-east-1"
  #
  # 例: "production-metrics", "dev-cluster-monitoring", "platform-observability"
  alias = "example-workspace"

  ################################################################################
  # 暗号化設定
  ################################################################################

  # KMS カスタマーマネージドキーの ARN（オプション）
  # - ワークスペース内のデータを暗号化するための KMS キー
  # - 未指定の場合、AWS 所有の暗号化キーが使用される
  # - 一度設定すると、AWS 所有キーへの変更は不可
  # - 逆に、AWS 所有キーからカスタマーマネージドキーへの変更も不可
  #
  # 必要な KMS 権限:
  # Amazon Managed Service for Prometheus が以下の権限を持つグラントが必要:
  #   * kms:DescribeKey - キーの検証
  #   * kms:GenerateDataKey - 暗号化されたデータキーの生成と保存
  #   * kms:Decrypt - データの復号化
  #
  # 制限事項:
  # - カスタマーマネージドキーを使用すると、AWS マネージドコレクターは
  #   使用できません（セルフマネージド Prometheus サーバーのみ対応）
  #
  # セキュリティ上の注意:
  # - カスタマーマネージドキーへのアクセスが取り消されると、
  #   ワークスペースはデータにアクセスできなくなり、
  #   データ損失の可能性があります
  # - KMS キー削除ウィンドウは 7日以上を推奨（誤削除防止）
  # - キーローテーションを有効化してセキュリティを強化
  #
  # 本番環境での推奨:
  # - コンプライアンス要件がある場合はカスタマーマネージドキーを使用
  # - 暗号化キーの制御が不要な場合は、AWS 所有キーで十分
  #
  # KMS キーポリシー例は下部の「使用例」セクションを参照
  #
  # 例:
  # kms_key_arn = aws_kms_key.example.arn
  kms_key_arn = null

  ################################################################################
  # リージョン設定
  ################################################################################

  # リソースが管理されるリージョン（オプション、計算済み）
  # - 未指定の場合、プロバイダー設定のリージョンを使用
  # - リージョンエンドポイント: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # - ワークスペースは作成後にリージョン間で移動できません
  # - マルチリージョンデプロイの場合、各リージョンに個別のワークスペースを作成
  #
  # 対応リージョン:
  # Amazon Managed Service for Prometheus は以下のリージョンで利用可能:
  # - 米国: us-east-1, us-east-2, us-west-1, us-west-2
  # - ヨーロッパ: eu-west-1, eu-west-2, eu-central-1, eu-north-1
  # - アジアパシフィック: ap-south-1, ap-northeast-1, ap-northeast-2,
  #                      ap-southeast-1, ap-southeast-2
  # - その他: ca-central-1, sa-east-1
  # ※ 最新の対応リージョンは公式ドキュメントで確認してください
  #
  # リージョン選択の考慮事項:
  # - データレジデンシー要件（コンプライアンス）
  # - レイテンシー（メトリクス送信元に近いリージョン）
  # - 他の AWS サービスとの統合（EKS クラスター等）
  # - コスト（リージョンによる料金差）
  # - ディザスタリカバリー（マルチリージョン構成）
  #
  # 例: "us-east-1", "eu-west-1", "ap-northeast-1"
  # region = "us-east-1"

  ################################################################################
  # ログ設定
  ################################################################################

  # ロギング設定ブロック（オプション）
  # - ワークスペースイベントを CloudWatch Logs に送信
  # - 警告（WARNING）およびエラー（ERROR）レベルのイベントのみログに記録
  # - 情報（INFO）やデバッグ（DEBUG）レベルのログは記録されません
  # - ログ分析、アラート、トラブルシューティングに使用
  # - CloudWatch Logs の無料枠: 5GB/月まで無料（超過分は課金）
  #
  # ログに記録される内容:
  # - アラートマネージャーのイベント
  # - ルールグループの実行結果
  # - ワークスペースのエラーと警告
  # - 設定変更のイベント
  #
  # ベストプラクティス:
  # - ログ グループ名には /aws/vendedlogs/ プレフィックスを使用
  #   （CloudWatch Logs リソースポリシーのサイズ制限 5120文字 対策）
  # - ログ保持期間を設定してコストを管理（7日、14日、30日など）
  # - ログメトリクスフィルターでアラートを設定
  # - KMS 暗号化を有効化してログデータを保護（コンプライアンス要件）
  # - ログ グループは事前に作成しておく必要があります
  #
  # IAM 権限要件:
  # - Amazon Managed Service for Prometheus サービスに以下の権限が必要:
  #   * logs:CreateLogStream
  #   * logs:PutLogEvents
  # - CloudWatch Logs リソースポリシーで許可を設定
  #
  # コスト最適化:
  # - 必要最小限のログ保持期間を設定
  # - ログインサイトクエリで効率的に分析
  # - S3 へのエクスポートで長期保存のコストを削減
  #
  # 例:
  # logging_configuration {
  #   log_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
  # }
  logging_configuration {
    # CloudWatch Logs ログ グループの ARN（必須）
    # - ログデータが公開される CloudWatch ログ グループ
    # - ログ グループは事前に作成されている必要があります
    # - ARN の末尾は `:*` で終わる必要があります（必須フォーマット）
    # - 形式: "arn:aws:logs:region:account-id:log-group:log-group-name:*"
    #
    # ログ グループ作成例:
    # resource "aws_cloudwatch_log_group" "example" {
    #   name              = "/aws/vendedlogs/prometheus/example"
    #   retention_in_days = 7
    # }
    #
    # 注意:
    # - ログ グループには適切な IAM ロールとリソースポリシーが必要
    # - Amazon Managed Service for Prometheus サービスに
    #   logs:CreateLogStream および logs:PutLogEvents 権限を付与
    # - ログ グループ削除時、ワークスペースの logging_configuration を
    #   先に削除する必要があります（依存関係）
    log_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
  }

  ################################################################################
  # タグ設定
  ################################################################################

  # リソースに割り当てるタグのマップ（オプション）
  # - ワークスペースの識別、整理、追跡に使用
  # - IAM ポリシーでのアクセス制御にも使用可能（タグベースアクセス制御: TBAC）
  # - AWS Cost Explorer でのコスト配分とレポート作成
  # - 最大 50 個のタグを設定可能
  # - タグキーの最大長: 128 文字（Unicode）
  # - タグ値の最大長: 256 文字（Unicode）
  # - タグキーと値は大文字小文字を区別（case sensitive）
  # - 各タグキーは一意である必要があり、値は1つのみ
  # - "aws:" または "AWS:" プレフィックスは AWS 予約のため使用不可
  #
  # プロバイダーレベルで default_tags が設定されている場合、
  # 同じキーを持つタグは上書きされます
  #
  # タグ戦略の例:
  # - 環境識別: Environment = "production" / "staging" / "development"
  # - コストセンター: CostCenter = "engineering" / "operations"
  # - プロジェクト: Project = "microservices-monitoring" / "platform-observability"
  # - チーム所有権: Team = "platform-engineering" / "devops"
  # - 自動化識別: ManagedBy = "terraform" / "cloudformation"
  # - データ分類: DataClassification = "confidential" / "internal" / "public"
  # - コンプライアンス: Compliance = "pci-dss" / "hipaa" / "gdpr"
  # - アプリケーション: Application = "payment-service" / "user-service"
  # - バックアップ: BackupPolicy = "daily" / "weekly"
  #
  # タグのベストプラクティス:
  # - 一貫した命名規則を使用（CamelCase または snake_case）
  # - 必須タグのセットを定義（Environment, Owner, Project など）
  # - プロバイダーレベルで共通タグを default_tags に設定
  # - タグを使って AWS Config ルールで準拠性を監視
  # - コストレポートのためにコストセンタータグを必ず付与
  tags = {
    Environment = "production"
    Project     = "monitoring"
    ManagedBy   = "terraform"
    Team        = "platform-engineering"
    CostCenter  = "engineering"
  }

  # プロバイダーのdefault_tagsを含むすべてのタグのマップ（計算済み）
  # - このフィールドは読み取り専用
  # - プロバイダーレベルの default_tags と
  #   リソースレベルの tags がマージされた結果
  # - 実際にリソースに適用されているすべてのタグを確認できます
  # - IAM ポリシーでアクセス制御する際に参照可能
  # tags_all は計算済み属性のため、ここでは設定不要
}

################################################################################
# 出力属性（計算済み・読み取り専用）
################################################################################
# このリソースは以下の属性を公開します:
#
# arn (string)
# - ワークスペースの Amazon Resource Name (ARN)
# - 形式: "arn:aws:aps:region:account-id:workspace/workspace-id"
# - IAM ポリシーでリソースを特定する際に使用
# - CloudWatch アラーム、EventBridge ルール等で参照
# - 例: aws_prometheus_workspace.example.arn
#
# id (string)
# - ワークスペースの一意識別子（ワークスペース ID）
# - 形式: "ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"（UUID）
# - Terraform でのリソース参照に使用
# - AWS CLI/API 呼び出しで使用
# - 例: aws_prometheus_workspace.example.id
#
# prometheus_endpoint (string)
# - このワークスペースで利用可能な Prometheus エンドポイント
# - ベース URL: "https://aps-workspaces.region.amazonaws.com/workspaces/workspace-id/"
# - リモート書き込み URL: ベース URL + "api/v1/remote_write"
# - クエリ URL: ベース URL + "api/v1/query"
# - ラベル取得 URL: ベース URL + "api/v1/labels"
# - メトリクスメタデータ URL: ベース URL + "api/v1/metadata"
#
# - デュアルスタック URL（IPv4 および IPv6 サポート）:
#   * ベース URL: "https://aps-workspaces.region.api.aws/workspaces/workspace-id/"
#   * リモート書き込み: ベース URL + "api/v1/remote_write"
#   * クエリ: ベース URL + "api/v1/query"
#
# - Prometheus サーバーの remote_write 設定で使用
# - Grafana データソース設定で使用
# - 例: aws_prometheus_workspace.example.prometheus_endpoint
#
# region (string)
# - ワークスペースが管理されているリージョン
# - リージョン指定がない場合、プロバイダー設定のリージョンが返される
# - マルチリージョン構成時のリージョン判定に使用
# - 例: aws_prometheus_workspace.example.region
#
# tags_all (map(string))
# - リソースに割り当てられたすべてのタグのマップ
# - プロバイダーの default_tags から継承されたタグを含む
# - リソースレベルの tags と default_tags がマージされた最終結果
# - IAM 条件キーでのアクセス制御に使用可能
# - 例: aws_prometheus_workspace.example.tags_all

################################################################################
# 使用例
################################################################################

# 例1: シンプルなワークスペース（最小構成）
# resource "aws_prometheus_workspace" "simple" {
#   alias = "simple-workspace"
#
#   tags = {
#     Name        = "simple-workspace"
#     Environment = "development"
#   }
# }

# 例2: CloudWatch Logs ロギング付きワークスペース
# resource "aws_cloudwatch_log_group" "prometheus" {
#   name              = "/aws/vendedlogs/prometheus/example"
#   retention_in_days = 7
#
#   tags = {
#     Name = "prometheus-workspace-logs"
#   }
# }
#
# resource "aws_prometheus_workspace" "with_logging" {
#   alias = "workspace-with-logging"
#
#   logging_configuration {
#     log_group_arn = "${aws_cloudwatch_log_group.prometheus.arn}:*"
#   }
#
#   tags = {
#     Name        = "workspace-with-logging"
#     Environment = "production"
#     Logging     = "enabled"
#   }
# }

# 例3: カスタマーマネージドキー (CMK) 暗号化付きワークスペース
# # KMS キーの作成
# resource "aws_kms_key" "prometheus" {
#   description             = "KMS key for Prometheus workspace encryption"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true
#
#   # KMS キーポリシー
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "Enable IAM User Permissions"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "Allow Amazon Managed Service for Prometheus to use the key"
#         Effect = "Allow"
#         Principal = {
#           Service = "aps.amazonaws.com"
#         }
#         Action = [
#           "kms:DescribeKey",
#           "kms:GenerateDataKey",
#           "kms:Decrypt"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "kms:ViaService" = [
#               "aps.${data.aws_region.current.name}.amazonaws.com"
#             ]
#           }
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name = "prometheus-workspace-encryption-key"
#   }
# }
#
# resource "aws_kms_alias" "prometheus" {
#   name          = "alias/prometheus-workspace"
#   target_key_id = aws_kms_key.prometheus.key_id
# }
#
# resource "aws_prometheus_workspace" "encrypted" {
#   alias       = "encrypted-workspace"
#   kms_key_arn = aws_kms_key.prometheus.arn
#
#   tags = {
#     Name        = "encrypted-workspace"
#     Environment = "production"
#     Encryption  = "customer-managed"
#     Compliance  = "required"
#   }
# }

# 例4: マルチリージョン展開
# # US East リージョン
# resource "aws_prometheus_workspace" "us_east" {
#   alias  = "prod-us-east-1"
#   region = "us-east-1"
#
#   tags = {
#     Name        = "production-us-east-1"
#     Environment = "production"
#     Region      = "us-east-1"
#   }
# }
#
# # EU West リージョン
# resource "aws_prometheus_workspace" "eu_west" {
#   alias  = "prod-eu-west-1"
#   region = "eu-west-1"
#
#   tags = {
#     Name        = "production-eu-west-1"
#     Environment = "production"
#     Region      = "eu-west-1"
#   }
# }

# 例5: 完全な構成（CloudWatch Logs + KMS 暗号化 + タグ）
# # KMS キー
# resource "aws_kms_key" "full_example" {
#   description             = "Prometheus workspace encryption key"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true
#
#   tags = {
#     Name = "prometheus-full-example-key"
#   }
# }
#
# # CloudWatch Logs ログ グループ（KMS 暗号化付き）
# resource "aws_cloudwatch_log_group" "full_example" {
#   name              = "/aws/vendedlogs/prometheus/full-example"
#   retention_in_days = 30
#   kms_key_id        = aws_kms_key.full_example.arn
#
#   tags = {
#     Name = "prometheus-full-example-logs"
#   }
# }
#
# # 完全な構成のワークスペース
# resource "aws_prometheus_workspace" "full_example" {
#   alias       = "full-example-workspace"
#   kms_key_arn = aws_kms_key.full_example.arn
#
#   logging_configuration {
#     log_group_arn = "${aws_cloudwatch_log_group.full_example.arn}:*"
#   }
#
#   tags = {
#     Name               = "full-example-workspace"
#     Environment        = "production"
#     Project            = "observability"
#     Team               = "platform-engineering"
#     CostCenter         = "engineering"
#     ManagedBy          = "terraform"
#     DataClassification = "confidential"
#     Compliance         = "required"
#   }
# }

# 例6: EKS クラスター統合用ワークスペース
# resource "aws_prometheus_workspace" "eks_monitoring" {
#   alias = "eks-cluster-monitoring"
#
#   logging_configuration {
#     log_group_arn = "${aws_cloudwatch_log_group.eks_prometheus.arn}:*"
#   }
#
#   tags = {
#     Name        = "eks-cluster-monitoring"
#     Environment = "production"
#     Purpose     = "eks-monitoring"
#     Cluster     = aws_eks_cluster.main.name
#   }
# }
#
# # EKS クラスターからのメトリクス送信用 IAM ロール
# resource "aws_iam_role" "prometheus_remote_write" {
#   name = "prometheus-remote-write-role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.eks.arn
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "${aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:prometheus:prometheus-server"
#           }
#         }
#       }
#     ]
#   })
# }
#
# resource "aws_iam_role_policy" "prometheus_remote_write" {
#   name = "prometheus-remote-write-policy"
#   role = aws_iam_role.prometheus_remote_write.id
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "aps:RemoteWrite",
#           "aps:QueryMetrics",
#           "aps:GetSeries",
#           "aps:GetLabels",
#           "aps:GetMetricMetadata"
#         ]
#         Resource = aws_prometheus_workspace.eks_monitoring.arn
#       }
#     ]
#   })
# }

################################################################################
# 統合例
################################################################################

# Prometheus サーバーの remote_write 設定例:
#
# global:
#   external_labels:
#     cluster: 'production-eks'
#     region: 'us-east-1'
#
# remote_write:
#   - url: https://<workspace_id>.aps-workspaces.<region>.amazonaws.com/api/v1/remote_write
#     queue_config:
#       max_samples_per_send: 1000
#       max_shards: 200
#       capacity: 2500
#     sigv4:
#       region: us-east-1
#     write_relabel_configs:
#       - source_labels: [__name__]
#         regex: 'expensive_metric.*'
#         action: drop
#
# Terraform での URL 取得:
# url = "${aws_prometheus_workspace.example.prometheus_endpoint}api/v1/remote_write"

# Amazon Managed Grafana データソース設定例:
# resource "aws_grafana_workspace" "example" {
#   name                      = "example-grafana"
#   account_access_type       = "CURRENT_ACCOUNT"
#   authentication_providers  = ["AWS_SSO"]
#   permission_type           = "SERVICE_MANAGED"
#   role_arn                  = aws_iam_role.grafana.arn
# }
#
# # Grafana で Prometheus データソースを追加:
# # - Type: Prometheus
# # - URL: aws_prometheus_workspace.example.prometheus_endpoint
# # - Auth: SigV4 auth
# # - SigV4 Auth Details: default region and credentials

################################################################################
# IAM ポリシー例
################################################################################

# Prometheus リモート書き込み用 IAM ポリシー:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "aps:RemoteWrite"
#       ],
#       "Resource": "arn:aws:aps:<region>:<account-id>:workspace/<workspace-id>"
#     }
#   ]
# }

# Prometheus クエリ用 IAM ポリシー:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "aps:QueryMetrics",
#         "aps:GetSeries",
#         "aps:GetLabels",
#         "aps:GetMetricMetadata"
#       ],
#       "Resource": "arn:aws:aps:<region>:<account-id>:workspace/<workspace-id>"
#     }
#   ]
# }

# 管理者用 IAM ポリシー（フルアクセス）:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "aps:*",
#       "Resource": "*"
#     }
#   ]
# }

# タグベースアクセス制御 (TBAC) 例:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "aps:*",
#       "Resource": "*",
#       "Condition": {
#         "StringEquals": {
#           "aws:ResourceTag/Team": "platform-engineering"
#         }
#       }
#     }
#   ]
# }

################################################################################
# インポート
################################################################################
# 既存の Prometheus ワークスペースは以下のコマンドでインポートできます:
#
# terraform import aws_prometheus_workspace.example ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
#
# ワークスペース ID は以下の方法で確認できます:
# - AWS コンソール: Amazon Managed Service for Prometheus > ワークスペース一覧
# - AWS CLI: aws amp list-workspaces
# - AWS CLI: aws amp describe-workspace --workspace-id <workspace-id>
#
# インポート例:
# $ terraform import aws_prometheus_workspace.example ws-12345678-1234-1234-1234-123456789012
#
# インポート後の確認:
# $ terraform plan
# $ terraform state show aws_prometheus_workspace.example

################################################################################
# トラブルシューティング
################################################################################
# よくある問題と解決策:
#
# 1. KMS キーアクセスエラー
#    症状: "KMS key not found" または "Access denied to KMS key"
#    原因: KMS キーポリシーに aps.amazonaws.com サービスプリンシパルがない
#    解決策:
#    - KMS キーポリシーに以下の権限を追加:
#      * kms:DescribeKey
#      * kms:GenerateDataKey
#      * kms:Decrypt
#    - サービスプリンシパル: "aps.amazonaws.com"
#    - kms:ViaService 条件で適切なリージョンを指定
#
# 2. ログ グループ ARN エラー
#    症状: "Invalid log group ARN format"
#    原因: ARN が `:*` で終わっていない
#    解決策:
#    - log_group_arn = "${aws_cloudwatch_log_group.example.arn}:*"
#    - ログ グループが存在し、正しいリージョンにあるか確認
#    - CloudWatch Logs リソースポリシーを確認
#
# 3. ワークスペース作成の遅延
#    症状: ワークスペースが "CREATING" 状態のまま
#    原因: AWS 側での初期化処理
#    解決策:
#    - 通常 1〜2 分で "ACTIVE" になります
#    - aws amp describe-workspace コマンドで状態を確認
#    - 5 分以上 CREATING の場合、AWS サポートに問い合わせ
#
# 4. タグ適用エラー
#    症状: "Invalid tag key" または "Tag limit exceeded"
#    原因: タグの制約違反
#    解決策:
#    - タグキーと値の長さ制限を確認（キー: 128文字、値: 256文字）
#    - "aws:" プレフィックスを使用していないか確認
#    - タグの数が 50 個を超えていないか確認
#    - タグキーが一意であることを確認
#
# 5. リモート書き込みエラー
#    症状: Prometheus サーバーから "401 Unauthorized" または "403 Forbidden"
#    原因: IAM 認証/認可の問題
#    解決策:
#    - IAM ロール/ユーザーに aps:RemoteWrite 権限があるか確認
#    - SigV4 認証が正しく設定されているか確認
#    - ワークスペース ARN がポリシーで正しく指定されているか確認
#    - リージョンが一致しているか確認
#
# 6. クエリパフォーマンスの問題
#    症状: クエリが遅い、タイムアウトする
#    原因: メトリクスのカーディナリティが高い、クエリが非効率
#    解決策:
#    - メトリクスラベルの数を削減
#    - 不要なメトリクスをフィルタリング（write_relabel_configs）
#    - クエリの時間範囲を短縮
#    - CloudWatch メトリクスでアクティブシリーズ数を監視
#
# 7. データ取り込みの遅延
#    症状: メトリクスが反映されるまで時間がかかる
#    原因: リモート書き込みキューの設定、ネットワークレイテンシー
#    解決策:
#    - remote_write の queue_config を調整
#    - max_shards を増やす（並列度向上）
#    - max_samples_per_send を調整
#    - Prometheus サーバーのリソース（CPU、メモリ）を確認
#
# 8. コストの急増
#    症状: 予想外に高額な請求
#    原因: メトリクスの急激な増加、クエリの過度な実行
#    解決策:
#    - CloudWatch メトリクスで使用量を監視:
#      * ActiveSeriesCount（アクティブシリーズ数）
#      * IngestionRate（取り込みレート）
#      * QuerySamplesProcessed（クエリ処理サンプル数）
#    - 不要なメトリクスを削除
#    - データ保持期間を見直し
#    - AWS Cost Explorer でコストを分析

################################################################################
# 重要な注意事項とベストプラクティス
################################################################################
#
# 1. ワークスペース命名規則:
#    - 環境、用途、リージョンが識別できるエイリアスを使用
#    - 例: "prod-eks-us-east-1", "staging-microservices-monitoring"
#    - エイリアスは後から変更可能（リソースの再作成不要）
#    - 一意性は必須ではないが、混乱を避けるため推奨
#
# 2. セキュリティベストプラクティス:
#    - 本番環境ではカスタマーマネージドキーの使用を検討
#    - KMS キーローテーションを有効化（年1回の自動ローテーション）
#    - KMS キーポリシーで最小権限の原則を適用
#    - IAM ポリシーでワークスペースへのアクセスを制限
#    - タグベースのアクセス制御 (TBAC) を活用
#    - CloudTrail で API コールを記録し、監査証跡を保持
#    - VPC エンドポイントを使用してプライベート接続を確立（推奨）
#
# 3. ロギングとモニタリング:
#    - CloudWatch Logs を有効化してイベントを監視
#    - ログ保持期間を適切に設定（コンプライアンス要件に応じて）
#    - ログメトリクスフィルターでアラートを設定
#    - CloudWatch メトリクスでワークスペースの使用状況を監視:
#      * ActiveSeriesCount（メトリクス数）
#      * IngestionRate（データ取り込みレート）
#      * QuerySamplesProcessed（クエリ処理量）
#    - アラームを設定して異常を早期検知
#
# 4. コスト最適化のヒント:
#    - 使用量の定期的な監視（CloudWatch メトリクス）
#    - 不要なメトリクスのフィルタリング（write_relabel_configs）
#    - 適切なデータ保持期間の設定（デフォルト: 150日）
#    - タグ付けによるコスト配分（Cost Explorer で分析）
#    - CloudWatch Logs の保持期間を適切に設定
#    - ログ グループ名に /aws/vendedlogs/ プレフィックスを使用
#      （リソースポリシーサイズ制限対策）
#
# 5. 高可用性とディザスタリカバリー:
#    - AMP は自動的に複数のアベイラビリティーゾーンにデータを複製
#    - 手動バックアップ設定は不要（フルマネージド）
#    - マルチリージョン構成でディザスタリカバリーを強化
#    - 重要なメトリクスは複数リージョンに送信することを検討
#
# 6. 統合のベストプラクティス:
#    - Prometheus サーバーで remote_write を適切に設定
#    - SigV4 認証を使用（AWS SDK または Sigv4Proxy）
#    - 外部ラベル（external_labels）でクラスター/環境を識別
#    - リモート書き込みキューの設定を最適化:
#      * max_samples_per_send: 1000
#      * max_shards: 200（並列度）
#      * capacity: 2500（キュー容量）
#    - リモート書き込みの失敗を監視（Prometheus メトリクス）
#
# 7. パフォーマンス最適化:
#    - メトリクスのカーディナリティを適切に管理
#    - ラベル数を最小限に抑える（高カーディナリティは避ける）
#    - 不要なメトリクスは収集しない（relabel_configs で除外）
#    - クエリは効率的な PromQL を使用
#    - 長時間範囲のクエリは避け、必要に応じて分割
#
# 8. データ保持とストレージ:
#    - デフォルトの保持期間: 150 日
#    - 現時点でカスタム保持期間の設定は不可
#    - 長期保存が必要な場合、外部ストレージへのエクスポートを検討
#    - S3 へのバックアップ（Prometheus Exporter 使用）
#
# 9. 移行とテスト:
#    - セルフマネージド Prometheus から段階的に移行
#    - テスト環境で PromQL クエリの互換性を検証
#    - メトリクスカーディナリティを事前に確認
#    - パイロットクラスターで先行テスト
#    - 移行計画を策定（リスク、ロールバック手順を含む）
#
# 10. 削除と依存関係管理:
#     - ワークスペース削除は取り消せません（データ損失）
#     - 削除前にデータのバックアップを確認
#     - 依存リソース（ルールグループ、アラートマネージャー）を先に削除
#     - logging_configuration を使用している場合、先に削除
#     - Terraform の lifecycle.prevent_destroy を検討（誤削除防止）

################################################################################
# セキュリティチェックリスト
################################################################################
# 本番環境デプロイ前に以下を確認してください:
#
# □ カスタマーマネージドキー (KMS) を使用している
# □ KMS キーローテーションが有効化されている
# □ CloudWatch Logs が有効化されている
# □ ログ グループに適切な保持期間が設定されている
# □ IAM ポリシーが最小権限の原則に従っている
# □ タグベースアクセス制御 (TBAC) を実装している
# □ CloudTrail でワークスペース API コールを記録している
# □ CloudWatch アラームが設定されている
# □ VPC エンドポイントを使用してプライベート接続を確立している
# □ コストアラートが設定されている
# □ バックアップとディザスタリカバリー計画が策定されている
# □ セキュリティグループで不要なトラフィックを制限している

################################################################################
# コンプライアンス考慮事項
################################################################################
#
# GDPR (EU 一般データ保護規則):
# - 個人データを含むメトリクスの場合、適切なリージョン選択
# - EU リージョン（eu-west-1, eu-central-1 など）を使用
# - データ保持期間をコンプライアンス要件に合わせて設定
#
# HIPAA (医療保険の携行性と責任に関する法律):
# - カスタマーマネージドキーで暗号化を有効化
# - CloudWatch Logs も KMS で暗号化
# - アクセスログを CloudTrail で記録
# - BAA (Business Associate Agreement) を AWS と締結
#
# PCI DSS (Payment Card Industry Data Security Standard):
# - カスタマーマネージドキーによる暗号化
# - タグで PCI 対象リソースを識別
# - アクセス制御を厳格に実装
# - 定期的なセキュリティ監査
#
# SOC 2:
# - 変更管理プロセスの実装
# - インフラストラクチャのコード化 (IaC)
# - すべての変更をバージョン管理
# - CloudTrail での監査証跡

################################################################################
# 追加リソースとドキュメント
################################################################################
#
# AWS 公式ドキュメント:
# - ユーザーガイド: https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html
# - API リファレンス: https://docs.aws.amazon.com/prometheus/latest/APIReference/Welcome.html
# - ベストプラクティス: https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-best-practices.html
# - 暗号化: https://docs.aws.amazon.com/prometheus/latest/userguide/encryption-at-rest-Amazon-Service-Prometheus.html
# - ロギング: https://docs.aws.amazon.com/prometheus/latest/userguide/CW-logs.html
# - タグ付け: https://docs.aws.amazon.com/prometheus/latest/userguide/tagging-workspaces.html
#
# Terraform ドキュメント:
# - リソース: https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/prometheus_workspace
# - データソース: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/prometheus_workspace
#
# 関連 AWS サービス:
# - Amazon Managed Grafana: Prometheus メトリクスの可視化
#   https://docs.aws.amazon.com/grafana/latest/userguide/
# - Amazon CloudWatch: 追加の監視とロギング
#   https://docs.aws.amazon.com/cloudwatch/
# - AWS KMS: 暗号化キー管理
#   https://docs.aws.amazon.com/kms/
# - Amazon EKS: Kubernetes ワークロード監視
#   https://docs.aws.amazon.com/eks/
#
# Prometheus 公式ドキュメント:
# - Remote Write: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write
# - PromQL: https://prometheus.io/docs/prometheus/latest/querying/basics/
#
# コミュニティリソース:
# - AWS Observability Accelerator: https://github.com/aws-observability/aws-observability-accelerator
# - EKS ワークショップ: https://www.eksworkshop.com/
# - AWS Samples: https://github.com/aws-samples/
