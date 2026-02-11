#---------------------------------------------------------------
# EBS Volume Attachment
#---------------------------------------------------------------
#
# EBS（Elastic Block Store）ボリュームをEC2インスタンスに接続するための
# トップレベルリソースです。ボリュームのアタッチとデタッチを管理します。
#
# 注意: aws_instanceリソースでebs_block_deviceを使用する場合、Terraformは
# そのインスタンスの非ルートEBSブロックデバイス全体を管理対象とみなすため、
# 外部のaws_ebs_volumeとaws_volume_attachmentリソースを混在させることは
# できません。
#
# AWS公式ドキュメント:
#   - Attach an Amazon EBS volume to an instance: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-attaching-volume.html
#   - EBS volume limits: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/volume_limits.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/6.28.0/docs/resources/volume_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-09
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_volume_attachment" "example" {

  #-------------------------------------------------------------
  # 必須パラメータ
  #-------------------------------------------------------------

  # device_name (Required)
  # 設定内容: インスタンスに公開するデバイス名
  # 設定可能な値: Linuxインスタンスの場合 /dev/sdh, /dev/sdf, xvdh など
  #             Windowsインスタンスの場合 xvdf, xvdh など
  # 省略時: 設定必須
  # 関連機能: Device Naming on Linux Instances
  #   デバイス命名規則に関する詳細 - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
  device_name = "/dev/sdh"

  # instance_id (Required)
  # 設定内容: ボリュームをアタッチするEC2インスタンスのID
  # 設定可能な値: EC2インスタンスID（例: i-1234567890abcdef0）
  # 省略時: 設定必須
  # 注意: ボリュームとインスタンスは同じアベイラビリティゾーンに存在する必要があります
  instance_id = "i-1234567890abcdef0"

  # volume_id (Required)
  # 設定内容: アタッチするEBSボリュームのID
  # 設定可能な値: EBSボリュームID（例: vol-049df61146c4d7901）
  # 省略時: 設定必須
  # 注意: ボリュームとインスタンスは同じアベイラビリティゾーンに存在する必要があります
  volume_id = "vol-049df61146c4d7901"

  #-------------------------------------------------------------
  # オプションパラメータ
  #-------------------------------------------------------------

  # force_detach (Optional)
  # 設定内容: ボリュームを強制的にデタッチするかどうか
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: 前回のデタッチ試行が失敗した場合に有効ですが、データ損失のリスクがあるため
  #      最後の手段としてのみ使用してください
  # 関連機能: Detaching an Amazon EBS Volume from an Instance
  #   ボリュームのデタッチに関する詳細 - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-detaching-volume.html
  # force_detach = false

  # skip_destroy (Optional)
  # 設定内容: リソース削除時にボリュームをインスタンスからデタッチせず、
  #          Terraformの状態からのみアタッチメントを削除するかどうか
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: 他の手段で作成されたボリュームがアタッチされているインスタンスを
  #      削除する場合に便利です
  # skip_destroy = false

  # stop_instance_before_detaching (Optional)
  # 設定内容: ボリュームのデタッチ前にインスタンスを停止するかどうか
  # 設定可能な値: true, false
  # 省略時: false
  # 注意: インスタンスが実行中の場合は停止してからデタッチを試みます
  # stop_instance_before_detaching = false

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョン
  # 設定可能な値: us-east-1, ap-northeast-1 など
  # 省略時: プロバイダー設定のリージョンを使用
  # 関連機能: AWS Regional Endpoints
  #   リージョナルエンドポイントの詳細 - https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "ap-northeast-1"

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: ボリュームアタッチ作成のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "5m", "10m"）
    # 省略時: デフォルトタイムアウト値
    # create = "5m"

    # delete (Optional)
    # 設定内容: ボリュームアタッチ削除のタイムアウト時間
    # 設定可能な値: 時間文字列（例: "5m", "10m"）
    # 省略時: デフォルトタイムアウト値
    # delete = "5m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# - id: アタッチメントのID（形式: DEVICE_NAME:VOLUME_ID:INSTANCE_ID）
# - device_name: インスタンスに公開されるデバイス名
# - instance_id: インスタンスのID
# - volume_id: ボリュームのID
#---------------------------------------------------------------
