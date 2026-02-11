#---------------------------------------------------------------
# AWS Storage Gateway
#---------------------------------------------------------------
#
# AWS Storage Gatewayは、オンプレミス環境とAWSクラウドストレージ間の
# ハイブリッドストレージソリューションを提供します。ファイル、ボリューム、
# テープゲートウェイをプロビジョニングし、オンプレミスアプリケーションから
# S3、FSx、または仮想テープライブラリへのアクセスを可能にします。
#
# AWS公式ドキュメント:
#   - Storage Gateway User Guide: https://docs.aws.amazon.com/storagegateway/latest/userguide/
#   - API Reference - ActivateGateway: https://docs.aws.amazon.com/storagegateway/latest/APIReference/API_ActivateGateway.html
#   - Getting an activation key: https://docs.aws.amazon.com/storagegateway/latest/vgw/get-activation-key.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-02-05
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_gateway" "example" {
  #---------------------------------------------------------------
  # 必須パラメータ
  #---------------------------------------------------------------

  # ゲートウェイの名前
  # ゲートウェイを識別するための名前を指定します。
  gateway_name = "example-gateway"

  # ゲートウェイのタイムゾーン
  # スナップショットのスケジュールやゲートウェイのメンテナンススケジュールに使用されます。
  # 形式: "GMT", "GMT-hh:mm", または "GMT+hh:mm"
  # 例: "GMT-4:00" は GMTより4時間遅れていることを示します。
  gateway_timezone = "GMT"

  #---------------------------------------------------------------
  # アクティベーション設定（どちらか一方が必須）
  #---------------------------------------------------------------

  # アクティベーションキー
  # リソース作成時のゲートウェイアクティベーションキー。
  # gateway_ip_addressと競合します。
  # Storage Gateway User Guideの手順に従って取得してください。
  # https://docs.aws.amazon.com/storagegateway/latest/userguide/get-activation-key.html
  # activation_key = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

  # ゲートウェイのIPアドレス
  # リソース作成時にアクティベーションキーを取得するためのゲートウェイIPアドレス。
  # activation_keyと競合します。
  # ゲートウェイはTerraformを実行している場所からポート80でアクセス可能である必要があります。
  # gateway_ip_address = "1.2.3.4"

  #---------------------------------------------------------------
  # ゲートウェイタイプ
  #---------------------------------------------------------------

  # ゲートウェイのタイプ
  # デフォルトはSTOREDです。
  # 有効な値:
  #   - CACHED: キャッシュボリュームゲートウェイ
  #   - FILE_FSX_SMB: Amazon FSx File Gateway
  #   - FILE_S3: Amazon S3 File Gateway
  #   - STORED: ストアドボリュームゲートウェイ
  #   - VTL: 仮想テープライブラリゲートウェイ
  gateway_type = "FILE_S3"

  #---------------------------------------------------------------
  # 帯域幅制限設定
  #---------------------------------------------------------------

  # 平均ダウンロード帯域幅制限（ビット/秒）
  # CACHED、STORED、VTLゲートウェイタイプでサポートされています。
  # average_download_rate_limit_in_bits_per_sec = 102400

  # 平均アップロード帯域幅制限（ビット/秒）
  # CACHED、STORED、VTLゲートウェイタイプでサポートされています。
  # average_upload_rate_limit_in_bits_per_sec = 51200

  #---------------------------------------------------------------
  # ネットワーク設定
  #---------------------------------------------------------------

  # VPCエンドポイントアドレス
  # プライベートサブネット内のインスタンスでゲートウェイをアクティブ化する際に使用します。
  # Terraformを実行しているクライアントコンピュータからHTTPアクセスが必要です。
  # VPCエンドポイントセキュリティグループで必要なポートの詳細:
  # https://docs.aws.amazon.com/storagegateway/latest/userguide/gateway-private-link.html
  # gateway_vpc_endpoint = "vpce-12345678"

  #---------------------------------------------------------------
  # ログ設定
  #---------------------------------------------------------------

  # CloudWatch Logs グループARN
  # ゲートウェイのイベントを監視およびログに記録するために使用する
  # Amazon CloudWatch LogsグループのARN。
  # cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/storagegateway/gateway"

  #---------------------------------------------------------------
  # テープゲートウェイ設定
  #---------------------------------------------------------------

  # ミディアムチェンジャータイプ
  # テープゲートウェイに使用するミディアムチェンジャーのタイプ。
  # Terraformはこの引数のドリフトを検出できません。
  # 有効な値: STK-L700, AWS-Gateway-VTL, IBM-03584L32-0402
  # VTLゲートウェイタイプでのみ使用します。
  # medium_changer_type = "AWS-Gateway-VTL"

  # テープドライブタイプ
  # テープゲートウェイに使用するテープドライブのタイプ。
  # Terraformはこの引数のドリフトを検出できません。
  # 有効な値: IBM-ULT3580-TD5
  # VTLゲートウェイタイプでのみ使用します。
  # tape_drive_type = "IBM-ULT3580-TD5"

  #---------------------------------------------------------------
  # SMB設定
  #---------------------------------------------------------------

  # SMBファイル共有の可視性
  # このゲートウェイの共有がリスト表示される際に表示されるかどうかを指定します。
  # FILE_S3およびFILE_FSX_SMBゲートウェイタイプでのみ有効です。
  # smb_file_share_visibility = false

  # SMBゲストパスワード
  # Server Message Block (SMB)ファイル共有のゲストパスワード。
  # FILE_S3およびFILE_FSX_SMBゲートウェイタイプでのみ有効です。
  # GuestAccess認証SMBファイル共有を作成する前に設定する必要があります。
  # Terraformはゲストパスワードの存在のみを検出でき、実際の値は検出できません。
  # ただし、引数を変更することでパスワードを更新できます。
  # smb_guest_password = "password"

  # SMBセキュリティ戦略
  # セキュリティ戦略のタイプを指定します。
  # 有効な値:
  #   - ClientSpecified: クライアントが指定したセキュリティレベル
  #   - MandatorySigning: 必須の署名
  #   - MandatoryEncryption: 必須の暗号化
  # 詳細: https://docs.aws.amazon.com/storagegateway/latest/userguide/managing-gateway-file.html#security-strategy
  # smb_security_strategy = "ClientSpecified"

  #---------------------------------------------------------------
  # リージョン設定
  #---------------------------------------------------------------

  # リージョン
  # このリソースが管理されるリージョン。
  # プロバイダー設定のリージョンがデフォルトになります。
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  # region = "us-east-1"

  #---------------------------------------------------------------
  # タグ
  #---------------------------------------------------------------

  # リソースタグ
  # キーバリューペアのリソースタグ。
  # プロバイダーのdefault_tagsと競合するキーは上書きされます。
  tags = {
    Name        = "example-gateway"
    Environment = "production"
  }

  # すべてのタグ（プロバイダーのdefault_tags含む）
  # プロバイダー設定のdefault_tagsを含む、このリソースに適用される全てのタグ。
  # 通常は明示的に設定する必要はありません。
  # tags_all = {}

  #---------------------------------------------------------------
  # 内部使用ID（通常は指定不要）
  #---------------------------------------------------------------

  # リソースID
  # インポート時などの特殊なケースでのみ使用します。
  # 通常は指定する必要はありません。
  # id = "arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678"

  #---------------------------------------------------------------
  # ネストブロック: メンテナンス開始時刻
  #---------------------------------------------------------------

  # ゲートウェイの週次メンテナンス開始時刻情報
  # メンテナンス時刻はゲートウェイのタイムゾーンで指定します。
  maintenance_start_time {
    # 時（必須）
    # メンテナンス開始時刻の時コンポーネント（00～23）。
    # ゲートウェイのタイムゾーンでの時刻です。
    hour_of_day = 12

    # 分（オプション）
    # メンテナンス開始時刻の分コンポーネント（00～59）。
    # ゲートウェイのタイムゾーンでの時刻です。
    minute_of_hour = 0

    # 曜日（オプション）
    # メンテナンス開始時刻の曜日コンポーネント（0～6）。
    # 0は日曜日、6は土曜日を表します。
    # day_of_weekまたはday_of_monthのいずれかを指定します。
    day_of_week = 0

    # 日（オプション）
    # メンテナンス開始時刻の月の日コンポーネント（1～28）。
    # 1は月の最初の日、28は月の最後の日を表します。
    # day_of_monthまたはday_of_weekのいずれかを指定します。
    # day_of_month = "1"
  }

  #---------------------------------------------------------------
  # ネストブロック: SMB Active Directory設定
  #---------------------------------------------------------------

  # Server Message Block (SMB)ファイル共有のActive Directoryドメイン参加情報
  # FILE_S3およびFILE_FSX_SMBゲートウェイタイプでのみ有効です。
  # ActiveDirectory認証SMBファイル共有を作成する前に設定する必要があります。
  # smb_active_directory_settings {
  #   # ドメイン名（必須）
  #   # ゲートウェイを参加させるドメインの名前。
  #   domain_name = "corp.example.com"

  #   # ユーザー名（必須）
  #   # ゲートウェイをActive Directoryドメインに追加する権限を持つユーザーのユーザー名。
  #   username = "Admin"

  #   # パスワード（必須、機密情報）
  #   # ゲートウェイをActive Directoryドメインに追加する権限を持つユーザーのパスワード。
  #   password = "avoid-plaintext-passwords"

  #   # 組織単位（オプション）
  #   # 組織単位(OU)はActive Directory内のコンテナで、
  #   # ユーザー、グループ、コンピュータ、および他のOUを保持できます。
  #   # このパラメータは、ゲートウェイがADドメイン内で参加するOUを指定します。
  #   # organizational_unit = "OU=Gateways,DC=corp,DC=example,DC=com"

  #   # ドメインコントローラー（オプション）
  #   # ドメインサーバーのIPv4アドレス、NetBIOS名、またはホスト名のリスト。
  #   # ポート番号を指定する必要がある場合は、コロン(":")の後に含めます。
  #   # 例: mydc.mydomain.com:389
  #   # domain_controllers = ["192.168.1.1", "mydc.mydomain.com:389"]

  #   # タイムアウト（秒）（オプション）
  #   # JoinDomain操作が完了する必要がある時間（秒単位）。
  #   # デフォルトは20秒です。
  #   # timeout_in_seconds = 20
  # }

  #---------------------------------------------------------------
  # ネストブロック: タイムアウト
  #---------------------------------------------------------------

  # リソース作成のタイムアウト設定
  timeouts {
    # 作成タイムアウト
    # ゲートウェイの作成完了を待機する時間。
    # デフォルトは適切な値が設定されています。
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference（参照専用属性）
#---------------------------------------------------------------
# 以下の属性はリソース作成後に参照可能ですが、設定はできません。
#
# - id: ゲートウェイのAmazon Resource Name (ARN)
# - arn: ゲートウェイのAmazon Resource Name (ARN)
# - gateway_id: ゲートウェイの識別子
# - ec2_instance_id: ゲートウェイの起動に使用されたAmazon EC2インスタンスのID
# - endpoint_type: ゲートウェイのエンドポイントタイプ
# - host_environment: ホストが使用するハイパーバイザー環境のタイプ
# - gateway_network_interface: ゲートウェイネットワークインターフェイスの説明を含む配列
#   - ipv4_address: インターフェイスのInternet Protocol version 4 (IPv4)アドレス
# - tags_all: プロバイダーのdefault_tagsを含む、リソースに割り当てられたタグのマップ
#
#---------------------------------------------------------------
