#---------------------------------------------------------------
# AWS Network Manager Site
#---------------------------------------------------------------
#
# AWS Network Managerでグローバルネットワーク内にサイトを作成するリソース。
# サイトはネットワークの物理的な場所（データセンター、オフィス、支店など）を表し、
# Network Managerのトランジットゲートウェイダッシュボードやグローバルネットワーク
# ダッシュボードで使用される。位置情報（住所、緯度、経度）を設定することで、
# ダッシュボードで視覚化できる。
#
# AWS公式ドキュメント:
#   - Create a site using AWS Network Manager: https://docs.aws.amazon.com/network-manager/latest/tgwnm/creating-a-site.html
#   - Create a site in an AWS Cloud WAN global network: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-sites-add.html
#   - Sites and links: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-sites-working-with.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_site
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_site" "this" {
  #---------------------------------------------------------------
  # 必須引数 (Required Arguments)
  #---------------------------------------------------------------

  # global_network_id (Required, string)
  # サイトを作成するグローバルネットワークのID。
  # グローバルネットワークは、ネットワークオブジェクト（サイト、デバイス、リンクなど）を
  # 含むコンテナとして機能する。サイトはグローバルネットワークに属する必要がある。
  # 例: aws_networkmanager_global_network.example.id
  global_network_id = aws_networkmanager_global_network.example.id

  #---------------------------------------------------------------
  # オプション引数 (Optional Arguments)
  #---------------------------------------------------------------

  # description (Optional, string)
  # サイトの説明文。
  # サイトの目的、役割、所在地などの詳細情報を記述するために使用。
  # 例: "Tokyo Main Office", "US East Data Center"
  description = null

  # location (Optional, Block, Max: 1)
  # サイトの位置情報。
  # 物理的な住所や緯度・経度を指定することで、ダッシュボードでサイトの位置を視覚化できる。
  # このブロックは任意で、指定する場合は1つだけ設定できる。
  location {
    # address (Optional, string)
    # サイトの物理的な住所。
    # 自由形式のテキストで住所を指定。ダッシュボードの表示や管理に使用される。
    # 例: "1-1-1 Marunouchi, Chiyoda-ku, Tokyo 100-0005, Japan"
    address = null

    # latitude (Optional, string)
    # サイトの緯度（文字列形式）。
    # 緯度は-90から90の範囲で指定。正の値は北緯、負の値は南緯を表す。
    # ダッシュボードでサイトの位置をマップに表示するために使用。
    # 例: "35.6762", "37.7749", "-33.8688"
    latitude = null

    # longitude (Optional, string)
    # サイトの経度（文字列形式）。
    # 経度は-180から180の範囲で指定。正の値は東経、負の値は西経を表す。
    # ダッシュボードでサイトの位置をマップに表示するために使用。
    # 例: "139.6503", "-122.4194", "151.2093"
    longitude = null
  }

  # tags (Optional, map of strings)
  # サイトに付与するタグのマップ。
  # リソースの識別、コスト管理、アクセス制御などに使用。
  # provider の default_tags と同じキーのタグは、ここで指定した値で上書きされる。
  tags = {
    Name        = "example-site"
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
#   サイトのAmazon Resource Name (ARN)。
#   形式: arn:aws:networkmanager::{account-id}:site/{global-network-id}/{site-id}
#
# id (string)
#   サイトの識別子。
#
# tags_all (map of strings)
#   リソースに適用されている全てのタグ（provider の default_tags を含む）。
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 基本的なサイト設定
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
# # サイト（位置情報なし）
# resource "aws_networkmanager_site" "simple" {
#   global_network_id = aws_networkmanager_global_network.example.id
#
#   tags = {
#     Name = "simple-site"
#   }
# }
#
# # サイト（位置情報あり）
# resource "aws_networkmanager_site" "tokyo" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = "Tokyo Main Office"
#
#   location {
#     address   = "Tokyo, Japan"
#     latitude  = "35.6762"
#     longitude = "139.6503"
#   }
#
#   tags = {
#     Name        = "tokyo-site"
#     Environment = "production"
#     Region      = "Asia Pacific"
#   }
# }
#
# # サイト（詳細な住所付き）
# resource "aws_networkmanager_site" "headquarters" {
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = "Company Headquarters"
#
#   location {
#     address   = "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA"
#     latitude  = "37.4220"
#     longitude = "-122.0841"
#   }
#
#   tags = {
#     Name     = "hq-site"
#     Location = "Mountain View"
#     Type     = "Headquarters"
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例: 複数サイトの設定
#---------------------------------------------------------------
#
# # 複数の地域にサイトを作成
# locals {
#   sites = {
#     tokyo = {
#       description = "Tokyo Office"
#       address     = "Tokyo, Japan"
#       latitude    = "35.6762"
#       longitude   = "139.6503"
#     }
#     singapore = {
#       description = "Singapore Office"
#       address     = "Singapore"
#       latitude    = "1.3521"
#       longitude   = "103.8198"
#     }
#     sydney = {
#       description = "Sydney Office"
#       address     = "Sydney, Australia"
#       latitude    = "-33.8688"
#       longitude   = "151.2093"
#     }
#   }
# }
#
# resource "aws_networkmanager_site" "regional" {
#   for_each = local.sites
#
#   global_network_id = aws_networkmanager_global_network.example.id
#   description       = each.value.description
#
#   location {
#     address   = each.value.address
#     latitude  = each.value.latitude
#     longitude = each.value.longitude
#   }
#
#   tags = {
#     Name   = "${each.key}-site"
#     Region = each.key
#   }
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# ベストプラクティス
#---------------------------------------------------------------
#
# 1. 位置情報の設定
#    - ダッシュボードでの視覚化を有効にするため、可能な限り位置情報を設定する
#    - 緯度・経度は正確な値を使用する（Google Mapsなどで確認可能）
#
# 2. 命名規則
#    - 一貫した命名規則を使用する（例: {location}-{purpose}-site）
#    - タグを活用してサイトを整理・分類する
#
# 3. サイト階層
#    - 地域、用途、重要度などでサイトを分類
#    - タグを使用してサイトのグループ化や検索を容易にする
#
# 4. デバイスとリンクの関連付け
#    - サイト作成後、必要に応じてデバイスとリンクを追加
#    - aws_networkmanager_device と aws_networkmanager_link を使用
#
# 5. モニタリング
#    - Network Managerダッシュボードでサイトの状態を監視
#    - CloudWatch Logsを活用してイベントを記録
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 注意事項
#---------------------------------------------------------------
#
# 1. サイトの削除
#    - サイトを削除する前に、関連するデバイス、リンク、VPN接続を削除する必要がある
#
# 2. 位置情報の形式
#    - 緯度・経度は文字列形式で指定する（数値ではない）
#    - 緯度: -90 〜 90、経度: -180 〜 180 の範囲内で指定
#
# 3. グローバルネットワーク
#    - サイトを作成する前に、グローバルネットワークが存在する必要がある
#
# 4. タグの継承
#    - provider レベルの default_tags は自動的にサイトに適用される
#    - リソースレベルのタグは provider の default_tags を上書きする
#
# 5. 即時作成
#    - サイトはAWS CLIやコンソールを使用して作成すると即座に作成される
#    - Terraformでも同様に迅速に作成される
#
#---------------------------------------------------------------
