#---------------------------------------------------------------
# AWS Network Manager Device
#---------------------------------------------------------------
#
# AWS Network Managerのグローバルネットワーク内にデバイスを作成する。
# デバイスは物理的または仮想的なネットワーク機器（ルーター、スイッチ等）を表し、
# グローバルネットワーク内のサイトやリンクと関連付けることで、
# ネットワークトポロジーの可視化と管理に使用される。
#
# AWS公式ドキュメント:
#   - Add a device to an AWS Cloud WAN global network: https://docs.aws.amazon.com/network-manager/latest/cloudwan/cloudwan-devices-add.html
#   - Working with devices: https://docs.aws.amazon.com/network-manager/latest/tgwnm/working-with-gnws.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkmanager_device
#
# Provider Version: 6.28.0
# Generated: 2026-01-29
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_networkmanager_device" "this" {
  #---------------------------------------------------------------
  # 必須属性
  #---------------------------------------------------------------

  # global_network_id (Required, string)
  # デバイスを作成するグローバルネットワークのID。
  # aws_networkmanager_global_networkリソースで作成したグローバルネットワークを参照する。
  global_network_id = aws_networkmanager_global_network.example.id

  #---------------------------------------------------------------
  # オプション属性
  #---------------------------------------------------------------

  # description (Optional, string)
  # デバイスの説明。
  # デバイスの用途や設置場所等を記述するために使用する。
  description = null

  # model (Optional, string)
  # デバイスのモデル番号。
  # デバイスの機種を識別するために使用する（例: "ISR 4451"）。
  model = null

  # serial_number (Optional, string)
  # デバイスのシリアル番号。
  # 物理デバイスを一意に識別するために使用する。
  serial_number = null

  # site_id (Optional, string)
  # デバイスが設置されているサイトのID。
  # aws_networkmanager_siteリソースで作成したサイトを参照する。
  # site_idとlocationの両方を指定した場合、Network Managerコンソールでの
  # 可視化にはサイトの位置情報が使用される。
  site_id = null

  # type (Optional, string)
  # デバイスのタイプ。
  # デバイスの種類を識別するために使用する（例: "router", "switch", "firewall"）。
  type = null

  # vendor (Optional, string)
  # デバイスのベンダー名。
  # デバイスの製造元を識別するために使用する（例: "Cisco", "Juniper"）。
  vendor = null

  # tags (Optional, map of strings)
  # デバイスに付与するタグ。
  # プロバイダーのdefault_tagsが設定されている場合、
  # 同じキーのタグはここで指定した値で上書きされる。
  tags = {
    Name = "example-device"
  }

  #---------------------------------------------------------------
  # aws_location ブロック (Optional, max: 1)
  #---------------------------------------------------------------
  # デバイスのAWS内での位置情報を指定する。
  # デバイスがAWSクラウド内（VPC内）に存在する場合に使用する。
  # オンプレミスやデータセンターに存在するデバイスの場合は、
  # 代わりにlocationブロックを使用する。

  aws_location {
    # subnet_arn (Optional, string)
    # デバイスが存在するサブネットのARN。
    # 形式: arn:aws:ec2:<region>:<account-id>:subnet/<subnet-id>
    # 例: "arn:aws:ec2:us-east-1:111111111111:subnet/subnet-abcd1234"
    subnet_arn = null

    # zone (Optional, string)
    # デバイスが存在するゾーンのID。
    # Availability Zone、Local Zone、Wavelength Zone、またはOutpostのIDを指定する。
    # 例: "us-east-1a", "us-east-1-lax-1a"
    zone = null
  }

  #---------------------------------------------------------------
  # location ブロック (Optional, max: 1)
  #---------------------------------------------------------------
  # デバイスの物理的な位置情報を指定する。
  # オンプレミス、データセンター、または他のクラウドプロバイダーに
  # 存在するデバイスの場合に使用する。
  # Network Managerコンソールでの地理的な可視化に使用される。

  location {
    # address (Optional, string)
    # デバイスの物理的な住所。
    # 例: "New York, NY 10004"
    address = null

    # latitude (Optional, string)
    # デバイスの位置の緯度。
    # 10進数形式で指定する。
    # 例: "40.7128"
    latitude = null

    # longitude (Optional, string)
    # デバイスの位置の経度。
    # 10進数形式で指定する。
    # 例: "-74.0060"
    longitude = null
  }

  #---------------------------------------------------------------
  # timeouts ブロック (Optional)
  #---------------------------------------------------------------
  # リソース操作のタイムアウト設定。
  # デフォルト値で問題ない場合は省略可能。

  timeouts {
    # create (Optional, string)
    # リソース作成時のタイムアウト。
    # Go言語のtime.ParseDuration形式で指定（例: "30m", "1h"）。
    create = null

    # update (Optional, string)
    # リソース更新時のタイムアウト。
    # Go言語のtime.ParseDuration形式で指定（例: "30m", "1h"）。
    update = null

    # delete (Optional, string)
    # リソース削除時のタイムアウト。
    # Go言語のtime.ParseDuration形式で指定（例: "30m", "1h"）。
    delete = null
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はTerraformによって自動的に設定され、他のリソースから参照可能。
# これらの値はresourceブロック内で設定することはできない。
#
# arn         - デバイスのARN（Amazon Resource Name）
# id          - デバイスのID
# tags_all    - プロバイダーのdefault_tagsで設定されたタグを含む、
#               リソースに付与された全てのタグのマップ
#---------------------------------------------------------------
