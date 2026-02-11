#---------------------------------------------------------------
# AWS ALB Target Group Attachment
#---------------------------------------------------------------
#
# Application Load Balancer（ALB）またはNetwork Load Balancer（NLB）の
# ターゲットグループにインスタンス、コンテナ、Lambda関数などを
# 登録するリソースです。
#
# NOTE: aws_alb_target_group_attachment は aws_lb_target_group_attachment の
#       エイリアスです。機能は同一です。
#
# AWS公式ドキュメント:
#   - ELBターゲットグループ: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
#   - ターゲットの登録: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_alb_target_group_attachment" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # target_group_arn (Required)
  # 設定内容: ターゲットを登録するターゲットグループのARNを指定します。
  # 設定可能な値: 有効なALB/NLBターゲットグループのARN
  target_group_arn = aws_lb_target_group.example.arn

  # target_id (Required)
  # 設定内容: 登録するターゲットのIDを指定します。
  # 設定可能な値: ターゲットグループのtarget_typeに応じて異なります
  #   - instance: EC2インスタンスID（例: i-0123456789abcdef0）
  #   - ip: IPアドレス（プライベートIPv4またはIPv6）
  #   - lambda: Lambda関数のARN
  #   - alb: ALBのARN（NLBのターゲットとして使用する場合）
  # 注意: target_typeがlambdaの場合、Lambda側で
  #       aws_lambda_permissionによるELBからの呼び出し許可が必要です。
  target_id = aws_instance.example.id

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # port (Optional)
  # 設定内容: ターゲットがトラフィックを受信するポート番号を指定します。
  # 設定可能な値: 1-65535の整数
  # 省略時: ターゲットグループに設定されたデフォルトポートを使用
  # 注意: target_typeがlambdaの場合は指定不要（指定しても無視されます）
  port = 80

  # availability_zone (Optional)
  # 設定内容: IPターゲットのアベイラビリティゾーンを指定します。
  # 設定可能な値:
  #   - 有効なアベイラビリティゾーン名（例: ap-northeast-1a）
  #   - "all": VPCスコープ外のプライベートIPアドレスを登録する場合に指定
  # 省略時: target_typeがipの場合、AWSが自動的に判定
  # 注意: target_typeがinstanceまたはlambdaの場合は指定不要
  # 関連機能: クロスゾーン登録
  #   VPC外のIPアドレス（オンプレミス等）をターゲットとして登録可能。
  #   その場合は"all"を指定します。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html
  availability_zone = null

  # quic_server_id (Optional, Forces replacement)
  # 設定内容: QUICプロトコル用のサーバーIDを指定します。
  # 設定可能な値: 0xプレフィックスに続く16桁の16進数文字列
  #   例: "0x1a2b3c4d5e6f7a8b"
  # 省略時: null（QUICプロトコルを使用しない場合）
  # 注意:
  #   - aws_lb_target_groupのprotocolがQUICまたはTCP_QUICの場合に必須
  #   - リスナーレベルで一意である必要があります
  #   - 変更時はリソースの再作成が発生します
  #   - 他のプロトコルでは無効（指定するとエラー）
  # 関連機能: QUIC (Quick UDP Internet Connections)
  #   HTTP/3の基盤となるプロトコル。低レイテンシと接続の高速化を実現。
  #   - https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html
  quic_server_id = null

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# resource "aws_lambda_permission" "allow_lb" {
#   statement_id  = "AllowExecutionFromLB"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.example.function_name
#   principal     = "elasticloadbalancing.amazonaws.com"
#   source_arn    = aws_lb_target_group.lambda_tg.arn
# }
#
# resource "aws_lb_target_group" "lambda_tg" {
#   name        = "lambda-target-group"
#   target_type = "lambda"
# }
#
# resource "aws_alb_target_group_attachment" "lambda" {
#   target_group_arn = aws_lb_target_group.lambda_tg.arn
#   target_id        = aws_lambda_function.example.arn
#   depends_on       = [aws_lambda_permission.allow_lb]
# }

#---------------------------------------------------------------
# resource "aws_lb_target_group" "quic_tg" {
#   name     = "quic-target-group"
#   port     = 443
#   protocol = "QUIC"
#   vpc_id   = aws_vpc.example.id
# }
#
# resource "aws_alb_target_group_attachment" "quic" {
#   target_group_arn = aws_lb_target_group.quic_tg.arn
#   target_id        = aws_instance.example.id
#   port             = 443
#   quic_server_id   = "0x1a2b3c4d5e6f7a8b"
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: アタッチメントの一意識別子
#---------------------------------------------------------------
