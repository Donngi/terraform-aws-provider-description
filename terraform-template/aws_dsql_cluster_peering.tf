#---------------------------------------------------------------
# Amazon Aurora DSQL Cluster Peering
#---------------------------------------------------------------
#
# Amazon Aurora DSQLのmulti-Region構成を実現するために、2つのDSQLクラスターを
# 接続（ピアリング）するリソースです。multi-Regionクラスターは、2つのリージョナル
# エンドポイントとwitnessリージョンで構成され、99.999%の可用性と強力な
# データ一貫性を提供します。
#
# AWS公式ドキュメント:
#   - Aurora DSQL Multi-Region Clusters: https://docs.aws.amazon.com/aurora-dsql/latest/userguide/multi-region-aws-cli.html
#   - Getting Started with Aurora DSQL: https://docs.aws.amazon.com/aurora-dsql/latest/userguide/getting-started.html
#   - Multi-Region Architecture: https://aws.amazon.com/blogs/database/implement-multi-region-endpoint-routing-for-amazon-aurora-dsql/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dsql_cluster_peering
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_dsql_cluster_peering" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # identifier (Required)
  # 設定内容: ピアリング元となるDSQLクラスターの識別子を指定します。
  # 設定可能な値: 既存のDSQLクラスターのidentifier
  # 注意:
  #   - クラスターは事前に作成されている必要があります
  #   - クラスターにはmulti_region_propertiesでwitness_regionが設定されている必要があります
  # 関連リソース: aws_dsql_cluster
  identifier = "primary-cluster-id"

  # clusters (Required)
  # 設定内容: ピアリング先となるDSQLクラスターのARNリストを指定します。
  # 設定可能な値: DSQLクラスターのARNの配列
  # 注意:
  #   - ピアリング先クラスターは異なるリージョンに存在する必要があります
  #   - 各クラスターARNは有効な形式である必要があります（arn:aws:dsql:region:account-id:cluster/cluster-id）
  #   - 通常は1つのクラスターARNを指定します（multi-Regionは2つのクラスターで構成）
  # 関連機能: Multi-Region Aurora DSQL
  #   2つのリージョンにそれぞれクラスターを作成し、ピアリングすることで
  #   Active-Activeのmulti-Region構成を実現します。
  #   - https://docs.aws.amazon.com/aurora-dsql/latest/userguide/multi-region-aws-cli.html
  clusters = [
    "arn:aws:dsql:eu-west-1:123456789012:cluster/secondary-cluster-id"
  ]

  # witness_region (Required)
  # 設定内容: multi-Regionクラスターのwitnessリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2, eu-west-1）
  # 注意:
  #   - ピアリングする両方のクラスターで同じwitness_regionを使用する必要があります
  #   - witnessリージョンはトランザクションログを保存し、クラスター間の一貫性を維持します
  #   - データリージョンとは異なる、地理的に離れたリージョンを選択することを推奨
  # 関連機能: Witness Region
  #   witnessリージョンは、multi-Regionクラスターのトランザクションログを保存し、
  #   障害発生時の整合性とクォーラムの維持に使用されます。
  #   - https://docs.aws.amazon.com/aurora-dsql/latest/APIReference/API_MultiRegionProperties.html
  witness_region = "us-west-2"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意:
  #   - identifierで指定したクラスターが存在するリージョンと一致する必要があります
  #   - multi-Region構成では、各リージョンでピアリング設定を作成する必要があります
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Multi-Region構成の完全な例（コメントアウト）
#---------------------------------------------------------------
# Multi-Region DSQLクラスターを構成するには、以下のように
# 各リージョンでクラスターとピアリングを設定します。
#
# # Provider設定（2つのリージョン）
# provider "aws" {
#   region = "us-east-1"
#   alias  = "primary"
# }
#
# provider "aws" {
#   region = "eu-west-1"
#   alias  = "secondary"
# }
#
# # Primaryリージョンのクラスター
# resource "aws_dsql_cluster" "primary" {
#   provider = aws.primary
#
#   multi_region_properties {
#     witness_region = "us-west-2"
#   }
#
#   deletion_protection_enabled = true
#
#   tags = {
#     Name        = "primary-dsql-cluster"
#     Environment = "production"
#     Role        = "primary"
#   }
# }
#
# # Secondaryリージョンのクラスター
# resource "aws_dsql_cluster" "secondary" {
#   provider = aws.secondary
#
#   multi_region_properties {
#     witness_region = "us-west-2"  # Primaryと同じwitness_region
#   }
#
#   deletion_protection_enabled = true
#
#   tags = {
#     Name        = "secondary-dsql-cluster"
#     Environment = "production"
#     Role        = "secondary"
#   }
# }
#
# # Primary → Secondaryへのピアリング
# resource "aws_dsql_cluster_peering" "primary_to_secondary" {
#   provider = aws.primary
#
#   identifier     = aws_dsql_cluster.primary.identifier
#   clusters       = [aws_dsql_cluster.secondary.arn]
#   witness_region = aws_dsql_cluster.primary.multi_region_properties[0].witness_region
#
#   depends_on = [
#     aws_dsql_cluster.primary,
#     aws_dsql_cluster.secondary
#   ]
# }
#
# # Secondary → Primaryへのピアリング（双方向設定）
# resource "aws_dsql_cluster_peering" "secondary_to_primary" {
#   provider = aws.secondary
#
#   identifier     = aws_dsql_cluster.secondary.identifier
#   clusters       = [aws_dsql_cluster.primary.arn]
#   witness_region = aws_dsql_cluster.secondary.multi_region_properties[0].witness_region
#
#   depends_on = [
#     aws_dsql_cluster.primary,
#     aws_dsql_cluster.secondary
#   ]
# }
#
# # エンドポイント出力
# output "primary_endpoint" {
#   value       = aws_dsql_cluster.primary.endpoint
#   description = "Primaryクラスターのエンドポイント"
# }
#
# output "secondary_endpoint" {
#   value       = aws_dsql_cluster.secondary.endpoint
#   description = "Secondaryクラスターのエンドポイント"
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ピアリング設定の一意識別子（通常はクラスター識別子と同じ）
#
# - identifier: クラスター識別子（入力値と同じ）
#
# - clusters: ピアリングされたクラスターのARNリスト
#
# - witness_region: witnessリージョン（入力値と同じ）
#---------------------------------------------------------------

