# ==============================================================================
# Terraform Resource Template: aws_ec2_serial_console_access
# ==============================================================================
# Generated: 2026-01-23
# Provider Version: hashicorp/aws v6.28.0
#
# NOTE: このテンプレートは生成時点の情報です。
#       最新の仕様については公式ドキュメントを確認してください。
#       https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_serial_console_access
#
# DESCRIPTION:
#   EC2 Serial Console へのアクセスを AWS アカウントレベルで管理するリソース。
#   シリアルコンソールはインスタンスのシリアルポートへのアクセスを提供し、
#   起動、ネットワーク設定、その他の問題のトラブルシューティングに使用できます。
#
# IMPORTANT:
#   - このリソースを削除すると、シリアルコンソールアクセスが無効になります
#   - デフォルトでは、シリアルコンソールアクセスは無効になっています
#   - アクセスはアカウントレベルで設定され、各 AWS リージョンで個別に設定する必要があります
#   - このリソースは組織レベルの SCP (Service Control Policy) と組み合わせて使用できます
#
# AWS OFFICIAL DOCUMENTATION:
#   - EC2 Serial Console overview: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-serial-console.html
#   - Configure access: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configure-access-to-serial-console.html
#   - API Reference (EnableSerialConsoleAccess): https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_EnableSerialConsoleAccess.html
# ==============================================================================

resource "aws_ec2_serial_console_access" "example" {
  # --------------------------------------------------------------------------
  # enabled - シリアルコンソールアクセスの有効/無効を設定
  # --------------------------------------------------------------------------
  # Type: bool
  # Required: No (Optional)
  # Default: true
  #
  # シリアルコンソールへのアクセスを有効にするかどうかを制御します。
  # 有効な値: true または false
  #
  # - true: アカウント内の EC2 インスタンスのシリアルコンソールへのアクセスを許可
  # - false: シリアルコンソールへのアクセスを拒否
  #
  # NOTE:
  #   - アクセスを有効にした後、IAM ポリシーでユーザーレベルのアクセス制御も必要です
  #   - リソースタグや instance ID を使用して、インスタンスレベルでアクセス制御可能
  #   - Linux インスタンスの場合、トラブルシューティングにはパスワードベースユーザーの設定が必要
  #
  # REFERENCE:
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configure-access-to-serial-console.html#serial-console-account-access
  # --------------------------------------------------------------------------
  enabled = true

  # --------------------------------------------------------------------------
  # id - Terraform リソース識別子
  # --------------------------------------------------------------------------
  # Type: string
  # Required: No (Optional)
  # Computed: Yes
  #
  # Terraform によって自動的に生成されるリソースの一意識別子。
  # 通常は明示的に設定する必要はなく、自動計算されます。
  #
  # NOTE:
  #   - この属性は主に Terraform の状態管理に使用されます
  #   - 明示的に設定することもできますが、通常は省略します
  # --------------------------------------------------------------------------
  # id = null  # 通常は設定不要（computed）

  # --------------------------------------------------------------------------
  # region - リソースを管理する AWS リージョン
  # --------------------------------------------------------------------------
  # Type: string
  # Required: No (Optional)
  # Computed: Yes
  #
  # このリソースが管理される AWS リージョンを指定します。
  # 省略した場合、プロバイダー設定で指定されたリージョンがデフォルトで使用されます。
  #
  # シリアルコンソールアクセスはアカウントレベルの設定ですが、
  # 各 AWS リージョンで個別に設定する必要があります。
  #
  # 例:
  #   - "us-east-1"     # 米国東部（バージニア北部）
  #   - "us-west-2"     # 米国西部（オレゴン）
  #   - "eu-west-1"     # 欧州（アイルランド）
  #   - "ap-northeast-1" # アジアパシフィック（東京）
  #
  # NOTE:
  #   - 複数のリージョンでアクセスを有効にする場合、各リージョンに個別のリソースが必要
  #   - Asia Pacific (Taipei) リージョンではサポートされていません
  #   - Wavelength Zones および AWS Outposts ではサポートされていません
  #
  # REFERENCE:
  #   - Regional endpoints: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  #   - Provider configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
  #   - Prerequisites: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-serial-console-prerequisites.html
  # --------------------------------------------------------------------------
  # region = "us-east-1"  # 通常はプロバイダー設定から継承
}

# ==============================================================================
# ADDITIONAL NOTES
# ==============================================================================
#
# IAM Policy Example:
#   シリアルコンソールへのユーザーアクセスを制御するには、以下のような IAM ポリシーが必要です:
#
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2-instance-connect:SendSerialConsoleSSHPublicKey"
#         ],
#         "Resource": "*"
#       }
#     ]
#   }
#
# Resource Tag Based Access Control:
#   リソースタグを使用してアクセスを制御する例:
#
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": "ec2-instance-connect:SendSerialConsoleSSHPublicKey",
#         "Resource": "*",
#         "Condition": {
#           "StringEquals": {
#             "ec2:ResourceTag/SerialConsole": "true"
#           }
#         }
#       }
#     ]
#   }
#
# Supported Instance Types:
#   - Nitro System ベースのすべての仮想化インスタンス（Linux）
#   - すべての仮想化インスタンス（Windows）
#   - 一部のベアメタルインスタンスはサポートされていません
#
# Security Considerations:
#   - シリアルコンソールは VPC の外部で動作するため、セキュリティグループや
#     ネットワーク ACL によるトラフィック制御は適用されません
#   - アクセス制御は IAM ポリシーと SCP によって行います
#   - 組織で不要な場合は AWS Control Tower の [CT.EC2.PV.9] コントロールで
#     アクセスを完全に禁止できます
#
# Troubleshooting Tools:
#   - Linux: GRUB、SysRq
#   - Windows: Special Admin Console (SAC)
#
# ==============================================================================
