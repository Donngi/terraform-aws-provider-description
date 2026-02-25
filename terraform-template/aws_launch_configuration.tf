#---------------------------------------------------------------
# AWS EC2 Auto Scaling Launch Configuration
#---------------------------------------------------------------
#
# Amazon EC2 Auto Scalingグループが使用するEC2インスタンス起動設定をプロビジョニングするリソースです。
# インスタンスタイプ、AMI、セキュリティグループ、ブロックデバイスマッピング等の
# 設定テンプレートを定義します。
#
# 警告: ローンチ設定の使用はローンチテンプレートへの移行が推奨されています。
#       2023年1月1日以降、新しいEC2インスタンスタイプはローンチ設定でサポートされなくなりました。
#       2024年10月1日以降に作成されたアカウントは、いかなる方法でもローンチ設定を作成できません。
#
# AWS公式ドキュメント:
#   - Auto Scalingローンチ設定: https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-configurations.html
#   - ローンチ設定の作成: https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-launch-config.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-02-17
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_launch_configuration" "example" {
  #-------------------------------------------------------------
  # 名前設定
  #-------------------------------------------------------------

  # name (Optional, Forces new resource)
  # 設定内容: ローンチ設定の名前を指定します。
  # 設定可能な値: 文字列
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: name_prefixと排他的（どちらか一方のみ指定可能）
  #       Auto Scalingグループと組み合わせて使用する場合は、
  #       name_prefixの使用を推奨（Terraformライフサイクルの検出が容易）
  name = null

  # name_prefix (Optional, Forces new resource)
  # 設定内容: ローンチ設定名のプレフィックスを指定します。
  # 設定可能な値: 文字列。Terraformが後ろにランダムなサフィックスを追加します。
  # 省略時: Terraformがランダムな一意の名前を生成します。
  # 注意: nameと排他的（どちらか一方のみ指定可能）
  name_prefix = "my-launch-config-"

  #-------------------------------------------------------------
  # AMI・インスタンス設定
  #-------------------------------------------------------------

  # image_id (Required, Forces new resource)
  # 設定内容: 起動するEC2インスタンスのAMI IDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-0abcdef1234567890）
  image_id = "ami-0abcdef1234567890"

  # instance_type (Required, Forces new resource)
  # 設定内容: 起動するEC2インスタンスのインスタンスタイプを指定します。
  # 設定可能な値: 有効なEC2インスタンスタイプ（例: t3.micro, m5.large）
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
  instance_type = "t3.micro"

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
  # ネットワーク設定
  #-------------------------------------------------------------

  # associate_public_ip_address (Optional, Forces new resource)
  # 設定内容: VPC内のインスタンスにパブリックIPアドレスを関連付けるかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPアドレスを割り当てる
  #   - false: パブリックIPアドレスを割り当てない
  # 省略時: サブネットのデフォルト設定に依存
  associate_public_ip_address = false

  # security_groups (Optional, Forces new resource)
  # 設定内容: インスタンスに関連付けるセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDの集合（例: ["sg-12345678", "sg-87654321"]）
  security_groups = ["sg-12345678"]

  # placement_tenancy (Optional, Forces new resource)
  # 設定内容: インスタンスのテナンシーを指定します。
  # 設定可能な値:
  #   - "default": 共有ハードウェアでインスタンスを実行
  #   - "dedicated": 専用ハードウェアでインスタンスを実行（追加コストが発生）
  # 省略時: "default"
  # 参考: https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-launch-config.html
  placement_tenancy = "default"

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # ebs_optimized (Optional, Forces new resource)
  # 設定内容: EBS最適化インスタンスとして起動するかを指定します。
  # 設定可能な値:
  #   - true: EBS最適化を有効化（専用のスループットを提供）
  #   - false: EBS最適化を無効化
  # 省略時: インスタンスタイプのデフォルト設定に依存
  ebs_optimized = false

  #-------------------------------------------------------------
  # 認証・アクセス設定
  #-------------------------------------------------------------

  # iam_instance_profile (Optional, Forces new resource)
  # 設定内容: 起動するインスタンスに関連付けるIAMインスタンスプロファイルの名前を指定します。
  # 設定可能な値: IAMインスタンスプロファイルの名前またはARN
  iam_instance_profile = null

  # key_name (Optional, Forces new resource)
  # 設定内容: インスタンスに使用するキーペアの名前を指定します。
  # 設定可能な値: 有効なEC2キーペア名
  # 省略時: キーペアなし（SSHアクセス不可）
  key_name = null

  #-------------------------------------------------------------
  # ユーザーデータ設定
  #-------------------------------------------------------------

  # user_data (Optional, Forces new resource)
  # 設定内容: インスタンス起動時に提供するユーザーデータを指定します。
  # 設定可能な値: テキスト形式のスクリプトまたはデータ（最大16KB）
  # 省略時: ユーザーデータなし
  # 注意: gzip圧縮データを渡す場合は user_data_base64 を使用してください。
  user_data = null

  # user_data_base64 (Optional, Forces new resource)
  # 設定内容: Base64エンコードされたバイナリデータをユーザーデータとして指定します。
  # 設定可能な値: Base64エンコードされた文字列
  # 省略時: ユーザーデータなし
  # 注意: gzip圧縮などのバイナリデータや、有効なUTF-8文字列でない値を渡す場合に使用します。
  #       user_dataとは排他的（どちらか一方のみ指定可能）
  user_data_base64 = null

  #-------------------------------------------------------------
  # モニタリング設定
  #-------------------------------------------------------------

  # enable_monitoring (Optional, Forces new resource)
  # 設定内容: 詳細モニタリングを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 詳細モニタリングを有効化（1分間隔でメトリクスを収集）
  #   - false: 詳細モニタリングを無効化（5分間隔の基本モニタリング）
  enable_monitoring = true

  #-------------------------------------------------------------
  # スポットインスタンス設定
  #-------------------------------------------------------------

  # spot_price (Optional, Forces new resource)
  # 設定内容: スポットインスタンスを予約するための最高入札価格を指定します。
  # 設定可能な値: 時間あたりの価格（USD）を表す文字列（例: "0.03"）
  # 省略時: オンデマンド価格を使用（スポットインスタンスではなくオンデマンドインスタンスとして起動）
  spot_price = null

  #-------------------------------------------------------------
  # インスタンスメタデータ設定
  #-------------------------------------------------------------

  metadata_options {
    # http_endpoint (Optional)
    # 設定内容: インスタンスメタデータサービス（IMDS）のエンドポイントの状態を指定します。
    # 設定可能な値:
    #   - "enabled" (デフォルト): IMDSエンドポイントを有効化
    #   - "disabled": IMDSエンドポイントを無効化
    # 参考: https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-launch-config.html
    http_endpoint = "enabled"

    # http_tokens (Optional)
    # 設定内容: インスタンスメタデータ取得時にセッショントークンを必須とするかを指定します。
    # 設定可能な値:
    #   - "optional": IMDSv1（トークン不要）とIMDSv2（トークン必須）の両方を許可
    #   - "required": IMDSv2のみを許可（セキュリティ強化推奨）
    # 省略時: "optional"
    http_tokens = "required"

    # http_put_response_hop_limit (Optional)
    # 設定内容: インスタンスメタデータリクエストのPUTレスポンスのホップ数上限を指定します。
    # 設定可能な値: 1〜64の整数
    # 省略時: 1
    # 注意: コンテナから IMDSにアクセスする場合は2以上に設定する必要があります。
    http_put_response_hop_limit = 1
  }

  #-------------------------------------------------------------
  # ルートブロックデバイス設定
  #-------------------------------------------------------------

  root_block_device {
    # volume_type (Optional)
    # 設定内容: ルートボリュームのEBSボリュームタイプを指定します。
    # 設定可能な値:
    #   - "gp2": 汎用SSD（旧世代）
    #   - "gp3": 汎用SSD（新世代、推奨）
    #   - "io1": プロビジョニングドIOPS SSD
    #   - "io2": プロビジョニングドIOPS SSD（新世代）
    #   - "sc1": コールドHDD
    #   - "st1": スループット最適化HDD
    #   - "standard": マグネティック（旧世代）
    # 省略時: AMIのルートデバイスのボリュームタイプ
    volume_type = "gp3"

    # volume_size (Optional)
    # 設定内容: ルートボリュームのサイズをGiBで指定します。
    # 設定可能な値:
    #   - gp2/gp3/magnetic: 1〜16384
    #   - io1/io2: 4〜16384
    #   - sc1/st1: 125〜16384
    # 省略時: AMIのルートデバイスのボリュームサイズ
    volume_size = 20

    # iops (Optional)
    # 設定内容: プロビジョニングされるIOPS数を指定します。
    # 設定可能な値: io1は100〜64000、io2は100〜256000、gp3は3000〜16000
    # 省略時: ボリュームタイプのデフォルト値
    # 注意: io1/io2/gp3以外では無視されます。
    iops = null

    # throughput (Optional)
    # 設定内容: EBSボリュームのスループット（MiB/s）を指定します。
    # 設定可能な値: gp3の場合125〜1000 MiB/s
    # 省略時: ボリュームタイプのデフォルト値
    # 注意: gp3のみに適用されます。
    throughput = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にルートボリュームを削除するかを指定します。
    # 設定可能な値:
    #   - true: インスタンス終了時にボリュームを削除
    #   - false: インスタンス終了時にボリュームを保持
    # 省略時: true
    delete_on_termination = true

    # encrypted (Optional)
    # 設定内容: ルートボリュームを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: ボリュームを暗号化
    #   - false: ボリュームを暗号化しない
    # 省略時: AMIのルートデバイスの暗号化設定に依存
    encrypted = true
  }

  #-------------------------------------------------------------
  # 追加EBSブロックデバイス設定
  #-------------------------------------------------------------

  ebs_block_device {
    # device_name (Required)
    # 設定内容: EBSボリュームのデバイス名を指定します。
    # 設定可能な値: デバイス名（例: /dev/sdb, /dev/xvdb）
    device_name = "/dev/sdb"

    # volume_type (Optional)
    # 設定内容: EBSボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "gp2": 汎用SSD（旧世代）
    #   - "gp3": 汎用SSD（新世代、推奨）
    #   - "io1": プロビジョニングドIOPS SSD
    #   - "io2": プロビジョニングドIOPS SSD（新世代）
    #   - "sc1": コールドHDD
    #   - "st1": スループット最適化HDD
    #   - "standard": マグネティック（旧世代）
    # 省略時: AMIのデバイスのボリュームタイプ
    volume_type = "gp3"

    # volume_size (Optional)
    # 設定内容: EBSボリュームのサイズをGiBで指定します。
    # 設定可能な値: ボリュームタイプに応じた有効な範囲
    # 省略時: AMIのデバイスのボリュームサイズ
    volume_size = 100

    # iops (Optional)
    # 設定内容: プロビジョニングされるIOPS数を指定します。
    # 設定可能な値: io1は100〜64000、io2は100〜256000、gp3は3000〜16000
    # 省略時: ボリュームタイプのデフォルト値
    # 注意: io1/io2/gp3以外では無視されます。
    iops = null

    # throughput (Optional)
    # 設定内容: EBSボリュームのスループット（MiB/s）を指定します。
    # 設定可能な値: gp3の場合125〜1000 MiB/s
    # 省略時: ボリュームタイプのデフォルト値
    # 注意: gp3のみに適用されます。
    throughput = null

    # snapshot_id (Optional)
    # 設定内容: ボリュームの作成元となるスナップショットIDを指定します。
    # 設定可能な値: 有効なEBSスナップショットID（例: snap-0abcdef1234567890）
    # 省略時: スナップショットなし（空のボリュームを作成）
    snapshot_id = null

    # encrypted (Optional)
    # 設定内容: EBSボリュームを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: ボリュームを暗号化
    #   - false: ボリュームを暗号化しない
    # 省略時: スナップショットの暗号化設定に依存
    encrypted = true

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にEBSボリュームを削除するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): インスタンス終了時にボリュームを削除
    #   - false: インスタンス終了時にボリュームを保持
    delete_on_termination = true

    # no_device (Optional)
    # 設定内容: AMIに含まれるデバイスマッピングを抑制するかを指定します。
    # 設定可能な値:
    #   - true: 指定したデバイス名のAMIマッピングを無効化
    #   - false: AMIのデバイスマッピングを使用
    # 省略時: false
    no_device = false
  }

  #-------------------------------------------------------------
  # エフェメラルブロックデバイス設定
  #-------------------------------------------------------------

  ephemeral_block_device {
    # device_name (Required)
    # 設定内容: インスタンスストアボリュームのデバイス名を指定します。
    # 設定可能な値: デバイス名（例: /dev/sdc, /dev/xvdc）
    device_name = "/dev/sdc"

    # virtual_name (Optional)
    # 設定内容: インスタンスストアボリュームの仮想名を指定します。
    # 設定可能な値: "ephemeral" + インデックス番号（例: "ephemeral0", "ephemeral1"）
    # 省略時: null
    virtual_name = "ephemeral0"

    # no_device (Optional)
    # 設定内容: AMIに含まれるインスタンスストアデバイスのマッピングを抑制するかを指定します。
    # 設定可能な値:
    #   - true: 指定したデバイス名のAMIマッピングを無効化
    #   - false: AMIのデバイスマッピングを使用
    # 省略時: false
    no_device = false
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ローンチ設定のID（nameと同一）
# - arn: ローンチ設定のAmazon Resource Name (ARN)
# - name: ローンチ設定の名前
#---------------------------------------------------------------
