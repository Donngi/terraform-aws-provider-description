#---------------------------------------------------------------
# Storage Gateway Stored iSCSI Volume
#---------------------------------------------------------------
#
# AWS Storage GatewayのStored iSCSIボリュームを管理します。
# Stored modeでは、プライマリデータはローカルに保存され、
# Amazon S3に非同期的にバックアップされます。
#
# 注意: ボリュームがクライアントから操作可能になるには、
# ゲートウェイに動作するストレージが追加されている必要があります
# (例: aws_storagegateway_working_storageリソース経由)。
# ただし、Storage Gateway APIは動作ストレージが未設定でもボリューム作成を
# エラーなく許可し、ステータスを「WORKING STORAGE NOT CONFIGURED」として返します。
#
# AWS公式ドキュメント:
#   - StorediSCSIVolume API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_StorediSCSIVolume.html
#   - Volume Gateway: https://aws.amazon.com/storagegateway/volume/
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_stored_iscsi_volume
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_stored_iscsi_volume" "example" {
  #-------------------------------------------------------------
  # ゲートウェイ設定
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: ゲートウェイのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN
  # 関連機能: AWS Storage Gateway
  #   ストレージゲートウェイは、オンプレミスアプリケーションにクラウドベースの
  #   iSCSIブロックストレージボリュームを提供するサービスです。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateStorediSCSIVolume.html
  gateway_arn = "arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678"

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # network_interface_id (Required)
  # 設定内容: iSCSIターゲットを公開するゲートウェイのネットワークインターフェイスを指定します。
  # 設定可能な値: IPv4アドレスのみ受け付けます
  # 関連機能: iSCSI接続
  #   イニシエーターがこのネットワークインターフェイスを通じてボリュームに接続します。
  #   通常はEC2インスタンスのプライベートIPアドレスまたはオンプレミス環境の
  #   ゲートウェイアプライアンスのIPアドレスを指定します。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/GettingStarted-create-storediscsi-volume.html
  network_interface_id = "10.0.1.10"

  #-------------------------------------------------------------
  # ターゲット設定
  #-------------------------------------------------------------

  # target_name (Required)
  # 設定内容: iSCSIターゲット名を指定します。
  # 設定可能な値:
  #   - パターン: ^[-\.;a-z0-9]+$
  #   - 長さ: 1-200文字
  # 関連機能: iSCSI Target
  #   イニシエーターがターゲットに接続する際に使用する名前であり、
  #   ターゲットARNのサフィックスとしても使用されます。
  #   例: "myvolume" を指定すると、ターゲットARNは
  #   arn:aws:storagegateway:region:account-id:gateway/gateway-id/target/iqn.1997-05.com.amazon:myvolume
  #   となります。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_StorediSCSIVolume.html
  # 注意: ゲートウェイの全ボリュームで一意である必要があります
  target_name = "myvolume"

  #-------------------------------------------------------------
  # ディスク設定
  #-------------------------------------------------------------

  # disk_id (Required)
  # 設定内容: Stored volumeとして設定されたゲートウェイローカルディスクの一意識別子を指定します。
  # 設定可能な値: ゲートウェイに接続されているローカルディスクのID
  # 関連機能: ローカルディスク割り当て
  #   data.aws_storagegateway_local_diskデータソースを使用して、
  #   利用可能なローカルディスクのIDを取得できます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateStorediSCSIVolume.html
  disk_id = data.aws_storagegateway_local_disk.example.id

  # preserve_existing_data (Required)
  # 設定内容: ローカルディスク上の既存データを保持するかどうかを指定します。
  # 設定可能な値:
  #   - true: ローカルディスク上の既存データを保持する
  #   - false: 空のボリュームを作成する
  # 関連機能: データ保持
  #   既存のローカルストレージからデータを移行する場合は true を指定し、
  #   新しい空のボリュームを作成する場合は false を指定します。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_StorediSCSIVolume.html
  preserve_existing_data = false

  #-------------------------------------------------------------
  # スナップショット設定
  #-------------------------------------------------------------

  # snapshot_id (Optional)
  # 設定内容: 新しいStored volumeとして復元するスナップショットのIDを指定します。
  # 設定可能な値:
  #   - パターン: \Asnap-([0-9A-Fa-f]{8}|[0-9A-Fa-f]{17})\z
  #   - 例: snap-1122aabb
  # 省略時: スナップショットからの復元は行われません
  # 関連機能: スナップショットからのボリューム復元
  #   既存のEBSスナップショットまたは以前のStorage Gateway volumeのスナップショットから
  #   ボリュームを復元する場合に使用します。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_StorediSCSIVolume.html
  snapshot_id = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_encrypted (Optional)
  # 設定内容: Amazon S3サーバーサイド暗号化でAWS KMSキーを使用するかどうかを指定します。
  # 設定可能な値:
  #   - true: 独自のAWS KMSキーを使用したAmazon S3サーバーサイド暗号化を使用
  #   - false: Amazon S3が管理するキーを使用
  # 省略時: false（Amazon S3管理キーを使用）
  # 関連機能: KMS暗号化
  #   ボリュームデータのAmazon S3バックアップに対して暗号化を適用します。
  #   trueを設定した場合、kms_keyパラメーターでKMSキーARNを指定する必要があります。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/WorkingWithVolumes.html
  kms_encrypted = false

  # kms_key (Optional)
  # 設定内容: Amazon S3サーバーサイド暗号化に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値:
  #   - パターン: (^arn:(aws(|-cn|-us-gov|-iso[A-Za-z0-9_-]*)):kms:([a-zA-Z0-9-]+):([0-9]+):(key|alias)/(\\S+)$)|(^alias/(\\S+)$)
  #   - 例: arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012
  #   - または: alias/my-kms-key-alias
  #   - 長さ: 7-2048文字
  # 省略時: kms_encrypted = false の場合、この値は無視されます
  # 関連機能: KMS暗号化
  #   kms_encrypted = true の場合のみ設定可能です。
  #   Storage Gatewayは非対称KMSキーをサポートしていません。対称KMSキーのみ使用可能です。
  #   - https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_StorediSCSIVolume.html
  # 注意: この値はkms_encrypted = trueの場合のみ有効です
  kms_key = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: リージョナルエンドポイント
  #   リソースをプロバイダー設定とは異なるリージョンで管理したい場合に使用します。
  #   - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、このリソースレベルで定義されたもので上書きされます。
  #   - https://docs.aws.amazon.com/storagegateway/latest/userguide/tagging-resources-common.html
  tags = {
    Name        = "example-stored-iscsi-volume"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられたすべてのタグのマップです。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: プロバイダーのdefault_tags設定ブロックで定義されたタグが自動的に含まれます
  # 関連機能: プロバイダーdefault_tags
  #   プロバイダーレベルで定義されたdefault_tagsを含む、
  #   リソースに割り当てられたすべてのタグのマップです。
  #   通常は明示的に指定する必要はありません。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null

  #-------------------------------------------------------------
  # リソース識別子
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: Terraform内部で使用されるリソース識別子です。
  # 設定可能な値: Volume Amazon Resource Name (ARN)
  # 省略時: Terraformによって自動的に計算されます
  # 関連機能: リソースID
  #   通常は指定不要です。TerraformがリソースのARNを自動的に割り当てます。
  #   形式: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678
  id = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ボリュームのAmazon Resource Name (ARN)
#        形式: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678
#
# - chap_enabled: iSCSIターゲットに対してmutual CHAP（Challenge-Handshake Authentication Protocol）が
#                 有効かどうかを示すブール値
#
# - id: ボリュームのAmazon Resource Name (ARN)
#       形式: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678
#
# - lun_number: 論理ディスク番号
#
# - network_interface_port: iSCSIターゲットとの通信に使用されるポート番号
#
# - target_arn: ターゲットのAmazon Resource Name (ARN)
#               形式: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/target/iqn.1997-05.com.amazon:TargetName
#
# - volume_id: ボリュームID
#              形式: vol-12345678
#
# - volume_size_in_bytes: ボリュームに保存されているデータのサイズ（バイト単位）
#---------------------------------------------------------------
