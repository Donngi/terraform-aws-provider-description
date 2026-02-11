#---------------------------------------------------------------
# Lightsail ディスクアタッチメント
#---------------------------------------------------------------
#
# Amazon Lightsailインスタンスに追加のブロックストレージディスクを
# アタッチするためのリソースです。ストレージ容量の拡張に使用します。
#
# AWS公式ドキュメント:
#   - AttachDisk API: https://docs.aws.amazon.com/lightsail/2016-11-28/api-reference/API_AttachDisk.html
#   - Block Storage FAQ: https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-faq-block-storage.html
#   - ディスクのトラブルシューティング: https://docs.aws.amazon.com/lightsail/latest/userguide/troubleshooting-block-storage-disk-issues.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/lightsail_disk_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-01-31
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_lightsail_disk_attachment" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ディスク名（必須）
  # アタッチするLightsailディスクの名前を指定します。
  # ディスクは事前にaws_lightsail_diskリソースで作成されている必要があります。
  #
  # 制約:
  #   - ディスクとインスタンスは同じアベイラビリティゾーンに存在する必要があります
  #   - 異なるリージョンやアベイラビリティゾーンのディスクはアタッチできません
  #   - ディスクは一度に1つのインスタンスにのみアタッチできます
  #
  # 例: "example-disk", "my-storage-disk"
  disk_name = "example-disk"

  # インスタンス名（必須）
  # ディスクをアタッチする先のLightsailインスタンスの名前を指定します。
  # インスタンスは事前にaws_lightsail_instanceリソースで作成されている必要があります。
  #
  # 注意:
  #   - インスタンスは実行中または停止中の状態である必要があります
  #   - インスタンスには最大15個のディスクをアタッチできます
  #   - アカウント全体の追加ディスクストレージ容量は20TBまでです
  #
  # 例: "example-instance", "my-web-server"
  instance_name = "example-instance"

  # ディスクパス（必須）
  # インスタンスに公開するディスクのデバイスパスを指定します。
  #
  # Linuxインスタンスの場合:
  #   - 通常は /dev/xvdf から /dev/xvdp までの範囲で指定します
  #   - 最初の追加ディスクには /dev/xvdf を指定するのが一般的です
  #   - 2番目には /dev/xvdg、3番目には /dev/xvdh というように順番に割り当てます
  #
  # Windowsインスタンスの場合:
  #   - xvdf は D:\、xvdg は E:\ にマウントされます
  #
  # アタッチ後の作業:
  #   - ディスクをアタッチした後、インスタンス内でフォーマットとマウントが必要です
  #   - Linux例: mkfs.ext4 /dev/xvdf && mount /dev/xvdf /mnt/data
  #   - 永続マウントには /etc/fstab の編集が必要です
  #
  # 例: "/dev/xvdf", "/dev/xvdg", "/dev/xvdh"
  disk_path = "/dev/xvdf"

  #---------------------------------------------------------------
  # オプションパラメータ
  #---------------------------------------------------------------

  # リージョン（オプション）
  # このリソースが管理されるAWSリージョンを指定します。
  # 指定しない場合、プロバイダー設定のリージョンが使用されます。
  #
  # 重要:
  #   - ディスク、インスタンス、アタッチメントは全て同じリージョンに存在する必要があります
  #   - さらに、同じアベイラビリティゾーンに存在する必要があります
  #   - 異なるリージョン・ゾーン間でのアタッチはエラーになります
  #
  # エラー例:
  #   "There are currently no instances in the us-east-1 that can use this disk."
  #   このエラーは、ディスクとインスタンスが異なるゾーンにある場合に発生します
  #
  # 例: "us-east-1", "ap-northeast-1", "eu-west-1"
  # region = "us-east-1"
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
#
# このリソースは以下の属性をエクスポートします:
#
# - id
#   ディスクアタッチメントの一意な識別子。
#   ディスク名とインスタンス名の組み合わせで構成されます。
#   形式: "disk_name,instance_name"
#   例: "example-disk,example-instance"
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 使用例
#---------------------------------------------------------------
#
# 以下は完全な設定例です:
#
# data "aws_availability_zones" "available" {
#   state = "available"
#
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }
#
# resource "aws_lightsail_disk" "example" {
#   name              = "example-disk"
#   size_in_gb        = 8
#   availability_zone = data.aws_availability_zones.available.names[0]
# }
#
# resource "aws_lightsail_instance" "example" {
#   name              = "example-instance"
#   availability_zone = data.aws_availability_zones.available.names[0]
#   blueprint_id      = "amazon_linux_2"
#   bundle_id         = "nano_3_0"
# }
#
# resource "aws_lightsail_disk_attachment" "example" {
#   disk_name     = aws_lightsail_disk.example.name
#   instance_name = aws_lightsail_instance.example.name
#   disk_path     = "/dev/xvdf"
# }
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 重要な注意事項
#---------------------------------------------------------------
#
# 1. アベイラビリティゾーンの一致
#    - ディスクとインスタンスは必ず同じアベイラビリティゾーンに作成してください
#    - 異なるゾーン間でのアタッチはサポートされていません
#    - エラー時は、ディスクを正しいゾーンで再作成する必要があります
#
# 2. ディスクの数と容量の制限
#    - 単一ディスクの最大サイズは16TB（16,384GB）です
#    - インスタンスには最大15個のディスクをアタッチできます
#    - アカウント全体の追加ディスクストレージ容量は20TBまでです
#    - これらの制限を超えるとディスク作成・アタッチがエラーになります
#
# 3. ディスクのフォーマットとマウント
#    - アタッチ後、インスタンス内でディスクのフォーマットとマウントが必要です
#    - 新しいディスクにはファイルシステムが存在しないため、作成が必要です
#    - Linux例: mkfs.ext4 /dev/xvdf && mount /dev/xvdf /mnt/data
#    - 永続マウントには /etc/fstab の編集が必要です
#    - 詳細は公式ドキュメントを参照してください
#
# 4. デタッチ時の注意
#    - ディスクをデタッチする前に、インスタンス内で必ずアンマウントしてください
#    - マウント状態でのデタッチは、データ破損のリスクがあります
#    - デタッチは、インスタンスが停止状態でのみ実行可能です
#    - 実行中のインスタンスからはデタッチできません
#
# 5. ディスクの削除
#    - ディスクを削除する前に、必ずインスタンスからデタッチしてください
#    - アタッチされたままのディスクは削除できません
#    - エラー例: "You can't perform this operation because the disk is still
#      attached to a Lightsail instance"
#
# 6. ディスクのエラーステータス
#    - ディスクが "error" ステータスになった場合、ハードウェア障害を示します
#    - エラーステータスのディスクは、スナップショットからの復元が必要です
#    - 復元しない場合、データは回復不能です
#    - エラーステータスのディスクには課金されません
#
# 7. ディスクパスの選択
#    - /dev/xvdf から /dev/xvdp の範囲で指定可能です
#    - 既存のデバイスと重複しないパスを選択してください
#    - 最初の追加ディスクには /dev/xvdf の使用が推奨されます
#
# 8. 高可用性と信頼性
#    - Lightsailブロックストレージは、アベイラビリティゾーン内で自動的に複製されます
#    - 99.99%の可用性が設計されています
#    - 転送中および保管時の暗号化が自動的に適用されます
#    - データ保護のため、定期的なスナップショット作成を推奨します
#
#---------------------------------------------------------------
