################################################################################
# AWS EC2 Network Insights Analysis
################################################################################
# Network Insights Analysisリソースは、VPCの「Reachability Analyzer」サービスの
# 一部です。Network Insights Pathに基づいてネットワーク到達性分析を実行し、
# ソースから宛先への通信経路の問題を診断します。

resource "aws_ec2_network_insights_analysis" "this" {
  ##############################################################################
  # Required Parameters
  ##############################################################################

  # network_insights_path_id - (Required) 分析を実行するNetwork Insights PathのID
  #
  # タイプ: string
  # 説明: 分析対象のNetwork Insights Pathを指定します。このパスは事前に
  #       aws_ec2_network_insights_pathリソースで定義されている必要があります。
  #
  # 例:
  #   network_insights_path_id = aws_ec2_network_insights_path.path.id
  network_insights_path_id = null # Required - 分析対象のNetwork Insights Path ID

  ##############################################################################
  # Optional Parameters
  ##############################################################################

  # filter_in_arns - (Optional) パスが通過する必要があるリソースのARNのリスト
  #
  # タイプ: list(string)
  # デフォルト: null
  # 説明: 分析時に、通信経路が必ず通過すべきリソースのARNを指定します。
  #       これにより、特定のネットワークコンポーネントを経由する経路のみを
  #       分析対象とすることができます。
  #
  # 例:
  #   filter_in_arns = [
  #     "arn:aws:ec2:us-west-2:123456789012:network-interface/eni-1234567890abcdef0"
  #   ]
  # filter_in_arns = null

  # wait_for_completion - (Optional) 分析の完了を待機するかどうか
  #
  # タイプ: bool
  # デフォルト: true
  # 説明: trueの場合、リソースはNetwork Insights Analysisのステータスが
  #       'succeeded'または'failed'になるまで待機します。falseに設定すると、
  #       この待機プロセスをスキップします。
  #
  # 例:
  #   wait_for_completion = true
  # wait_for_completion = true

  # tags - (Optional) リソースに割り当てるタグのマップ
  #
  # タイプ: map(string)
  # デフォルト: {}
  # 説明: Network Insights Analysisに付与するタグを指定します。
  #       プロバイダーのdefault_tagsが設定されている場合、キーが一致する
  #       タグはプロバイダーレベルで定義されたものを上書きします。
  #
  # 例:
  #   tags = {
  #     Name        = "production-network-analysis"
  #     Environment = "production"
  #     Purpose     = "troubleshooting"
  #   }
  # tags = {}

  ##############################################################################
  # Computed Attributes (Read-Only)
  ##############################################################################
  # 以下の属性は自動的に計算され、参照のみ可能です:
  #
  # - id                      : Network Insights AnalysisのID
  # - arn                     : Network Insights AnalysisのARN
  # - path_found              : 宛先に到達可能な場合はtrueに設定される
  # - status                  : 分析のステータス ('succeeded'は分析完了を意味し、
  #                             パスが見つかったことを意味するわけではない)
  # - status_message          : statusが'failed'の場合に詳細なコンテキストを提供
  # - start_date              : 分析が開始された日時
  # - warning_message         : 警告メッセージ
  # - tags_all                : プロバイダーのdefault_tagsを含む、リソースに
  #                             割り当てられたすべてのタグのマップ
  # - forward_path_components : ソースから宛先への経路のコンポーネント
  #                             (詳細はAWS APIドキュメント参照)
  # - return_path_components  : 宛先からソースへの経路のコンポーネント
  #                             (詳細はAWS APIドキュメント参照)
  # - explanations            : 到達不可能な経路の説明コード
  #                             (詳細はAWS APIドキュメント参照)
  # - alternate_path_hints    : 実現可能な経路の潜在的な中間コンポーネント
  #                             以下のネストされた属性を含む:
  #   - component_arn         : コンポーネントのARN (string, computed)
  #   - component_id          : コンポーネントのID (string, computed)
  ##############################################################################
}

################################################################################
# 使用例
################################################################################

