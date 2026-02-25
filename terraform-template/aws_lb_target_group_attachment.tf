#---------------------------------------------------------------
# AWS LB Target Group Attachment
#---------------------------------------------------------------
#
# Application Load Balancer（ALB）/ Network Load Balancer（NLB）の
# ターゲットグループにターゲットを登録するリソースです。
# ターゲットとしては EC2インスタンス、IPアドレス、Lambda関数、
# 他のALB/NLBなどを指定できます。
#
# 主なユースケース:
#   - EC2インスタンスをALB/NLBターゲットグループに登録
#   - コンテナ（ECS）の個別IPアドレスをターゲット登録
#   - Lambda関数をALBターゲットとして登録
#   - 別リージョン・別VPCのリソースをクロスゾーンで登録
#   - QUICプロトコル対応のターゲット登録
#
# 重要な注意事項:
#   - aws_lb_target_group リソースと組み合わせて使用します
#   - ターゲットグループのターゲットタイプ（instance / ip / lambda / alb）に
#     合わせて target_id の値を変える必要があります
#   - 同一ターゲットグループへの複数ターゲット登録は、このリソースを複数定義します
#   - aws_alb_target_group_attachment は本リソースのエイリアスです
#
# AWS公式ドキュメント:
#   - ターゲットグループ概要: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
#   - ターゲット登録: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lb_target_group_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lb_target_group_attachment" "example" {
  #---------------------------------------------------------------
  # ターゲットグループ・ターゲット設定（必須）
  #---------------------------------------------------------------

  # target_group_arn (Required)
  # 設定内容: ターゲットを登録するターゲットグループのARNを指定します。
  # 設定可能な値: ターゲットグループのARN文字列
  # 参考: aws_lb_target_group リソースの arn 属性を参照
  target_group_arn = aws_lb_target_group.example.arn

  # target_id (Required)
  # 設定内容: 登録するターゲットのIDを指定します。ターゲットタイプにより指定する値が異なります。
  # 設定可能な値:
  #   - instance タイプ: EC2インスタンスID（例: "i-0123456789abcdef0"）
  #   - ip タイプ: IPアドレス（例: "10.0.1.100"）。VPC CIDR外のIPも指定可能
  #   - lambda タイプ: Lambda関数のARN（例: "arn:aws:lambda:us-east-1:123456789012:function:my-func"）
  #   - alb タイプ: ALBのARN（NLBのターゲットとして別のALBを使用する場合）
  target_id = aws_instance.example.id

  #---------------------------------------------------------------
  # ポート・アベイラビリティゾーン設定
  #---------------------------------------------------------------

  # port (Optional)
  # 設定内容: ターゲットがトラフィックを受け取るポート番号を指定します。
  # 設定可能な値: 1〜65535 の整数
  # 省略時: ターゲットグループのデフォルトポートが使用されます
  #
  # 注意:
  #   - lambda タイプのターゲットグループでは使用できません
  #   - ターゲットグループのデフォルトポートと異なるポートでトラフィックを受け取りたい場合に指定します
  port = 80

  # availability_zone (Optional)
  # 設定内容: ターゲットのアベイラビリティゾーンを指定します。
  # 設定可能な値:
  #   - AZコード（例: "us-east-1a"）: 指定したAZのターゲットとして登録
  #   - "all": すべてのAZにトラフィックをルーティング（クロスゾーン負荷分散）
  # 省略時: ターゲットグループのデフォルト設定に従います
  #
  # 注意:
  #   - "all" を指定すると、ターゲットはVPC外（別リージョンや外部IPなど）でも有効になります
  #   - ip タイプのターゲットグループでVPC外のIPを登録する場合は "all" が必要です
  availability_zone = null

  # quic_server_id (Optional)
  # 設定内容: QUICプロトコル使用時のサーバーIDを指定します。
  # 設定可能な値: QUIC対応ロードバランサーで使用するサーバーID文字列
  # 省略時: QUICサーバーID未設定
  #
  # 注意: QUICプロトコル対応のターゲットグループでのみ使用します
  quic_server_id = null

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: AWSリージョンコード（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定のリージョンが使用されます
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id
#     ターゲットグループARN、ターゲットID、ポートを組み合わせた一意の識別子
#
