#---------------------------------------------------------------
# AWS AMI Copy
#---------------------------------------------------------------
#
# Amazon Machine Image (AMI) をコピーするリソースです。
# リージョン間でのAMIコピー（クロスリージョンコピー）を含む、AMIの複製を可能にします。
#
# ソースAMIに関連付けられたEBSスナップショットがある場合、それらもAMIと一緒に
# 複製されます。これは、1つのリージョンでプロビジョニングされたAMIを別の
# リージョンでも利用可能にするマルチリージョンデプロイメントに有用です。
#
# AMIのコピーには数分かかる場合があります。このリソースの作成は、新しいAMIが
# 新しいインスタンスで使用可能になるまでブロックされます。
#
# AWS公式ドキュメント:
#   - AMIコピーの仕組み: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ami-copy-works.html
#   - AMIのコピー: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/CopyingAMIs.html
#   - AMIの非推奨化: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-deprecate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_copy
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ami_copy" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: AMIのリージョン内で一意の名前を指定します。
  # 設定可能な値: 文字列
  # 注意: このAMIを識別するための名前です。
  name = "my-copied-ami"

  # source_ami_id (Required)
  # 設定内容: コピー元のAMI IDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-xxxxxxxx）
  # 注意: このIDはsource_ami_regionで指定したリージョンで有効である必要があります。
  source_ami_id = "ami-xxxxxxxx"

  # source_ami_region (Required)
  # 設定内容: コピー元のAMIが存在するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-west-1, ap-northeast-1）
  # 注意: 同じリージョン内でコピーを作成する場合は、AWSプロバイダーの
  #       リージョンと同じ値を指定できます。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  source_ami_region = "us-west-1"

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
  # 説明設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: AMIの説明を指定します。
  # 設定可能な値: 文字列
  # 用途: AMIの目的や内容を説明するために使用します。
  description = "Copied AMI from us-west-1"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encrypted (Optional)
  # 設定内容: コピー先イメージのスナップショットを暗号化するかを指定します。
  # 設定可能な値:
  #   - true: スナップショットを暗号化
  #   - false (デフォルト): 暗号化しない（ソースの暗号化状態を維持）
  # 関連機能: AMIコピー時の暗号化
  #   暗号化されていないAMIを暗号化されたAMIにコピーすることは可能ですが、
  #   暗号化されたAMIを暗号化されていないAMIにコピーすることはできません。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ami-copy-works.html#ami-copy-encryption
  encrypted = false

  # kms_key_id (Optional)
  # 設定内容: スナップショットの暗号化に使用するKMSキーのフルARNを指定します。
  # 設定可能な値: 有効なKMSキーARN
  # 省略時: 指定しない場合はデフォルトのAWS KMSキーが使用されます。
  # 関連機能: KMSによるスナップショット暗号化
  #   カスタマーマネージドキーを使用してスナップショットを暗号化できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ami-copy-works.html#ami-copy-encryption
  kms_key_id = null

  #-------------------------------------------------------------
  # Outpost設定
  #-------------------------------------------------------------

  # destination_outpost_arn (Optional)
  # 設定内容: AMIのコピー先となるOutpostのARNを指定します。
  # 設定可能な値: 有効なOutpost ARN
  # 注意: AWSリージョンからOutpostにAMIをコピーする場合のみ指定してください。
  #       AMIはコピー先Outpostのリージョン内に存在する必要があります。
  destination_outpost_arn = null

  #-------------------------------------------------------------
  # 非推奨化設定
  #-------------------------------------------------------------

  # deprecation_time (Optional)
  # 設定内容: AMIを非推奨とする日時を指定します。
  # 設定可能な値: ISO 8601形式の日時文字列（例: 2025-05-01T00:00:00.000Z）
  # 関連機能: AMI非推奨化
  #   非推奨化されたAMIは削除されませんが、DescribeImages APIや
  #   EC2コンソールで他のユーザーには表示されなくなります。
  #   既存のインスタンスや起動設定には影響しません。
  #   - プライベートAMI: 最大10年先まで設定可能
  #   - パブリックAMI: AMI作成日から最大2年先まで設定可能
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-deprecate.html
  deprecation_time = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #       一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-copied-ami"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソースの作成・更新・削除操作のタイムアウト時間を指定します。
  # 注意: AMIのコピーには数分かかる場合があります。大きなAMIの場合は
  #       タイムアウト値を増やすことを検討してください。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "40m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "40m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "90m", "1h"）
    # 省略時: デフォルトのタイムアウト値
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AMIのAmazon Resource Name (ARN)
# - id: 作成されたAMIのID
# - architecture: AMIのアーキテクチャ（例: x86_64, arm64）
# - boot_mode: ブートモード（例: legacy-bios, uefi）
# - ena_support: ENA (Elastic Network Adapter) サポートの有無
# - hypervisor: ハイパーバイザータイプ（例: xen, nitro）
# - image_location: AMIのロケーション
# - image_owner_alias: AMI所有者のエイリアス
# - image_type: イメージタイプ（例: machine）
# - imds_support: インスタンスメタデータサービスのサポート
# - kernel_id: カーネルID
# - last_launched_time: 最後にインスタンスを起動した時刻
# - manage_ebs_snapshots: EBSスナップショット管理の有無
# - owner_id: AMI所有者のAWSアカウントID
# - platform: プラットフォーム（Windowsの場合は "windows"）
# - platform_details: プラットフォームの詳細
# - public: AMIがパブリックかどうか
# - ramdisk_id: RAMディスクID
# - root_device_name: ルートデバイス名（例: /dev/sda1）
# - root_snapshot_id: ルートデバイスのスナップショットID
# - sriov_net_support: SR-IOVネットワーキングサポート
# - tpm_support: TPMサポート
# - uefi_data: UEFIデータ
# - usage_operation: 使用操作
# - virtualization_type: 仮想化タイプ（例: hvm, paravirtual）
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#
# block型属性（computed only）:
# - ebs_block_device: EBSブロックデバイスのセット
#   - delete_on_termination: インスタンス終了時に削除するか
#   - device_name: デバイス名
#   - encrypted: 暗号化されているか
#   - iops: IOPS値
#   - outpost_arn: Outpost ARN
#   - snapshot_id: スナップショットID
#   - throughput: スループット
#   - volume_size: ボリュームサイズ（GiB）
#   - volume_type: ボリュームタイプ
#
# - ephemeral_block_device: エフェメラルブロックデバイスのセット
#   - device_name: デバイス名
#   - virtual_name: 仮想名
#---------------------------------------------------------------
