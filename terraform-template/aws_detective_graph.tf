#---------------------------------------------------------------
# AWS Detective Graph
#---------------------------------------------------------------
#
# Amazon Detectiveのグラフをプロビジョニングするリソースです。
# Amazon Detectiveは、セキュリティ調査サービスで、AWS CloudTrail、
# Amazon VPC Flow Logs、Amazon GuardDuty、Amazon EKS監査ログなどの
# データを自動的に収集・分析し、機械学習やグラフ理論を使用して
# セキュリティ問題の根本原因を特定するのに役立ちます。
#
# 重要: 1つのAWSアカウントは、各リージョンにつき1つのDetectiveグラフのみ
#       所有できます。複数のグラフをプロビジョニングするには、
#       それぞれ異なるプロバイダー設定が必要です。
#
# AWS公式ドキュメント:
#   - Amazon Detective概要: https://docs.aws.amazon.com/detective/latest/userguide/what-is-detective.html
#   - CreateGraph API: https://docs.aws.amazon.com/detective/latest/APIReference/API_CreateGraph.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/detective_graph
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_detective_graph" "example" {
  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-detective-graph"
    Environment = "production"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Detectiveグラフの識別子（graph_arnと同じ値）
#
# - graph_arn: DetectiveグラフのAmazon Resource Name (ARN)
#
# - created_time: DetectiveグラフがUTCで作成された日時
#                 （拡張RFC 3339形式）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
