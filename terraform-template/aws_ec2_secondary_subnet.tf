#---------------------------------------------------------------
# AWS EC2 Secondary Subnet
#---------------------------------------------------------------
#
# EC2セカンダリネットワーク内にセカンダリサブネットを作成するリソースです。
# セカンダリサブネットは、RDMA（Remote Direct Memory Access）などの
# 高性能ネットワーキングを必要とする特殊なワークロード向けの
# サブネットです。セカンダリネットワーク内のIPアドレス範囲を分割し、
# 特定のアベイラビリティゾーンに配置します。
#
# AWS公式ドキュメント:
#   - CreateSecondarySubnet API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateSecondarySubnet.html
#   - セカンダリサブネットCIDRブロック: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecondarySubnetIpv4CidrBlockAssociation.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_secondary_subnet
#
# Provider Version: 6.36.0
# Generated: 2026-03-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ec2_secondary_subnet" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # secondary_network_id (Required)
  # 設定内容: セカンダリサブネットを作成するセカンダリネットワークのIDを指定します。
  # 設定可能な値: 有効なセカンダリネットワークID
  secondary_network_id = aws_ec2_secondary_network.example.id

  # ipv4_cidr_block (Required)
  # 設定内容: セカンダリサブネットのIPv4 CIDRブロックを指定します。
  # 設定可能な値: /12〜/28の範囲のCIDR表記（例: 10.0.1.0/24）
  # 注意: セカンダリネットワーク内の既存サブネットとCIDRブロックが重複してはなりません。
  #       最初の4つのIPアドレスと最後のIPアドレスはAWSにより予約されています。
  ipv4_cidr_block = "10.0.1.0/24"

  #-------------------------------------------------------------
  # アベイラビリティゾーン設定
  #-------------------------------------------------------------

  # availability_zone (Optional)
  # 設定内容: セカンダリサブネットを配置するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAZコード（例: ap-northeast-1a, us-west-2a）
  # 省略時: AWSがランダムに選択
  # 注意: availability_zone_idとは排他的（どちらか一方のみ指定可能）
  availability_zone = "ap-northeast-1a"

  # availability_zone_id (Optional)
  # 設定内容: セカンダリサブネットを配置するアベイラビリティゾーンのIDを指定します。
  # 設定可能な値: 有効なAZ ID（例: apne1-az1, usw2-az1）
  # 省略時: availability_zoneで指定する方法を推奨
  # 注意: availability_zoneとは排他的（どちらか一方のみ指定可能）。
  #       AZ IDはAWSアカウント間で一貫した識別子を提供するため、
  #       マルチアカウント環境ではこちらの使用が推奨されます。
  # availability_zone_id = "apne1-az1"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "example-secondary-subnet"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を設定するブロックです。
  timeouts {

    # create (Optional)
    # 設定内容: セカンダリサブネット作成操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30s", "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    create = "10m"

    # update (Optional)
    # 設定内容: セカンダリサブネット更新操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30s", "10m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    update = "10m"

    # delete (Optional)
    # 設定内容: セカンダリサブネット削除操作のタイムアウト時間を指定します。
    # 設定可能な値: Goのtime.Duration形式の文字列（例: "30s", "20m", "1h"）
    # 省略時: プロバイダーのデフォルトタイムアウトを使用
    delete = "20m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: セカンダリサブネットのID
# - arn: セカンダリサブネットのAmazon Resource Name (ARN)
# - secondary_subnet_id: セカンダリサブネットのID
# - secondary_network_type: セカンダリネットワークのタイプ（例: rdma）
# - owner_id: セカンダリサブネットを所有するAWSアカウントのID
# - state: セカンダリサブネットの状態
# - ipv4_cidr_block_associations: IPv4 CIDRブロックの関連付けリスト
#   - association_id: IPv4 CIDRブロックの関連付けID
#   - cidr_block: IPv4 CIDRブロック
#   - state: CIDRブロック関連付けの状態
# - tags_all: プロバイダーのdefault_tagsから継承されたタグを含む全タグのマップ
#---------------------------------------------------------------
