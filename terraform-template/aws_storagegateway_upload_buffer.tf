#---------------------------------------------------------------
# AWS Storage Gateway Upload Buffer
#---------------------------------------------------------------
#
# AWS Storage Gatewayのアップロードバッファを管理するリソースです。
# アップロードバッファは、Amazon S3にアップロードする前のデータの
# ステージング領域として機能します。
#
# ゲートウェイタイプに応じて、1つ以上のローカルディスクを
# アップロードバッファとして構成できます。
# 対応ゲートウェイタイプ: Stored Volume、Cached Volume、Tape Gateway
#
# AWS公式ドキュメント:
#   - Storage Gateway アップロードバッファ API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddUploadBuffer.html
#   - ローカルディスクストレージの決定: https://docs.aws.amazon.com/storagegateway/latest/vgw/decide-local-disks-and-sizes.html
#   - アップロードバッファの監視: https://docs.aws.amazon.com/storagegateway/latest/vgw/PerfUploadBuffer-common.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_upload_buffer
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 重要な注意事項:
#   Storage Gateway APIには、アップロードバッファディスクを削除する
#   メソッドが提供されていません。そのため、このTerraformリソースを
#   destroyしても、Storage Gatewayに対する削除操作は実行されません。
#
#---------------------------------------------------------------

resource "aws_storagegateway_upload_buffer" "example" {
  #-------------------------------------------------------------
  # ゲートウェイ設定 (必須)
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: アップロードバッファを追加するゲートウェイのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN
  # 注意: このゲートウェイARNは、Stored Volume、Cached Volume、Tape Gatewayのいずれかである必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddUploadBuffer.html
  gateway_arn = "arn:aws:storagegateway:ap-northeast-1:123456789012:gateway/sgw-12345678"

  #-------------------------------------------------------------
  # ローカルディスク識別子設定
  #-------------------------------------------------------------

  # disk_id (Optional)
  # 設定内容: ローカルディスク識別子を指定します。
  # 設定可能な値: ローカルディスクのID（例: pci-0000:03:00.0-scsi-0:0:0:0）
  # 注意: disk_path と排他的（どちらか一方のみ指定可能）
  #       Stored Gateway タイプではこの属性を使用します。
  # 参考: data source aws_storagegateway_local_disk を使用してディスクIDを取得できます
  disk_id = null

  # disk_path (Optional)
  # 設定内容: ローカルディスクパスを指定します。
  # 設定可能な値: ローカルディスクのパス（例: /dev/nvme1n1）
  # 注意: disk_id と排他的（どちらか一方のみ指定可能）
  #       Cached および VTL Gateway タイプではこの属性を使用します。
  # 参考: data source aws_storagegateway_local_disk を使用してディスクパスを取得できます
  disk_path = "/dev/nvme1n1"

  #-------------------------------------------------------------
  # リソース識別子設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースのIDを指定します。
  # 設定可能な値: 文字列
  # 省略時: ゲートウェイARNとローカルディスク識別子の組み合わせから自動生成されます。
  # 注意: 通常は省略し、Terraformに自動生成させることを推奨します。
  id = null

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
# - id: 結合されたゲートウェイAmazon Resource Name (ARN)とローカルディスク識別子
#
#---------------------------------------------------------------

#---------------------------------------------------------------
# 以下は、Cached および VTL Gateway タイプでの使用例です:
#
# data "aws_storagegateway_local_disk" "example" {
#   disk_node   = aws_volume_attachment.example.device_name
#   gateway_arn = aws_storagegateway_gateway.example.arn
# }
#
# resource "aws_storagegateway_upload_buffer" "example" {
#   disk_path   = data.aws_storagegateway_local_disk.example.disk_path
#   gateway_arn = aws_storagegateway_gateway.example.arn
# }
#
#---------------------------------------------------------------
# Stored Gateway タイプでの使用例:
#
#---------------------------------------------------------------