#---------------------------------------------------------------
# インポート
#---------------------------------------------------------------
# 既存のDSQLクラスターピアリング設定は、クラスター識別子を使用して
# インポートできます。
#
# 基本的なインポート:
#   terraform import aws_dsql_cluster_peering.example <cluster-identifier>
#
# プロバイダーエイリアスを使用する場合:
#   terraform import 'aws_dsql_cluster_peering.primary_to_secondary' \
#     -provider=aws.primary \
#     primary-cluster-id
#
# 注意事項:
#   - インポートは各リージョンで個別に実行する必要があります
#   - プロバイダーエイリアスを使用する場合、正しいプロバイダーを指定してください
#   - インポート後、terraform planで差分がないことを確認してください
#   - witness_regionとclustersの値が正しく設定されているか確認してください
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティスとトラブルシューティング
#---------------------------------------------------------------
#
# 【アーキテクチャ設計】
#
# 1. Witnessリージョンの選択
#    - データリージョンとは異なる、地理的に離れたリージョンを選択
#    - 例: データリージョンがus-east-1とeu-west-1の場合、witnessはus-west-2を推奨
#
# 2. 双方向ピアリングの一貫性
#    - 両方のピアリング設定で同じwitness_regionを使用する必要があります
#    - locals変数を使用して一貫性を保つことを推奨
#
# 3. リージョン間レイテンシーの考慮
#    - アプリケーションに近いリージョンを選択
#    - 北米とヨーロッパのユーザーベース → us-east-1とeu-west-1を推奨
#
# 【セキュリティ】
#
# 1. 削除保護の有効化
#    - 本番環境では、クラスターのdeletion_protection_enabled = trueを設定
#    - ピアリング設定にもlifecycle { prevent_destroy = true }を追加検討
#
# 2. IAMポリシーによるアクセス制御
#    - multi-Regionクラスター用のIAMポリシーを設定
#    - リージョン制限条件を追加してセキュリティを強化
#
# 3. PrivateLinkによる閉域接続
#    - VPCエンドポイント経由でのみアクセス可能に設定
#    - パブリックエンドポイントへのアクセスをブロック
#
# 【運用】
#
# 1. 命名規則の統一
#    - 環境とリージョンを含む命名規則を使用
#    - 例: production-primary、production-secondary
#
# 2. 依存関係の明示化
#    - depends_onを使用してクラスター作成後にピアリングを設定
#
# 3. モジュール化による再利用性
#    - multi-Region構成をモジュールとして定義
#    - 複数の環境で再利用可能にする
#
# 【よくあるエラーと解決方法】
#
# 1. Witnessリージョンの不一致
#    エラー: "Witness region mismatch between clusters"
#    解決方法: 両方のクラスターで同じwitness_regionを使用
#
# 2. クラスターが見つからない
#    エラー: "Cluster not found or not accessible"
#    解決方法:
#      - identifierが正しいクラスター識別子であることを確認
#      - clustersに指定したARNが正しいことを確認
#      - IAM権限が適切に設定されていることを確認
#
# 3. 削除保護エラー
#    エラー: "Cannot delete peering: deletion protection is enabled"
#    解決方法:
#      1. まず削除保護を無効化
#      2. terraform applyを実行
#      3. ピアリングを削除
#      4. クラスターを削除
#
# 4. 双方向ピアリングの不整合
#    症状: 片方のリージョンでのみピアリングが設定されている
#    解決方法: 両方のリージョンでピアリング設定を作成する必要があります
#
# 【デバッグ方法】
#
# 1. クラスター情報の確認
#    aws dsql get-cluster \
#      --identifier <cluster-identifier> \
#      --region us-east-1
#
# 2. Multi-Regionプロパティの確認
#    aws dsql get-cluster \
#      --identifier <cluster-identifier> \
#      --region us-east-1 \
#      --query 'multiRegionProperties'
#
# 3. Terraformステート確認
#    terraform state show aws_dsql_cluster_peering.primary_to_secondary
#    terraform state list | grep aws_dsql
#
# 4. 接続テスト
#    psql -h <primary-endpoint> -U <username> -d postgres
#    psql -h <secondary-endpoint> -U <username> -d postgres
#
# 【関連リソース】
#   - aws_dsql_cluster: Aurora DSQLクラスター本体
#   - aws_vpc_endpoint: PrivateLink経由での接続に使用
#   - aws_security_group: VPCエンドポイントのセキュリティ設定
#
# 【参考資料】
#   - Terraform AWS Provider - aws_dsql_cluster_peering:
#     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dsql_cluster_peering
#   - Amazon Aurora DSQL - Multi-Region Clusters:
#     https://docs.aws.amazon.com/aurora-dsql/latest/userguide/multi-region-aws-cli.html
#   - Multi-Region Endpoint Routing for Aurora DSQL:
#     https://aws.amazon.com/blogs/database/implement-multi-region-endpoint-routing-for-amazon-aurora-dsql/
#   - Aurora DSQL General Availability:
#     https://aws.amazon.com/blogs/aws/amazon-aurora-dsql-is-now-generally-available/
#---------------------------------------------------------------
