#---------------------------------------------------------------
# AWS AMI from Instance
#---------------------------------------------------------------
#
# 既存のEBSバックドEC2インスタンスをベースにAmazon Machine Image (AMI)を
# 作成するリソースです。
#
# 作成されたAMIは、インスタンスのEBSボリュームの暗黙的に作成されたスナップショットを
# 参照し、リソース作成時点で割り当てられたブロックデバイス構成を模倣します。
#
# このリソースは、インスタンスが停止している状態で適用することが推奨されます。
# 実行中のインスタンスに適用した場合、スナップショット取得前にインスタンスが
# 停止され、その後再起動されるため、ダウンタイムが発生します。
#
# 注意: ソースインスタンスはこのリソースの初回作成時のみ検査されます。
#       参照されているインスタンスへの継続的な更新は、生成されたAMIには
#       反映されません。新しいスナップショットを作成するには、リソースを
#       taintするか再作成する必要があります。
#
# AWS公式ドキュメント:
#   - AMI概要: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html
#   - AMIの廃止: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-deprecate.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_from_instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ami_from_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: AMIの名前を指定します。
  # 設定可能な値: リージョン内で一意の文字列
  # 注意: AMI名はリージョン内で一意である必要があります。
  name = "my-ami-from-instance"

  # source_instance_id (Required, Forces new resource)
  # 設定内容: AMIのベースとなるインスタンスのIDを指定します。
  # 設定可能な値: 有効なEC2インスタンスID（例: i-xxxxxxxx）
  # 注意: EBSバックドインスタンスである必要があります。
  source_instance_id = "i-0123456789abcdef0"

  #-------------------------------------------------------------
  # オプション設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: AMIの説明を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: AMIの用途や作成理由を記録するために使用します。
  description = "AMI created from my EC2 instance"

  # snapshot_without_reboot (Optional)
  # 設定内容: スナップショット取得前にインスタンスを停止する動作を
  #           オーバーライドするかを指定します。
  # 設定可能な値:
  #   - true: インスタンスを停止せずにスナップショットを取得
  #   - false (デフォルト): インスタンスを停止してからスナップショットを取得
  # 注意: trueを設定すると、ファイルシステムの整合性が保証されない
  #       スナップショットが作成されるリスクがあります。ユーザーが
  #       スナップショット時点でファイルシステムへの書き込みが行われない
  #       ことを保証できる場合にのみ使用してください。
  # 用途: ダウンタイムを回避したい場合に使用します。
  snapshot_without_reboot = false

  # deprecation_time (Optional)
  # 設定内容: AMIを廃止（非推奨）にする日時をUTCで指定します。
  # 設定可能な値: ISO 8601形式の日時文字列（例: "2025-12-31T23:59:59Z"）
  # 関連機能: AMI廃止機能
  #   AMIを廃止すると、そのAMIは古くなっており新しいユーザーは使用すべきでない
  #   ことを示します。廃止されたAMIは削除されませんが、IDが既知でない限り
  #   EC2コンソールやAPI呼び出しで新しいユーザーが発見できなくなります。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-deprecate.html
  # 注意:
  #   - 過去の日時は指定できません
  #   - パブリックAMIの場合、作成日から2年が上限
  #   - その他のAMIの場合、現在から10年が上限
  deprecation_time = null

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
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html
  tags = {
    Name        = "my-ami-from-instance"
    Environment = "production"
  }

  # tags_all (Optional, Computed)
  # 設定内容: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
  #           リソースに割り当てられたすべてのタグのマップ。
  # 注意: 通常は明示的に設定する必要はありません。
  #       プロバイダーレベルのdefault_tagsと個別のtagsが自動的にマージされます。

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "40m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    # 用途: 大容量のEBSボリュームを持つインスタンスからAMIを作成する場合、
    #       スナップショット作成に時間がかかるため、タイムアウトを延長することがあります。
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "40m", "1h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除時のタイムアウトを指定します。
    # 設定可能な値: 時間文字列（例: "90m", "2h"）
    # 省略時: デフォルトのタイムアウト値が使用されます
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# 基本属性:
# - id: 作成されたAMIのID
# - arn: AMIのAmazon Resource Name (ARN)
#
# インスタンス情報から継承される属性:
# - architecture: AMIのアーキテクチャ（i386, x86_64, arm64など）
# - boot_mode: AMIのブートモード（legacy-bios, uefi, uefi-preferredなど）
# - ena_support: ENA（Elastic Network Adapter）による拡張ネットワーキングが
#                有効かどうか
# - hypervisor: AMIのハイパーバイザータイプ（xenなど）
# - image_location: AMIの場所
# - image_owner_alias: AMIの所有者エイリアス
# - image_type: AMIのタイプ（machine, kernel, ramdisk）
# - imds_support: IMDSv2がAMIで指定されているかどうか
# - kernel_id: AMIに関連付けられたカーネルID（存在する場合）
# - last_launched_time: AMIが最後にEC2インスタンスの起動に使用された日時
# - manage_ebs_snapshots: EBSスナップショットの管理が有効かどうか
# - owner_id: AMIを所有するAWSアカウントのID
# - platform: AMIのプラットフォーム（Windows AMIの場合は"windows"）
# - platform_details: AMIの課金コードに関連付けられたプラットフォームの詳細
# - public: AMIがパブリック起動許可を持っているかどうか
# - ramdisk_id: AMIに関連付けられたRAMディスクID（存在する場合）
# - root_device_name: ルートデバイスボリュームのデバイス名
# - root_snapshot_id: ルートデバイスのスナップショットID
# - sriov_net_support: Intel 82599仮想ファンクションインターフェースによる
#                      拡張ネットワーキングが有効かどうか
# - tpm_support: NitroTPMサポート用に構成されている場合は"v2.0"
# - uefi_data: UEFIデータ
# - usage_operation: EC2インスタンスの操作とAMIに関連付けられた課金コード
# - virtualization_type: AMIの仮想化タイプ
#
# ブロックデバイス情報:
# - ebs_block_device: EBSブロックデバイスのセット
#   - delete_on_termination: 終了時に削除するかどうか
#   - device_name: デバイス名
#   - encrypted: 暗号化されているかどうか
#   - iops: IOPS値
#   - outpost_arn: Outpost ARN
#   - snapshot_id: スナップショットID
#   - throughput: スループット
#   - volume_size: ボリュームサイズ
#   - volume_type: ボリュームタイプ
#
# - ephemeral_block_device: エフェメラルブロックデバイスのセット
#   - device_name: デバイス名
#   - virtual_name: 仮想名
#
# タグ:
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
