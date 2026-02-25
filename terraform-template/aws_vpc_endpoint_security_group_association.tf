#---------------------------------------------------------------
# VPC Endpoint Security Group Association
#---------------------------------------------------------------
#
# VPCエンドポイントとセキュリティグループの関連付けをプロビジョニングするリソースです。
# Interface型VPCエンドポイントに対してセキュリティグループを関連付けることで、
# エンドポイントへのインバウンド/アウトバウンドトラフィックを制御します。
#
# AWS公式ドキュメント:
#   - Interface VPC Endpoints: https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html
#   - Security Groups for Interface Endpoints: https://docs.aws.amazon.com/vpc/latest/privatelink/interface-endpoints.html#vpce-security-groups
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_security_group_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_vpc_endpoint_security_group_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # vpc_endpoint_id (Required)
  # 設定内容: セキュリティグループと関連付けるVPCエンドポイントの識別子を指定します。
  # 設定可能な値: 有効なVPCエンドポイントID（例: vpce-12345678）
  # 注意: Interface型VPCエンドポイントに対して使用します。
  #       Gateway型VPCエンドポイント（S3、DynamoDBなど）にはセキュリティグループを
  #       関連付けることができません。
  vpc_endpoint_id = aws_vpc_endpoint.example.id

  # security_group_id (Required)
  # 設定内容: VPCエンドポイントに関連付けるセキュリティグループの識別子を指定します。
  # 設定可能な値: 有効なセキュリティグループID（例: sg-12345678）
  # 注意: セキュリティグループはVPCエンドポイントと同じVPCに属している必要があります。
  #       インバウンドルールでエンドポイントへのアクセスを制御し、
  #       アウトバウンドルールでエンドポイントからの応答を制御します。
  security_group_id = aws_security_group.example.id

  #-------------------------------------------------------------
  # デフォルト関連付け設定
  #-------------------------------------------------------------

  # replace_default_association (Optional)
  # 設定内容: VPCエンドポイントにデフォルトで関連付けられているセキュリティグループを
  #           このリソースで指定するセキュリティグループに置き換えるかどうかを指定します。
  # 設定可能な値: true / false
  # 省略時: false（デフォルトのセキュリティグループはそのまま保持されます）
  # 注意: true に設定すると、VPCのデフォルトセキュリティグループが削除され、
  #       指定したセキュリティグループのみが関連付けられます。
  replace_default_association = false

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
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: VPCエンドポイントIDとセキュリティグループIDを組み合わせた識別子。
#       この値は関連付けの一意の識別子として使用されます。
#---------------------------------------------------------------