# Example 1: 基本的な使用例 - EC2インスタンス間の到達性分析
#
# resource "aws_ec2_network_insights_path" "example_path" {
#   source      = aws_network_interface.source.id
#   destination = aws_network_interface.destination.id
#   protocol    = "tcp"
#
#   tags = {
#     Name = "example-insights-path"
#   }
# }
#
# resource "aws_ec2_network_insights_analysis" "example" {
#   network_insights_path_id = aws_ec2_network_insights_path.example_path.id
#   wait_for_completion      = true
#
#   tags = {
#     Name        = "example-network-analysis"
#     Environment = "production"
#   }
# }
#
# output "analysis_path_found" {
#   description = "宛先に到達可能かどうか"
#   value       = aws_ec2_network_insights_analysis.example.path_found
# }
#
# output "analysis_status" {
#   description = "分析のステータス"
#   value       = aws_ec2_network_insights_analysis.example.status
# }

# Example 2: フィルタを使用した分析
#
# resource "aws_ec2_network_insights_analysis" "filtered" {
#   network_insights_path_id = aws_ec2_network_insights_path.path.id
#
#   # 特定のENIを経由する経路のみを分析
#   filter_in_arns = [
#     aws_network_interface.nat_gateway_eni.arn
#   ]
#
#   wait_for_completion = true
#
#   tags = {
#     Name    = "filtered-analysis"
#     Purpose = "NAT Gateway経由の通信検証"
#   }
# }

# Example 3: 非同期実行（完了を待たない）
#
# resource "aws_ec2_network_insights_analysis" "async" {
#   network_insights_path_id = aws_ec2_network_insights_path.path.id
#   wait_for_completion      = false
#
#   tags = {
#     Name = "async-analysis"
#   }
# }
#
# # 分析結果は後で確認可能
# output "async_analysis_id" {
#   value = aws_ec2_network_insights_analysis.async.id
# }

################################################################################
# ユースケースと推奨事項
################################################################################
# 1. トラブルシューティング
#    - VPC内の接続問題の診断に使用
#    - セキュリティグループ、NACLの設定確認
#    - ルーティング問題の特定
#
# 2. ネットワーク設計の検証
#    - 新しいネットワーク構成のテスト
#    - マルチAZ構成の到達性確認
#    - ハイブリッドクラウド接続の検証
#
# 3. コンプライアンスとセキュリティ
#    - 意図しない通信経路の検出
#    - ネットワーク分離の確認
#    - セグメンテーションの妥当性検証
#
# 4. 推奨事項
#    - wait_for_completion = trueを使用して、分析完了を確認
#    - path_found属性で到達性を確認し、falseの場合はexplanationsを確認
#    - 定期的な分析を自動化して、ネットワーク構成の変更を監視
#    - filter_in_arnsを使用して、特定の経路に焦点を当てた分析を実施
#
# 5. コスト最適化
#    - 分析には料金が発生するため、必要な場合のみ実行
#    - 同じパスに対する重複分析を避ける
#    - wait_for_completion = falseで非同期実行し、他の処理を継続
#
# 6. 制限事項
#    - Network Insights Pathが事前に作成されている必要がある
#    - 分析結果は一時的なスナップショットであり、ネットワーク構成の
#      変更後は再分析が必要
#    - 複雑なネットワーク構成では分析に時間がかかる場合がある
################################################################################

################################################################################
# 関連リソース
################################################################################
# - aws_ec2_network_insights_path : 分析対象のネットワークパスを定義
# - aws_network_interface         : 分析のソース/宛先として使用可能
# - aws_instance                  : インスタンスのENIを分析対象として使用可能
# - aws_vpc                       : VPC内の到達性分析に使用
################################################################################

################################################################################
# 参照
################################################################################
# AWS Provider Documentation:
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_network_insights_analysis
#
# AWS API Documentation:
#   https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_NetworkInsightsAnalysis.html
#
# AWS VPC Reachability Analyzer:
#   https://docs.aws.amazon.com/vpc/latest/reachability/what-is-reachability-analyzer.html
################################################################################
