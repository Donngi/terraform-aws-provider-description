#---------------------------------------------------------------
# AWS ELB Attachment
#---------------------------------------------------------------
#
# Classic Elastic Load Balancer（ELB）にEC2インスタンスを
# アタッチするためのリソースです。
#
# NOTE: ELBインスタンスとELBアタッチメントについて
#   Terraformでは、ELB Attachmentリソース（インスタンスをELBにアタッチ）と
#   aws_elbリソース内でinstancesをインライン定義する方法の両方を提供しています。
#   ただし、インラインinstancesを持つELBとELB Attachmentリソースを
#   同時に使用することはできません。競合が発生し、アタッチメントが上書きされます。
#
# NOTE: ALB/NLBを使用する場合は aws_lb_target_group_attachment を使用してください。
#
# AWS公式ドキュメント:
#   - Classic Load Balancer: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/introduction.html
#   - インスタンスの登録/登録解除: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-deregister-register-instances.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-23
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_elb_attachment" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # elb (Required)
  # 設定内容: インスタンスをアタッチするClassic ELBの名前を指定します。
  # 設定可能な値: 有効なClassic ELBの名前
  elb = aws_elb.example.name

  # instance (Required)
  # 設定内容: ELBプールに配置するEC2インスタンスのIDを指定します。
  # 設定可能な値: 有効なEC2インスタンスID（例: i-0123456789abcdef0）
  # 注意: インスタンスはELBと同じVPC内に存在する必要があります。
  instance = aws_instance.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# resource "aws_elb" "example" {
#   name               = "example-elb"
#   availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
#
#   listener {
#     instance_port     = 80
#     instance_protocol = "HTTP"
#     lb_port           = 80
#     lb_protocol       = "HTTP"
#   }
#
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:80/"
#     interval            = 30
#   }
# }
#
# resource "aws_instance" "web" {
#   count         = 2
#   ami           = "ami-xxxxxxxxxxxxxxxxx"
#   instance_type = "t3.micro"
# }
#
# resource "aws_elb_attachment" "web" {
#   count    = 2
#   elb      = aws_elb.example.name
#   instance = aws_instance.web[count.index].id
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アタッチメントの一意識別子
#---------------------------------------------------------------
