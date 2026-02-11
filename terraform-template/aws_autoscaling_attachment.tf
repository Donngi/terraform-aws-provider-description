#---------------------------------------------------------------
# AWS Auto Scaling Attachment
#---------------------------------------------------------------
#
# Auto ScalingグループにElastic Load Balancer（Classic Load Balancer）
# またはLoad Balancerターゲットグループ（ALB/NLB/GLB）をアタッチする
# リソースです。
#
# このリソースを使用することで、Auto Scalingグループ内のインスタンスが
# 自動的にロードバランサーに登録され、トラフィックを受信できるようになります。
#
# AWS公式ドキュメント:
#   - Auto ScalingグループへのELBのアタッチ: https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
#   - AttachLoadBalancerTargetGroups API: https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_AttachLoadBalancerTargetGroups.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
resource "aws_autoscaling_attachment" "elb_example" {
  #-------------------------------------------------------------
  # Auto Scalingグループ設定（必須）
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: ELBまたはターゲットグループをアタッチするAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  # 注意: Auto Scalingグループが存在している必要があります。
  autoscaling_group_name = aws_autoscaling_group.example.id

  #-------------------------------------------------------------
  # Classic Load Balancer設定
  #-------------------------------------------------------------

  # elb (Optional)
  # 設定内容: アタッチするClassic Load Balancer（ELB）の名前を指定します。
  # 設定可能な値: 既存のClassic Load Balancerの名前
  # 注意: lb_target_group_arnと排他的（どちらか一方のみ指定）
  #       Classic Load Balancerを使用する場合はこちらを指定します。
  # 関連機能: Elastic Load Balancing Classic Load Balancer
  #   Classic Load Balancerは、EC2-Classicネットワーク用に構築されたロードバランサーです。
  #   新規構築ではALB/NLBの使用が推奨されています。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html
  elb = aws_elb.example.id

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
resource "aws_autoscaling_attachment" "alb_example" {
  #-------------------------------------------------------------
  # Auto Scalingグループ設定（必須）
  #-------------------------------------------------------------

  # autoscaling_group_name (Required)
  # 設定内容: ターゲットグループをアタッチするAuto Scalingグループの名前を指定します。
  # 設定可能な値: 既存のAuto Scalingグループ名
  autoscaling_group_name = aws_autoscaling_group.example.id

  #-------------------------------------------------------------
  # ターゲットグループ設定
  #-------------------------------------------------------------

  # lb_target_group_arn (Optional)
  # 設定内容: アタッチするロードバランサーターゲットグループのARNを指定します。
  # 設定可能な値: 既存のターゲットグループのARN
  # 対象ロードバランサー:
  #   - Application Load Balancer (ALB)
  #   - Network Load Balancer (NLB)
  #   - Gateway Load Balancer (GLB)
  # 注意: elbと排他的（どちらか一方のみ指定）
  # 関連機能: Elastic Load Balancing ターゲットグループ
  #   ターゲットグループは、ロードバランサーがトラフィックをルーティングする
  #   宛先（EC2インスタンス、IPアドレス、Lambda関数など）のグループです。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
  lb_target_group_arn = aws_lb_target_group.example.arn

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = null
}

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. 競合の回避:
#    Auto Scalingグループには、以下の方法でロードバランサーをアタッチできますが、
#    同じトラフィックソースを複数の方法で指定しないでください：
#    - aws_autoscaling_attachment リソース（本リソース）
#    - aws_autoscaling_traffic_source_attachment リソース
#    - aws_autoscaling_group リソースの load_balancers, target_group_arns, traffic_source 属性
#
#    競合が発生する場合は、lifecycle設定ブロックを使用して差分を抑制できます。
#
# 2. ELBヘルスチェック:
#    Auto Scalingグループのヘルスチェックタイプを "ELB" に設定することで、
#    ロードバランサーが報告するインスタンスの健全性に基づいて
#    インスタンスを置換できます。
#
# 3. 推奨事項:
#    新規構築では、Classic Load Balancer (elb) ではなく、
#    Application Load Balancer または Network Load Balancer (lb_target_group_arn)
#    の使用を推奨します。
#
#---------------------------------------------------------------
