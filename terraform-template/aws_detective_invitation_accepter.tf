#---------------------------------------------------------------
# AWS Detective Invitation Accepter
#---------------------------------------------------------------
#
# Amazon Detectiveの招待を承諾するためのリソースです。
# このリソースは、Detectiveグラフの管理者アカウントから送信された招待を
# メンバーアカウント側で承諾するために使用します。
#
# Amazon Detectiveは、セキュリティデータを分析・視覚化し、
# セキュリティ上の問題の根本原因を迅速に特定するためのサービスです。
# 複数のAWSアカウントからのデータを集約して分析できます。
#
# AWS公式ドキュメント:
#   - Amazon Detective概要: https://docs.aws.amazon.com/detective/latest/adminguide/what-is-detective.html
#   - メンバーアカウントの招待管理: https://docs.aws.amazon.com/detective/latest/adminguide/graph-admin-add-member-accounts.html
#   - AcceptInvitation API: https://docs.aws.amazon.com/detective/latest/APIReference/API_AcceptInvitation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/detective_invitation_accepter
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_detective_invitation_accepter" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # graph_arn (Required)
  # 設定内容: メンバーアカウントが招待を承諾するDetective動作グラフのARNを指定します。
  # 設定可能な値: 有効なDetectiveグラフのARN
  # 形式: arn:aws:detective:{region}:{account-id}:graph:{graph-id}
  # 注意: 管理者アカウントから招待されたグラフのARNを指定する必要があります
  # 参考: https://docs.aws.amazon.com/detective/latest/APIReference/API_AcceptInvitation.html
  graph_arn = "arn:aws:detective:ap-northeast-1:123456789012:graph/abcdef1234567890"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: Detective招待承諾のユニーク識別子（ID）
#
#---------------------------------------------------------------
