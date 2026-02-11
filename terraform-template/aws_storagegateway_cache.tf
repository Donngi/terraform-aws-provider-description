#---------------------------------------------------------------
# AWS Storage Gateway Cache
#---------------------------------------------------------------
#
# AWS Storage Gatewayのキャッシュストレージを構成するリソースです。
# ゲートウェイのローカルディスクをキャッシュとして設定し、
# 頻繁にアクセスされるデータへの低レイテンシアクセスを提供します。
# キャッシュボリューム型、テープ型、ファイルゲートウェイで使用されます。
#
# AWS公式ドキュメント:
#   - Storage Gateway概要: https://docs.aws.amazon.com/storagegateway/latest/userguide/StorageGatewayConcepts.html
#   - ローカルディスク管理: https://docs.aws.amazon.com/storagegateway/latest/vgw/ManagingLocalStorage-common.html
#   - AddCache API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddCache.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_cache
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_cache" "example" {
  #-------------------------------------------------------------
  # ディスク設定
  #-------------------------------------------------------------

  # disk_id (Required)
  # 設定内容: キャッシュとして構成するローカルディスクの識別子を指定します。
  # 設定可能な値: ローカルディスク識別子（例: pci-0000:03:00.0-scsi-0:0:0:0）
  # 関連機能: Storage Gateway ローカルディスク管理
  #   ゲートウェイVMはオンプレミスで割り当てられたローカルディスクを
  #   バッファリングとストレージに使用します。EC2インスタンス上に作成された
  #   ゲートウェイの場合、Amazon EBSボリュームがローカルディスクとして使用されます。
  #   キャッシュストレージは、データへの低レイテンシアクセスを提供し、
  #   Amazon S3へのアップロード待ちデータの永続的なストアとして機能します。
  #   最低でも150 GiBのディスクが1つ必要です。
  #   - https://docs.aws.amazon.com/storagegateway/latest/vgw/ManagingLocalStorage-common.html
  # 注意: ディスクIDはListLocalDisks APIまたはaws_storagegateway_local_diskデータソースから取得可能
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddCache.html
  disk_id = data.aws_storagegateway_local_disk.example.id

  #-------------------------------------------------------------
  # ゲートウェイ設定
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: キャッシュを追加するStorage GatewayのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN（50-500文字）
  # 関連機能: Storage Gateway
  #   キャッシュボリューム型、テープ型、ファイルゲートウェイで使用されます。
  #   これらのゲートウェイタイプでは、ローカルディスクをキャッシュとして構成し、
  #   頻繁にアクセスされるデータをローカルに保持することで
  #   パフォーマンスを向上させます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/StorageGatewayConcepts.html
  # 注意: ListGateways APIまたはaws_storagegateway_gatewayリソースから取得可能
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddCache.html
  gateway_arn = aws_storagegateway_gateway.example.arn

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
# - id: ゲートウェイのAmazon Resource Name (ARN)とローカルディスク識別子を
#       組み合わせた識別子
#
# 注意:
# - Storage Gateway APIはキャッシュディスクを削除するメソッドを提供していません。
#   このTerraformリソースを破棄しても、Storage Gateway上で実際の削除操作は
#   実行されません。リソースはTerraform stateからのみ削除されます。
#---------------------------------------------------------------
