#---------------------------------------------------------------
# AWS Network Manager Link
#---------------------------------------------------------------
#
# AWS Network Managerのグローバルネットワークにおけるサイトのリンクを
# プロビジョニングするリソースです。リンクはデバイスとサイト間の接続を表し、
# 上り・下り帯域幅やプロバイダー情報を含みます。
#
# AWS公式ドキュメント:
#   - リンクの追加 (Cloud WAN): https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-site-link-add.html
#   - リンクの追加 (Transit Gateway NM): https://docs.aws.amazon.com/network-manager/latest/tgwnm/nm-site-link-add.html
#   - サイトとリンク: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-sites-links.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_link
#
# Provider Version: 6.28.0
# Generated: 2026-02-18
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_link" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # global_network_id (Required)
  # 設定内容: リンクを作成するグローバルネットワークのIDを指定します。
  # 設定可能な値: 有効なNetwork ManagerグローバルネットワークID
  global_network_id = aws_networkmanager_global_network.example.id

  # site_id (Required)
  # 設定内容: リンクを関連付けるサイトのIDを指定します。
  # 設定可能な値: 有効なNetwork ManagerサイトID
  site_id = aws_networkmanager_site.example.id

  # description (Optional)
  # 設定内容: リンクの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Broadband link for main office site"

  # provider_name (Optional)
  # 設定内容: リンクのサービスプロバイダー名を指定します。
  # 設定可能な値: 任意の文字列（例: "MegaCorp", "NTT", "SoftBank"）
  # 省略時: プロバイダー名なし
  provider_name = "MegaCorp"

  # type (Optional)
  # 設定内容: リンクの接続タイプを指定します。
  # 設定可能な値: 任意の文字列（例: "broadband", "fiber", "MPLS"）
  # 省略時: タイプなし
  type = "broadband"

  #-------------------------------------------------------------
  # 帯域幅設定
  #-------------------------------------------------------------

  # bandwidth (Required)
  # 設定内容: リンクの上り・下り帯域幅（Mbps）を指定します。
  # 注意: このブロックは必須です（min_items: 1, max_items: 1）
  bandwidth {
    # download_speed (Optional)
    # 設定内容: ダウンロード速度をMbps単位で指定します。
    # 設定可能な値: 正の整数（例: 50, 100, 1000）
    # 省略時: ダウンロード速度未設定
    download_speed = 50

    # upload_speed (Optional)
    # 設定内容: アップロード速度をMbps単位で指定します。
    # 設定可能な値: 正の整数（例: 10, 100, 1000）
    # 省略時: アップロード速度未設定
    upload_speed = 10
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 注意: プロバイダーレベルのdefault_tags設定と一致するキーは上書きされます。
  tags = {
    Name        = "example-networkmanager-link"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等のGoのtime.Duration形式
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    create = "30m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等のGoのtime.Duration形式
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    update = "30m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: "60s", "10m", "2h" 等のGoのtime.Duration形式
    # 省略時: プロバイダーデフォルトのタイムアウトを使用
    delete = "30m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: リンクのAmazon Resource Name (ARN)
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ。
#---------------------------------------------------------------
