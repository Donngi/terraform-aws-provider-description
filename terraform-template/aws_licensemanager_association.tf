#---------------------------------------------------------------
# AWS License Manager Association
#---------------------------------------------------------------
#
# License Manager のライセンス設定をAWSリソース（EC2インスタンスやAMIなど）に
# 関連付けるリソースです。これにより、ライセンスの使用状況を追跡し、
# ライセンスコンプライアンスを維持できます。
#
# 注意: 起動テンプレート（aws_launch_template）のlicense_specificationsブロックを
# 使用してライセンス設定を関連付けることもできます。
#
# AWS公式ドキュメント:
#   - License Manager: https://docs.aws.amazon.com/license-manager/latest/userguide/license-manager.html
#   - ライセンス設定の関連付け: https://docs.aws.amazon.com/license-manager/latest/userguide/license-configurations.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/licensemanager_association
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_licensemanager_association" "example" {
  #-------------------------------------------------------------
  # ライセンス設定 (Required)
  #-------------------------------------------------------------

  # license_configuration_arn (Required)
  # 設定内容: 関連付けるライセンス設定のARNを指定します。
  # 設定可能な値: aws_licensemanager_license_configurationリソースのARN
  # 関連機能: License Manager License Configuration
  #   ライセンス設定は、ソフトウェアライセンスのルールと制限を定義します。
  #   これにはライセンスのカウント方法（インスタンス単位、vCPU単位など）や
  #   ライセンスの上限数などが含まれます。
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/license-configurations.html
  license_configuration_arn = aws_licensemanager_license_configuration.example.arn

  #-------------------------------------------------------------
  # リソース設定 (Required)
  #-------------------------------------------------------------

  # resource_arn (Required)
  # 設定内容: ライセンス設定に関連付けるAWSリソースのARNを指定します。
  # 設定可能な値: EC2インスタンス、AMI、ホストなどのAWSリソースARN
  # サポートされるリソース:
  #   - EC2インスタンス (aws_instance)
  #   - AMI (aws_ami)
  #   - RDS DBインスタンス
  #   - Dedicated Hosts
  # 用途: 指定したリソースのライセンス使用状況を追跡し、コンプライアンスを
  #       維持するために使用します。
  # 参考: https://docs.aws.amazon.com/license-manager/latest/userguide/license-configurations.html
  resource_arn = aws_instance.example.arn

  #-------------------------------------------------------------
  # リージョン設定 (Optional)
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースが管理されるリージョンを指定します。
  # 設定可能な値: AWSリージョン識別子（例: "us-east-1", "ap-northeast-1"）
  # 省略時: プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  # 用途: クロスリージョン管理を行う場合や、特定のリージョンでリソースを
  #       管理する必要がある場合に使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ライセンス設定のARN
#       ライセンス設定の一意の識別子として使用されます。
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、EC2インスタンスにライセンス設定を関連付ける基本的な例です:
#
# data "aws_ami" "example" {
#   most_recent = true
#   owners      = ["amazon"]
#
#   filter {
#     name   = "name"
#     values = ["amzn-ami-vpc-nat*"]
#   }
# }
#
# resource "aws_instance" "example" {
#   ami           = data.aws_ami.example.id
#   instance_type = "t2.micro"
#---------------------------------------------------------------
