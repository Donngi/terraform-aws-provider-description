#---------------------------------------------------------------
# AWS Network Manager Link Association
#---------------------------------------------------------------
#
# Network Manager のリンクとデバイスを関連付けるリソース。
# リンクは物理的なWAN接続（専用線、ブロードバンド等）を表し、
# デバイスはオンプレミスのルーター等のネットワーク機器を表す。
# この関連付けにより、どのデバイスがどのリンクを使用して
# グローバルネットワークに接続しているかを管理できる。
#
# 1つのデバイスは複数のリンクに関連付け可能で、
# 1つのリンクも複数のデバイスに関連付け可能。
# ただし、デバイスとリンクは同一のグローバルネットワークおよび
# 同一のサイトに属している必要がある。
#
# AWS公式ドキュメント:
#   - Network Manager User Guide: https://docs.aws.amazon.com/network-manager/latest/tgwnm/what-is-network-manager.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_link_association
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_link_association" "example" {
  #---------------------------------------------------------------
  # 必須引数（Required Arguments）
  #---------------------------------------------------------------

  # global_network_id (Required, Forces new resource)
  # グローバルネットワークのID。
  # リンクとデバイスが属するグローバルネットワークを指定する。
  # Network Manager で管理するネットワーク全体の論理的なコンテナとなる。
  # この値を変更すると、リソースが再作成される。
  global_network_id = aws_networkmanager_global_network.example.id

  # device_id (Required, Forces new resource)
  # デバイスのID。
  # リンクを関連付けるデバイスを指定する。
  # デバイスはオンプレミスのルーター、ファイアウォール、
  # SD-WAN機器などのネットワーク機器を表す。
  # デバイスは指定したグローバルネットワークに属している必要がある。
  # この値を変更すると、リソースが再作成される。
  device_id = aws_networkmanager_device.example.id

  # link_id (Required, Forces new resource)
  # リンクのID。
  # デバイスに関連付けるリンクを指定する。
  # リンクはサイトへの物理的なWAN接続を表す。
  # 例: インターネット回線、専用線、MPLS接続など。
  # リンクは指定したグローバルネットワークに属し、
  # かつデバイスと同じサイトに属している必要がある。
  # この値を変更すると、リソースが再作成される。
  link_id = aws_networkmanager_link.example.id

  #---------------------------------------------------------------
  # オプション引数（Optional Arguments）
  #---------------------------------------------------------------

  # timeouts ブロック
  # リソースの作成・削除操作のタイムアウト時間を設定する。
  # ネットワークの状態変更に時間がかかる場合に調整する。
  timeouts {
    # create (Optional)
    # リンク関連付け作成のタイムアウト時間。
    # 指定時間内に作成が完了しない場合、操作が失敗する。
    # 形式: "10m"（10分）、"1h"（1時間）など。
    # デフォルト値はプロバイダーに依存。
    create = "10m"

    # delete (Optional)
    # リンク関連付け削除のタイムアウト時間。
    # 指定時間内に削除が完了しない場合、操作が失敗する。
    # 形式: "10m"（10分）、"1h"（1時間）など。
    # デフォルト値はプロバイダーに依存。
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# 以下の属性はリソース作成後に参照可能（Terraformで設定は不可）:
#
# id
#   - リンク関連付けの識別子
#   - 形式: {global_network_id},{link_id},{device_id}
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 関連リソースの例
#---------------------------------------------------------------

# グローバルネットワーク（Network Manager の最上位コンテナ）
# resource "aws_networkmanager_global_network" "example" {
#   description = "Example global network"
#
#   tags = {
#     Name = "example-global-network"
#   }
# }

# サイト（物理的なロケーションを表す）
# resource "aws_networkmanager_site" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = "Example site"
#
#   location {
#     address   = "Tokyo, Japan"
#     latitude  = "35.6762"
#     longitude = "139.6503"
#   }
#
#   tags = {
#     Name = "example-site"
#   }
# }

# デバイス（ネットワーク機器を表す）
# resource "aws_networkmanager_device" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   site_id           = aws_networkmanager_site.example.id
#   description       = "Example device"
#   type              = "router"
#   vendor            = "Cisco"
#   model             = "ISR 4000"
#
#   tags = {
#     Name = "example-device"
#   }
# }

# リンク（WAN接続を表す）
# resource "aws_networkmanager_link" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   site_id           = aws_networkmanager_site.example.id
#   description       = "Example link"
#   type              = "broadband"
#   provider_name     = "Example ISP"
#
#   bandwidth {
#     download_speed = 100
#     upload_speed   = 50
#   }
#
#   tags = {
#     Name = "example-link"
#   }
# }
