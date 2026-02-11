#---------------------------------------------------------------
# AWS Network Manager Link
#---------------------------------------------------------------
#
# AWS Network Managerでサイトにリンクを作成するリソース。
# リンクは、サイトに関連付けられたデバイスのインターネット接続を表す。
# グローバルネットワーク内のサイトとデバイス間の接続を定義するために使用する。
#
# AWS公式ドキュメント:
#   - Add a link using AWS Network Manager: https://docs.aws.amazon.com/network-manager/latest/tgwnm/nm-site-link-add.html
#   - Sites and links: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-sites-working-with.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_link
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_link" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # global_network_id (Required, string)
  # リンクを作成するグローバルネットワークのID。
  # グローバルネットワークは、ネットワークオブジェクト（サイト、デバイス、リンクなど）を
  # 含むコンテナとして機能する。
  # 例: aws_networkmanager_global_network.example.id
  global_network_id = aws_networkmanager_global_network.example.id

  # site_id (Required, string)
  # リンクを関連付けるサイトのID。
  # サイトは物理的な場所（データセンター、オフィスなど）を表す。
  # リンクはサイトに属し、そのサイトのデバイスと関連付けることができる。
  # 例: aws_networkmanager_site.example.id
  site_id = aws_networkmanager_site.example.id

  # bandwidth (Required, Block, Max: 1)
  # リンクの帯域幅設定。アップロード速度とダウンロード速度をMbps単位で指定する。
  # このブロックは必須で、1つだけ指定できる。
  bandwidth {
    # download_speed (Optional, number)
    # ダウンロード速度（Mbps単位）。
    # サービスプロバイダーから提供される下り帯域幅を指定。
    # 例: 50, 100, 1000
    download_speed = 50

    # upload_speed (Optional, number)
    # アップロード速度（Mbps単位）。
    # サービスプロバイダーから提供される上り帯域幅を指定。
    # 例: 10, 50, 100
    upload_speed = 10
  }

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (Optional, string)
  # リンクの説明文。
  # リンクの目的や接続先などを記述するために使用。
  # 例: "Tokyo Office Primary Link", "Backup Internet Connection"
  description = null

  # provider_name (Optional, string)
  # サービスプロバイダーの名前。
  # インターネット接続を提供する通信事業者やISPの名前を指定。
  # 例: "NTT", "KDDI", "Verizon", "AT&T"
  provider_name = null

  # type (Optional, string)
  # リンクのタイプ。
  # 接続の種類を示す任意の文字列を指定。
  # 例: "broadband", "fiber", "4G", "5G", "dedicated"
  type = null

  # tags (Optional, map of strings)
  # リンクに付与するタグのマップ。
  # リソースの識別、コスト管理、アクセス制御などに使用。
  # provider の default_tags と同じキーのタグは、ここで指定した値で上書きされる。
  tags = {
    Name        = "example-link"
    Environment = "production"
  }

  #---------------------------------------------------------------
  # タイムアウト設定 (Timeouts)
  #---------------------------------------------------------------

  # timeouts (Optional, Block)
  # リソース操作のタイムアウト時間を設定。
  # デフォルト値で問題がある場合にのみカスタマイズ。
  timeouts {
    # create (Optional, string)
    # リソース作成のタイムアウト時間。
    # 形式: "60m", "1h", "30s" など
    create = null

    # update (Optional, string)
    # リソース更新のタイムアウト時間。
    # 形式: "60m", "1h", "30s" など
    update = null

    # delete (Optional, string)
    # リソース削除のタイムアウト時間。
    # 形式: "60m", "1h", "30s" など
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (出力専用属性)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に設定され、参照可能。
# これらはリソースブロック内では設定できない（computed only）。
#
# arn (string)
#   リンクのAmazon Resource Name (ARN)。
#   形式: arn:aws:networkmanager::{account-id}:link/{global-network-id}/{link-id}
#
# id (string)
#   リンクの識別子。
#
# tags_all (map of strings)
#   リソースに適用されている全てのタグ（provider の default_tags を含む）。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なリンク設定
#---------------------------------------------------------------
#
# # グローバルネットワーク
# resource "aws_networkmanager_global_network" "example" {
#   description = "Example Global Network"
#
#   tags = {
#     Name = "example-global-network"
#   }
# }
#
# # サイト
# resource "aws_networkmanager_site" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = "Example Site"
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
#
# # リンク
# resource "aws_networkmanager_link" "example" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   site_id           = aws_networkmanager_site.example.id
#
#   bandwidth {
#     upload_speed   = 10
#     download_speed = 50
#   }
#
#   provider_name = "ExampleISP"
#   type          = "broadband"
#   description   = "Primary Internet Connection"
#
#   tags = {
#     Name = "example-link"
#   }
# }
#
#---------------------------------------------------------------
