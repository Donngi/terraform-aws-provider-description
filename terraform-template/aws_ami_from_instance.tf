#---------------------------------------------------------------
# EC2 AMI from Instance
#---------------------------------------------------------------
#
# 既存のEBSバックアップEC2インスタンスからAmazon Machine Image (AMI)を作成するリソースです。
# 作成されたAMIは、インスタンスのEBSボリュームのスナップショットを参照し、
# リソース作成時点のブロックデバイス設定を模倣します。
#
# このリソースは、インスタンスが停止している状態で適用すると、
# 作成されるイメージの内容が予測可能になります。実行中のインスタンスに適用すると、
# スナップショット取得前にインスタンスが停止され、完了後に再起動されます。
#
# AWS公式ドキュメント:
#   - EBSバックアップAMIの作成: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html
#   - CreateImage API: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateImage.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_from_instance
#
# Provider Version: 6.28.0
# Generated: 2026-02-11
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ami_from_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required)
  # 設定内容: AMIの名前（リージョン内で一意）
  # 設定可能な値: 3-128文字の英数字、スペース、括弧、ピリオド、スラッシュ、ダッシュ、アポストロフィ
  # 省略時: 設定必須
  name = "example-ami-from-instance"

  # source_instance_id (Required)
  # 設定内容: AMIを作成する元となるEC2インスタンスID
  # 設定可能な値: 有効なEC2インスタンスID（i-で始まる文字列）
  # 省略時: 設定必須
  source_instance_id = "i-1234567890abcdef0"

  #-------------------------------------------------------------
  # AMI説明・メタデータ設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: AMIの説明文
  # 設定可能な値: 任意の文字列
  # 省略時: 説明なし
  description = "Example AMI created from running instance"

  # deprecation_time (Optional)
  # 設定内容: AMIの非推奨日時（ISO 8601形式）
  # 設定可能な値: RFC3339形式の日時文字列（例: 2025-12-31T23:59:59Z）
  # 省略時: 非推奨日時未設定
  deprecation_time = "2025-12-31T23:59:59Z"

  #-------------------------------------------------------------
  # スナップショット作成設定
  #-------------------------------------------------------------

  # snapshot_without_reboot (Optional)
  # 設定内容: スナップショット作成時にインスタンスを停止しないフラグ
  # 設定可能な値: true（停止せずスナップショット）、false（停止してスナップショット）
  # 省略時: false（インスタンスを停止してからスナップショットを作成）
  # 注意: trueに設定すると、ファイルシステムの整合性が保証されない可能性があります
  snapshot_without_reboot = false

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: AMIを作成するAWSリージョン
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1、ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  region = "us-east-1"

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: AMIに付与するタグ
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  tags = {
    Name        = "example-ami"
    Environment = "production"
    CreatedBy   = "terraform"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: AMI作成処理のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 40m、1h）
    # 省略時: 40m
    create = "40m"

    # update (Optional)
    # 設定内容: AMI更新処理のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 40m、1h）
    # 省略時: 40m
    update = "40m"

    # delete (Optional)
    # 設定内容: AMI削除処理のタイムアウト時間
    # 設定可能な値: 時間文字列（例: 90m、2h）
    # 省略時: 90m
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# arn                   - AMIのARN
# id                    - AMIのID
# architecture          - AMIのアーキテクチャ（x86_64、i386、arm64など）
# boot_mode             - AMIのブートモード（legacy-bios、uefi、uefi-preferred）
# ena_support           - 拡張ネットワーキングサポートの有効化状態
# hypervisor            - AMIのハイパーバイザータイプ（xen、nitro）
# image_location        - AMIのS3上の保存場所
# image_owner_alias     - AMIの所有者エイリアス
# image_type            - AMIのタイプ（machine、kernel、ramdisk）
# imds_support          - IMDSv2サポート状態（v2.0）
# kernel_id             - カーネルID（PV AMIの場合）
# last_launched_time    - AMIが最後に起動された日時
# manage_ebs_snapshots  - EBSスナップショット管理フラグ
# owner_id              - AMIの所有者のAWSアカウントID
# platform              - プラットフォーム（windows等）
# platform_details      - プラットフォーム詳細情報
# public                - AMIの公開状態
# ramdisk_id            - RAMディスクID（PV AMIの場合）
# root_device_name      - ルートデバイス名（/dev/sda1等）
# root_snapshot_id      - ルートボリュームのスナップショットID
# sriov_net_support     - SR-IOVネットワークサポート状態
# tags_all              - デフォルトタグを含む全タグ
# tpm_support           - TPMサポート状態（v2.0）
# uefi_data             - UEFIデータ
# usage_operation       - 使用オペレーション情報
# virtualization_type   - 仮想化タイプ（hvm、paravirtual）
# ebs_block_device      - EBSブロックデバイス設定（読み取り専用）
# ephemeral_block_device - エフェメラルブロックデバイス設定（読み取り専用）
