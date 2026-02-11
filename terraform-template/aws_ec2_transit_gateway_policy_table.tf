#---------------------------------------------------------------
# EC2 Transit Gateway Policy Table
#---------------------------------------------------------------
#
# EC2 Transit Gateway Policy Table を管理するリソースです。
# Transit Gateway Policy Table は、Transit Gateway でのルーティングポリシーを管理するための
# テーブルで、トラフィックフローに対してきめ細かな制御を提供します。
#
# Policy Table を使用することで、特定の送信元から特定の宛先へのトラフィックを制御したり、
# セキュリティグループのようなポリシーベースのルーティングルールを適用できます。
# これにより、Transit Gateway を通過するトラフィックに対して、より高度なネットワークセグメンテーション
# とセキュリティ制御を実装できます。
#
# 主な特徴:
#   - ポリシーベースのルーティング制御
#   - きめ細かなトラフィック制御とセグメンテーション
#   - Transit Gateway アタッチメントとの関連付けによるポリシー適用
#   - マルチテナント環境でのネットワーク分離の強化
#
# AWS公式ドキュメント:
#   - Transit Gateway Policy Tables 概要: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-policy-tables.html
#   - Transit Gateway Policy Tables の作成: https://docs.aws.amazon.com/vpc/latest/tgw/tgw-policy-tables-create.html
#   - Transit Gateway ルーティング: https://docs.aws.amazon.com/vpc/latest/tgw/how-transit-gateways-work.html
#   - API リファレンス: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateTransitGatewayPolicyTable.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_transit_gateway_policy_table" "example" {
  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # transit_gateway_id (Required)
  # 設定内容: EC2 Transit Gateway の識別子を指定します。
  # 設定可能な値: Transit Gateway の ID (形式: tgw-xxxxxxxxxxxxxxxxx)
  # 用途: Policy Table を作成する対象の Transit Gateway を指定
  # 関連機能: Transit Gateway
  #   リージョナルなネットワーク中継ハブとして機能し、VPC、VPN、Direct Connect などを相互接続します。
  #   Policy Table はこの Transit Gateway に紐づけられ、トラフィックポリシーを管理します。
  #   1つの Transit Gateway に複数の Policy Table を作成できます。
  #   - https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html
  transit_gateway_id = "tgw-0123456789abcdef0"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # region (Optional, Computed)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWS リージョンコード (例: us-east-1, ap-northeast-1)
  # デフォルト値: プロバイダー設定で指定されたリージョン
  # 用途: マルチリージョン構成でリソースのリージョンを明示的に制御する場合に使用
  # 関連機能: AWS リージョナルエンドポイント
  #   Transit Gateway はリージョナルリソースです。Policy Table も同じリージョン内で管理されます。
  #   異なるリージョン間の接続には Transit Gateway ピアリングを使用します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#region
  # region = "ap-northeast-1"

  # tags (Optional)
  # 設定内容: EC2 Transit Gateway Policy Table に適用するキー・バリューペアのタグを指定します。
  # 設定可能な値: 任意の文字列のキー・バリューマップ
  # 用途: リソースの識別、分類、コスト配分、アクセス制御などに使用
  # 関連機能: AWS タグ
  #   リソースの管理、検索、フィルタリング、コスト配分に使用できます。
  #   プロバイダーレベルで default_tags を設定している場合、それらのタグと統合されます。
  #   - https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-tgw-policy-table"
    Environment = "production"
    ManagedBy   = "terraform"
    Purpose     = "traffic-segmentation"
  }
}

