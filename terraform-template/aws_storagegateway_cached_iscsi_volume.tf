#---------------------------------------------------------------
# AWS Storage Gateway Cached iSCSI Volume
#---------------------------------------------------------------
#
# AWS Storage Gatewayのキャッシュ型iSCSIボリュームをプロビジョニングするリソースです。
# キャッシュ型iSCSIボリュームは、プライマリデータをAmazon S3に保存し、
# 頻繁にアクセスされるデータをローカルにキャッシュすることで、
# オンプレミスアプリケーションに低レイテンシーのブロックストレージアクセスを提供します。
#
# AWS公式ドキュメント:
#   - Volume Gateway概要: https://aws.amazon.com/storagegateway/volume/
#   - CreateCachediSCSIVolume API: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
#   - データ暗号化: https://docs.aws.amazon.com/storagegateway/latest/vgw/encryption.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_cached_iscsi_volume
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_cached_iscsi_volume" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # gateway_arn (Required)
  # 設定内容: ボリュームを作成するStorage GatewayのAmazon Resource Name (ARN)を指定します。
  # 設定可能な値: 有効なStorage Gateway ARN
  # 注意: ゲートウェイには事前にキャッシュストレージが追加されている必要があります。
  #       キャッシュが追加されていない場合、Storage Gateway APIはエラーを返します。
  #       (aws_storagegateway_cache リソースを使用してキャッシュを追加可能)
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  gateway_arn = "arn:aws:storagegateway:ap-northeast-1:123456789012:gateway/sgw-12345678"

  # network_interface_id (Required)
  # 設定内容: iSCSIターゲットを公開するゲートウェイのネットワークインターフェースを指定します。
  # 設定可能な値: IPv4アドレスのみ受け付けます
  # 注意: この設定により、イニシエーターがターゲットに接続する際のネットワークインターフェースが決定されます。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  network_interface_id = "10.0.1.100"

  # target_name (Required)
  # 設定内容: イニシエーターがターゲットに接続する際に使用するiSCSIターゲット名を指定します。
  # 設定可能な値: 文字列。ゲートウェイの全ボリューム間で一意である必要があります
  # 注意: この名前はターゲットARNのサフィックスとしても使用されます。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  target_name = "example-target"

  # volume_size_in_bytes (Required)
  # 設定内容: ボリュームのサイズをバイト単位で指定します。
  # 設定可能な値: 数値（バイト単位）
  # 注意: 既存のボリュームから作成する場合(source_volume_arn指定時)、
  #       この値は既存ボリュームのサイズ以上である必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  volume_size_in_bytes = 5368709120 # 5 GB

  #-------------------------------------------------------------
  # リソース識別子設定
  #-------------------------------------------------------------

  # id (Optional, Computed)
  # 設定内容: リソースの識別子を指定します。
  # 設定可能な値: 文字列
  # 省略時: リソース作成後にAWSが自動的に生成します（ボリュームARN）
  # 注意: 通常は設定不要です。Terraformがリソース作成後に自動的に取得します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_cached_iscsi_volume
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

  #-------------------------------------------------------------
  # ボリュームソース設定
  #-------------------------------------------------------------

  # snapshot_id (Optional)
  # 設定内容: 新しいキャッシュボリュームとして復元するスナップショットのIDを指定します。
  # 設定可能な値: 有効なEBSスナップショットID（例: snap-1122aabb）
  # 注意: source_volume_arnと排他的（どちらか一方のみ指定可能）
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  snapshot_id = null

  # source_volume_arn (Optional)
  # 設定内容: 既存ボリュームのARNを指定して、その最新のリカバリポイントの正確なコピーを作成します。
  # 設定可能な値: 有効なボリュームARN
  # 注意: snapshot_idと排他的（どちらか一方のみ指定可能）
  #       この新しいボリュームのvolume_size_in_bytes値は、既存ボリュームのサイズ以上である必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_CreateCachediSCSIVolume.html
  source_volume_arn = null

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # kms_encrypted (Optional)
  # 設定内容: Amazon S3のサーバーサイド暗号化にAWS KMSキーを使用するか、
  #           Amazon S3管理キーを使用するかを指定します。
  # 設定可能な値:
  #   - true: 独自のAWS KMSキーを使用してAmazon S3サーバーサイド暗号化を行います
  #   - false: Amazon S3が管理するキーを使用します
  # 省略時: false（Amazon S3管理キーを使用）
  # 注意: trueに設定した場合、kms_keyの指定が必須となります。
  #       KMSキーで暗号化されたボリュームから暗号化されていないボリュームは作成できません。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/vgw/encryption.html
  kms_encrypted = false

  # kms_key (Optional)
  # 設定内容: Amazon S3のサーバーサイド暗号化に使用するAWS KMSキーのARNを指定します。
  # 設定可能な値: 有効な対称型KMSキーのARN
  # 注意: kms_encrypted が true に設定されている場合に必須です。
  #       対称キーのみサポートされています。
  #       KMSキーが削除、無効化、またはグラント トークンが取り消された場合、
  #       ボリューム上のデータへのアクセスは失われます。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/vgw/encryption.html
  kms_key = null

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
    Name        = "example-cached-iscsi-volume"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: リソースに割り当てられるすべてのタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: tagsとプロバイダーのdefault_tagsが自動的にマージされます
  # 注意: 通常は設定不要です。プロバイダーのdefault_tagsとリソースのtagsが
  #       自動的にマージされた結果が格納されます。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags_all = null
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: ボリュームのAmazon Resource Name (ARN)
#        例: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678
#
# - chap_enabled: iSCSIターゲットに対してmutual CHAPが有効になっているかを示すブール値
#
# - id: ボリュームのAmazon Resource Name (ARN)
#
# - lun_number: 論理ディスク番号
#
# - network_interface_port: iSCSIターゲットとの通信に使用するポート
#
# - target_arn: ターゲットのAmazon Resource Name (ARN)
#               例: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/target/iqn.1997-05.com.amazon:TargetName
#
# - volume_arn: ボリュームのAmazon Resource Name (ARN)
#               例: arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678
#
# - volume_id: ボリュームID
#              例: vol-12345678
#
#---------------------------------------------------------------
