#---------------------------------------------------------------
# EC2 Instance Connect Endpoint
#---------------------------------------------------------------
#
# EC2 Instance Connect Endpointをプロビジョニングするリソースです。
# このエンドポイントを使用すると、パブリックIPv4アドレスなしで
# プライベートサブネット内のEC2インスタンスに安全に接続できます。
#
# AWS公式ドキュメント:
#   - EC2 Instance Connect: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html
#   - EC2 Instance Connect Endpoint: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-using-eice.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_connect_endpoint
#
# Provider Version: 6.28.0
# Generated: 2026-01-26
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_instance_connect_endpoint" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # subnet_id (Required, Forces new resource)
  # 設定内容: EC2 Instance Connect Endpointを配置するサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 注意: エンドポイントはこのサブネット内に作成され、後から変更できません（Forces new resource）
  subnet_id = "subnet-12345678"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # security_group_ids (Optional)
  # 設定内容: エンドポイントに関連付けるセキュリティグループのIDセットを指定します。
  # 設定可能な値: セキュリティグループIDのセット
  # 省略時: VPCのデフォルトセキュリティグループが使用されます
  # 関連機能: セキュリティグループ
  #   エンドポイント経由の接続に対するインバウンド・アウトバウンドトラフィックを制御します。
  #   - https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
  security_group_ids = ["sg-12345678"]

  # ip_address_type (Optional)
  # 設定内容: エンドポイントのIPアドレスタイプを指定します。
  # 設定可能な値:
  #   - "ipv4" (デフォルト): IPv4アドレスを使用
  #   - "ipv6": IPv6アドレスを使用
  #   - "dualstack": IPv4とIPv6の両方を使用
  # 省略時: "ipv4"が使用されます
  ip_address_type = "ipv4"

  # preserve_client_ip (Optional)
  # 設定内容: クライアントIPアドレスを保持するかを指定します。
  # 設定可能な値:
  #   - true: クライアントのソースIPアドレスを保持します
  #   - false (デフォルト): クライアントIPアドレスを保持しません
  # 省略時: false
  # 関連機能: クライアントIP保持
  #   クライアントIPアドレスを保持することで、接続元の追跡やアクセス制御が可能になります。
  preserve_client_ip = false

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html
  tags = {
    Name        = "example-eic-endpoint"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    create = "10m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "30s", "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます
    # 注意: Delete操作のタイムアウトは、destroy操作前に変更が状態に保存される場合にのみ適用されます
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: EC2 Instance Connect EndpointのAmazon Resource Name (ARN)
#
# - availability_zone: エンドポイントが配置されているアベイラビリティーゾーン
#
# - dns_name: エンドポイントのDNS名
#
# - fips_dns_name: エンドポイントのFIPS対応DNS名
#
# - id: エンドポイントのID
#
# - network_interface_ids: エンドポイントに関連付けられたネットワークインターフェースのIDリスト
#
# - owner_id: エンドポイントを所有するAWSアカウントのID
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# - vpc_id: エンドポイントが配置されているVPCのID
#---------------------------------------------------------------
