#---------------------------------------------------------------
# Amazon EC2 Instance
#---------------------------------------------------------------
#
# Amazon EC2インスタンスをプロビジョニングするリソースです。
# このリソースを使用して、EC2インスタンスの作成、更新、削除を行うことができます。
# インスタンスはプロビジョニングもサポートしています。
#
# AWS公式ドキュメント:
#   - EC2インスタンス: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Instances.html
#   - インスタンスライフサイクル: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
#   - インスタンスタイプ: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
#   - EBS最適化: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#
# Provider Version: 6.28.0
# Generated: 2026-01-27
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_instance" "example" {
  #-------------------------------------------------------------
  # 基本設定（必須）
  #-------------------------------------------------------------

  # ami (Optional)
  # 設定内容: インスタンスに使用するAMI IDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-0c55b159cbfafe1f0）
  # 注意: launch_templateで指定しない限り必須です。
  #       launch_templateでAMIが指定されている場合、この値で上書きできます。
  # 関連機能: AMIはインスタンスのベースイメージを定義します
  ami = "ami-0c55b159cbfafe1f0"

  # instance_type (Optional)
  # 設定内容: インスタンスタイプを指定します。
  # 設定可能な値: 有効なインスタンスタイプ（例: t3.micro, m5.large, c5.xlarge）
  # 注意: launch_templateで指定しない限り必須です。
  #       launch_templateでインスタンスタイプが指定されている場合、この値で上書きできます。
  #       この値の更新はインスタンスの停止/起動をトリガーします。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
  instance_type = "t3.micro"

  #-------------------------------------------------------------
  # リージョン・配置設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  # availability_zone (Optional)
  # 設定内容: インスタンスを起動するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なAZ名（例: ap-northeast-1a, us-east-1b）
  # 省略時: AWSが自動的に選択
  availability_zone = null

  # placement_group (Optional)
  # 設定内容: インスタンスを起動する配置グループ名を指定します。
  # 設定可能な値: 既存の配置グループ名
  # 注意: placement_group_idと競合します
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  placement_group = null

  # placement_group_id (Optional)
  # 設定内容: インスタンスを起動する配置グループのIDを指定します。
  # 設定可能な値: 既存の配置グループID
  # 注意: placement_groupと競合します
  placement_group_id = null

  # placement_partition_number (Optional)
  # 設定内容: インスタンスが配置されるパーティション番号を指定します。
  # 設定可能な値: 整数値
  # 注意: aws_placement_groupのstrategyが"partition"の場合のみ有効
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/placement_group
  placement_partition_number = null

  # tenancy (Optional)
  # 設定内容: インスタンスのテナンシー（VPCで実行される場合）を指定します。
  # 設定可能な値:
  #   - "default": 共有ハードウェア
  #   - "dedicated": 専用ハードウェア
  #   - "host": 専用ホスト
  # 注意: import-instanceコマンドでは"host"はサポートされていません
  tenancy = null

  # host_id (Optional)
  # 設定内容: インスタンスが割り当てられる専用ホストのIDを指定します。
  # 設定可能な値: 専用ホストのID
  # 用途: 特定の専用ホストでインスタンスを起動する場合に使用
  host_id = null

  # host_resource_group_arn (Optional)
  # 設定内容: インスタンスを起動するホストリソースグループのARNを指定します。
  # 設定可能な値: ホストリソースグループのARN
  # 注意: ARNを指定する場合、tenancyパラメータは省略するか"host"に設定します
  host_resource_group_arn = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # subnet_id (Optional)
  # 設定内容: 起動するVPCサブネットIDを指定します。
  # 設定可能な値: 有効なサブネットID
  subnet_id = null

  # vpc_security_group_ids (Optional, VPC only)
  # 設定内容: 関連付けるセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDのリスト
  # 用途: VPC内でのみ使用可能
  vpc_security_group_ids = []

  # security_groups (Optional, EC2-Classic and default VPC only)
  # 設定内容: 関連付けるセキュリティグループ名のリストを指定します。
  # 設定可能な値: セキュリティグループ名のリスト
  # 注意: VPCでインスタンスを作成する場合は、代わりにvpc_security_group_idsを使用してください
  security_groups = []

  # associate_public_ip_address (Optional)
  # 設定内容: VPC内のインスタンスにパブリックIPアドレスを関連付けるかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPを関連付ける
  #   - false: パブリックIPを関連付けない
  associate_public_ip_address = null

  # private_ip (Optional)
  # 設定内容: VPC内のインスタンスに関連付けるプライベートIPアドレスを指定します。
  # 設定可能な値: 有効なプライベートIPアドレス
  private_ip = null

  # secondary_private_ips (Optional)
  # 設定内容: インスタンスのプライマリネットワークインターフェース(eth0)に割り当てるセカンダリプライベートIPv4アドレスのリストを指定します。
  # 設定可能な値: プライベートIPアドレスのリスト
  # 注意: インスタンス作成時に接続されたプライマリネットワークインターフェース(eth0)にのみ割り当て可能です。
  #       既存のネットワークインターフェース（network_interfaceブロックで参照）には割り当てできません。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
  secondary_private_ips = []

  # source_dest_check (Optional)
  # 設定内容: 送信先アドレスがインスタンスと一致しない場合にトラフィックをルーティングするかを制御します。
  # 設定可能な値:
  #   - true (デフォルト): 送信元/送信先チェックを有効化
  #   - false: 送信元/送信先チェックを無効化
  # 用途: NATまたはVPNで使用
  source_dest_check = true

  # enable_primary_ipv6 (Optional)
  # 設定内容: デュアルスタックまたはIPv6専用サブネットで起動する際に、プライマリIPv6グローバルユニキャストアドレス(GUA)を割り当てるかを指定します。
  # 設定可能な値:
  #   - true: プライマリIPv6アドレスを割り当てる
  #   - false: プライマリIPv6アドレスを割り当てない
  # 注意: プライマリIPv6アドレスは一度有効にすると、最初のIPv6 GUAがプライマリIPv6アドレスになり無効化できません。
  #       インスタンスが終了するかENIがデタッチされるまでプライマリIPv6アドレスは保持されます。
  #       有効化後に無効化するとインスタンスの再作成が発生します。
  enable_primary_ipv6 = null

  # ipv6_address_count (Optional)
  # 設定内容: プライマリネットワークインターフェースに関連付けるIPv6アドレスの数を指定します。
  # 設定可能な値: 整数値
  # 注意: ipv6_addressesと同時には使用できません
  ipv6_address_count = null

  # ipv6_addresses (Optional)
  # 設定内容: サブネットの範囲から1つ以上のIPv6アドレスを指定して、プライマリネットワークインターフェースに関連付けます。
  # 設定可能な値: IPv6アドレスのリスト
  # 注意: ipv6_address_countと同時には使用できません
  ipv6_addresses = []

  #-------------------------------------------------------------
  # ストレージ設定
  #-------------------------------------------------------------

  # ebs_optimized (Optional)
  # 設定内容: 起動されるEC2インスタンスをEBS最適化するかを指定します。
  # 設定可能な値:
  #   - true: EBS最適化を有効化
  #   - false: EBS最適化を無効化
  # 注意: デフォルトで最適化されているインスタンスタイプでこれを設定しない場合、
  #       無効と表示されますが、効果はありません。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html
  ebs_optimized = null

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_instance_profile (Optional)
  # 設定内容: インスタンスに起動時に割り当てるIAMインスタンスプロファイルを指定します。
  # 設定可能な値: インスタンスプロファイルの名前
  # 注意: 認証情報にインスタンスプロファイルを割り当てる適切な権限があることを確認してください。
  #       特に`iam:PassRole`権限が必要です。
  # 参考: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html#roles-usingrole-ec2instance-permissions
  iam_instance_profile = null

  #-------------------------------------------------------------
  # セキュリティ設定
  #-------------------------------------------------------------

  # key_name (Optional)
  # 設定内容: インスタンスで使用するキーペアの名前を指定します。
  # 設定可能な値: 既存のキーペア名
  # 関連リソース: aws_key_pairリソースで管理可能
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
  key_name = null

  # disable_api_termination (Optional)
  # 設定内容: EC2インスタンス終了保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 終了保護を有効化
  #   - false: 終了保護を無効化
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingDisableAPITermination
  disable_api_termination = null

  # disable_api_stop (Optional)
  # 設定内容: EC2インスタンス停止保護を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 停止保護を有効化
  #   - false: 停止保護を無効化
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Stop_Start.html#Using_StopProtection
  disable_api_stop = null

  # force_destroy (Optional)
  # 設定内容: disable_api_terminationまたはdisable_api_stopがtrueに設定されている場合でもインスタンスを破棄します。
  # 設定可能な値:
  #   - true: 強制破棄を有効化
  #   - false (デフォルト): 強制破棄を無効化
  # 注意: このパラメータをtrueに設定した後、destroy前に成功したterraform applyの実行が必要です。
  #       インスタンスのインポート後は、このフラグを有効にするために成功したterraform applyが必要です。
  force_destroy = false

  #-------------------------------------------------------------
  # ユーザーデータ設定
  #-------------------------------------------------------------

  # user_data (Optional)
  # 設定内容: インスタンス起動時に提供するユーザーデータを指定します。
  # 設定可能な値: スクリプトまたは設定データ（文字列）
  # 注意: この引数でgzip圧縮データを渡さないでください。代わりにuser_data_base64を使用してください。
  #       この値の更新は、デフォルトでインスタンスの停止/起動をトリガーします。
  #       user_data_replace_on_changeが設定されている場合、インスタンスの破棄と再作成をトリガーします。
  user_data = null

  # user_data_base64 (Optional)
  # 設定内容: user_dataの代わりに使用して、base64エンコードされたバイナリデータを直接渡すことができます。
  # 設定可能な値: Base64エンコードされた文字列
  # 用途: 値が有効なUTF-8文字列でない場合に使用します。
  #       例えば、gzip圧縮されたユーザーデータは破損を避けるためにbase64エンコードしてこの引数で渡す必要があります。
  # 注意: この値の更新は、デフォルトでインスタンスの停止/起動をトリガーします。
  #       user_data_replace_on_changeが設定されている場合、インスタンスの破棄と再作成をトリガーします。
  user_data_base64 = null

  # user_data_replace_on_change (Optional)
  # 設定内容: user_dataまたはuser_data_base64と組み合わせて使用すると、trueに設定された場合にインスタンスの破棄と再作成をトリガーします。
  # 設定可能な値:
  #   - true: ユーザーデータ変更時にインスタンスを再作成
  #   - false (デフォルト): ユーザーデータ変更時にインスタンスを停止/起動
  user_data_replace_on_change = null

  #-------------------------------------------------------------
  # インスタンス動作設定
  #-------------------------------------------------------------

  # instance_initiated_shutdown_behavior (Optional)
  # 設定内容: インスタンスのシャットダウン動作を指定します。
  # 設定可能な値:
  #   - "stop" (EBS-backedインスタンスのデフォルト): インスタンスを停止
  #   - "terminate" (instance-storeインスタンスのデフォルト): インスタンスを終了
  # 注意: instance-storeインスタンスには設定できません
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  instance_initiated_shutdown_behavior = null

  # hibernation (Optional)
  # 設定内容: 起動されるEC2インスタンスがハイバネーションをサポートするかを指定します。
  # 設定可能な値:
  #   - true: ハイバネーションを有効化
  #   - false: ハイバネーションを無効化
  hibernation = null

  # monitoring (Optional)
  # 設定内容: 起動されるEC2インスタンスで詳細モニタリングを有効にするかを指定します。
  # 設定可能な値:
  #   - true: 詳細モニタリングを有効化
  #   - false: 詳細モニタリングを無効化
  monitoring = null

  #-------------------------------------------------------------
  # パスワード取得設定
  #-------------------------------------------------------------

  # get_password_data (Optional)
  # 設定内容: パスワードデータが利用可能になるまで待機し、取得するかを指定します。
  # 設定可能な値:
  #   - true: パスワードデータを取得
  #   - false: パスワードデータを取得しない
  # 用途: Microsoft Windowsを実行しているインスタンスの管理者パスワードを取得する場合に便利です。
  #       パスワードデータはpassword_data属性にエクスポートされます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_GetPasswordData.html
  get_password_data = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キー・バリューペアのマップ
  # 注意: これらのタグはインスタンスに適用され、ブロックストレージデバイスには適用されません。
  #       プロバイダーにdefault_tags設定ブロックがある場合、一致するキーを持つタグは
  #       プロバイダーレベルで定義されたタグを上書きします。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name = "example-instance"
  }

  # volume_tags (Optional)
  # 設定内容: インスタンス作成時にルートおよびEBSボリュームに割り当てるタグのマップを指定します。
  # 設定可能な値: キー・バリューペアのマップ
  # 注意: aws_instanceの外部でブロックデバイスタグを管理する予定の場合（aws_ebs_volumeリソースの
  #       tagsやaws_volume_attachmentなど）、volume_tagsは使用しないでください。
  #       そうすると、リソースサイクルや一貫性のない動作が発生します。
  # 参考: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
  volume_tags = null

  # tags_all (Optional)
  # 設定内容: リソースに割り当てられたタグのマップ（プロバイダーのdefault_tags設定ブロックから継承されたものを含む）
  # 注意: これはcomputed属性ですが、optionalフラグも持っています
  tags_all = null

  # id (Optional)
  # 設定内容: インスタンスIDを指定します。
  # 注意: 通常はTerraformによって自動的に生成されますが、optionalフラグがあります
  id = null

  #-------------------------------------------------------------
  # ネストブロック: capacity_reservation_specification
  #-------------------------------------------------------------
  # インスタンスのキャパシティ予約ターゲティングオプションを記述します。

  capacity_reservation_specification {
    # capacity_reservation_preference (Optional)
    # 設定内容: インスタンスのキャパシティ予約設定を指定します。
    # 設定可能な値:
    #   - "open" (デフォルト): オープンキャパシティ予約を使用
    #   - "none": キャパシティ予約を使用しない
    capacity_reservation_preference = "open"

    # capacity_reservation_target (Optional)
    # 設定内容: ターゲットキャパシティ予約に関する情報を指定します。
    capacity_reservation_target {
      # capacity_reservation_id (Optional)
      # 設定内容: インスタンスを実行するキャパシティ予約のIDを指定します。
      # 設定可能な値: キャパシティ予約ID
      capacity_reservation_id = null

      # capacity_reservation_resource_group_arn (Optional)
      # 設定内容: インスタンスを実行するキャパシティ予約リソースグループのARNを指定します。
      # 設定可能な値: キャパシティ予約リソースグループのARN
      capacity_reservation_resource_group_arn = null
    }
  }

  #-------------------------------------------------------------
  # ネストブロック: cpu_options
  #-------------------------------------------------------------
  # インスタンスのCPUオプションを設定します。

  cpu_options {
    # core_count (Optional)
    # 設定内容: インスタンスのCPUコア数を設定します。
    # 設定可能な値: 整数値
    # 注意: このオプションは、CPUオプションをサポートするインスタンスタイプの作成時のみサポートされます。
    #       サポートされていないインスタンスタイプでこのオプションを指定すると、EC2 APIからエラーが返されます。
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
    core_count = null

    # threads_per_core (Optional)
    # 設定内容: コアあたりのスレッド数を設定します。
    # 設定可能な値:
    #   - 1: ハイパースレッディングを無効化
    #   - 2 (デフォルト): ハイパースレッディングを有効化
    # 注意: core_countも設定されていない場合、効果はありません
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html
    threads_per_core = null

    # amd_sev_snp (Optional)
    # 設定内容: インスタンスでAMD SEV-SNPを有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled": AMD SEV-SNPを有効化
    #   - "disabled": AMD SEV-SNPを無効化
    # 注意: AMD SEV-SNPはM6a、R6a、C6aインスタンスタイプでのみサポートされています
    amd_sev_snp = null
  }

  #-------------------------------------------------------------
  # ネストブロック: credit_specification
  #-------------------------------------------------------------
  # インスタンスのクレジット仕様をカスタマイズします。

  credit_specification {
    # cpu_credits (Optional)
    # 設定内容: CPU使用のクレジットオプションを指定します。
    # 設定可能な値:
    #   - "standard": 標準クレジット（T2インスタンスのデフォルト）
    #   - "unlimited": 無制限クレジット（T3インスタンスのデフォルト）
    # 注意: Terraformは設定に存在する場合のみドリフト検出を実行します。
    #       既存のインスタンスでこの設定を削除しても、管理を停止するだけで、
    #       インスタンスタイプのデフォルトに戻すことはありません。
    cpu_credits = null
  }

  #-------------------------------------------------------------
  # ネストブロック: ebs_block_device
  #-------------------------------------------------------------
  # インスタンスに追加するEBSブロックデバイスの設定です。
  # 複数のブロックを定義できます。

  ebs_block_device {
    # device_name (Required)
    # 設定内容: マウントするデバイスの名前を指定します。
    # 設定可能な値: デバイス名（例: /dev/sdf, /dev/sdg）
    device_name = "/dev/sdf"

    # volume_type (Optional)
    # 設定内容: ボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "standard": 標準（マグネティック）
    #   - "gp2" (デフォルト): 汎用SSD
    #   - "gp3": 汎用SSD（第3世代）
    #   - "io1": プロビジョンドIOPS SSD
    #   - "io2": プロビジョンドIOPS SSD（第2世代）
    #   - "sc1": コールドHDD
    #   - "st1": スループット最適化HDD
    volume_type = "gp2"

    # volume_size (Optional)
    # 設定内容: ボリュームのサイズをギビバイト(GiB)で指定します。
    # 設定可能な値: 整数値（ボリュームタイプに応じた範囲）
    volume_size = null

    # iops (Optional)
    # 設定内容: プロビジョンドIOPS量を指定します。
    # 設定可能な値: 整数値
    # 注意: volume_typeが"io1"、"io2"、または"gp3"の場合のみ有効
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-io-characteristics.html
    iops = null

    # throughput (Optional)
    # 設定内容: ボリュームのスループットをメビバイト毎秒(MiB/s)でプロビジョニングします。
    # 設定可能な値: 整数値（125-1000 MiB/s）
    # 注意: volume_typeが"gp3"の場合のみ有効
    throughput = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にボリュームを破棄するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): 終了時に削除
    #   - false: 終了時に保持
    delete_on_termination = true

    # encrypted (Optional)
    # 設定内容: ボリュームの暗号化を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 暗号化を有効化
    #   - false (デフォルト): 暗号化を無効化
    # 注意: snapshot_idと同時に使用できません。ドリフト検出を実行するには設定が必要です。
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html
    encrypted = null

    # kms_key_id (Optional)
    # 設定内容: ボリュームの暗号化時に使用するKMSキーのARNを指定します。
    # 設定可能な値: KMSキーのARN
    # 注意: ドリフト検出を実行するには設定が必要です
    kms_key_id = null

    # snapshot_id (Optional)
    # 設定内容: マウントするスナップショットIDを指定します。
    # 設定可能な値: 有効なスナップショットID
    snapshot_id = null

    # tags (Optional)
    # 設定内容: デバイスに割り当てるタグのマップを指定します。
    # 設定可能な値: キー・バリューペアのマップ
    tags = null
  }

  #-------------------------------------------------------------
  # ネストブロック: enclave_options
  #-------------------------------------------------------------
  # 起動されたインスタンスでNitro Enclavesを有効にします。

  enclave_options {
    # enabled (Optional)
    # 設定内容: インスタンスでNitro Enclavesを有効にするかを指定します。
    # 設定可能な値:
    #   - true: Nitro Enclavesを有効化
    #   - false (デフォルト): Nitro Enclavesを無効化
    # 参考: https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html
    enabled = false
  }

  #-------------------------------------------------------------
  # ネストブロック: ephemeral_block_device
  #-------------------------------------------------------------
  # インスタンスのエフェメラル（インスタンスストア）ボリュームをカスタマイズします。
  # 複数のブロックを定義できます。

  ephemeral_block_device {
    # device_name (Required)
    # 設定内容: インスタンスにマウントするブロックデバイスの名前を指定します。
    # 設定可能な値: デバイス名
    device_name = "/dev/sdb"

    # virtual_name (Optional)
    # 設定内容: インスタンスストアデバイス名を指定します。
    # 設定可能な値: "ephemeral0"から"ephemeralN"の形式
    # 注意: 各AWSインスタンスタイプには、接続可能なインスタンスストアブロックデバイスの
    #       セットが異なります。AWSは各タイプで利用可能なエフェメラルデバイスのリストを公開しています。
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html#InstanceStoreDeviceNames
    virtual_name = "ephemeral0"

    # no_device (Optional)
    # 設定内容: AMIのブロックデバイスマッピングに含まれる指定されたデバイスを抑制します。
    # 設定可能な値: true/false
    no_device = null
  }

  #-------------------------------------------------------------
  # ネストブロック: instance_market_options
  #-------------------------------------------------------------
  # インスタンスの市場（購入）オプションを記述します。

  instance_market_options {
    # market_type (Optional)
    # 設定内容: インスタンスの市場タイプを指定します。
    # 設定可能な値:
    #   - "spot" (デフォルト): スポットインスタンス
    #   - "capacity-block": キャパシティブロック
    # 注意: spot_optionsが指定されている場合は必須
    market_type = "spot"

    # spot_options (Optional)
    # 設定内容: スポットインスタンスのオプションを設定するブロックです。
    spot_options {
      # max_price (Optional)
      # 設定内容: スポットインスタンスに支払う最大時間単価を指定します。
      # 設定可能な値: 価格（文字列形式）
      max_price = null

      # spot_instance_type (Optional)
      # 設定内容: スポットインスタンスリクエストのタイプを指定します。
      # 設定可能な値:
      #   - "one-time" (デフォルト): 1回限りのリクエスト
      #   - "persistent": 永続的なリクエスト
      # 注意: 永続的なスポットインスタンスリクエストは、インスタンス中断動作が
      #       hibernateまたはstopの場合のみサポートされます
      spot_instance_type = "one-time"

      # instance_interruption_behavior (Optional)
      # 設定内容: スポットインスタンスが中断された場合の動作を指定します。
      # 設定可能な値:
      #   - "terminate" (デフォルト): インスタンスを終了
      #   - "stop": インスタンスを停止
      #   - "hibernate": インスタンスをハイバネート
      instance_interruption_behavior = "terminate"

      # valid_until (Optional)
      # 設定内容: リクエストの終了日をUTC形式で指定します。
      # 設定可能な値: YYYY-MM-DDTHH:MM:SSZ形式のタイムスタンプ
      # 注意: 永続的なリクエストでのみサポートされます
      valid_until = null
    }
  }

  #-------------------------------------------------------------
  # ネストブロック: launch_template
  #-------------------------------------------------------------
  # インスタンスを設定するための起動テンプレートを指定します。
  # このリソースで設定されたパラメータは、起動テンプレートの対応するパラメータを上書きします。

  launch_template {
    # id (Optional)
    # 設定内容: 起動テンプレートのIDを指定します。
    # 設定可能な値: 起動テンプレートID
    # 注意: nameと競合します
    id = null

    # name (Optional)
    # 設定内容: 起動テンプレートの名前を指定します。
    # 設定可能な値: 起動テンプレート名
    # 注意: idと競合します
    name = null

    # version (Optional)
    # 設定内容: テンプレートのバージョンを指定します。
    # 設定可能な値:
    #   - 特定のバージョン番号
    #   - "$Latest": 最新バージョン
    #   - "$Default" (デフォルト): デフォルトバージョン
    version = "$Default"
  }

  #-------------------------------------------------------------
  # ネストブロック: maintenance_options
  #-------------------------------------------------------------
  # インスタンスのメンテナンスおよび復旧オプションを設定します。

  maintenance_options {
    # auto_recovery (Optional)
    # 設定内容: インスタンスの自動復旧動作を指定します。
    # 設定可能な値:
    #   - "default": デフォルトの自動復旧動作
    #   - "disabled": 自動復旧を無効化
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html
    auto_recovery = null
  }

  #-------------------------------------------------------------
  # ネストブロック: metadata_options
  #-------------------------------------------------------------
  # インスタンスのメタデータオプションをカスタマイズします。

  metadata_options {
    # http_endpoint (Optional)
    # 設定内容: メタデータサービスが利用可能かを指定します。
    # 設定可能な値:
    #   - "enabled" (デフォルト): メタデータサービスを有効化
    #   - "disabled": メタデータサービスを無効化
    http_endpoint = "enabled"

    # http_tokens (Optional)
    # 設定内容: メタデータサービスがセッショントークンを必要とするか（IMDSv2）を指定します。
    # 設定可能な値:
    #   - "optional": IMDSv1/v2の両方を許可
    #   - "required": IMDSv2のみを許可（推奨）
    http_tokens = null

    # http_put_response_hop_limit (Optional)
    # 設定内容: インスタンスメタデータリクエストの望ましいHTTP PUTレスポンスホップ制限を指定します。
    # 設定可能な値: 1から64の整数
    # 注意: 数値が大きいほど、インスタンスメタデータリクエストはより遠くまで移動できます
    # デフォルト: 1
    http_put_response_hop_limit = 1

    # http_protocol_ipv6 (Optional)
    # 設定内容: インスタンスメタデータサービスのIPv6エンドポイントを有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled": IPv6エンドポイントを有効化
    #   - "disabled" (デフォルト): IPv6エンドポイントを無効化
    http_protocol_ipv6 = "disabled"

    # instance_metadata_tags (Optional)
    # 設定内容: インスタンスメタデータサービスからインスタンスタグへのアクセスを有効または無効にします。
    # 設定可能な値:
    #   - "enabled": インスタンスタグへのアクセスを有効化
    #   - "disabled" (デフォルト): インスタンスタグへのアクセスを無効化
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
    instance_metadata_tags = "disabled"
  }

  #-------------------------------------------------------------
  # ネストブロック: network_interface (Deprecated)
  #-------------------------------------------------------------
  # インスタンスブート時に接続されるネットワークインターフェースをカスタマイズします。
  #
  # 注意: プライマリネットワークインターフェースを指定する場合はprimary_network_interfaceの使用が推奨されます。
  #       追加のネットワークインターフェースを接続する場合はaws_network_interface_attachmentリソースを使用してください。
  #       aws_instanceでnetwork_interfaceを使用すると、Terraformはインスタンスのすべての非ルートEBSブロックデバイスの
  #       管理を引き受け、追加のブロックデバイスをドリフトとして扱います。
  # 複数のブロックを定義できます。

  network_interface {
    # network_interface_id (Required)
    # 設定内容: 接続するネットワークインターフェースのIDを指定します。
    # 設定可能な値: ネットワークインターフェースID
    network_interface_id = null

    # device_index (Required)
    # 設定内容: ネットワークインターフェース接続の整数インデックスを指定します。
    # 設定可能な値: 整数値
    # 注意: インスタンスタイプによって制限されます
    device_index = 0

    # network_card_index (Optional)
    # 設定内容: ネットワークカードの整数インデックスを指定します。
    # 設定可能な値: 整数値
    # 注意: インスタンスタイプによって制限されます
    # デフォルト: 0
    network_card_index = 0

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にネットワークインターフェースを削除するかを指定します。
    # 設定可能な値:
    #   - true: 終了時に削除
    #   - false (デフォルト): 終了時に保持
    # 注意: 現在、唯一の有効な値はfalseです。これは新しいネットワークインターフェースを
    #       作成する際のみサポートされているためです。
    delete_on_termination = false
  }

  #-------------------------------------------------------------
  # ネストブロック: primary_network_interface
  #-------------------------------------------------------------
  # プライマリネットワークインターフェースを設定します。

  primary_network_interface {
    # network_interface_id (Required)
    # 設定内容: 接続するネットワークインターフェースのIDを指定します。
    # 設定可能な値: ネットワークインターフェースID
    network_interface_id = null

    # delete_on_termination (Read-Only)
    # このフィールドは読み取り専用です。
    # インスタンス終了時にネットワークインターフェースが削除されるかを示します。
  }

  #-------------------------------------------------------------
  # ネストブロック: private_dns_name_options
  #-------------------------------------------------------------
  # インスタンスホスト名のオプションを設定します。
  # デフォルト値はサブネットから継承されます。

  private_dns_name_options {
    # hostname_type (Optional)
    # 設定内容: Amazon EC2インスタンスのホスト名タイプを指定します。
    # 設定可能な値:
    #   - "ip-name": IPv4アドレスベースのDNS名
    #   - "resource-name": インスタンスIDベースのDNS名
    # 注意: IPv4専用サブネットでは、インスタンスDNS名はインスタンスIPv4アドレスに基づく必要があります。
    #       IPv6ネイティブサブネットでは、インスタンスDNS名はインスタンスIDに基づく必要があります。
    #       デュアルスタックサブネットでは、DNS名がインスタンスIPv4アドレスを使用するか
    #       インスタンスIDを使用するかを指定できます。
    hostname_type = null

    # enable_resource_name_dns_a_record (Optional)
    # 設定内容: インスタンスホスト名のDNSクエリに対してDNS Aレコードで応答するかを指定します。
    # 設定可能な値: true/false
    enable_resource_name_dns_a_record = null

    # enable_resource_name_dns_aaaa_record (Optional)
    # 設定内容: インスタンスホスト名のDNSクエリに対してDNS AAAAレコードで応答するかを指定します。
    # 設定可能な値: true/false
    enable_resource_name_dns_aaaa_record = null
  }

  #-------------------------------------------------------------
  # ネストブロック: root_block_device
  #-------------------------------------------------------------
  # インスタンスのルートブロックデバイスの詳細をカスタマイズします。
  # 属性参照としてアクセスする場合、1つのオブジェクトを含むリストです。

  root_block_device {
    # volume_type (Optional)
    # 設定内容: ボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "standard": 標準（マグネティック）
    #   - "gp2": 汎用SSD
    #   - "gp3": 汎用SSD（第3世代）
    #   - "io1": プロビジョンドIOPS SSD
    #   - "io2": プロビジョンドIOPS SSD（第2世代）
    #   - "sc1": コールドHDD
    #   - "st1": スループット最適化HDD
    # デフォルト: AMIが使用するボリュームタイプ
    volume_type = null

    # volume_size (Optional)
    # 設定内容: ボリュームのサイズをギビバイト(GiB)で指定します。
    # 設定可能な値: 整数値（ボリュームタイプに応じた範囲）
    volume_size = null

    # iops (Optional)
    # 設定内容: プロビジョンドIOPS量を指定します。
    # 設定可能な値: 整数値
    # 注意: volume_typeが"io1"、"io2"、または"gp3"の場合のみ有効
    # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-io-characteristics.html
    iops = null

    # throughput (Optional)
    # 設定内容: ボリュームのスループットをメビバイト毎秒(MiB/s)でプロビジョニングします。
    # 設定可能な値: 整数値
    # 注意: volume_typeが"gp3"の場合のみ有効
    throughput = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にボリュームを破棄するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): 終了時に削除
    #   - false: 終了時に保持
    delete_on_termination = true

    # encrypted (Optional)
    # 設定内容: ボリュームの暗号化を有効にするかを指定します。
    # 設定可能な値:
    #   - true: 暗号化を有効化
    #   - false (デフォルト): 暗号化を無効化
    # 注意: ドリフト検出を実行するには設定が必要です
    encrypted = null

    # kms_key_id (Optional)
    # 設定内容: ボリュームの暗号化時に使用するKMSキーのARNを指定します。
    # 設定可能な値: KMSキーのARN
    # 注意: ドリフト検出を実行するには設定が必要です
    kms_key_id = null

    # tags (Optional)
    # 設定内容: デバイスに割り当てるタグのマップを指定します。
    # 設定可能な値: キー・バリューペアのマップ
    tags = null
  }

  #-------------------------------------------------------------
  # ネストブロック: timeouts
  #-------------------------------------------------------------
  # リソース操作のタイムアウトを設定します。

  timeouts {
    # create (Optional)
    # 設定内容: インスタンス作成のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "60m", "2h"）
    create = null

    # update (Optional)
    # 設定内容: インスタンス更新のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "60m", "2h"）
    update = null

    # delete (Optional)
    # 設定内容: インスタンス削除のタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "60m", "2h"）
    delete = null

    # read (Optional)
    # 設定内容: インスタンス読み取りのタイムアウトを指定します。
    # 設定可能な値: 期間文字列（例: "20m"）
    read = null
  }
}

