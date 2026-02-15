#---------------------------------------
# AWS リソース: aws_ec2_network_insights_analysis
#---------------------------------------
# VPC Reachability Analyzerの分析を実行し、ネットワークパスの到達可能性を検証します。
# Network Insights Pathに対して実行され、送信元から宛先へのネットワーク経路を分析します。
# 分析結果には、経路上のコンポーネント、セキュリティグループルール、ACL、ルーティング情報が含まれます。
#
# 主な用途:
# - VPC内のリソース間の接続性トラブルシューティング
# - ネットワーク構成の検証と可視化
# - セキュリティ設定の影響分析
# - マルチアカウント環境での接続性確認
#
# 料金: 分析実行ごとに課金されます（$0.10/分析）
#
# 公式ドキュメント:
# https://docs.aws.amazon.com/vpc/latest/reachability/
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_network_insights_analysis
#
# Provider Version: 6.28.0
# Generated: 2026-02-15
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#---------------------------------------

resource "aws_ec2_network_insights_analysis" "example" {
  #---------------------------------------
  # 必須パラメータ
  #---------------------------------------

  # 分析対象のNetwork Insights PathのID
  # 設定内容: 既存のaws_ec2_network_insights_pathリソースのIDを指定
  # 注意: 分析はこのパスに定義された送信元、宛先、プロトコル、ポートに基づいて実行されます
  network_insights_path_id = "nip-0123456789abcdef0"

  #---------------------------------------
  # オプションパラメータ - 分析設定
  #---------------------------------------

  # 分析時にフィルタリングするAWSリソースのARNセット
  # 設定内容: 分析対象に含めるリソースのARNリスト（セキュリティグループ、ロードバランサーなど）
  # 用途: 特定のコンポーネントに焦点を当てた分析を実行
  # 省略時: すべてのコンポーネントが分析対象となります
  filter_in_arns = null
  # 例:
  # filter_in_arns = [
  #   "arn:aws:ec2:ap-northeast-1:123456789012:security-group/sg-0123456789abcdef0",
  #   "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/my-alb/50dc6c495c0c9188"
  # ]

  # 分析完了まで待機するかどうか
  # 設定内容: trueの場合、分析完了までTerraformが待機します
  # 用途: 分析結果を即座に参照する必要がある場合に使用
  # 省略時: false（分析は非同期で実行され、即座にリソースが作成されます）
  # 注意: 分析には数分かかる場合があります
  wait_for_completion = null

  #---------------------------------------
  # オプションパラメータ - リージョン設定
  #---------------------------------------

  # 分析を実行するAWSリージョン
  # 設定内容: リージョンコード（例: ap-northeast-1）
  # 省略時: プロバイダーのデフォルトリージョンが使用されます
  # 注意: Network Insights Pathと同じリージョンである必要があります
  region = null

  #---------------------------------------
  # タグ設定
  #---------------------------------------

  # リソースタグ
  # 設定内容: 分析リソースに付与するタグのキーバリューペア
  # 用途: コスト配分、リソース管理、検索の容易化
  tags = {
    Name        = "vpc-reachability-analysis"
    Environment = "production"
    Purpose     = "network-troubleshooting"
    ManagedBy   = "terraform"
  }
}

#---------------------------------------
# Attributes Reference（参照可能な属性）
#---------------------------------------
# この分析リソースから参照可能な主要な属性:
#
# id - 分析ID（例: nia-0123456789abcdef0）
# arn - 分析のARN
# path_found - 送信元から宛先への経路が見つかったかどうか（true/false）
# status - 分析のステータス（running/succeeded/failed）
# status_message - ステータスに関する詳細メッセージ
# start_date - 分析開始日時（RFC3339形式）
# warning_message - 分析に関する警告メッセージ
# forward_path_components - 順方向経路のコンポーネントリスト（詳細な経路情報）
# return_path_components - 戻り経路のコンポーネントリスト（双方向通信の場合）
# explanations - 経路が見つからなかった場合の詳細な説明リスト
# alternate_path_hints - 代替経路のヒント（利用可能な場合）
#
# 出力例:
# output "analysis_result" {
#   value = {
#     path_found = aws_ec2_network_insights_analysis.example.path_found
#     status     = aws_ec2_network_insights_analysis.example.status
#   }
# }
