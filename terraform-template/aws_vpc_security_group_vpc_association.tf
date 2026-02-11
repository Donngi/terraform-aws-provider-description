#---------------------------------------------------------------
# AWS VPC Security Group VPC Association
#---------------------------------------------------------------
#
# セキュリティグループを別のVPCに関連付けるリソースです。
# これにより、1つのセキュリティグループを複数のVPCで共有して使用できます。
# VPC間でセキュリティグループを共有することで、ネットワーク設定の一貫性を
# 維持しながら、管理の複雑さを軽減できます。
#
# AWS公式ドキュメント:
#   - Security Group VPC Association API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroupVpcAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_vpc_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_security_group_vpc_association" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # security_group_id (Required)
  # 設定内容: 関連付けるセキュリティグループのIDを指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-xxxxxxxxxxxxxxxxx）
  # 注意: 指定するセキュリティグループは、関連付け先のVPCとは異なるVPCに
  #       属している必要があります。
  security_group_id = "sg-05f1f54ab49bb39a3"

  # vpc_id (Required)
  # 設定内容: セキュリティグループを関連付けるVPCのIDを指定します。
  # 設定可能な値: 有効なVPC ID（例: vpc-xxxxxxxxxxxxxxxxx）
  # 注意: security_group_idで指定したセキュリティグループが属するVPCとは
  #       異なるVPCを指定する必要があります。
  vpc_id = "vpc-01df9d105095412ba"

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
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・削除操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "5m", "2h45m"）
    #   - "s": 秒
    #   - "m": 分
    #   - "h": 時間
    # 省略時: デフォルトのタイムアウト値を使用
    # 注意: 削除操作のタイムアウト設定は、destroy操作の前に状態が保存される
    #       場合にのみ適用されます。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - state: VPC関連付けの状態。
#          可能な値についてはAWSドキュメントを参照:
#          https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroupVpcAssociation.html
#---------------------------------------------------------------
