# Terraform AWS リソーステンプレート - aws_default_vpc_dhcp_options
# Generated: 2026-02-14
# Provider Version: 6.28.0
# Resource Type: aws_default_vpc_dhcp_options
# Terraform Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc_dhcp_options
# AWS Documentation: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
# NOTE: このテンプレートには全ての設定可能なパラメータとその説明が含まれています

#-----------------------------------------------------------------------
# リソース概要
#-----------------------------------------------------------------------
# デフォルトVPCのDHCPオプションセットを管理するリソース。
# 既存のデフォルトDHCPオプションセットを削除せずにTerraformの管理下に置き、
# タグの追加やリージョン指定が可能。
# VPC作成時に自動的に作成されるDHCPオプションセットをインポートして管理する。

resource "aws_default_vpc_dhcp_options" "example" {
  tags = {
    Name        = "default-dhcp-options"
    Environment = "production"
  }
}

#-----------------------------------------------------------------------
# タグ管理
#-----------------------------------------------------------------------

#------- tags（リソースタグ）
# 設定内容: DHCPオプションセットに付与するタグのマップ
# 設定可能な値: キーと値のペアのマップ（キー: 128文字以内、値: 256文字以内）
# 省略時: タグなし
  tags = {
    Name        = "default-vpc-dhcp-options"
    Environment = "production"
  }

#------- tags_all（全タグの統合ビュー）
# 設定内容: リソースレベルとプロバイダーレベルのタグを統合した全タグ
# 設定可能な値: キーと値のペアのマップ（自動計算）
# 省略時: tagsとプロバイダーdefault_tagsの統合値
# 注意: このパラメータは通常省略し、Terraformが自動的に管理します

#-----------------------------------------------------------------------
# リージョン設定
#-----------------------------------------------------------------------

#------- region（管理リージョン）
# 設定内容: このリソースを管理するAWSリージョン
# 設定可能な値: 有効なAWSリージョン名（us-east-1、ap-northeast-1等）
# 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

#-----------------------------------------------------------------------
# オーナー情報
#-----------------------------------------------------------------------

#------- owner_id（所有者ID）
# 設定内容: DHCPオプションセットを所有するAWSアカウントID
# 設定可能な値: 12桁のAWSアカウントID文字列
# 省略時: 現在のアカウントIDを自動取得
# 注意: 通常は省略し、Terraformが自動的に設定します
  owner_id = "123456789012"

#-----------------------------------------------------------------------
# Attributes Reference（参照専用属性）
#-----------------------------------------------------------------------
# このリソースでは以下の属性が参照可能です:

# arn - DHCPオプションセットのARN
# id - DHCPオプションセットのID（dopt-xxxxxxxxxxxxxxxxx形式）
# domain_name - ドメイン名（例: us-east-1.compute.internal）
# domain_name_servers - ドメイン名サーバーのIPアドレスリスト
# ntp_servers - NTPサーバーのIPアドレスリスト
# netbios_name_servers - NetBIOS名前解決サーバーのIPアドレスリスト
# netbios_node_type - NetBIOSノードタイプ（1, 2, 4, 8のいずれか）
# ipv6_address_preferred_lease_time - IPv6アドレスの優先リース時間
# owner_id - DHCPオプションセットを所有するAWSアカウントID

#-----------------------------------------------------------------------
# Import（既存リソースのインポート）
#-----------------------------------------------------------------------
# 既存のデフォルトDHCPオプションセットをインポートする場合:
#
# terraform import aws_default_vpc_dhcp_options.example dopt-xxxxxxxxxxxxxxxxx
#
# 注意事項:
# - デフォルトVPCのDHCPオプションセットIDを指定
# - インポート後は既存の設定が維持される
# - タグの追加・変更のみ可能で、DHCP設定自体は変更不可
