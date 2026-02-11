#---------------------------------------------------------------
# AWS Device Farm Network Profile
#---------------------------------------------------------------
#
# AWS Device Farmのネットワークプロファイルをプロビジョニングするリソースです。
# ネットワークプロファイルは、テストの実行時にデバイスのネットワーク条件を
# シミュレートするために使用されます。帯域幅、遅延、ジッター、パケットロスなどの
# パラメータを設定して、様々なネットワーク環境をエミュレートできます。
#
# AWS公式ドキュメント:
#   - Device Farm概要: https://docs.aws.amazon.com/devicefarm/latest/developerguide/welcome.html
#   - ネットワークプロファイル: https://docs.aws.amazon.com/devicefarm/latest/developerguide/how-to-create-network-profile.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/devicefarm_network_profile
#
# Provider Version: 6.28.0
# Generated: 2026-01-22
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意: AWS Device Farmは現在、限定されたリージョンでのみ利用可能です（例: us-west-2）。
#       サポートされるリージョンについては以下を参照してください:
#       https://docs.aws.amazon.com/general/latest/gr/devicefarm.html
#
#---------------------------------------------------------------

resource "aws_devicefarm_network_profile" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: ネットワークプロファイルの名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "example-network-profile"

  # project_arn (Required)
  # 設定内容: ネットワークプロファイルを作成するDevice Farmプロジェクトの
  #          Amazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なDevice FarmプロジェクトのARN
  # 注意: 事前にaws_devicefarm_projectリソースを作成しておく必要があります
  project_arn = aws_devicefarm_project.example.arn

  # description (Optional)
  # 設定内容: ネットワークプロファイルの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example network profile for mobile app testing"

  # type (Optional)
  # 設定内容: ネットワークプロファイルのタイプを指定します。
  # 設定可能な値:
  #   - "PRIVATE": プライベートネットワークプロファイル（ユーザー定義のプロファイル）
  #   - "CURATED": AWS提供のキュレートされたネットワークプロファイル
  # 省略時: "PRIVATE"
  type = "PRIVATE"

  #-------------------------------------------------------------
  # ダウンリンク設定（デバイスへのネットワーク受信側）
  #-------------------------------------------------------------

  # downlink_bandwidth_bits (Optional)
  # 設定内容: ダウンリンクのデータスループットレートをビット/秒で指定します。
  # 設定可能な値: 0から104857600（100 Mbps）までの整数
  # 省略時: 104857600（100 Mbps）
  # 用途: 低帯域幅環境（3G、遅いWi-Fiなど）をシミュレートする場合に使用
  downlink_bandwidth_bits = 104857600

  # downlink_delay_ms (Optional)
  # 設定内容: ダウンリンクのパケット遅延をミリ秒で指定します。
  #          全てのパケットが宛先に到達するまでの遅延時間を表します。
  # 設定可能な値: 0から2000までの整数
  # 省略時: 0
  # 用途: 高遅延ネットワーク（衛星接続など）をシミュレートする場合に使用
  downlink_delay_ms = 0

  # downlink_jitter_ms (Optional)
  # 設定内容: ダウンリンクのジッター（遅延の変動）をミリ秒で指定します。
  #          受信パケットの遅延時間の変動を表します。
  # 設定可能な値: 0から2000までの整数
  # 省略時: 0
  # 用途: 不安定なネットワーク接続をシミュレートする場合に使用
  downlink_jitter_ms = 0

  # downlink_loss_percent (Optional)
  # 設定内容: ダウンリンクのパケットロス率をパーセントで指定します。
  #          到達に失敗する受信パケットの割合を表します。
  # 設定可能な値: 0から100までの整数
  # 省略時: 0
  # 用途: パケットロスが発生するネットワーク環境をシミュレートする場合に使用
  downlink_loss_percent = 0

  #-------------------------------------------------------------
  # アップリンク設定（デバイスからのネットワーク送信側）
  #-------------------------------------------------------------

  # uplink_bandwidth_bits (Optional)
  # 設定内容: アップリンクのデータスループットレートをビット/秒で指定します。
  # 設定可能な値: 0から104857600（100 Mbps）までの整数
  # 省略時: 104857600（100 Mbps）
  # 用途: 低帯域幅環境でのアップロードをシミュレートする場合に使用
  uplink_bandwidth_bits = 104857600

  # uplink_delay_ms (Optional)
  # 設定内容: アップリンクのパケット遅延をミリ秒で指定します。
  #          全ての送信パケットが宛先に到達するまでの遅延時間を表します。
  # 設定可能な値: 0から2000までの整数
  # 省略時: 0
  # 用途: 高遅延ネットワークでの送信をシミュレートする場合に使用
  uplink_delay_ms = 0

  # uplink_jitter_ms (Optional)
  # 設定内容: アップリンクのジッター（遅延の変動）をミリ秒で指定します。
  #          送信パケットの遅延時間の変動を表します。
  # 設定可能な値: 0から2000までの整数
  # 省略時: 0
  # 用途: 不安定なアップロード接続をシミュレートする場合に使用
  uplink_jitter_ms = 0

  # uplink_loss_percent (Optional)
  # 設定内容: アップリンクのパケットロス率をパーセントで指定します。
  #          送信に失敗するパケットの割合を表します。
  # 設定可能な値: 0から100までの整数
  # 省略時: 0
  # 用途: パケットロスが発生するアップロード環境をシミュレートする場合に使用
  uplink_loss_percent = 0

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-2）
  # 省略時: プロバイダー設定のリージョンを使用
  # 注意: Device Farmは限定されたリージョンでのみ利用可能です
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
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-network-profile"
    Environment = "development"
  }

  # tags_all (Optional/Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #          リソースに割り当てられたすべてのタグのマップです。
  # 注意: この属性は通常、明示的に設定する必要はありません。
  #       tagsとdefault_tagsから自動的に計算されます。
  # tags_all = {}
}

#---------------------------------------------------------------
# resource "aws_devicefarm_network_profile" "3g_simulation" {
#   name        = "3g-network-simulation"
#   project_arn = aws_devicefarm_project.example.arn
#   description = "Simulates 3G network conditions"
#   type        = "PRIVATE"
#
#   # 3Gネットワークの典型的な設定
#   downlink_bandwidth_bits = 1500000   # 1.5 Mbps
#   downlink_delay_ms       = 100       # 100ms遅延
#   downlink_jitter_ms      = 20        # 20msのジッター
#   downlink_loss_percent   = 1         # 1%のパケットロス
#
#   uplink_bandwidth_bits   = 500000    # 500 Kbps
#   uplink_delay_ms         = 100       # 100ms遅延
#   uplink_jitter_ms        = 20        # 20msのジッター
#   uplink_loss_percent     = 1         # 1%のパケットロス
#
#   tags = {
#     Name        = "3g-network-simulation"
#     Environment = "testing"
#   }
# }

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ネットワークプロファイルのAmazon Resource Name (ARN)
#
# - id: ネットワークプロファイルのARN（arnと同じ値）
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
