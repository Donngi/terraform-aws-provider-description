#---------------------------------------------------------------
# Auto Scaling Attachment
#---------------------------------------------------------------
#
# Auto ScalingグループにロードバランサーまたはTarget Groupをアタッチするリソースです。
# Classic Load Balancer(ELB)、またはALB/NLB/GLBのTarget Groupをアタッチできます。
#
# VPC Latticeターゲットグループをアタッチする場合は、aws_autoscaling_traffic_source_attachment
# リソースを使用してください。
#
# 重要: 同一のトラフィックソースを複数のアタッチメントリソースで使用すると競合が発生します。
# Auto Scaling Group本体のload_balancers、target_group_arns、traffic_source属性との
# 併用は避けてください。競合を抑制する必要がある場合はlifecycleブロックを使用できます。
#
# AWS公式ドキュメント:
#   - Auto Scalingグループへのロードバランサーのアタッチ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
#   - AttachLoadBalancerTargetGroups API: https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_AttachLoadBalancerTargetGroups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: アタッチ先のAuto Scalingグループ名
  # 設定可能な値: 既存のAuto Scalingグループの名前
  autoscaling_group_name = "example-asg"

  #-------------------------------------------------------------
  # ロードバランサー設定
  #-------------------------------------------------------------
  # 注: elbとlb_target_group_arnは排他的です。いずれか一方のみを指定してください。

  # elb (Optional)
  # 設定内容: アタッチするClassic Load Balancer(ELB)の名前
  # 省略時: なし(Target Groupアタッチの場合は指定不要)
  # 補足: Classic Load Balancerをアタッチする場合に指定します
  # 注意: lb_target_group_arnと排他的
  elb = "example-elb"

  # lb_target_group_arn (Optional)
  # 設定内容: アタッチするロードバランサーTarget GroupのARN
  # 省略時: なし(ELBアタッチの場合は指定不要)
  # 補足: ALB/NLB/GLBのTarget Groupをアタッチする場合に指定します
  # 注意: elbと排他的
  lb_target_group_arn = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  # 補足: 明示的にリージョンを指定する場合に使用します
  region = "us-east-1"
}

#-------
# Attributes Reference
#-------
# このリソースは以下の属性をエクスポートする:
#
# id - アタッチメントID(形式: <autoscaling_group_name>/<elb or lb_target_group_arn>)
# region - リソースが管理されているAWSリージョン
