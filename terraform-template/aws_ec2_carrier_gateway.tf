#---------------------------------------------------------------
# EC2 Carrier Gateway
#---------------------------------------------------------------
#
# EC2 Carrier Gatewayは、Wavelength Zones内のリソースがキャリアネットワーク
# およびインターネットと通信できるようにするためのゲートウェイです。
# Wavelength ZonesはAWSとキャリアネットワークの間に配置され、
# モバイルエッジコンピューティングアプリケーションに超低レイテンシを提供します。
#
# AWS公式ドキュメント:
#   - Carrier Gateway: https://docs.aws.amazon.com/wavelength/latest/developerguide/how-wavelengths-work.html
#   - Wavelength Zones: https://docs.aws.amazon.com/wavelength/latest/developerguide/what-is-wavelength.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ec2_carrier_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_carrier_gateway" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # VPC ID
  # Carrier Gatewayをアタッチする対象のVPC ID。
  # Wavelength Zonesで使用するVPCを指定します。
  # Type: string
  # Required: Yes
  vpc_id = "vpc-0123456789abcdef0"


  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # Region
  # このリソースを管理するAWSリージョン。
  # 指定しない場合、プロバイダー設定のリージョンがデフォルトで使用されます。
  # Wavelength Zonesを利用する場合は、親リージョンを指定します。
  # Type: string
  # Default: Provider configuration
  # region = "us-east-1"

  # Tags
  # Carrier Gatewayに付与するタグのマップ。
  # リソースの識別や管理に使用します。
  # Type: map(string)
  # Default: {}
  # tags = {
  #   Name        = "example-carrier-gateway"
  #   Environment = "production"
  #   ManagedBy   = "terraform"
  # }

  # Tags All
  # プロバイダーのdefault_tagsとリソース固有のtagsをマージした全タグ。
  # 通常は明示的に設定する必要はなく、Terraformが自動で管理します。
  # Type: map(string)
  # Computed: Yes
  # tags_all = {}
}


#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能です（computed-only）:
#
# - arn (string)
#   Carrier GatewayのAmazon Resource Name (ARN)
#   例: arn:aws:ec2:us-east-1:123456789012:carrier-gateway/cagw-0123456789abcdef0
#
# - id (string)
#   Carrier GatewayのID
#   例: cagw-0123456789abcdef0
#
# - owner_id (string)
#   Carrier Gatewayを所有するAWSアカウントのID
#   例: 123456789012
#
#---------------------------------------------------------------
