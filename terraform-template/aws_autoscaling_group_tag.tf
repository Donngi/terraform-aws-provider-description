#---------------------------------------------------------------
# AWS Auto Scaling Group Tag
#---------------------------------------------------------------
#
# Auto Scalingグループ（ASG）に個別のタグを管理するリソースです。
# このリソースは、Terraform外で作成されたASG（例：EKS Node Groupsによって
# 暗黙的に作成されたASG）にタグを追加する場合にのみ使用してください。
#
# 注意: aws_autoscaling_groupリソースと同じASGに対してこのリソースを使用しないでください。
#       両方を使用すると、タグの追加・削除が繰り返される永続的な差分が発生します。
#
# AWS公式ドキュメント:
#   - Auto Scaling グループ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-groups.html
#   - ASGタグ付け: https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-tagging.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group_tag
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_autoscaling_group_tag" "example" {
  #-------------------------------------------------------------
  # ASG設定
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: タグを適用するAuto Scalingグループの名前を指定します。
  # 設定可能な値: 有効なASG名の文字列
  # 用途: EKS Node Groupsなど、Terraform外で作成されたASGにタグを追加する際に使用
  autoscaling_group_name = "my-eks-node-group-asg"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tag (Required)
  # 設定内容: ASGに作成するタグを指定します。
  # 必須ブロック: 必ず1つのtagブロックを指定する必要があります。
  # 注意: 1つのリソースで1つのタグのみ管理可能。複数のタグには複数のリソースを使用。
  tag {
    # key (Required)
    # 設定内容: タグのキー（名前）を指定します。
    # 設定可能な値: 文字列（128文字以内）
    key = "k8s.io/cluster-autoscaler/node-template/label/eks.amazonaws.com/capacityType"

    # value (Required)
    # 設定内容: タグの値を指定します。
    # 設定可能な値: 文字列（256文字以内）
    value = "SPOT"

    # propagate_at_launch (Required)
    # 設定内容: ASGから起動されるインスタンスにタグを伝播するかを指定します。
    # 設定可能な値:
    #   - true: ASGから起動されるEC2インスタンスにもこのタグを適用
    #   - false: ASGリソース自体にのみタグを適用、インスタンスには伝播しない
    # 用途: Cluster Autoscalerのラベル情報など、ASGレベルでのみ必要なタグはfalse
    propagate_at_launch = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ASG名とキーをカンマ（`,`）で区切った文字列
#       例: "my-asg,my-tag-key"
#---------------------------------------------------------------

#---------------------------------------------------------------
# resource "aws_eks_node_group" "example" {
#   cluster_name    = "example"
#   node_group_name = "example"
#   # ... other configuration ...
# }
#
# resource "aws_autoscaling_group_tag" "example" {
#   for_each = toset(
#     [for asg in flatten(
#       [for resources in aws_eks_node_group.example.resources : resources.autoscaling_groups]
#     ) : asg.name]
#   )
#
#   autoscaling_group_name = each.value
#
#---------------------------------------------------------------