#---------------------------------------------------------------
# Attributes Reference
#---------------------------------------------------------------
# 以下の属性は読み取り専用です（computed only）。
# これらはリソースの出力として参照できますが、入力として設定することはできません。
#
# - arn
#   インスタンスのARN
#
# - instance_state
#   インスタンスの状態。以下のいずれか: pending, running, shutting-down,
#   terminated, stopping, stopped
#   参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
#
# - outpost_arn
#   インスタンスが割り当てられているOutpostのARN
#
# - password_data
#   インスタンスのBase-64エンコードされた暗号化パスワードデータ。
#   Microsoft Windowsを実行しているインスタンスの管理者パスワードを取得するのに便利です。
#   get_password_dataがtrueの場合のみエクスポートされます。
#   暗号化された値は状態ファイルに保存されます。
#   参考: https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_GetPasswordData.html
#
# - primary_network_interface_id
#   インスタンスのプライマリネットワークインターフェースのID
#
# - private_dns
#   インスタンスに割り当てられたプライベートDNS名。
#   Amazon EC2内でのみ使用でき、VPCのDNSホスト名を有効にしている場合のみ利用可能です。
#
# - public_dns
#   インスタンスに割り当てられたパブリックDNS名。
#   EC2-VPCの場合、VPCのDNSホスト名を有効にしている場合のみ利用可能です。
#
# - public_ip
#   インスタンスに割り当てられたパブリックIPアドレス（該当する場合）。
#   注意: インスタンスでaws_eipを使用している場合は、public_ipではなく
#         EIPのアドレスを直接参照してください。EIP接続後、このフィールドは変更されます。
#
# - instance_lifecycle
#   これがスポットインスタンスかスケジュールされたインスタンスかを示します。
#
# - spot_instance_request_id
#   リクエストがスポットインスタンスリクエストの場合、リクエストのID。
#
# - capacity_reservation_specification
#   インスタンスのキャパシティ予約仕様
#
#---------------------------------------------------------------
