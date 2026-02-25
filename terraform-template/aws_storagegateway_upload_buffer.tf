#---------------------------------------------------------------
# AWS Storage Gateway Upload Buffer
#---------------------------------------------------------------
#
# AWS Storage Gatewayのゲートウェイにアップロードバッファディスクを
# 設定するリソースです。アップロードバッファは、ゲートウェイがAWSクラウドへの
# データ転送時に一時的にデータを格納する領域として使用されます。
# Cached Volume Gateway、Stored Volume Gateway、Tape Gatewayの各タイプで
# サポートされています。
#
# 注意: Storage Gateway APIはアップロードバッファディスクの削除手段を提供しないため、
# このリソースをdestroyしてもStorage Gatewayの設定には変更は加えられません。
#
# AWS公式ドキュメント:
#   - AddUploadBuffer API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddUploadBuffer.html
#   - アップロードバッファの設定: https://docs.aws.amazon.com/storagegateway/latest/vgw/ConfiguringLocalDiskStorage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_upload_buffer
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_upload_buffer" "example" {
  #-------------------------------------------------------------
  # ゲートウェイ設定
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: アップロードバッファを設定するゲートウェイのARNを指定します。
  # 設定可能な値: 有効なStorage GatewayのARN文字列
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddUploadBuffer.html
  gateway_arn = "arn:aws:storagegateway:ap-northeast-1:123456789012:gateway/sgw-12345678"

  #-------------------------------------------------------------
  # ディスク設定
  #-------------------------------------------------------------

  # disk_id (Optional)
  # 設定内容: アップロードバッファとして割り当てるローカルディスクの識別子を指定します。
  # 設定可能な値: ローカルディスクの識別子文字列（例: "pci-0000:03:00.0-scsi-0:0:0:0"）
  # 省略時: Terraformが値を算出します
  # 注意: disk_idとdisk_pathはどちらか一方を指定してください。
  #       Stored Volume GatewayタイプではこのパラメータでディスクIDを指定します。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddUploadBuffer.html
  disk_id = null

  # disk_path (Optional)
  # 設定内容: アップロードバッファとして割り当てるローカルディスクのパスを指定します。
  # 設定可能な値: ローカルディスクのパス文字列（例: "/dev/nvme1n1"）
  # 省略時: Terraformが値を算出します
  # 注意: disk_idとdisk_pathはどちらか一方を指定してください。
  #       Cached Volume GatewayタイプおよびVTL Gatewayタイプではこのパラメータでディスクパスを指定します。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/vgw/ConfiguringLocalDiskStorage.html
  disk_path = "/dev/nvme1n1"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
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
# - id: ゲートウェイのARNとローカルディスク識別子を組み合わせた値
#---------------------------------------------------------------
