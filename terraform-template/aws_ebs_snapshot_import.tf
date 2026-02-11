#---------------------------------------------------------------
# AWS EBS Snapshot Import
#---------------------------------------------------------------
#
# S3からディスクイメージをインポートしてEBSスナップショットを作成するリソースです。
# このリソースを使用すると、VHDまたはVMDK形式のディスクイメージをS3バケットから
# EBSスナップショットとしてインポートできます。
#
# インポートされたスナップショットは、通常のEBSスナップショットと同様に
# EC2インスタンスのEBSボリューム作成やAMI作成に使用できます。
#
# 関連リソース:
#   - スナップショットのコピー: `aws_ebs_snapshot_copy`
#   - EC2インスタンスからのAMI作成: `aws_ami_from_instance`
#
# AWS公式ドキュメント:
#   - VM Import/Export の前提条件: https://docs.aws.amazon.com/vm-import/latest/userguide/vmie_prereqs.html
#   - VM Import/Export ユーザーガイド: https://docs.aws.amazon.com/vm-import/latest/userguide/
#   - ディスクイメージのインポート: https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot_import
#
# Provider Version: 6.28.0
# Generated: 2026-02-04
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ebs_snapshot_import" "example" {
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
  # ディスクコンテナ設定 (必須)
  #-------------------------------------------------------------

  # disk_container (Required)
  # 設定内容: インポートするディスクイメージに関する情報を定義します。
  # 用途: S3に保存されているディスクイメージの場所とフォーマットを指定
  disk_container {
    # format (Required)
    # 設定内容: インポートするディスクイメージの形式を指定します。
    # 設定可能な値:
    #   - "VHD": Virtual Hard Disk形式（Hyper-V、VirtualBox等で使用）
    #   - "VMDK": Virtual Machine Disk形式（VMware等で使用）
    # 注意: RAW形式は現在サポートされていません
    format = "VHD"

    # description (Optional)
    # 設定内容: インポートするディスクイメージの説明を指定します。
    # 設定可能な値: 任意の文字列
    # 用途: ディスクイメージの識別や管理のための説明文
    description = null

    # url (Optional)
    # 設定内容: インポートするディスクイメージのS3 URLを指定します。
    # 設定可能な値:
    #   - "https://..." 形式のHTTPS URL
    #   - "s3://..." 形式のS3 URL
    # 注意: `url` または `user_bucket` のいずれかを必ず設定する必要があります
    # 例: "https://s3.amazonaws.com/my-bucket/my-disk-image.vhd"
    url = null

    # user_bucket (Optional)
    # 設定内容: ディスクイメージが保存されているS3バケット情報を指定します。
    # 注意: `url` または `user_bucket` のいずれかを必ず設定する必要があります
    user_bucket {
      # s3_bucket (Required)
      # 設定内容: ディスクイメージが保存されているS3バケット名を指定します。
      # 設定可能な値: 有効なS3バケット名
      s3_bucket = "disk-images"

      # s3_key (Required)
      # 設定内容: S3バケット内のディスクイメージのオブジェクトキー（ファイル名）を指定します。
      # 設定可能な値: S3オブジェクトキー
      # 例: "source.vhd", "images/windows-server.vmdk"
      s3_key = "source.vhd"
    }
  }

  #-------------------------------------------------------------
  # IAMロール設定
  #-------------------------------------------------------------

  # role_name (Optional)
  # 設定内容: VM Import/Exportサービスが引き受けるIAMロールの名前を指定します。
  # 設定可能な値: 有効なIAMロール名
  # デフォルト: "vmimport"
  # 関連機能: VM Import/Exportサービスロール
  #   このロールには、S3バケットへのアクセス権限とEC2スナップショット作成権限が必要です。
  #   詳細: https://docs.aws.amazon.com/vm-import/latest/userguide/vmie_prereqs.html#vmimport-role
  role_name = "vmimport"

  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # description (Optional)
  # 設定内容: インポートスナップショットタスクの説明文を指定します。
  # 設定可能な値: 任意の文字列
  # 用途: スナップショットの識別や管理のための説明文
  description = "Imported snapshot from S3 disk image"

  #-------------------------------------------------------------
  # 暗号化設定
  #-------------------------------------------------------------

  # encrypted (Optional)
  # 設定内容: インポートされたイメージの宛先スナップショットを暗号化するかを指定します。
  # 設定可能な値:
  #   - true: スナップショットを暗号化
  #   - false (デフォルト): スナップショットを暗号化しない
  # 注意: kms_key_idを指定しない場合、EBSのデフォルトKMSキーが使用されます
  encrypted = null

  # kms_key_id (Optional)
  # 設定内容: 暗号化されたスナップショット作成時に使用する対称KMSキーの識別子を指定します。
  # 設定可能な値: KMSキーのID、ARN、エイリアス、またはエイリアスARN
  # 注意: このパラメータを指定する場合、`encrypted`も必ずtrueに設定する必要があります
  # 省略時: EBSのデフォルトKMSキーが使用されます
  # 例: "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  kms_key_id = null

  #-------------------------------------------------------------
  # ストレージティア設定
  #-------------------------------------------------------------

  # storage_tier (Optional)
  # 設定内容: ストレージ階層の名前を指定します。
  # 設定可能な値:
  #   - "standard" (デフォルト): 標準ストレージ階層
  #   - "archive": アーカイブストレージ階層（低コスト、アクセス時に復元が必要）
  # 関連機能: EBS Snapshot Archive
  #   長期保存用の低コストストレージ。復元には24〜72時間かかります。
  storage_tier = "standard"

  #-------------------------------------------------------------
  # アーカイブ復元設定
  #-------------------------------------------------------------

  # permanent_restore (Optional)
  # 設定内容: アーカイブされたスナップショットを永続的に復元するかを指定します。
  # 設定可能な値:
  #   - true: 永続的に標準階層に復元
  #   - false: 一時的に復元（temporary_restore_daysと併用）
  # 注意: storage_tierが"archive"のスナップショットに対してのみ有効
  permanent_restore = null

  # temporary_restore_days (Optional)
  # 設定内容: アーカイブされたスナップショットを一時的に復元する日数を指定します。
  # 設定可能な値: 正の整数（日数）
  # 注意: 一時復元の場合のみ必須。指定期間後、スナップショットは自動的に再アーカイブされます
  # 用途: 短期間のみアクセスが必要な場合のコスト最適化
  temporary_restore_days = null

  #-------------------------------------------------------------
  # クライアントデータ設定
  #-------------------------------------------------------------

  # client_data (Optional)
  # 設定内容: クライアント固有のデータを指定します。
  # 用途: ディスクアップロードに関するメタデータの記録
  client_data {
    # comment (Optional)
    # 設定内容: ディスクアップロードに関するユーザー定義のコメントを指定します。
    # 設定可能な値: 任意の文字列
    comment = null

    # upload_start (Optional)
    # 設定内容: ディスクアップロードの開始時刻を指定します。
    # 設定可能な値: 日時文字列
    # 用途: アップロード期間の追跡や監査
    upload_start = null

    # upload_end (Optional)
    # 設定内容: ディスクアップロードの終了時刻を指定します。
    # 設定可能な値: 日時文字列
    # 用途: アップロード期間の追跡や監査
    upload_end = null

    # upload_size (Optional)
    # 設定内容: アップロードされたディスクイメージのサイズ（GiB単位）を指定します。
    # 設定可能な値: 正の数値（GiB単位）
    # 用途: ディスクサイズの記録や検証
    upload_size = null
  }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: スナップショットに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name = "HelloWorld"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: EBSスナップショットのAmazon Resource Name (ARN)
#        形式: arn:aws:ec2:region:account-id:snapshot/snap-id
#
# - id: スナップショットID（例: snap-59fcb34e）
#       用途: 他のリソースでこのスナップショットを参照する際に使用
#
# - owner_id: EBSスナップショット所有者のAWSアカウントID
#
# - owner_alias: スナップショット所有者のAmazon管理リストからの値
#                設定可能な値:
#                  - "amazon": AWS公式が管理するスナップショット
#                  - "aws-marketplace": AWS Marketplaceのスナップショット
#                  - "microsoft": Microsoft公式が管理するスナップショット
#
# - volume_size: ドライブのサイズ（GiB単位）
#                用途: このスナップショットから作成可能なEBSボリュームの最小サイズ
#
# - data_encryption_key_id: スナップショットのデータ暗号化キー識別子
#                           暗号化されたスナップショットの場合のみ設定されます
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
