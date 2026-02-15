#---------------------------------------
# AMI Copy
#---------------------------------------
# 他のリージョンまたは同一リージョン内でAMI（Amazon Machine Image）のコピーを作成する
# EBSスナップショットも含めて複製され、マルチリージョンデプロイメントでの利用が可能
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
#
# NOTE:
#   AMIのコピーには数分から数十分かかることがあります
#   コピー元AMIのEBSスナップショットも自動的に複製されます
#   クロスリージョンコピーおよび同一リージョン内コピーの両方をサポートします
#
# Terraform設定例
# https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/ami_copy
#---------------------------------------

#---------------------------------------
# 基本設定
#---------------------------------------
resource "aws_ami_copy" "example" {
  # 設定内容: コピー後のAMI名（リージョン内で一意）
  # 省略時: 省略不可（必須パラメータ）
  name = "my-copied-ami"

  # 設定内容: コピー元のAMI ID
  # 省略時: 省略不可（必須パラメータ）
  source_ami_id = "ami-0123456789abcdef0"

  # 設定内容: コピー元AMIが存在するリージョン
  # 省略時: 省略不可（必須パラメータ）
  source_ami_region = "us-west-1"

  #---------------------------------------
  # 暗号化設定
  #---------------------------------------
  # 設定内容: コピー先スナップショットの暗号化の有効化
  # 設定可能な値: true（暗号化する）、false（暗号化しない）
  # 省略時: false
  encrypted = false

  # 設定内容: スナップショット暗号化に使用するKMSキーの完全ARN
  # 省略時: デフォルトのAWS管理KMSキーを使用
  kms_key_id = null

  #---------------------------------------
  # Outposts設定
  #---------------------------------------
  # 設定内容: AMIのコピー先となるOutpostのARN
  # 省略時: リージョン内にコピー
  destination_outpost_arn = null

  #---------------------------------------
  # 説明とメタデータ
  #---------------------------------------
  # 設定内容: AMIの説明文
  # 省略時: 説明なし
  description = null

  # 設定内容: AMIが非推奨となる日時（RFC3339形式）
  # 省略時: 非推奨日時なし
  deprecation_time = null

  #---------------------------------------
  # リージョン設定
  #---------------------------------------
  # 設定内容: リソースを管理するAWSリージョン
  # 省略時: プロバイダー設定のリージョンを使用
  region = null

  #---------------------------------------
  # EBSブロックデバイス設定
  #---------------------------------------
  # 設定内容: AMIに関連付けられたEBSブロックデバイス（読み取り専用）
  # 省略時: コピー元AMIの設定を継承
  # ebs_block_device {
  #   # 以下の属性は全て参照専用（computed）で設定不可
  #   # - device_name          : デバイス名
  #   # - snapshot_id          : スナップショットID
  #   # - volume_size          : ボリュームサイズ（GB）
  #   # - volume_type          : ボリュームタイプ（gp2、gp3、io1、io2、st1、sc1）
  #   # - iops                 : プロビジョンドIOPS
  #   # - throughput           : スループット（MB/s）
  #   # - encrypted            : 暗号化の有無
  #   # - delete_on_termination: インスタンス終了時の削除設定
  #   # - outpost_arn          : Outpost ARN
  # }

  #---------------------------------------
  # エフェメラルブロックデバイス設定
  #---------------------------------------
  # 設定内容: AMIに関連付けられたエフェメラルブロックデバイス（読み取り専用）
  # 省略時: コピー元AMIの設定を継承
  # ephemeral_block_device {
  #   # 以下の属性は全て参照専用（computed）で設定不可
  #   # - device_name  : デバイス名
  #   # - virtual_name : 仮想デバイス名（ephemeral0など）
  # }

  #---------------------------------------
  # タグ設定
  #---------------------------------------
  # 設定内容: AMIに付与するタグのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-ami-copy"
    Environment = "production"
  }

  # 設定内容: プロバイダーのdefault_tagsとマージされた全タグ
  # 省略時: tags とプロバイダーのdefault_tagsがマージされる
  tags_all = null

  #---------------------------------------
  # タイムアウト設定
  #---------------------------------------
  # timeouts {
  #   # 設定内容: AMIコピー作成のタイムアウト時間
  #   # 省略時: デフォルトタイムアウト
  #   # create = "60m"
  #
  #   # 設定内容: AMIコピー更新のタイムアウト時間
  #   # 省略時: デフォルトタイムアウト
  #   # update = "60m"
  #
  #   # 設定内容: AMIコピー削除のタイムアウト時間
  #   # 省略時: デフォルトタイムアウト
  #   # delete = "90m"
  # }
}

#---------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------
# このリソースでは以下の属性が参照可能:
#
# - id                     : コピーされたAMIのID
# - arn                    : AMIのARN
# - architecture           : AMIのアーキテクチャ（x86_64、arm64など）
# - boot_mode              : AMIのブートモード
# - ena_support            : Enhanced Networkingのサポート有無
# - hypervisor             : ハイパーバイザーの種類（xen、nitroなど）
# - image_location         : AMIのS3ロケーション
# - image_owner_alias      : イメージ所有者のエイリアス
# - image_type             : イメージタイプ（machine、kernel、ramdisk）
# - imds_support           : IMDSバージョンのサポート状況
# - kernel_id              : カーネルID
# - last_launched_time     : 最後にインスタンス起動された日時
# - manage_ebs_snapshots   : EBSスナップショット管理の有無
# - owner_id               : AMI所有者のAWSアカウントID
# - platform               : プラットフォーム（windowsなど）
# - platform_details       : プラットフォームの詳細情報
# - public                 : AMIが公開されているかどうか
# - ramdisk_id             : ramdiskのID
# - root_device_name       : ルートデバイス名
# - root_snapshot_id       : ルートデバイスのスナップショットID
# - sriov_net_support      : SR-IOVネットワークサポート
# - tpm_support            : TPMサポート状況
# - uefi_data              : UEFIデータ
# - usage_operation        : 使用オペレーション
# - virtualization_type    : 仮想化タイプ（hvm、paravirtual）
