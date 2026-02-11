#---------------------------------------------------------------
# EC2 Image Block Public Access
#---------------------------------------------------------------
#
# EC2のAMI（Amazon Machine Image）に対するパブリックアクセスのブロック設定を
# 管理するリソースです。リージョン単位でAMIの公開を制御し、意図しない
# AMIの公開を防止します。
#
# AWS公式ドキュメント:
#   - EC2 AMI概要: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html
#   - AMI公開の管理: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-intro.html
#   - Block public access to AMIs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-intro.html#block-public-access-to-amis
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_image_block_public_access
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_image_block_public_access" "example" {
  #---------------------------------------------------------------
  # Required Arguments
  #---------------------------------------------------------------

  # state (Required)
  # 設定内容: AMIのパブリックアクセスをブロックする状態を指定します。
  # 設定可能な値:
  #   - "block-new-sharing": 新規のAMI公開をブロック。既存の公開AMIは影響を受けません。
  #   - "unblocked": ブロックを解除し、AMIの公開を許可します。
  # 関連機能: EC2 Image Block Public Access
  #   リージョン単位でAMIのパブリックアクセスを制御する機能。
  #   意図しないAMIの公開によるセキュリティリスクを軽減します。
  #   block-new-sharingを設定すると、新たにAMIをパブリックに共有することが
  #   できなくなりますが、既に公開されているAMIには影響しません。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-intro.html#block-public-access-to-amis
  state = "block-new-sharing"

  #---------------------------------------------------------------
  # Optional Arguments
  #---------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの識別子を指定します。
  # 省略時: Terraformが自動的に生成します。
  # 注意: 通常は省略し、Terraformに管理を任せることを推奨します。
  id = null

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # 注意: この設定はリージョン単位で適用されます。
  region = null

  #---------------------------------------------------------------
  # Timeouts
  #---------------------------------------------------------------

  timeouts {
    # update (Optional)
    # 設定内容: リソースの更新操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    update = null
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# このリソースには明示的な読み取り専用属性（computed onlyの属性）は
# 定義されていません。idとregionは省略可能かつcomputed属性として動作します。
#---------------------------------------------------------------
