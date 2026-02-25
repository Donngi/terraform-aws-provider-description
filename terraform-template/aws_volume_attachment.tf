#---------------------------------------------------------------
# AWS EBS Volume Attachment
#---------------------------------------------------------------
#
# Amazon EBSボリュームをEC2インスタンスにアタッチするリソースです。
# EBSボリュームとEC2インスタンスを独立したリソースとして管理し、
# アタッチ・デタッチを宣言的に制御できます。
#
# 注意: aws_instanceのebs_block_deviceと併用すると、Terraformは
# インスタンスのすべての非ルートEBSブロックデバイスを管理対象とみなします。
# そのため、ebs_block_deviceとaws_volume_attachmentを同一インスタンスに
# 混在させることは推奨されません。
#
# AWS公式ドキュメント:
#   - EBSボリュームのアタッチ: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-attaching-volume.html
#   - デバイス名の命名規則: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_volume_attachment" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # device_name (Required, Forces new resource)
  # 設定内容: インスタンスに公開するデバイス名を指定します。
  # 設定可能な値:
  #   - Linuxインスタンス(HVM): /dev/sdf～/dev/sdp（例: /dev/sdh）
  #   - Linuxインスタンス(PV): /dev/sdf～/dev/sdm（例: /dev/sdh）
  #   - Windowsインスタンス: xvdf～xvdz（例: xvdh）
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
  device_name = "/dev/sdh"

  # instance_id (Required, Forces new resource)
  # 設定内容: ボリュームをアタッチするEC2インスタンスのIDを指定します。
  # 設定可能な値: 有効なEC2インスタンスID（例: i-0123456789abcdef0）
  # 注意: インスタンスはボリュームと同じアベイラビリティーゾーンに
  #       存在する必要があります。
  instance_id = "i-0123456789abcdef0"

  # volume_id (Required, Forces new resource)
  # 設定内容: アタッチするEBSボリュームのIDを指定します。
  # 設定可能な値: 有効なEBSボリュームID（例: vol-0123456789abcdef0）
  # 注意: ボリュームはインスタンスと同じアベイラビリティーゾーンに
  #       存在する必要があります。
  volume_id = "vol-0123456789abcdef0"

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するAWSリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # デタッチ・削除動作設定
  #-------------------------------------------------------------

  # force_detach (Optional)
  # 設定内容: ボリュームのデタッチを強制するかどうかを指定します。
  # 設定可能な値:
  #   - true: 以前の試みが失敗した場合にデタッチを強制します
  #   - false (デフォルト): 通常のデタッチ処理を行います
  # 省略時: false
  # 注意: このオプションは最終手段としてのみ使用してください。
  #       データ損失が発生する可能性があります。
  # 参考: https://docs.aws.amazon.com/ebs/latest/userguide/ebs-detaching-volume.html
  force_detach = false

  # skip_destroy (Optional)
  # 設定内容: destroy時にインスタンスからボリュームをデタッチしないかどうかを指定します。
  # 設定可能な値:
  #   - true: destroy時にアタッチメントをTerraform stateから削除するのみで、
  #           実際のデタッチ処理は行いません
  #   - false (デフォルト): destroy時にボリュームをデタッチします
  # 省略時: false
  # 用途: 別の手段で作成されたボリュームがアタッチされているインスタンスを
  #       破棄する場合に有用です。
  skip_destroy = false

  # stop_instance_before_detaching (Optional)
  # 設定内容: デタッチ前にターゲットインスタンスを停止するかどうかを指定します。
  # 設定可能な値:
  #   - true: ボリュームのデタッチを試みる前にインスタンスを停止します。
  #           既に停止している場合はそのまま停止状態を維持します。
  #   - false (デフォルト): インスタンスを停止せずにデタッチを試みます
  # 省略時: false
  stop_instance_before_detaching = false

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: ボリュームアタッチメントの作成完了を待機する最大時間を指定します。
    # 設定可能な値: Go duration形式の文字列（例: "10m", "1h30m"）
    # 省略時: デフォルトのタイムアウト値を使用
    create = "10m"

    # delete (Optional)
    # 設定内容: ボリュームアタッチメントの削除完了を待機する最大時間を指定します。
    # 設定可能な値: Go duration形式の文字列（例: "10m", "1h30m"）
    # 省略時: デフォルトのタイムアウト値を使用
    delete = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - device_name: インスタンスに公開されたデバイス名
# - instance_id: アタッチ先のEC2インスタンスID
# - volume_id: アタッチされたEBSボリュームID
#---------------------------------------------------------------
