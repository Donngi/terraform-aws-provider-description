# ================================================================================
# AWS OpenSearch Serverless Security Policy - Network Type
# ================================================================================
#
# このリソースは、OpenSearch Serverlessコレクションのネットワークポリシーを管理します。
# ネットワークポリシーは、コレクションとOpenSearch Dashboardsエンドポイントへの
# アクセスを制御し、パブリックアクセスまたはVPCエンドポイント経由のプライベート
# アクセスを定義します。
#
# ユースケース:
# - パブリックインターネットからのアクセス制御
# - VPCエンドポイント経由のプライベートアクセスの実装
# - コレクションとDashboardsエンドポイントへの異なるアクセスポリシー設定
# - 複数のコレクションに対する統一されたネットワークアクセス管理
#
# 前提条件:
# - VPCアクセスを使用する場合、OpenSearch Serverless管理VPCエンドポイントを事前に作成
# - IAM権限: aoss:CreateSecurityPolicy, aoss:UpdateSecurityPolicy
#
# 関連リソース:
# - aws_opensearchserverless_collection
# - aws_opensearchserverless_vpc_endpoint (プライベートアクセス用)
#
# 公式ドキュメント:
# - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-network.html
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy
#
# ================================================================================

# --------------------------------------------------------------------------------
# パブリックアクセス - インターネット経由のアクセス許可 (開発環境向け)
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_public" {
  # ポリシー名 (必須)
  # - 3〜32文字の長さ
  # - 小文字、数字、ハイフンのみ使用可能
  # - 小文字で開始する必要がある
  name = "example-public-network-policy"

  # セキュリティポリシーのタイプ (必須)
  # - 有効な値: "encryption" または "network"
  type = "network"

  # ポリシーの説明 (オプション)
  description = "Public access to collection and Dashboards endpoint"

  # JSON形式のポリシードキュメント (必須)
  # ネットワークポリシーは配列形式で定義
  #
  # 各ポリシーエントリの構成:
  # - Description: ポリシールールの説明
  # - Rules: アクセスを許可するリソースのリスト
  #   - ResourceType: "collection" (コレクションエンドポイント) または "dashboard" (Dashboards)
  #   - Resource: 適用するコレクションのパターン
  # - AllowFromPublic: true (パブリックアクセス許可) / false (VPCアクセスのみ)
  policy = jsonencode([
    {
      Description = "Public access to collection and Dashboards endpoint",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/example-collection"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/example-collection"
          ]
        }
      ],
      AllowFromPublic = true
    }
  ])

  # リージョンの指定 (オプション)
  # region = "us-east-1"
}

# --------------------------------------------------------------------------------
# VPCプライベートアクセス - VPCエンドポイント経由のアクセス (本番環境推奨)
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_vpc" {
  name        = "example-vpc-network-policy"
  type        = "network"
  description = "VPC access to collection and Dashboards endpoint"

  # VPCエンドポイント経由のプライベートアクセス設定
  #
  # セキュリティ上の利点:
  # - インターネットへの露出を回避
  # - VPC内からの制御されたアクセス
  # - AWS PrivateLink経由の安全な通信
  #
  # 必須設定:
  # - AllowFromPublic: false (パブリックアクセスを拒否)
  # - SourceVPCEs: アクセスを許可するVPCエンドポイントIDのリスト
  #
  # 注意:
  # - VPCエンドポイント (aws_opensearchserverless_vpc_endpoint) を
  #   事前に作成する必要がある
  policy = jsonencode([
    {
      Description = "VPC access to collection and Dashboards endpoint",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/example-collection"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/example-collection"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    }
  ])
}

# --------------------------------------------------------------------------------
# 複数VPCエンドポイント - マルチVPCアクセス
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_multi_vpc" {
  name        = "example-multi-vpc-policy"
  type        = "network"
  description = "Multiple VPC access to collection"

  # 複数のVPCエンドポイントからのアクセスを許可
  # - 複数のVPCまたはAWSアカウントからのアクセスに対応
  # - 各VPCエンドポイントIDをSourceVPCEsリストに追加
  policy = jsonencode([
    {
      Description = "Multi-VPC access to collection",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/shared-collection"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/shared-collection"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs = [
        "vpce-050f79086ee71ac05",
        "vpce-0a1b2c3d4e5f67890",
        "vpce-0fedcba9876543210"
      ]
    }
  ])
}

# --------------------------------------------------------------------------------
# 混合アクセスパターン - 異なるコレクションに異なるアクセスポリシー
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_mixed" {
  name        = "example-mixed-network-policy"
  type        = "network"
  description = "Mixed access for marketing and sales collections"

  # 複数のポリシールールを定義して、コレクションごとに異なるアクセスパターンを実装
  #
  # ユースケース:
  # - 開発環境はパブリックアクセス、本番環境はVPCアクセス
  # - チームごとに異なるネットワークアクセス要件
  # - 機密性レベルに応じたアクセス制御
  policy = jsonencode([
    {
      Description = "Marketing collections - VPC access only",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/marketing-*"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/marketing-*"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    },
    {
      Description = "Sales collection - Public access",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/sales"
          ]
        }
      ],
      AllowFromPublic = true
    }
  ])
}

