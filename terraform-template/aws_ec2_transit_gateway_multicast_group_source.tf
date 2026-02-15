#-------------------------------------------------------------------------------------------------------
# AWS EC2 Transit Gateway Multicast Group Source
#-------------------------------------------------------------------------------------------------------
# Provider Version: 6.28.0
# Generated: 2026-02-15
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_multicast_group_source
#
# NOTE:
# このテンプレートはAWS Provider 6.28.0のスキーマ定義に基づいて生成されています。
# 実際の利用時には、プロバイダーバージョンとの互換性を確認してください。
#
# 用途: Transit Gatewayマルチキャストドメイン内のマルチキャストグループソース（送信元）を登録
#
# 主な機能:
# - マルチキャストトラフィックを送信するネットワークインターフェースの登録
# - IGMPv2プロトコルによる動的なマルチキャストグループ管理
# - VPC間でのマルチキャストトラフィックのルーティング
#
# ユースケース:
# - アプリケーションのマルチキャスト配信（ビデオストリーミング、リアルタイムデータ配信など）
# - 複数のVPCにまたがるマルチキャスト通信の実装
# - 静的またはIGMPベースのマルチキャストソース管理
#
# 注意事項:
# - Transit Gatewayはマルチキャストルーターとして機能
# - マルチキャストは高頻度取引やパフォーマンス重視のアプリケーションには不向き
# - Direct Connect、Site-to-Site VPN、ピアリング接続経由のマルチキャストルーティングは非サポート
# - マルチキャストパケットの断片化は非サポート
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# Terraform設定
#-------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }
}

#-------------------------------------------------------------------------------------------------------
# Provider設定
#-------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-northeast-1" # 東京リージョン

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = "production"
      SystemName  = "example-system"
    }
  }
}

#-------------------------------------------------------------------------------------------------------
# Transit Gateway Multicast Domain（前提リソース）
#-------------------------------------------------------------------------------------------------------
# マルチキャストドメインの作成例
resource "aws_ec2_transit_gateway" "example" {
  description                     = "マルチキャスト対応Transit Gateway"
  multicast_support               = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "example-tgw-multicast"
  }
}

resource "aws_ec2_transit_gateway_multicast_domain" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id

  static_sources_support    = "disable" # IGMPベースの動的管理
  igmpv2_support            = "enable"  # IGMPv2プロトコルを有効化
  auto_accept_shared_associations = "enable"

  tags = {
    Name = "example-multicast-domain"
  }
}

#-------------------------------------------------------------------------------------------------------
# VPCとサブネットの関連付け（前提リソース）
#-------------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id

  tags = {
    Name = "example-tgw-attachment"
  }
}

resource "aws_ec2_transit_gateway_multicast_domain_association" "example" {
  subnet_id                           = aws_subnet.example.id
  transit_gateway_attachment_id       = aws_ec2_transit_gateway_vpc_attachment.example.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

#-------------------------------------------------------------------------------------------------------
# マルチキャストグループソース
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# 基本設定
#-------------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_multicast_group_source" "basic" {
  # 設定内容: マルチキャストグループのIPアドレス（IPv4）
  # 設定可能な値: 224.0.0.0/4 の範囲内の有効なマルチキャストIPアドレス
  # 省略時: 設定必須（必須パラメータ）
  group_ip_address = "224.0.0.1"

  # 設定内容: マルチキャストトラフィックを送信するネットワークインターフェースのID
  # 設定可能な値: EC2インスタンスに関連付けられた有効なネットワークインターフェースID
  # 省略時: 設定必須（必須パラメータ）
  network_interface_id = aws_network_interface.source.id

  # 設定内容: マルチキャストドメインのID
  # 設定可能な値: 存在するTransit GatewayマルチキャストドメインのリソースID
  # 省略時: 設定必須（必須パラメータ）
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

#-------------------------------------------------------------------------------------------------------
# 複数ソースの登録例
#-------------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_multicast_group_source" "source_1" {
  group_ip_address                    = "224.0.0.10"
  network_interface_id                = aws_network_interface.source_1.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

resource "aws_ec2_transit_gateway_multicast_group_source" "source_2" {
  group_ip_address                    = "224.0.0.10"
  network_interface_id                = aws_network_interface.source_2.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.example.id
}

#-------------------------------------------------------------------------------------------------------
# リージョン指定例
#-------------------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_multicast_group_source" "regional" {
  group_ip_address                    = "224.0.0.20"
  network_interface_id                = aws_network_interface.source_regional.id
  transit_gateway_multicast_domain_id = aws_ec2_transit_gateway_multicast_domain.regional.id

  # 設定内容: リソースを管理するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-west-2"
}

#-------------------------------------------------------------------------------------------------------
# ネットワークインターフェース（前提リソース）
#-------------------------------------------------------------------------------------------------------
resource "aws_network_interface" "source" {
  subnet_id = aws_subnet.example.id

  tags = {
    Name = "multicast-source-eni"
  }
}

resource "aws_network_interface" "source_1" {
  subnet_id = aws_subnet.example.id

  tags = {
    Name = "multicast-source-1-eni"
  }
}

resource "aws_network_interface" "source_2" {
  subnet_id = aws_subnet.example.id

  tags = {
    Name = "multicast-source-2-eni"
  }
}

resource "aws_network_interface" "source_regional" {
  subnet_id = aws_subnet.regional.id
  provider  = aws.us_west_2

  tags = {
    Name = "multicast-source-regional-eni"
  }
}

#-------------------------------------------------------------------------------------------------------
# VPCとサブネット（前提リソース）
#-------------------------------------------------------------------------------------------------------
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "multicast-vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "multicast-subnet"
  }
}

resource "aws_vpc" "regional" {
  provider   = aws.us_west_2
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "multicast-vpc-regional"
  }
}

resource "aws_subnet" "regional" {
  provider          = aws.us_west_2
  vpc_id            = aws_vpc.regional.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "multicast-subnet-regional"
  }
}

#-------------------------------------------------------------------------------------------------------
# 追加プロバイダー設定
#-------------------------------------------------------------------------------------------------------
provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = "production"
      SystemName  = "example-system"
    }
  }
}

#-------------------------------------------------------------------------------------------------------
# Attributes Reference（参照可能な属性）
#-------------------------------------------------------------------------------------------------------
# このリソースからは以下の属性を参照可能:
#
# - id
#   マルチキャストグループソースの一意識別子
#   形式: {transit_gateway_multicast_domain_id}_{group_ip_address}_{network_interface_id}
#
# - group_ip_address
#   マルチキャストグループのIPアドレス
#
# - network_interface_id
#   ソースとして登録されたネットワークインターフェースのID
#
# - transit_gateway_multicast_domain_id
#   マルチキャストドメインのID
#
# - region
#   リソースが管理されているリージョン
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# 出力値
#-------------------------------------------------------------------------------------------------------
output "multicast_group_source_id" {
  description = "マルチキャストグループソースのID"
  value       = aws_ec2_transit_gateway_multicast_group_source.basic.id
}

output "multicast_group_ip" {
  description = "マルチキャストグループのIPアドレス"
  value       = aws_ec2_transit_gateway_multicast_group_source.basic.group_ip_address
}

output "multicast_source_eni_id" {
  description = "ソースネットワークインターフェースのID"
  value       = aws_ec2_transit_gateway_multicast_group_source.basic.network_interface_id
}
