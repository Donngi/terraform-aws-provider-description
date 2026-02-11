#---------------------------------------------------------------
# AWS AMI (Amazon Machine Image)
#---------------------------------------------------------------
#
# Amazon Machine Image (AMI) をプロビジョニングするリソースです。
# AMIはEC2インスタンスの起動に必要なソフトウェア構成（オペレーティングシステム、
# アプリケーションサーバー、アプリケーション）を含むテンプレートです。
#
# 既存のAMIを複製する場合は `aws_ami_copy` の使用を推奨します。
# 既存のAMIを他のAWSアカウントと共有する場合は `aws_ami_launch_permission` を推奨します。
#
# AWS公式ドキュメント:
#   - AMIライフサイクル: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-lifecycle.html
#   - EBS-backed AMIの作成: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html
#   - ブートモード: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-boot.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami
#
# Provider Version: 6.28.0
# Generated: 2026-01-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_ami" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # name (Required, Forces new resource)
  # 設定内容: AMIのリージョン内で一意な名前を指定します。
  # 設定可能な値: 任意の文字列
  name = "my-custom-ami"

  # description (Optional)
  # 設定内容: AMIの説明文を指定します。
  # 設定可能な値: 任意の文字列
  description = "Custom AMI for my application"

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
  # 仮想化設定
  #-------------------------------------------------------------

  # virtualization_type (Optional)
  # 設定内容: インスタンスで使用する仮想化モードを指定します。
  # 設定可能な値:
  #   - "paravirtual" (デフォルト): 準仮想化。kernel_idが必要
  #   - "hvm": ハードウェア仮想マシン。最新のインスタンスタイプで推奨
  # 注意: 選択する仮想化タイプによって必要な追加引数が変わります
  virtualization_type = "hvm"

  # architecture (Optional)
  # 設定内容: 作成されるインスタンスのマシンアーキテクチャを指定します。
  # 設定可能な値:
  #   - "x86_64" (デフォルト): 64ビットx86アーキテクチャ
  #   - "arm64": 64ビットARMアーキテクチャ (Gravitonプロセッサ用)
  #   - "i386": 32ビットx86アーキテクチャ
  architecture = "x86_64"

  #-------------------------------------------------------------
  # ルートデバイス設定
  #-------------------------------------------------------------

  # root_device_name (Optional)
  # 設定内容: ルートデバイスの名前を指定します。
  # 設定可能な値: デバイスパス（例: /dev/sda1, /dev/xvda）
  # 関連機能: EBSボリュームマッピング
  #   ルートボリュームとしてマッピングするデバイス名を指定します。
  root_device_name = "/dev/xvda"

  #-------------------------------------------------------------
  # ブートモード設定
  #-------------------------------------------------------------

  # boot_mode (Optional)
  # 設定内容: AMIのブートモードを指定します。
  # 設定可能な値:
  #   - "legacy-bios": レガシーBIOSブートモード
  #   - "uefi": UEFIブートモード
  #   - "uefi-preferred": UEFIを優先、サポートされない場合はlegacy-biosにフォールバック
  # 関連機能: EC2ブートモード
  #   インスタンスの起動方法を制御します。新しいインスタンスタイプではUEFIが推奨されます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-boot.html
  boot_mode = null

  # uefi_data (Optional)
  # 設定内容: 非揮発性UEFI変数ストアのBase64表現を指定します。
  # 設定可能な値: Base64エンコードされた文字列
  # 用途: UEFIブートモードで使用するファームウェア設定データ
  uefi_data = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # ena_support (Optional)
  # 設定内容: ENA（Elastic Network Adapter）による拡張ネットワーキングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: ENAサポートを有効化（高帯域幅、低レイテンシネットワーキング）
  #   - false (デフォルト): ENAサポートを無効化
  # 関連機能: 拡張ネットワーキング
  #   ENAはより高いパケット毎秒（PPS）パフォーマンスと一貫したレイテンシを提供します。
  ena_support = true

  # sriov_net_support (Optional)
  # 設定内容: SR-IOV（Single Root I/O Virtualization）ネットワークサポートを指定します。
  # 設定可能な値:
  #   - "simple" (デフォルト): 拡張ネットワーキングを有効化
  # 注意: virtualization_typeが"hvm"の場合のみ適用
  # 関連機能: SR-IOVネットワーキング
  #   ハードウェアレベルでの仮想化により、高性能ネットワーキングを実現します。
  sriov_net_support = "simple"

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # imds_support (Optional)
  # 設定内容: このAMIから起動するインスタンスでIMDSv2の使用を強制するかを指定します。
  # 設定可能な値:
  #   - "v2.0": IMDSv2の使用を強制（推奨）
  # 関連機能: Instance Metadata Service v2 (IMDSv2)
  #   セッション指向のリクエストを使用したより安全なメタデータアクセス方法。
  #   SSRF攻撃からの保護を強化します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-IMDS-new-instances.html
  imds_support = "v2.0"

  # tpm_support (Optional)
  # 設定内容: NitroTPMサポートを指定します。
  # 設定可能な値:
  #   - "v2.0": NitroTPMサポートを有効化
  # 関連機能: NitroTPM
  #   TPM 2.0仕様に準拠した仮想トラステッドプラットフォームモジュール。
  #   セキュアブートや暗号化キーの保護に使用されます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nitrotpm.html
  tpm_support = null

  #-------------------------------------------------------------
  # 非推奨化設定
  #-------------------------------------------------------------

  # deprecation_time (Optional)
  # 設定内容: AMIを非推奨にする日時を指定します。
  # 設定可能な値: RFC3339形式の日時文字列（YYYY-MM-DDTHH:MM:SSZ）
  # 関連機能: AMI非推奨化
  #   指定日時以降、AMIはリスト表示から非表示になりますが、
  #   引き続きインスタンスの起動に使用できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ami-lifecycle.html
  deprecation_time = null

  #-------------------------------------------------------------
  # Paravirtual用設定
  #-------------------------------------------------------------
  # 以下の設定はvirtualization_typeが"paravirtual"の場合に使用します。

  # image_location (Required for paravirtual)
  # 設定内容: イメージマニフェストを含むS3オブジェクトへのパスを指定します。
  # 設定可能な値: S3パス（ec2-upload-bundleコマンドで作成）
  # 注意: paravirtual仮想化タイプの場合に必要
  image_location = null

  # kernel_id (Required for paravirtual)
  # 設定内容: 準仮想化カーネルとして使用するカーネルイメージ（AKI）のIDを指定します。
  # 設定可能な値: 有効なAKI ID
  # 注意: paravirtual仮想化タイプの場合に必要
  kernel_id = null

  # ramdisk_id (Optional)
  # 設定内容: インスタンス起動時に使用するinitrdイメージ（ARI）のIDを指定します。
  # 設定可能な値: 有効なARI ID
  # 注意: paravirtual仮想化タイプの場合にオプションで使用
  ramdisk_id = null

  #-------------------------------------------------------------
  # EBSブロックデバイス設定
  #-------------------------------------------------------------

  # ebs_block_device (Optional)
  # 設定内容: インスタンスにアタッチするEBSブロックデバイスを定義します。
  # 注意: encrypted と snapshot_id は同時に指定できません
  ebs_block_device {
    # device_name (Required)
    # 設定内容: デバイスが公開されるパスを指定します。
    # 設定可能な値: デバイスパス（例: /dev/xvda, /dev/sda1, /dev/sdf）
    device_name = "/dev/xvda"

    # snapshot_id (Optional)
    # 設定内容: EBSボリュームの初期化に使用するスナップショットIDを指定します。
    # 設定可能な値: 有効なスナップショットID
    # 注意: 指定時、volume_sizeはスナップショット以上のサイズが必要
    snapshot_id = "snap-xxxxxxxx"

    # volume_size (Required unless snapshot_id is set)
    # 設定内容: 作成するボリュームのサイズ（GiB）を指定します。
    # 設定可能な値: 正の整数
    # 注意: snapshot_id指定時は省略可能（スナップショットと同サイズになる）
    volume_size = 8

    # volume_type (Optional)
    # 設定内容: EBSボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "standard" (デフォルト): マグネティックボリューム
    #   - "gp2": 汎用SSD（第2世代）
    #   - "gp3": 汎用SSD（第3世代、推奨）
    #   - "io1": プロビジョンドIOPS SSD（第1世代）
    #   - "io2": プロビジョンドIOPS SSD（第2世代）
    #   - "sc1": コールドHDD
    #   - "st1": スループット最適化HDD
    volume_type = "gp3"

    # iops (Required for io1/io2)
    # 設定内容: ボリュームがサポートするI/O操作数/秒を指定します。
    # 設定可能な値: 正の整数
    # 注意: volume_typeがio1またはio2の場合に必須
    iops = null

    # throughput (Optional)
    # 設定内容: EBSボリュームがサポートするスループット（MiB/s）を指定します。
    # 設定可能な値: 125〜1000の整数
    # 注意: volume_typeがgp3の場合のみ有効
    throughput = null

    # encrypted (Optional)
    # 設定内容: 作成するEBSボリュームを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: ボリュームを暗号化
    #   - false: ボリュームを暗号化しない
    # 注意: snapshot_idと同時に指定できません
    encrypted = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にEBSボリュームを削除するかを指定します。
    # 設定可能な値:
    #   - true: インスタンス終了時にボリュームを削除
    #   - false: インスタンス終了後もボリュームを保持
    delete_on_termination = true

    # outpost_arn (Optional)
    # 設定内容: スナップショットが保存されているOutpostのARNを指定します。
    # 設定可能な値: 有効なOutpost ARN
    # 関連機能: AWS Outposts
    #   オンプレミス環境でAWSインフラストラクチャを実行するためのサービス。
    outpost_arn = null
  }

  #-------------------------------------------------------------
  # エフェメラルブロックデバイス設定
  #-------------------------------------------------------------

  # ephemeral_block_device (Optional)
  # 設定内容: インスタンスにアタッチするエフェメラル（インスタンスストア）ブロックデバイスを定義します。
  # 注意: インスタンスストアボリュームはインスタンス停止時にデータが失われます
  # ephemeral_block_device {
  #   # device_name (Required)
  #   # 設定内容: デバイスが公開されるパスを指定します。
  #   # 設定可能な値: デバイスパス（例: /dev/sdb, /dev/xvdb）
  #   device_name = "/dev/sdb"
  #
  #   # virtual_name (Required)
  #   # 設定内容: エフェメラルデバイスの名前を指定します。
  #   # 設定可能な値: "ephemeralN"形式（Nは0から始まるボリューム番号）
  #   virtual_name = "ephemeral0"
  # }

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  tags = {
    Name        = "my-custom-ami"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "40m", "1h"）
    # デフォルト: 40m
    create = "40m"

    # update (Optional)
    # 設定内容: リソース更新のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "40m", "1h"）
    # デフォルト: 40m
    update = "40m"

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間を表す文字列（例: "90m", "2h"）
    # デフォルト: 90m
    delete = "90m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - arn: AMIのAmazon Resource Name (ARN)
#
# - id: 作成されたAMIのID
#
# - hypervisor: イメージのハイパーバイザータイプ
#
# - image_owner_alias: AWSアカウントエイリアス（例: amazon, self）
#                      またはAMI所有者のAWSアカウントID
#
# - image_type: イメージのタイプ
#
# - last_launched_time: AMIが最後にEC2インスタンスの起動に使用された日時
#                       （ISO 8601形式）。使用から報告まで24時間の遅延があります。
#
# - manage_ebs_snapshots: TerraformがEBSスナップショットを管理するかどうか
#
# - owner_id: イメージ所有者のAWSアカウントID
#
# - platform: WindowsAMIの場合は"windows"、それ以外は空白
#
#---------------------------------------------------------------