#---------------------------------------------------------------
# 出力値 (Computed Attributes)
#---------------------------------------------------------------
# 以下の属性は Terraform によって自動的に計算され、他のリソースで参照可能です:
#
# id (Computed)
#   説明: EC2 Transit Gateway Policy Table の識別子
#   形式: tgw-ptb-xxxxxxxxxxxxxxxxx
#   用途: 他のリソース (aws_ec2_transit_gateway_policy_table_association など) で参照
#   例: aws_ec2_transit_gateway_policy_table.example.id
#
# arn (Computed)
#   説明: EC2 Transit Gateway Policy Table の Amazon Resource Name (ARN)
#   形式: arn:aws:ec2:region:account-id:transit-gateway-policy-table/tgw-ptb-xxxxxxxxxxxxxxxxx
#   用途: IAM ポリシーでのリソース指定、CloudTrail ログの識別など
#   例: aws_ec2_transit_gateway_policy_table.example.arn
#   - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference-arns.html
#
# state (Computed)
#   説明: EC2 Transit Gateway Policy Table の状態
#   設定可能な値: "pending" | "available" | "deleting" | "deleted"
#   内容:
#     - pending: 作成中または変更中
#     - available: 使用可能な状態
#     - deleting: 削除中
#     - deleted: 削除済み
#   用途: リソースの現在の状態を確認、他のリソースの依存関係管理に使用
#   例: aws_ec2_transit_gateway_policy_table.example.state
#
# tags_all (Computed)
#   説明: リソースに割り当てられたすべてのタグのマップ
#   内容: 明示的に設定したタグとプロバイダーの default_tags から継承したタグを含む
#   用途: 実際に適用されているすべてのタグを確認、他のリソースで参照
#   例: aws_ec2_transit_gateway_policy_table.example.tags_all
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: Policy Table Association との組み合わせ
#---------------------------------------------------------------
#
# Policy Table を作成した後、Transit Gateway アタッチメントに関連付けて
# ポリシーを適用します:
#
# resource "aws_ec2_transit_gateway_policy_table_association" "example" {
#   transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_policy_table_id = aws_ec2_transit_gateway_policy_table.example.id
# }
#
# 詳細: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_policy_table_association
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティスと考慮事項
#---------------------------------------------------------------
#
# 1. Policy Table の設計:
#    - 環境ごと (本番、開発、ステージング) に個別の Policy Table を作成
#    - セキュリティレベルや用途に応じて Policy Table を分離
#    - 命名規則を統一し、タグで目的を明確にする
#
# 2. アタッチメントとの関連付け:
#    - Policy Table を作成するだけでは効果がありません
#    - Transit Gateway アタッチメントに関連付けることでポリシーが適用されます
#    - 1つのアタッチメントには1つの Policy Table のみ関連付け可能
#
# 3. ルーティングとの関係:
#    - Policy Table はルートテーブルと併用して使用します
#    - ルートテーブルが「どこに」トラフィックを送るかを決定
#    - Policy Table が「誰が」「どこへ」アクセスできるかを制御
#
# 4. セグメンテーション戦略:
#    - マイクロセグメンテーション: アプリケーションごとに細かくポリシーを設定
#    - マクロセグメンテーション: 部門やプロジェクトごとに大まかにポリシーを設定
#    - ハイブリッドアプローチ: 状況に応じて両方を組み合わせる
#
# 5. セキュリティ:
#    - Policy Table を使用してゼロトラストネットワークアーキテクチャを実装
#    - 最小権限の原則に従い、必要最小限のアクセスのみ許可
#    - 定期的にポリシールールをレビューし、不要なルールを削除
#
# 6. 高可用性:
#    - Policy Table はリージョナルリソースで、AWS によって高可用性が保証されます
#    - マルチリージョン構成の場合は、各リージョンで同様の Policy Table を作成
#
# 7. モニタリングとログ:
#    - VPC Flow Logs で Policy Table によって制御されたトラフィックを監視
#    - CloudWatch メトリクスで Transit Gateway のトラフィックパターンを分析
#    - CloudTrail で Policy Table の変更履歴を追跡
#    - https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-cloudwatch-metrics.html
#
# 8. コスト最適化:
#    - Policy Table 自体は追加料金が発生しません
#    - Transit Gateway の通常の料金 (アタッチメント料金とデータ処理料金) のみが適用されます
#    - 不要な Policy Table は削除してリソースを整理
#    - https://aws.amazon.com/transit-gateway/pricing/
#
# 9. 制限事項:
#    - Policy Table は Transit Gateway と同じリージョンに作成する必要があります
#    - Policy Table を削除する前に、すべてのアタッチメントとの関連付けを解除する必要があります
#    - AWS アカウントごとの Policy Table 数には制限があります (サービスクォータを確認)
#
# 10. トラブルシューティング:
#     - Policy Table の state が "available" であることを確認
#     - アタッチメントとの関連付けが正しく設定されているか確認
#     - ルートテーブルと Policy Table の両方が正しく設定されているか確認
#     - VPC Flow Logs で拒否されたトラフィックを分析
#
# 11. マイグレーション:
#     - 既存の Transit Gateway に Policy Table を追加する場合は、段階的に実施
#     - まずテスト環境で動作を確認してから本番環境に適用
#     - ロールバック計画を事前に準備
#
# 12. マルチアカウント環境:
#     - AWS Organizations と組み合わせて、組織全体のネットワークポリシーを統一
#     - Resource Access Manager (RAM) を使用して、Policy Table を他のアカウントと共有
#     - 各アカウントの責任範囲を明確にし、適切な権限を付与
#     - https://docs.aws.amazon.com/ram/latest/userguide/what-is.html
#
#---------------------------------------------------------------
