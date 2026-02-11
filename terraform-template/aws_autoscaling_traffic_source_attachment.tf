#---------------------------------------------------------------
# AWS Auto Scaling Traffic Source Attachment
#---------------------------------------------------------------
#
# Auto Scalingグループにトラフィックソースをアタッチするリソースです。
# Load Balancer（ALB/NLB/GLB）やVPC Latticeターゲットグループを
# Auto Scalingグループに関連付けることができます。
#
# 重要: Auto Scalingグループ、Attachment、Traffic Source Attachmentについて
# Terraformは以下の独立したリソースを提供しています:
#   - aws_autoscaling_attachment: Classic Load BalancerとALB/GLB/NLBターゲットグループのアタッチ用
#   - aws_autoscaling_traffic_source_attachment: Load BalancerとVPC Latticeターゲットグループのアタッチ用
#   - aws_autoscaling_group: load_balancers, target_group_arns, traffic_source属性を持つ
# 同じトラフィックソースを複数のリソースで使用しないでください。
# 競合が発生する可能性があります。
#
# AWS公式ドキュメント:
#   - Auto Scalingグループへのロードバランサーのアタッチ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
#   - VPC Latticeターゲットグループへのアタッチ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-vpc-lattice.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_traffic_source_attachment
#
# Provider Version: 6.28.0
# Generated: 2025-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_traffic_source_attachment" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: トラフィックソースをアタッチするAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名またはaws_autoscaling_groupリソースのID/name
  autoscaling_group_name = aws_autoscaling_group.example.id

  #-------------------------------------------------------------
  # トラフィックソース設定
  #-------------------------------------------------------------

  # traffic_source (Required)
  # 設定内容: Auto Scalingグループにアタッチするトラフィックソースを定義します。
  # 関連機能: Auto Scalingグループのトラフィックソース
  #   EC2 Auto Scalingでは、ロードバランサーまたはVPC Latticeターゲットグループを
  #   トラフィックソースとしてアタッチできます。
  #   - https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
  traffic_source {
    # identifier (Required)
    # 設定内容: トラフィックソースの識別子を指定します。
    # 設定可能な値:
    #   - ELBv2ターゲットグループの場合: ターゲットグループのARN
    #   - VPC Latticeターゲットグループの場合: ターゲットグループのARN
    identifier = aws_lb_target_group.example.arn

    # type (Required)
    # 設定内容: トラフィックソースのタイプを指定します。
    # 設定可能な値:
    #   - "elbv2": Application Load Balancer、Network Load Balancer、
    #              Gateway Load Balancerのターゲットグループ
    #   - "vpc-lattice": VPC Latticeターゲットグループ
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
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = "30m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Auto Scalingグループ名とトラフィックソース識別子を組み合わせた一意のID
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: VPC Latticeターゲットグループへのアタッチ
#---------------------------------------------------------------
# resource "aws_autoscaling_traffic_source_attachment" "vpc_lattice_example" {
#   autoscaling_group_name = aws_autoscaling_group.example.id
#
#   traffic_source {
#     identifier = aws_vpclattice_target_group.example.arn
#     type       = "vpc-lattice"
#   }
# }
#---------------------------------------------------------------