# --------------------------------------------------------------------------------
# コレクションのみアクセス - Dashboards無効化
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_collection_only" {
  name        = "example-collection-only-policy"
  type        = "network"
  description = "Access to collection endpoint only, no Dashboards access"

  # コレクションエンドポイントのみアクセス許可
  # - APIベースのアクセスのみを許可
  # - Dashboardsエンドポイントへのアクセスを制限
  #
  # ユースケース:
  # - プログラマティックアクセスのみが必要な場合
  # - セキュリティ要件でUI アクセスを制限する必要がある場合
  policy = jsonencode([
    {
      Description = "Collection endpoint access only",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/api-only-collection"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    }
  ])
}

# --------------------------------------------------------------------------------
# ワイルドカードパターン - 複数コレクションへの統一ポリシー
# --------------------------------------------------------------------------------
resource "aws_opensearchserverless_security_policy" "network_wildcard" {
  name        = "example-wildcard-network-policy"
  type        = "network"
  description = "Network policy for all production collections"

  # ワイルドカードパターンで複数のコレクションに適用
  # - 命名規則に基づいた効率的な管理
  # - スケーラブルなネットワークポリシー管理
  policy = jsonencode([
    {
      Description = "Production collections - VPC access",
      Rules = [
        {
          ResourceType = "collection",
          Resource = [
            "collection/prod-*"
          ]
        },
        {
          ResourceType = "dashboard",
          Resource = [
            "collection/prod-*"
          ]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs = [
        "vpce-050f79086ee71ac05"
      ]
    }
  ])
}

# --------------------------------------------------------------------------------
# Outputs - 他のリソースで参照可能な値
# --------------------------------------------------------------------------------

# ポリシー名 (コレクション作成時に必要)
output "network_policy_name" {
  description = "Name of the network security policy"
  value       = aws_opensearchserverless_security_policy.network_vpc.name
}

# ポリシーバージョン (監査・追跡用)
output "network_policy_version" {
  description = "Version of the network security policy"
  value       = aws_opensearchserverless_security_policy.network_vpc.policy_version
}

# ポリシーID (一意識別子)
output "network_policy_id" {
  description = "ID of the network security policy"
  value       = aws_opensearchserverless_security_policy.network_vpc.id
}

# ================================================================================
# 重要な注意事項
# ================================================================================
#
# 1. ネットワークポリシーの作成タイミング
#    - コレクション作成前にネットワークポリシーを作成する必要がある
#    - ポリシーが存在しないとコレクション作成は失敗する
#
# 2. パブリックアクセスのセキュリティ考慮事項
#    - 本番環境ではVPCアクセスの使用を強く推奨
#    - パブリックアクセスは開発・テスト環境にのみ使用
#    - パブリックアクセスを使用する場合は、データアクセスポリシーとIAM認証で
#      適切なアクセス制御を実装
#
# 3. VPCエンドポイントの前提条件
#    - aws_opensearchserverless_vpc_endpointを事前に作成
#    - VPCエンドポイントは同じリージョン内に存在する必要がある
#    - VPCエンドポイントの作成には時間がかかる場合がある
#
# 4. ResourceTypeの使い分け
#    - "collection": OpenSearch APIエンドポイント (データの検索・インデックス化)
#    - "dashboard": OpenSearch Dashboards UI (可視化・管理)
#    - 両方を含めるか、片方のみにするかはユースケースに応じて決定
#
# 5. 複数ポリシールールの評価
#    - ネットワークポリシーは複数のルールを配列で定義可能
#    - 各ルールは独立して評価される
#    - 少なくとも1つのルールがマッチすればアクセスが許可される
#
# 6. ポリシー変更の影響
#    - 既存のコレクションへのアクセスパターンに影響
#    - パブリックからVPCアクセスへの変更は慎重に計画
#    - 変更前にアクセス要件を確認
#
# 7. ベストプラクティス
#    - 環境ごとに異なるネットワークポリシーを使用 (dev/staging/prod)
#    - 最小権限の原則に従い、必要なアクセスのみを許可
#    - VPCアクセスを優先し、パブリックアクセスは最小限に
#    - ポリシーの変更を監査ログで追跡
#    - 定期的にアクセスパターンをレビュー
#
# 8. トラブルシューティング
#    - アクセスできない場合、ネットワークポリシーとデータアクセスポリシーの
#      両方を確認
#    - VPCエンドポイントIDが正しいか確認
#    - リソースパターンがコレクション名とマッチしているか確認
#
# ================================================================================
