#---------------------------------------------------------------
# AWS Storage Gateway Working Storage
#---------------------------------------------------------------
#
# Storage Gateway のワーキングストレージ（作業用ディスク）を管理するリソースです。
# ワーキングストレージは、Stored Volumes ゲートウェイがデータをAWSに
# アップロードする際の一時バッファとして使用されるローカルディスクです。
#
# 重要な注意事項:
#   - Storage Gateway APIにはワーキングストレージディスクを削除する方法がありません。
#     このリソースをTerraformで破棄しても、Storage Gateway側では何も変更されません。
#   - ワーキングストレージは Stored Volumes ゲートウェイタイプで使用されます。
#
# AWS公式ドキュメント:
#   - Storage Gateway 概要: https://docs.aws.amazon.com/storagegateway/latest/userguide/WhatIsStorageGateway.html
#   - ローカルディスクの管理: https://docs.aws.amazon.com/storagegateway/latest/userguide/ManagingLocalStorage-common.html
#   - API リファレンス (AddWorkingStorage): https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_AddWorkingStorage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_working_storage
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_working_storage" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # disk_id (Required)
  # 設定内容: ワーキングストレージとして使用するローカルディスクの識別子を指定します。
  # 設定可能な値: ローカルディスクのID文字列（例: "pci-0000:03:00.0-scsi-0:0:0:0"）
  # 関連機能: Storage Gateway ローカルディスク
  #   ゲートウェイVMに割り当てたローカルディスクをワーキングストレージとして構成します。
  #   通常は data.aws_storagegateway_local_disk データソースを使用してディスクIDを取得します。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/ManagingLocalStorage-common.html
  disk_id = data.aws_storagegateway_local_disk.example.id

  # gateway_arn (Required)
  # 設定内容: ワーキングストレージを追加するゲートウェイのARNを指定します。
  # 設定可能な値: Storage Gateway の Amazon Resource Name (ARN)
  # 関連機能: Storage Gateway ゲートウェイ
  #   対象のゲートウェイを一意に識別するARN。aws_storagegateway_gateway リソースから取得できます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/WhatIsStorageGateway.html
  gateway_arn = aws_storagegateway_gateway.example.arn
}
