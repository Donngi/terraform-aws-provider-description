#---------------------------------------------------------------
# VPC Endpoint Security Group Association
#---------------------------------------------------------------
#
# VPCエンドポイントとセキュリティグループの関連付けを作成するリソースです。
# 単一のVPCエンドポイントと単一のセキュリティグループとの間の関連付けを
# スタンドアロンリソースとして管理します。
#
# 注意: Terraformは、VPC Endpoint Security Group Associationスタンドアロン
# リソース（VPCエンドポイントと単一のsecurity_group_id間の関連付け）と、
# security_group_ids属性を持つVPC Endpointリソースの両方を提供しています。
# 同じセキュリティグループIDをVPC EndpointリソースとVPC Endpoint Security
# Group Associationリソースの両方で使用しないでください。関連付けの競合が
# 発生し、関連付けが上書きされます。
#
# AWS公式ドキュメント:
#   - VPC endpoints security groups: https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-access.html#vpc-endpoint-security-groups
#   - Security group VPC association: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroupVpcAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/vpc_endpoint_security_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_security_group_association" "example" {

  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # vpc_endpoint_id (Required)
  # 設定内容: セキュリティグループを関連付けるVPCエンドポイントのID
  # 設定可能な値: VPCエンドポイントID（例: vpce-0123456789abcdef0）
  # 省略時: 設定必須
  # 関連機能: VPC Endpoints
  #   VPCエンドポイントの詳細 - https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html
  vpc_endpoint_id = "vpce-0123456789abcdef0"

  # security_group_id (Required)
  # 設定内容: VPCエンドポイントに関連付けるセキュリティグループのID
  # 設定可能な値: セキュリティグループID（例: sg-0123456789abcdef0）
  # 省略時: 設定必須
  # 注意: セキュリティグループはVPCエンドポイントと同じVPC内に存在する
  #      必要があります
  security_group_id = "sg-0123456789abcdef0"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # replace_default_association (Optional)
  # 設定内容: VPCエンドポイント作成時にセキュリティグループを指定しなかった
  #          場合に作成されるVPCのデフォルトセキュリティグループとの関連付けを
  #          この関連付けで置き換えるかどうか
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: VPCエンドポイントごとに最大1つの関連付けを
  #      replace_default_association = trueで設定してください
  #      リソースをインポートする場合はfalseを使用してください
  # replace_default_association = false

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1 など
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: AWS Regional Endpoints
  #   リージョナルエンドポイントの詳細 - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: 関連付けのID
#---------------------------------------------------------------
