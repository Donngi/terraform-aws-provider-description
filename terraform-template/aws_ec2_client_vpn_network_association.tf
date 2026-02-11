#---------------------------------------------------------------
# AWS Client VPN Network Association
#---------------------------------------------------------------
#
# AWS Client VPN エンドポイントにターゲットネットワーク（サブネット）を
# 関連付けるためのリソースです。Client VPNエンドポイントに1つ以上の
# サブネットを関連付けることで、VPNクライアントがVPC内のリソースに
# アクセスできるようになります。
#
# AWS公式ドキュメント:
#   - Client VPN ターゲットネットワークの関連付け: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-target-associate.html
#   - Client VPN Administrator's Guide: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_client_vpn_network_association" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # client_vpn_endpoint_id (Required)
  # 設定内容: ターゲットネットワークを関連付けるClient VPNエンドポイントのIDを指定します。
  # 設定可能な値: 有効なClient VPNエンドポイントID（cvpn-endpoint-で始まる識別子）
  # 関連機能: Client VPN Endpoint
  #   Client VPNエンドポイントは、VPNクライアントが接続するエントリーポイントです。
  #   エンドポイントを作成後、ターゲットネットワークを関連付けることでクライアントが
  #   VPC内のリソースにアクセスできるようになります。
  #   - https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-endpoints.html
  client_vpn_endpoint_id = "cvpn-endpoint-0123456789abcdef0"

  # subnet_id (Required)
  # 設定内容: Client VPNエンドポイントに関連付けるサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID（subnet-で始まる識別子）
  # 注意:
  #   - 複数のサブネットを同じClient VPNエンドポイントに関連付けることができますが、
  #     同一アベイラビリティーゾーン内から複数のサブネットを関連付けることはできません
  #   - Client VPNエンドポイント作成時にVPCを指定した場合、または既存のサブネット
  #     関連付けがある場合、指定するサブネットは同じVPC内である必要があります
  #   - 異なるVPCのサブネットを関連付けるには、先にClient VPNエンドポイントを
  #     変更する必要があります
  # 参考: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-target-associate.html
  subnet_id = "subnet-0123456789abcdef0"

  #-------------------------------------------------------------
  # ID設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformが自動的に一意のIDを生成します
  # 注意: 通常は省略してTerraformに自動生成させることを推奨します
  id = null

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
  # 関連機能: Terraform Timeouts
  #   リソースの作成や削除が完了するまでの待機時間を設定します。
  #   大規模な環境やネットワーク遅延がある場合に有用です。
  timeouts {
    # create (Optional)
    # 設定内容: ネットワーク関連付けの作成操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = null

    # delete (Optional)
    # 設定内容: ネットワーク関連付けの削除操作のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "30m", "1h"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ターゲットネットワーク関連付けの一意のID
#
# - association_id: ターゲットネットワーク関連付けの一意のID
#                   （cvpn-assoc-で始まる識別子）
#
# - vpc_id: ターゲットサブネットが配置されているVPCのID
#---------------------------------------------------------------
