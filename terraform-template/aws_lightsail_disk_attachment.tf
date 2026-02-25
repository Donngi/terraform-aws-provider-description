#---------------------------------------------------------------
# AWS Lightsail Disk Attachment
#---------------------------------------------------------------
#
# Amazon Lightsailのブロックストレージディスクをインスタンスにアタッチします。
# 追加のストレージ容量が必要な場合に、既存のLightsailディスクをインスタンスに
# 接続するリソースです。ディスクはインスタンス停止中・稼働中いずれの状態でも
# アタッチ可能です。
#
# AWS公式ドキュメント:
#   - Lightsailブロックストレージ概要: https://docs.aws.amazon.com/lightsail/latest/userguide/elastic-block-storage-and-ssd-disks-in-amazon-lightsail.html
#   - AttachDisk APIリファレンス: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_AttachDisk.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_disk_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_disk_attachment" "example" {
  #-------------------------------------------------------------
  # ディスク設定
  #-------------------------------------------------------------

  # disk_name (Required, Forces new resource)
  # 設定内容: アタッチするLightsailディスクの名前を指定します。
  # 設定可能な値: 既存のLightsailディスクの名前（文字列）
  # 注意: 指定したディスクは同じアベイラビリティーゾーンに存在する必要があります。
  #       1つのディスクは同時に1つのインスタンスにのみアタッチ可能です。
  disk_name = "example-disk"

  # disk_path (Required, Forces new resource)
  # 設定内容: インスタンスに公開するディスクのデバイスパスを指定します。
  # 設定可能な値: Linuxインスタンスの場合は /dev/xvdf ～ /dev/xvdz の形式
  # 注意: 既存のデバイスパスと重複しないように指定してください。
  #       /dev/xvda は通常ルートデバイスとして予約されています。
  disk_path = "/dev/xvdf"

  #-------------------------------------------------------------
  # インスタンス設定
  #-------------------------------------------------------------

  # instance_name (Required, Forces new resource)
  # 設定内容: ディスクをアタッチするLightsailインスタンスの名前を指定します。
  # 設定可能な値: 既存のLightsailインスタンスの名前（文字列）
  # 注意: インスタンスとディスクは同じAWSリージョン・アベイラビリティーゾーンに
  #       存在する必要があります。
  instance_name = "example-instance"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ディスク名とインスタンス名を組み合わせた一意のID
#        形式: disk_name,instance_name
#---------------------------------------------------------------
