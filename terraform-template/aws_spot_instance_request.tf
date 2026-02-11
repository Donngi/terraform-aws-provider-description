#---------------------------------------------------------------
# EC2 Spot Instance Request
#---------------------------------------------------------------
#
# EC2スポットマーケットでインスタンスをリクエストするリソースです。
# スポットインスタンスは、AWS の余剰キャパシティを活用することで、
# オンデマンドインスタンスと比較して最大90%のコスト削減が可能です。
# ただし、容量が必要になった場合、AWSによって中断される可能性があります。
#
# AWS公式ドキュメント:
#   - Spot Instances概要: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html
#   - How Spot Instances work: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-instances-work.html
#   - Spot Instance interruption behavior: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/interruption-behavior.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
# 注意: AWSは、このリソースが使用するレガシーAPIの使用を強く非推奨としています。
#       代わりに、aws_instanceリソースでinstance_market_optionsを使用することを推奨します。
#       https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html#which-spot-request-method-to-use
#
#---------------------------------------------------------------

resource "aws_spot_instance_request" "example" {
  #-------------------------------------------------------------
  # 基本設定
  #-------------------------------------------------------------

  # ami (Optional, Forces new resource)
  # 設定内容: 起動するAMI（Amazon Machine Image）のIDを指定します。
  # 設定可能な値: 有効なAMI ID（例: ami-12345678）
  # 省略時: launch_templateで指定されたAMIが使用されます。
  # 注意: launch_templateと併用する場合、launch_template内のAMI設定を上書きします。
  ami = "ami-12345678"

  # instance_type (Optional, Forces new resource)
  # 設定内容: 起動するインスタンスタイプを指定します。
  # 設定可能な値: 有効なEC2インスタンスタイプ（例: t3.micro, c5.large）
  # 省略時: launch_templateで指定されたインスタンスタイプが使用されます。
  # 注意: launch_templateと併用する場合、launch_template内のインスタンスタイプ設定を上書きします。
  instance_type = "t3.micro"

  # key_name (Optional, Forces new resource)
  # 設定内容: インスタンスへのSSH接続に使用するキーペア名を指定します。
  # 設定可能な値: 既存のEC2キーペア名
  # 省略時: キーペアなしでインスタンスが起動します。
  key_name = "my-key-pair"

  #-------------------------------------------------------------
  # Spotリクエスト設定
  #-------------------------------------------------------------

  # spot_price (Optional)
  # 設定内容: スポットマーケットでリクエストする最大価格を指定します。
  # 設定可能な値: 時間あたりの価格を文字列で指定（例: "0.05"）
  # 省略時: オンデマンド価格が最大価格として設定されます。
  # 注意: 最大価格を設定しても、起動確率が上がったり中断確率が下がったりすることはありません。
  #       実際の支払額はスポット価格であり、最大価格ではありません。
  # 参考: https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-leveraging-ec2-spot-instances/how-spot-instances-work.html
  spot_price = "0.05"

  # spot_type (Optional)
  # 設定内容: スポットリクエストのタイプを指定します。
  # 設定可能な値:
  #   - "persistent" (デフォルト): インスタンスが終了しても、リクエストは継続され、再度起動が試みられます
  #   - "one-time": インスタンスが終了すると、スポットリクエストも閉じられます
  # 省略時: "persistent"が設定されます。
  # 注意: 永続的なリクエストは、キャンセルまたは有効期限まで継続されます。
  # 参考: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-instances-work.html
  spot_type = "persistent"

  # instance_interruption_behavior (Optional)
  # 設定内容: スポットインスタンスが中断された際の動作を指定します。
  # 設定可能な値:
  #   - "terminate" (デフォルト): インスタンスを終了します
  #   - "stop": インスタンスを停止します（spot_typeがpersistentの場合のみ）
  #   - "hibernate": インスタンスを休止状態にします（spot_typeがpersistentの場合のみ）
  # 省略時: "terminate"が設定されます。
  # 関連機能: Spot Instance interruption behavior
  #   中断時の動作により、アプリケーションの状態保存方法が変わります。
  #   停止または休止を選択した場合、容量が利用可能になると自動的に再起動されます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/interruption-behavior.html
  instance_interruption_behavior = "terminate"

  # wait_for_fulfillment (Optional)
  # 設定内容: スポットリクエストが満たされるまでTerraformが待機するかを指定します。
  # 設定可能な値:
  #   - true: リクエストが満たされるまで待機します（タイムアウト10分）
  #   - false (デフォルト): リクエスト送信後すぐに完了します
  # 省略時: falseが設定されます。
  # 注意: trueに設定した場合、10分以内にインスタンスが起動しない場合はエラーが発生します。
  wait_for_fulfillment = false

  # launch_group (Optional, Forces new resource)
  # 設定内容: 一緒に起動・終了するスポットインスタンスのグループ名を指定します。
  # 設定可能な値: 任意のグループ名文字列
  # 省略時: インスタンスは個別に起動・終了されます。
  # 関連機能: Launch Group
  #   同じlaunch_groupを持つすべてのインスタンスが一緒に起動され、一緒に終了されます。
  #   これにより、満たされる確率は低下しますが、すべてのインスタンスが同時に終了されるリスクが高まります。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-instances-work.html
  launch_group = null

  # valid_from (Optional, Forces new resource)
  # 設定内容: スポットリクエストの開始日時を指定します。
  # 設定可能な値: UTC RFC3339形式の日時（例: 2024-01-01T00:00:00Z）
  # 省略時: リクエストはすぐに有効になります。
  # 参考: https://tools.ietf.org/html/rfc3339#section-5.8
  valid_from = null

  # valid_until (Optional, Forces new resource)
  # 設定内容: スポットリクエストの終了日時を指定します。
  # 設定可能な値: UTC RFC3339形式の日時（例: 2024-12-31T23:59:59Z）
  # 省略時: 現在の日付から7日後が終了日として設定されます。
  # 注意: この日時以降、新しいスポットインスタンスは起動されず、既存のリクエストは無効になります。
  # 参考: https://tools.ietf.org/html/rfc3339#section-5.8
  valid_until = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: ap-northeast-1, us-east-1）
  # 省略時: プロバイダー設定のリージョンを使用します。
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # ネットワーク設定
  #-------------------------------------------------------------

  # availability_zone (Optional, Forces new resource)
  # 設定内容: インスタンスを起動するアベイラビリティゾーンを指定します。
  # 設定可能な値: 有効なアベイラビリティゾーン名（例: ap-northeast-1a）
  # 省略時: AWSが自動的に選択します。
  availability_zone = null

  # subnet_id (Optional, Forces new resource)
  # 設定内容: インスタンスを起動するVPCサブネットのIDを指定します。
  # 設定可能な値: 有効なサブネットID
  # 省略時: デフォルトVPCまたはEC2-Classicで起動します。
  # 注意: サブネットを指定すると、availability_zoneは自動的に決定されます。
  subnet_id = null

  # private_ip (Optional, Forces new resource)
  # 設定内容: インスタンスに割り当てるプライマリプライベートIPアドレスを指定します。
  # 設定可能な値: サブネットのCIDR範囲内の有効なIPアドレス
  # 省略時: サブネットのCIDR範囲内から自動的に割り当てられます。
  private_ip = null

  # secondary_private_ips (Optional)
  # 設定内容: インスタンスに割り当てるセカンダリプライベートIPアドレスのリストを指定します。
  # 設定可能な値: サブネットのCIDR範囲内の有効なIPアドレスのセット
  # 省略時: セカンダリIPアドレスは割り当てられません。
  secondary_private_ips = []

  # associate_public_ip_address (Optional, Forces new resource)
  # 設定内容: パブリックIPアドレスを関連付けるかを指定します。
  # 設定可能な値:
  #   - true: パブリックIPアドレスを割り当てます
  #   - false: パブリックIPアドレスを割り当てません
  # 省略時: サブネットのパブリックIP設定に従います。
  # 注意: VPC内のインスタンスのみ有効です。
  associate_public_ip_address = null

  # ipv6_address_count (Optional, Forces new resource)
  # 設定内容: インスタンスに割り当てるIPv6アドレスの数を指定します。
  # 設定可能な値: 0以上の整数
  # 省略時: IPv6アドレスは自動割り当てされません。
  # 注意: ipv6_addressesと排他的（どちらか一方のみ指定可能）
  ipv6_address_count = null

  # ipv6_addresses (Optional, Forces new resource)
  # 設定内容: インスタンスに割り当てる特定のIPv6アドレスのリストを指定します。
  # 設定可能な値: サブネットのIPv6 CIDR範囲内の有効なIPv6アドレスのリスト
  # 省略時: IPv6アドレスは指定されません。
  # 注意: ipv6_address_countと排他的（どちらか一方のみ指定可能）
  ipv6_addresses = []

  # enable_primary_ipv6 (Optional, Forces new resource)
  # 設定内容: プライマリIPv6アドレスを有効にするかを指定します。
  # 設定可能な値:
  #   - true: プライマリIPv6アドレスを有効化します
  #   - false: プライマリIPv6アドレスを無効化します
  # 省略時: プライマリIPv6アドレスは割り当てられません。
  enable_primary_ipv6 = null

  # security_groups (Optional, Forces new resource)
  # 設定内容: インスタンスに関連付けるセキュリティグループ名のリストを指定します。
  # 設定可能な値: セキュリティグループ名のセット（VPC外の場合）
  # 注意: VPC内のインスタンスの場合は、vpc_security_group_idsを使用してください。
  #       このパラメータはEC2-ClassicまたはデフォルトVPC用です。
  security_groups = []

  # vpc_security_group_ids (Optional)
  # 設定内容: インスタンスに関連付けるVPCセキュリティグループIDのリストを指定します。
  # 設定可能な値: セキュリティグループIDのセット
  # 省略時: デフォルトセキュリティグループが使用されます。
  # 注意: VPC内のインスタンスの場合に使用します。
  vpc_security_group_ids = []

  # source_dest_check (Optional)
  # 設定内容: 送信元/送信先チェックを有効にするかを指定します。
  # 設定可能な値:
  #   - true (デフォルト): 送信元/送信先チェックを有効化します
  #   - false: 送信元/送信先チェックを無効化します
  # 省略時: trueが設定されます。
  # 注意: NAT instanceやルーターとして機能させる場合はfalseに設定します。
  source_dest_check = true

  #-------------------------------------------------------------
  # 配置設定
  #-------------------------------------------------------------

  # placement_group (Optional, Forces new resource)
  # 設定内容: インスタンスを起動する配置グループ名を指定します。
  # 設定可能な値: 既存の配置グループ名
  # 省略時: 配置グループは使用されません。
  # 関連機能: Placement Groups
  #   配置グループを使用すると、インスタンス間のネットワークレイテンシーを低減できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  placement_group = null

  # placement_group_id (Optional, Forces new resource)
  # 設定内容: インスタンスを起動する配置グループのIDを指定します。
  # 設定可能な値: 既存の配置グループID
  # 省略時: 配置グループは使用されません。
  placement_group_id = null

  # placement_partition_number (Optional, Forces new resource)
  # 設定内容: パーティション配置グループ内のパーティション番号を指定します。
  # 設定可能な値: 1以上の整数
  # 省略時: 自動的にパーティションが選択されます。
  # 注意: パーティション配置グループを使用する場合のみ有効です。
  # 関連機能: Partition Placement Groups
  #   複数のパーティションに分散してインスタンスを配置し、障害ドメインを分離できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-partition
  placement_partition_number = null

  # tenancy (Optional, Forces new resource)
  # 設定内容: インスタンスのテナンシーを指定します。
  # 設定可能な値:
  #   - "default": 共有ハードウェアで実行します
  #   - "dedicated": 専有インスタンスとして実行します
  #   - "host": 専有ホストで実行します
  # 省略時: "default"が設定されます。
  # 関連機能: Dedicated Instances
  #   専有ハードウェアでインスタンスを実行し、コンプライアンス要件を満たすことができます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html
  tenancy = null

  # host_id (Optional, Forces new resource)
  # 設定内容: インスタンスを起動する専有ホストのIDを指定します。
  # 設定可能な値: 既存の専有ホストID
  # 省略時: 専有ホストは使用されません。
  # 注意: tenancyが"host"の場合に使用します。
  host_id = null

  # host_resource_group_arn (Optional, Forces new resource)
  # 設定内容: ホストリソースグループのARNを指定します。
  # 設定可能な値: 有効なホストリソースグループARN
  # 省略時: ホストリソースグループは使用されません。
  host_resource_group_arn = null

  #-------------------------------------------------------------
  # インスタンス動作設定
  #-------------------------------------------------------------

  # monitoring (Optional)
  # 設定内容: 詳細モニタリング（CloudWatch詳細メトリクス）を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 詳細モニタリングを有効化します（1分間隔でメトリクスを収集）
  #   - false (デフォルト): 基本モニタリングのみ（5分間隔でメトリクスを収集）
  # 省略時: falseが設定されます。
  # 関連機能: CloudWatch Detailed Monitoring
  #   詳細モニタリングを有効にすると、より細かい粒度でインスタンスのメトリクスを監視できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch-new.html
  monitoring = false

  # ebs_optimized (Optional, Forces new resource)
  # 設定内容: EBS最適化を有効にするかを指定します。
  # 設定可能な値:
  #   - true: EBS最適化を有効化します
  #   - false: EBS最適化を無効化します
  # 省略時: インスタンスタイプのデフォルト設定が使用されます。
  # 関連機能: EBS-optimized instances
  #   EBS最適化により、EBSボリュームへの専用帯域幅が確保され、I/Oパフォーマンスが向上します。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html
  ebs_optimized = null

  # disable_api_stop (Optional)
  # 設定内容: API経由でのインスタンス停止を無効にするかを指定します。
  # 設定可能な値:
  #   - true: API経由での停止を無効化します
  #   - false (デフォルト): API経由での停止を許可します
  # 省略時: falseが設定されます。
  # 注意: この設定は、コンソールやCLIからの停止操作には影響しません。
  disable_api_stop = null

  # disable_api_termination (Optional)
  # 設定内容: API経由でのインスタンス終了を無効にするかを指定します。
  # 設定可能な値:
  #   - true: API経由での終了を無効化します（終了保護）
  #   - false (デフォルト): API経由での終了を許可します
  # 省略時: falseが設定されます。
  # 関連機能: Termination Protection
  #   誤ってインスタンスを終了することを防ぐ保護機能です。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingDisableAPITermination
  disable_api_termination = false

  # instance_initiated_shutdown_behavior (Optional, Forces new resource)
  # 設定内容: インスタンス内からシャットダウンした際の動作を指定します。
  # 設定可能な値:
  #   - "stop": インスタンスを停止します
  #   - "terminate": インスタンスを終了します
  # 省略時: "stop"が設定されます。
  # 注意: インスタンス内でshutdownコマンドを実行した際の動作を制御します。
  instance_initiated_shutdown_behavior = null

  # hibernation (Optional, Forces new resource)
  # 設定内容: 休止機能を有効にするかを指定します。
  # 設定可能な値:
  #   - true: 休止機能を有効化します
  #   - false (デフォルト): 休止機能を無効化します
  # 省略時: falseが設定されます。
  # 関連機能: Hibernate Your Instance
  #   休止機能により、インスタンスのメモリ内容をEBSルートボリュームに保存し、再起動時に復元できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Hibernate.html
  # 注意: 休止を有効にするには、暗号化されたEBSルートボリュームと十分な容量が必要です。
  hibernation = false

  #-------------------------------------------------------------
  # IAM設定
  #-------------------------------------------------------------

  # iam_instance_profile (Optional, Forces new resource)
  # 設定内容: インスタンスに関連付けるIAMインスタンスプロファイルを指定します。
  # 設定可能な値: IAMインスタンスプロファイルの名前またはARN
  # 省略時: IAMインスタンスプロファイルは関連付けられません。
  # 関連機能: IAM Roles for Amazon EC2
  #   インスタンスプロファイルにより、AWSサービスへのアクセス権限をインスタンスに付与できます。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
  iam_instance_profile = null

  #-------------------------------------------------------------
  # ユーザーデータ設定
  #-------------------------------------------------------------

  # user_data (Optional)
  # 設定内容: インスタンス起動時に実行するユーザーデータスクリプトを指定します。
  # 設定可能な値: 任意のテキストまたはスクリプト
  # 省略時: ユーザーデータは設定されません。
  # 関連機能: User Data
  #   インスタンスの初回起動時に自動的に実行されるスクリプトです。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
  # 注意: user_data_base64と排他的（どちらか一方のみ指定可能）
  user_data = null

  # user_data_base64 (Optional)
  # 設定内容: Base64エンコードされたユーザーデータを指定します。
  # 設定可能な値: Base64エンコードされた文字列
  # 省略時: ユーザーデータは設定されません。
  # 注意: user_dataと排他的（どちらか一方のみ指定可能）。
  #       バイナリデータを含む場合に使用します。
  user_data_base64 = null

  # user_data_replace_on_change (Optional)
  # 設定内容: user_dataの変更時にインスタンスを再作成するかを指定します。
  # 設定可能な値:
  #   - true: user_data変更時にインスタンスを再作成します
  #   - false (デフォルト): user_data変更時にインスタンスを再作成しません
  # 省略時: falseが設定されます。
  # 注意: trueに設定すると、user_data変更時にインスタンスが一時的に停止します。
  user_data_replace_on_change = false

  #-------------------------------------------------------------
  # パスワード取得設定
  #-------------------------------------------------------------

  # get_password_data (Optional)
  # 設定内容: Windowsインスタンスの管理者パスワードを取得するかを指定します。
  # 設定可能な値:
  #   - true: パスワードデータを取得します
  #   - false (デフォルト): パスワードデータを取得しません
  # 省略時: falseが設定されます。
  # 注意: Windowsインスタンスの場合のみ有効です。パスワード取得には時間がかかる場合があります。
  get_password_data = false

  #-------------------------------------------------------------
  # Terraform管理設定
  #-------------------------------------------------------------

  # id (Optional)
  # 設定内容: リソースの一意な識別子を指定します。
  # 設定可能な値: 任意の文字列
  # 省略時: Terraformが自動的に生成します。
  # 注意: 通常は指定する必要はありません。既存リソースのインポート時に使用されます。
  id = null

  # force_destroy (Optional)
  # 設定内容: terraform destroy時に関連リソースを強制削除するかを指定します。
  # 設定可能な値:
  #   - true: 関連リソースを強制的に削除します
  #   - false (デフォルト): 関連リソースが存在する場合はエラーを返します
  # 省略時: falseが設定されます。
  force_destroy = false

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: スポットインスタンスリクエストに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: これらのタグは起動されたインスタンスには自動的に適用されません。
  #       インスタンスにタグを適用する場合は、user_dataまたは別のリソースで設定してください。
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html
  tags = {
    Name        = "my-spot-instance"
    Environment = "production"
  }

  # tags_all (Optional)
  # 設定内容: プロバイダーのdefault_tagsを含むすべてのタグを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
  tags_all = null

  # volume_tags (Optional)
  # 設定内容: インスタンスに接続されるすべてのEBSボリュームに適用するタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: ボリュームにタグは適用されません。
  # 注意: ルートボリュームと追加のEBSボリュームの両方にタグが適用されます。
  volume_tags = null

  #-------------------------------------------------------------
  # Capacity Reservation設定
  #-------------------------------------------------------------

  capacity_reservation_specification {
    # capacity_reservation_preference (Optional)
    # 設定内容: Capacity Reservationの利用設定を指定します。
    # 設定可能な値:
    #   - "open": 一致するCapacity Reservationがあれば自動的に使用します
    #   - "none": Capacity Reservationを使用しません
    # 省略時: "open"が設定されます。
    # 関連機能: On-Demand Capacity Reservations
    #   Capacity Reservationにより、特定のアベイラビリティゾーンでキャパシティを予約できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-capacity-reservations.html
    capacity_reservation_preference = "open"

    capacity_reservation_target {
      # capacity_reservation_id (Optional)
      # 設定内容: 使用するCapacity ReservationのIDを指定します。
      # 設定可能な値: 既存のCapacity Reservation ID
      # 省略時: 特定のCapacity Reservationは使用されません。
      # 注意: capacity_reservation_resource_group_arnと排他的（どちらか一方のみ指定可能）
      capacity_reservation_id = null

      # capacity_reservation_resource_group_arn (Optional)
      # 設定内容: 使用するCapacity ReservationリソースグループのARNを指定します。
      # 設定可能な値: 有効なリソースグループARN
      # 省略時: リソースグループは使用されません。
      # 注意: capacity_reservation_idと排他的（どちらか一方のみ指定可能）
      capacity_reservation_resource_group_arn = null
    }
  }

  #-------------------------------------------------------------
  # CPU設定
  #-------------------------------------------------------------

  cpu_options {
    # core_count (Optional)
    # 設定内容: CPUコアの数を指定します。
    # 設定可能な値: インスタンスタイプでサポートされるコア数
    # 省略時: インスタンスタイプのデフォルト設定が使用されます。
    # 関連機能: CPU Options
    #   コア数とスレッド数をカスタマイズすることで、ライセンスコストを最適化できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html
    core_count = null

    # threads_per_core (Optional)
    # 設定内容: CPUコアあたりのスレッド数を指定します。
    # 設定可能な値:
    #   - 1: ハイパースレッディングを無効化します
    #   - 2: ハイパースレッディングを有効化します
    # 省略時: インスタンスタイプのデフォルト設定が使用されます。
    # 注意: 特定のワークロード（HPC等）では、ハイパースレッディングを無効化することでパフォーマンスが向上する場合があります。
    threads_per_core = null

    # amd_sev_snp (Optional)
    # 設定内容: AMD SEV-SNP（Secure Encrypted Virtualization - Secure Nested Paging）を有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled": AMD SEV-SNPを有効化します
    #   - "disabled": AMD SEV-SNPを無効化します
    # 省略時: インスタンスタイプのデフォルト設定が使用されます。
    # 関連機能: AMD SEV-SNP
    #   メモリ暗号化を強化し、仮想マシンの機密性を向上させます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sev-snp.html
    # 注意: AMDプロセッサを搭載した特定のインスタンスタイプでのみ利用可能です。
    amd_sev_snp = null
  }

  #-------------------------------------------------------------
  # クレジット仕様設定（T2/T3インスタンス用）
  #-------------------------------------------------------------

  credit_specification {
    # cpu_credits (Optional)
    # 設定内容: T2/T3インスタンスのCPUクレジット使用モードを指定します。
    # 設定可能な値:
    #   - "standard": 標準モード（クレジットを超過すると性能が低下）
    #   - "unlimited": 無制限モード（クレジットを超過しても性能を維持、追加料金が発生）
    # 省略時: インスタンスタイプのデフォルト設定が使用されます。
    # 関連機能: Burstable Performance Instances
    #   T2/T3インスタンスは、ベースラインCPU性能を持ち、CPUクレジットを使用してバースト可能です。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html
    # 注意: T2/T3インスタンスタイプでのみ有効です。
    cpu_credits = null
  }

  #-------------------------------------------------------------
  # EBSブロックデバイス設定
  #-------------------------------------------------------------

  ebs_block_device {
    # device_name (Required)
    # 設定内容: デバイス名を指定します。
    # 設定可能な値: デバイス名（例: /dev/sdf, /dev/xvdf）
    # 関連機能: Device Naming on Linux Instances
    #   EBSボリュームをアタッチする際のデバイス名の命名規則です。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
    device_name = "/dev/sdf"

    # volume_type (Optional)
    # 設定内容: EBSボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "gp2": 汎用SSD（前世代）
    #   - "gp3": 汎用SSD（最新世代、推奨）
    #   - "io1": プロビジョンドIOPS SSD（前世代）
    #   - "io2": プロビジョンドIOPS SSD（最新世代）
    #   - "sc1": Cold HDD
    #   - "st1": スループット最適化HDD
    #   - "standard": マグネティック（前世代、非推奨）
    # 省略時: "gp3"が設定されます。
    # 関連機能: Amazon EBS Volume Types
    #   ワークロードに応じて最適なボリュームタイプを選択できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html
    volume_type = "gp3"

    # volume_size (Optional)
    # 設定内容: EBSボリュームのサイズをGBで指定します。
    # 設定可能な値: 1-16384（ボリュームタイプにより上限が異なります）
    # 省略時: スナップショットサイズまたはAMIのサイズが使用されます。
    volume_size = 100

    # iops (Optional)
    # 設定内容: プロビジョンドIOPSの値を指定します。
    # 設定可能な値: ボリュームタイプとサイズに応じた範囲
    # 省略時: ボリュームタイプのデフォルト値が使用されます。
    # 注意: io1、io2、gp3ボリュームタイプでのみ設定可能です。
    iops = null

    # throughput (Optional)
    # 設定内容: スループット（MB/s）を指定します。
    # 設定可能な値: 125-1000（gp3ボリュームの場合）
    # 省略時: 125 MB/s（gp3のデフォルト）
    # 注意: gp3ボリュームタイプでのみ設定可能です。
    throughput = null

    # encrypted (Optional)
    # 設定内容: EBSボリュームを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: ボリュームを暗号化します
    #   - false: ボリュームを暗号化しません
    # 省略時: アカウントのデフォルト暗号化設定が使用されます。
    # 関連機能: Amazon EBS Encryption
    #   EBS暗号化により、データの保護とコンプライアンス要件を満たすことができます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html
    encrypted = true

    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用するKMSキーのARNまたはIDを指定します。
    # 設定可能な値: 有効なKMSキーARNまたはID
    # 省略時: デフォルトのEBS暗号化キーが使用されます。
    # 注意: encryptedがtrueの場合のみ有効です。
    kms_key_id = null

    # snapshot_id (Optional)
    # 設定内容: ボリュームの作成元となるスナップショットIDを指定します。
    # 設定可能な値: 既存のEBSスナップショットID
    # 省略時: 空のボリュームが作成されます。
    snapshot_id = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にボリュームを削除するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): インスタンス終了時にボリュームを削除します
    #   - false: インスタンス終了後もボリュームを保持します
    # 省略時: trueが設定されます。
    delete_on_termination = true

    # tags (Optional)
    # 設定内容: EBSボリュームに割り当てるタグのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグは設定されません。
    tags = null

    # tags_all (Optional)
    # 設定内容: プロバイダーのdefault_tagsを含むすべてのタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
    tags_all = null
  }

  #-------------------------------------------------------------
  # Enclaveオプション設定
  #-------------------------------------------------------------

  enclave_options {
    # enabled (Optional)
    # 設定内容: AWS Nitro Enclavesを有効にするかを指定します。
    # 設定可能な値:
    #   - true: Nitro Enclavesを有効化します
    #   - false: Nitro Enclavesを無効化します
    # 省略時: falseが設定されます。
    # 関連機能: AWS Nitro Enclaves
    #   機密性の高いデータ処理のための隔離されたコンピューティング環境を提供します。
    #   - https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html
    # 注意: サポートされているインスタンスタイプでのみ利用可能です。
    enabled = false
  }

  #-------------------------------------------------------------
  # エフェメラルブロックデバイス設定
  #-------------------------------------------------------------

  ephemeral_block_device {
    # device_name (Required)
    # 設定内容: デバイス名を指定します。
    # 設定可能な値: デバイス名（例: /dev/sdb, /dev/xvdb）
    device_name = "/dev/sdb"

    # virtual_name (Optional)
    # 設定内容: インスタンスストアボリュームの仮想デバイス名を指定します。
    # 設定可能な値: ephemeral0, ephemeral1, ephemeral2, etc.
    # 省略時: インスタンスストアは使用されません。
    # 関連機能: Instance Store
    #   インスタンスストアは、インスタンスに物理的に接続された一時ストレージです。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html
    # 注意: インスタンス停止時にデータは失われます。
    virtual_name = "ephemeral0"

    # no_device (Optional)
    # 設定内容: AMIで定義されたデバイスマッピングを抑制するかを指定します。
    # 設定可能な値:
    #   - true: デバイスマッピングを抑制します
    #   - false: デバイスマッピングを抑制しません
    # 省略時: falseが設定されます。
    no_device = false
  }

  #-------------------------------------------------------------
  # 起動テンプレート設定
  #-------------------------------------------------------------

  launch_template {
    # id (Optional)
    # 設定内容: 使用する起動テンプレートのIDを指定します。
    # 設定可能な値: 既存の起動テンプレートID
    # 省略時: 起動テンプレートは使用されません。
    # 注意: nameと排他的（どちらか一方のみ指定可能）
    id = null

    # name (Optional)
    # 設定内容: 使用する起動テンプレートの名前を指定します。
    # 設定可能な値: 既存の起動テンプレート名
    # 省略時: 起動テンプレートは使用されません。
    # 注意: idと排他的（どちらか一方のみ指定可能）
    name = null

    # version (Optional)
    # 設定内容: 使用する起動テンプレートのバージョンを指定します。
    # 設定可能な値: バージョン番号、"$Latest"、"$Default"
    # 省略時: "$Default"が使用されます。
    # 関連機能: Launch Templates
    #   起動テンプレートを使用すると、インスタンス設定を再利用できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html
    version = null
  }

  #-------------------------------------------------------------
  # メンテナンスオプション設定
  #-------------------------------------------------------------

  maintenance_options {
    # auto_recovery (Optional)
    # 設定内容: 自動リカバリーの動作を指定します。
    # 設定可能な値:
    #   - "default": デフォルトの自動リカバリー動作
    #   - "disabled": 自動リカバリーを無効化します
    # 省略時: "default"が設定されます。
    # 関連機能: EC2 Instance Auto Recovery
    #   システム障害が発生した際に、インスタンスを自動的に別のハードウェアで再起動します。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-recover.html
    auto_recovery = "default"
  }

  #-------------------------------------------------------------
  # メタデータオプション設定
  #-------------------------------------------------------------

  metadata_options {
    # http_endpoint (Optional)
    # 設定内容: インスタンスメタデータサービスを有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled" (デフォルト): メタデータサービスを有効化します
    #   - "disabled": メタデータサービスを無効化します
    # 省略時: "enabled"が設定されます。
    # 関連機能: Instance Metadata Service
    #   インスタンスに関する情報を取得するためのサービスです。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
    http_endpoint = "enabled"

    # http_tokens (Optional)
    # 設定内容: メタデータサービスのセッショントークンの使用を要求するかを指定します。
    # 設定可能な値:
    #   - "optional": トークンの使用は任意です（IMDSv1とIMDSv2の両方が利用可能）
    #   - "required": トークンの使用を必須とします（IMDSv2のみ）
    # 省略時: "optional"が設定されます。
    # 関連機能: Instance Metadata Service Version 2 (IMDSv2)
    #   IMDSv2は、セッション指向の方式でセキュリティを強化しています。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html
    # 注意: セキュリティのため、"required"に設定することを推奨します。
    http_tokens = "optional"

    # http_put_response_hop_limit (Optional)
    # 設定内容: メタデータトークンのPUTレスポンスホップ制限を指定します。
    # 設定可能な値: 1-64の整数
    # 省略時: 1が設定されます。
    # 注意: コンテナ環境などで、メタデータにアクセスするために複数のネットワークホップが必要な場合に増やします。
    http_put_response_hop_limit = 1

    # http_protocol_ipv6 (Optional)
    # 設定内容: IPv6を使用したメタデータサービスへのアクセスを有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled": IPv6を有効化します
    #   - "disabled" (デフォルト): IPv6を無効化します
    # 省略時: "disabled"が設定されます。
    http_protocol_ipv6 = null

    # instance_metadata_tags (Optional)
    # 設定内容: インスタンスメタデータサービス経由でのインスタンスタグへのアクセスを有効にするかを指定します。
    # 設定可能な値:
    #   - "enabled": タグへのアクセスを有効化します
    #   - "disabled" (デフォルト): タグへのアクセスを無効化します
    # 省略時: "disabled"が設定されます。
    # 関連機能: Instance Metadata Tags
    #   メタデータサービス経由でインスタンスタグを取得できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#work-with-tags-in-IMDS
    instance_metadata_tags = null
  }

  #-------------------------------------------------------------
  # ネットワークインターフェース設定（非推奨）
  #-------------------------------------------------------------

  # network_interface {
  #   # device_index (Required)
  #   # 設定内容: ネットワークインターフェースのデバイスインデックスを指定します。
  #   # 設定可能な値: 0以上の整数
  #   device_index = 0
  #
  #   # network_interface_id (Required)
  #   # 設定内容: 使用するネットワークインターフェースのIDを指定します。
  #   # 設定可能な値: 既存のネットワークインターフェースID
  #   network_interface_id = "eni-12345678"
  #
  #   # delete_on_termination (Optional)
  #   # 設定内容: インスタンス終了時にネットワークインターフェースを削除するかを指定します。
  #   # 設定可能な値:
  #   #   - true: インスタンス終了時にネットワークインターフェースを削除します
  #   #   - false: インスタンス終了後もネットワークインターフェースを保持します
  #   # 省略時: falseが設定されます。
  #   delete_on_termination = false
  #
  #   # 注意: このブロックは非推奨です。代わりに、aws_network_interfaceリソースと
  #   #       aws_network_interface_attachmentリソースを使用してください。
  # }

  #-------------------------------------------------------------
  # プライベートDNS名オプション設定
  #-------------------------------------------------------------

  private_dns_name_options {
    # hostname_type (Optional)
    # 設定内容: プライベートDNS名のホスト名タイプを指定します。
    # 設定可能な値:
    #   - "ip-name": IPベースの命名（例: ip-10-0-0-5）
    #   - "resource-name": リソースベースの命名
    # 省略時: サブネットのデフォルト設定が使用されます。
    # 関連機能: Private DNS Hostnames
    #   VPC内のインスタンスのプライベートDNS名の形式を制御します。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-naming.html
    hostname_type = null

    # enable_resource_name_dns_a_record (Optional)
    # 設定内容: リソース名に対するDNS Aレコードを有効にするかを指定します。
    # 設定可能な値:
    #   - true: DNS Aレコードを有効化します
    #   - false: DNS Aレコードを無効化します
    # 省略時: サブネットのデフォルト設定が使用されます。
    enable_resource_name_dns_a_record = null

    # enable_resource_name_dns_aaaa_record (Optional)
    # 設定内容: リソース名に対するDNS AAAAレコードを有効にするかを指定します。
    # 設定可能な値:
    #   - true: DNS AAAAレコードを有効化します
    #   - false: DNS AAAAレコードを無効化します
    # 省略時: サブネットのデフォルト設定が使用されます。
    enable_resource_name_dns_aaaa_record = null
  }

  #-------------------------------------------------------------
  # ルートブロックデバイス設定
  #-------------------------------------------------------------

  root_block_device {
    # volume_type (Optional)
    # 設定内容: ルートEBSボリュームのタイプを指定します。
    # 設定可能な値:
    #   - "gp2": 汎用SSD（前世代）
    #   - "gp3": 汎用SSD（最新世代、推奨）
    #   - "io1": プロビジョンドIOPS SSD（前世代）
    #   - "io2": プロビジョンドIOPS SSD（最新世代）
    #   - "sc1": Cold HDD
    #   - "st1": スループット最適化HDD
    #   - "standard": マグネティック（前世代、非推奨）
    # 省略時: AMIで指定されたボリュームタイプが使用されます。
    # 関連機能: Amazon EBS Volume Types
    #   ワークロードに応じて最適なボリュームタイプを選択できます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html
    volume_type = "gp3"

    # volume_size (Optional)
    # 設定内容: ルートEBSボリュームのサイズをGBで指定します。
    # 設定可能な値: 1-16384（ボリュームタイプにより上限が異なります）
    # 省略時: AMIで指定されたボリュームサイズが使用されます。
    volume_size = 30

    # iops (Optional)
    # 設定内容: プロビジョンドIOPSの値を指定します。
    # 設定可能な値: ボリュームタイプとサイズに応じた範囲
    # 省略時: ボリュームタイプのデフォルト値が使用されます。
    # 注意: io1、io2、gp3ボリュームタイプでのみ設定可能です。
    iops = null

    # throughput (Optional)
    # 設定内容: スループット（MB/s）を指定します。
    # 設定可能な値: 125-1000（gp3ボリュームの場合）
    # 省略時: 125 MB/s（gp3のデフォルト）
    # 注意: gp3ボリュームタイプでのみ設定可能です。
    throughput = null

    # encrypted (Optional)
    # 設定内容: ルートEBSボリュームを暗号化するかを指定します。
    # 設定可能な値:
    #   - true: ボリュームを暗号化します
    #   - false: ボリュームを暗号化しません
    # 省略時: アカウントのデフォルト暗号化設定が使用されます。
    # 関連機能: Amazon EBS Encryption
    #   EBS暗号化により、データの保護とコンプライアンス要件を満たすことができます。
    #   - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html
    encrypted = true

    # kms_key_id (Optional)
    # 設定内容: 暗号化に使用するKMSキーのARNまたはIDを指定します。
    # 設定可能な値: 有効なKMSキーARNまたはID
    # 省略時: デフォルトのEBS暗号化キーが使用されます。
    # 注意: encryptedがtrueの場合のみ有効です。
    kms_key_id = null

    # delete_on_termination (Optional)
    # 設定内容: インスタンス終了時にルートボリュームを削除するかを指定します。
    # 設定可能な値:
    #   - true (デフォルト): インスタンス終了時にボリュームを削除します
    #   - false: インスタンス終了後もボリュームを保持します
    # 省略時: trueが設定されます。
    delete_on_termination = true

    # tags (Optional)
    # 設定内容: ルートEBSボリュームに割り当てるタグのマップを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 省略時: タグは設定されません。
    tags = null

    # tags_all (Optional)
    # 設定内容: プロバイダーのdefault_tagsを含むすべてのタグを指定します。
    # 設定可能な値: キーと値のペアのマップ
    # 注意: 通常は明示的に設定する必要はありません。Terraformが自動的に管理します。
    tags_all = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  timeouts {
    # create (Optional)
    # 設定内容: リソース作成のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    create = null

    # delete (Optional)
    # 設定内容: リソース削除のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    delete = null

    # read (Optional)
    # 設定内容: リソース読み取りのタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間が使用されます。
    read = null
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: スポットインスタンスリクエストID
#
# - arn: スポットインスタンスリクエストのAmazon Resource Name (ARN)
#
# - spot_instance_id: スポットリクエストを満たすために現在実行中のインスタンスID（存在する場合）
#
# - spot_bid_status: スポットインスタンスリクエストの現在の入札ステータス
#        https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-bid-status.html
#
# - spot_request_state: スポットインスタンスリクエストの現在のリクエスト状態
#        https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-requests.html#creating-spot-request-status
#
# - instance_state: インスタンスの現在の状態（running, stopped, terminated等）
#
# - public_ip: インスタンスに割り当てられたパブリックIPアドレス（該当する場合）
#
# - public_dns: インスタンスに割り当てられたパブリックDNS名
#        EC2-VPCの場合、VPCでDNSホスト名を有効にしている場合のみ利用可能
#
# - private_ip: インスタンスに割り当てられたプライベートIPアドレス
#
# - private_dns: インスタンスに割り当てられたプライベートDNS名
#        Amazon EC2内でのみ使用可能で、VPCでDNSホスト名を有効にしている場合のみ利用可能
#
# - primary_network_interface_id: インスタンスのプライマリネットワークインターフェースID
#
# - primary_network_interface: プライマリネットワークインターフェースの詳細情報
#        - network_interface_id: ネットワークインターフェースID
#        - delete_on_termination: 終了時に削除されるかどうか
#
# - outpost_arn: インスタンスが実行されているOutpostのARN（該当する場合）
#
# - password_data: Windowsインスタンスの管理者パスワードデータ（get_password_dataがtrueの場合のみ）
#        注意: 取得には時間がかかる場合があります
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
