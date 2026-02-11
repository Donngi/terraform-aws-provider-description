#---------------------------------------------------------------
# EC2 Auto Scaling Launch Configuration
#---------------------------------------------------------------
#
# Auto Scalingグループで使用するEC2インスタンスの起動設定を定義します。
# AMI ID、インスタンスタイプ、セキュリティグループ、ブロックデバイスマッピング
# などの情報を含むテンプレートです。
#
# 【重要な注意事項】
# Launch Configurationの使用は非推奨です。AWS公式ドキュメントでは
# Launch Templatesの使用が推奨されています。
# - 2023年1月1日以降、新しいEC2インスタンスタイプはlaunch configurationsでサポートされません
# - 2023年6月1日以降に作成されたアカウントは、コンソールから新規作成できません
# - 2024年10月1日以降に作成されたアカウントは、いかなる方法でも新規作成できません
#
# AWS公式ドキュメント:
#   - Auto Scaling launch configurations: https://docs.aws.amazon.com/autoscaling/ec2/userguide/launch-configurations.html
#   - CreateLaunchConfiguration API: https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_CreateLaunchConfiguration.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
#
# Provider Version: 6.28.0
# Generated: 2026-01-28
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_launch_configuration" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # (必須) 起動するEC2インスタンスのAMI ID
  # 例: "ami-0c55b159cbfafe1f0"
  image_id = "ami-xxxxxxxxxxxxxxxxx"

  # (必須) 起動するインスタンスのサイズ
  # 例: "t2.micro", "t3.medium", "m5.large"
  instance_type = "t3.micro"

  #---------------------------------------------------------------
  # 任意パラメータ - 基本設定
  #---------------------------------------------------------------

  # (任意) Launch Configurationの名前
  # 空欄の場合、Terraformが自動生成します
  # name_prefixと競合するため、どちらか一方のみを使用してください
  # Auto Scaling Groupと組み合わせて使用する場合は、name_prefixの使用が推奨されます
  name = "example-launch-config"

  # (任意) 指定したプレフィックスで始まる一意の名前を作成
  # nameと競合するため、どちらか一方のみを使用してください
  # Auto Scaling Groupのライフサイクル管理を適切に行うため、こちらの使用が推奨されます
  # name_prefix = "example-lc-"

  # (任意) このリソースが管理されるAWSリージョン
  # 指定しない場合、プロバイダー設定のリージョンが使用されます
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # 任意パラメータ - ネットワーク設定
  #---------------------------------------------------------------

  # (任意) VPC内のインスタンスにパブリックIPアドレスを関連付けるかどうか
  # trueの場合、起動されたインスタンスにパブリックIPが割り当てられます
  # デフォルト: サブネットの設定に従います
  # associate_public_ip_address = true

  # (任意) 関連付けるセキュリティグループIDのリスト
  # VPC内で起動する場合は、セキュリティグループIDを指定します
  # EC2-Classicの場合は、セキュリティグループ名を指定します
  # 例: ["sg-12345678", "sg-87654321"]
  # security_groups = []

  #---------------------------------------------------------------
  # 任意パラメータ - IAM設定
  #---------------------------------------------------------------

  # (任意) 起動されたインスタンスに関連付けるIAMインスタンスプロファイルの名前
  # EC2インスタンスがAWSリソースにアクセスする際に使用する権限を付与します
  # 例: "ec2-instance-profile"
  # iam_instance_profile = ""

  #---------------------------------------------------------------
  # 任意パラメータ - インスタンス設定
  #---------------------------------------------------------------

  # (任意) インスタンスで使用するキーペアの名前
  # SSH接続に使用されます
  # 例: "my-key-pair"
  # key_name = ""

  # (任意) 起動されたEC2インスタンスをEBS最適化するかどうか
  # EBS最適化により、EBSボリュームへの専用帯域幅が確保されます
  # デフォルト: インスタンスタイプのデフォルト設定に従います
  # ebs_optimized = false

  # (任意) インスタンスの配置テナンシー
  # 有効な値: "default" または "dedicated"
  # "dedicated"の場合、インスタンスは専有ハードウェア上で実行されます
  # 参考: http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_CreateLaunchConfiguration.html
  # placement_tenancy = "default"

  # (任意) 詳細モニタリングを有効/無効にする
  # trueの場合、CloudWatchで1分間隔のメトリクスが利用可能になります
  # falseの場合、5分間隔のメトリクスのみが利用可能です
  # デフォルト: 有効
  # enable_monitoring = true

  #---------------------------------------------------------------
  # 任意パラメータ - Spot Instance設定
  #---------------------------------------------------------------

  # (任意) Spotインスタンスの予約に使用する最大価格
  # 指定しない場合、オンデマンド価格が使用されます
  # 例: "0.03" (1時間あたりの米ドル)
  # spot_price = ""

  #---------------------------------------------------------------
  # 任意パラメータ - User Data
  #---------------------------------------------------------------

  # (任意) インスタンス起動時に提供するユーザーデータ
  # 起動時に実行するスクリプトやクラウド初期化データを指定します
  # gzip圧縮されたデータは渡さないでください。その場合はuser_data_base64を使用してください
  # 例: "#!/bin/bash\necho 'Hello World'"
  # user_data = ""

  # (任意) user_dataの代わりにbase64エンコードされたバイナリデータを渡す
  # 値が有効なUTF-8文字列でない場合に使用します
  # 例えば、gzip圧縮されたユーザーデータは破損を避けるため、
  # base64エンコードしてこの引数で渡す必要があります
  # user_data_base64 = ""

  #---------------------------------------------------------------
  # ブロックデバイス設定 - Root Block Device
  #---------------------------------------------------------------

  # (任意) ルートブロックデバイスの詳細設定
  # AMIのルートデバイスの設定をカスタマイズします
  # 最大1つまで指定可能
  # root_block_device {
  #   # (任意) インスタンス終了時にボリュームを削除するかどうか
  #   # デフォルト: AMIの設定に従います
  #   delete_on_termination = true
  #
  #   # (任意) ボリュームを暗号化するかどうか
  #   # デフォルト: AMIの設定に従います
  #   encrypted = false
  #
  #   # (任意) ボリュームのIOPS (Input/Output Operations Per Second)
  #   # io1, io2, gp3ボリュームタイプでのみ使用可能
  #   # デフォルト: ボリュームタイプのデフォルト設定に従います
  #   iops = 3000
  #
  #   # (任意) ボリュームのスループット (MiB/s)
  #   # gp3ボリュームタイプでのみ使用可能
  #   # デフォルト: ボリュームタイプのデフォルト設定に従います
  #   throughput = 125
  #
  #   # (任意) ボリュームのサイズ (GiB)
  #   # デフォルト: AMIの設定に従います
  #   volume_size = 20
  #
  #   # (任意) ボリュームのタイプ
  #   # 有効な値: "standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"
  #   # デフォルト: AMIの設定に従います
  #   volume_type = "gp3"
  # }

  #---------------------------------------------------------------
  # ブロックデバイス設定 - Additional EBS Block Devices
  #---------------------------------------------------------------

  # (任意) インスタンスにアタッチする追加のEBSブロックデバイス
  # 複数指定可能
  # ebs_block_device {
  #   # (必須) デバイス名 (例: "/dev/sdf", "/dev/xvdf")
  #   # 利用可能なデバイス名はインスタンスタイプとAMIによって異なります
  #   device_name = "/dev/sdf"
  #
  #   # (任意) インスタンス終了時にボリュームを削除するかどうか
  #   # デフォルト: true
  #   delete_on_termination = true
  #
  #   # (任意) ボリュームを暗号化するかどうか
  #   # デフォルト: false
  #   encrypted = false
  #
  #   # (任意) ボリュームのIOPS (Input/Output Operations Per Second)
  #   # io1, io2, gp3ボリュームタイプでのみ使用可能
  #   iops = 3000
  #
  #   # (任意) AMIのブロックデバイスマッピングを抑制するかどうか
  #   # trueの場合、このデバイス名のマッピングが無効化されます
  #   no_device = false
  #
  #   # (任意) ボリュームの作成元となるスナップショットID
  #   # 例: "snap-1234567890abcdef0"
  #   snapshot_id = ""
  #
  #   # (任意) ボリュームのスループット (MiB/s)
  #   # gp3ボリュームタイプでのみ使用可能
  #   throughput = 125
  #
  #   # (任意) ボリュームのサイズ (GiB)
  #   # snapshot_idを指定した場合、スナップショットと同じかそれ以上のサイズである必要があります
  #   volume_size = 100
  #
  #   # (任意) ボリュームのタイプ
  #   # 有効な値: "standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"
  #   # デフォルト: "gp2"
  #   volume_type = "gp3"
  # }

  #---------------------------------------------------------------
  # ブロックデバイス設定 - Ephemeral Block Devices
  #---------------------------------------------------------------

  # (任意) インスタンスのエフェメラル (インスタンスストア) ボリュームのカスタマイズ
  # インスタンスストアボリュームは、インスタンスが停止または終了すると失われます
  # 複数指定可能
  # ephemeral_block_device {
  #   # (必須) デバイス名 (例: "/dev/sdb", "/dev/xvdb")
  #   device_name = "/dev/sdb"
  #
  #   # (任意) AMIのブロックデバイスマッピングを抑制するかどうか
  #   # trueの場合、このデバイス名のマッピングが無効化されます
  #   no_device = false
  #
  #   # (任意) インスタンスストアボリュームの仮想名
  #   # 例: "ephemeral0", "ephemeral1"
  #   # 利用可能な仮想名はインスタンスタイプによって異なります
  #   virtual_name = "ephemeral0"
  # }

  #---------------------------------------------------------------
  # メタデータオプション設定
  #---------------------------------------------------------------

  # (任意) インスタンスのメタデータオプション
  # Instance Metadata Service (IMDS) の設定をカスタマイズします
  # 最大1つまで指定可能
  # metadata_options {
  #   # (任意) メタデータサービスの状態
  #   # 有効な値: "enabled", "disabled"
  #   # デフォルト: "enabled"
  #   http_endpoint = "enabled"
  #
  #   # (任意) インスタンスメタデータリクエストの希望するHTTP PUTレスポンスホップ制限
  #   # 有効な値: 1〜64の整数
  #   # デフォルト: 1
  #   http_put_response_hop_limit = 1
  #
  #   # (任意) セッショントークンが必要かどうか
  #   # 有効な値: "optional", "required"
  #   # "required"の場合、IMDSv2が必須となり、セキュリティが向上します
  #   # デフォルト: "optional"
  #   http_tokens = "required"
  # }
}

#---------------------------------------------------------------
# Attributes Reference (Computed Only - 参照のみ)
#---------------------------------------------------------------
#
# 以下の属性はTerraformによって自動的に設定され、参照のみ可能です。
# リソース定義では設定できません。
#
# - id   : Launch Configurationの一意識別子 (名前と同じ)
# - arn  : Launch ConfigurationのAmazon Resource Name
# - name : Launch Configurationの名前 (nameまたはname_prefixで指定、または自動生成)
#
# 使用例:
#   output "launch_config_id" {
#     value = aws_launch_configuration.example.id
#   }
#
#   output "launch_config_arn" {
#     value = aws_launch_configuration.example.arn
#   }
#
#---------------------------------------------------------------
