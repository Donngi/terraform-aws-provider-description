#---------------------------------------------------------------
# AWS Auto Scaling Traffic Source Attachment
#---------------------------------------------------------------
#
# Auto Scalingグループにトラフィックソース（ロードバランサーやVPC Latticeターゲットグループ）
# をアタッチするリソースです。
#
# 注意事項:
#   aws_autoscaling_attachment、aws_autoscaling_traffic_source_attachment、
#   aws_autoscaling_group の load_balancers/target_group_arns/traffic_source 属性を
#   同時に使用しないでください。同じトラフィックソースを複数のリソースで定義すると、
#   アタッチメントの競合が発生します。
#
# AWS公式ドキュメント:
#   - Auto Scaling グループとトラフィックソース: https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
#   - VPC Lattice統合: https://docs.aws.amazon.com/vpc-lattice/latest/ug/target-groups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_traffic_source_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_traffic_source_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: トラフィックソースをアタッチするAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  autoscaling_group_name = "example-asg"

  #-------------------------------------------------------------
  # トラフィックソース設定
  #-------------------------------------------------------------

  # traffic_source (Required)
  # 設定内容: Auto Scalingグループにアタッチするトラフィックソースを定義します。
  # 設定可能な値: トラフィックソースの識別子とタイプを含むブロック
  # 注意: 最大1つのtraffic_sourceブロックのみ指定可能です。
  traffic_source {
    # identifier (Required)
    # 設定内容: トラフィックソースの識別子（ARNなど）を指定します。
    # 設定可能な値:
    #   - ELBv2の場合: ターゲットグループのARN
    #     (例: arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example/abc123)
    #   - VPC Latticeの場合: ターゲットグループのARN
    #     (例: arn:aws:vpc-lattice:ap-northeast-1:123456789012:targetgroup/tg-abc123)
    identifier = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/example/abc123"

    # type (Required)
    # 設定内容: トラフィックソースのタイプを指定します。
    # 設定可能な値:
    #   - "elbv2": Elastic Load Balancing v2（ALB、NLB、GWLB）のターゲットグループ
    #   - "vpc-lattice": VPC Latticeのターゲットグループ
    type = "elbv2"
  }

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アタッチメントの識別子
#       （autoscaling_group_name とトラフィックソース識別子の組み合わせ）
#---------------------------------------------------------------

#---------------------------------------------------------------
# Timeouts設定
#---------------------------------------------------------------
# 以下のタイムアウト設定が可能です:
#
# timeouts {
#   create = "10m"  # 作成のタイムアウト（デフォルト: 10分）
#   delete = "10m"  # 削除のタイムアウト（デフォルト: 10分）
# }
#---------------------------------------------------------------
