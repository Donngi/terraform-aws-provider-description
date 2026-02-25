#---------------------------------------------------------------
# AWS Storage Gateway Gateway
#---------------------------------------------------------------
#
# AWS Storage Gatewayのゲートウェイをプロビジョニングするリソースです。
# ファイルゲートウェイ（S3/FSx）、テープゲートウェイ（VTL）、
# ボリュームゲートウェイ（CACHED/STORED）の各タイプに対応しています。
#
# AWS公式ドキュメント:
#   - Storage Gateway概要: https://docs.aws.amazon.com/storagegateway/latest/userguide/WhatIsStorageGateway.html
#   - ゲートウェイのアクティベーション: https://docs.aws.amazon.com/storagegateway/latest/userguide/get-activation-key.html
#   - VPCプライベートリンク: https://docs.aws.amazon.com/storagegateway/latest/userguide/gateway-private-link.html
#
# Terraform Registry:
#   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/storagegateway_gateway
#
# Provider Version: 6.28.0
# Generated: 2026-02-19
# NOTE: 本テンプレートは生成時点の情報に基づきAIが生成しています。
#       情報が古くなっている可能性、誤りを含む可能性があるため、
#       正確な最新仕様は公式ドキュメントを参照してください。
#
#---------------------------------------------------------------

resource "aws_storagegateway_gateway" "example" {
  #-------------------------------------------------------------
  # 必須設定
  #-------------------------------------------------------------

  # gateway_name (Required)
  # 設定内容: ゲートウェイの名前を指定します。
  # 設定可能な値: 任意の文字列
  gateway_name = "example-gateway"

  # gateway_timezone (Required)
  # 設定内容: ゲートウェイのタイムゾーンを指定します。
  #          タイムゾーンはスナップショットのスケジューリングやメンテナンス時刻に使用されます。
  # 設定可能な値:
  #   - "GMT": 協定世界時
  #   - "GMT-hr:mm": UTCマイナスオフセット（例: "GMT-4:00", "GMT-9:00"）
  #   - "GMT+hr:mm": UTCプラスオフセット（例: "GMT+9:00", "GMT+5:30"）
  gateway_timezone = "GMT+9:00"

  #-------------------------------------------------------------
  # アクティベーション設定
  #-------------------------------------------------------------

  # activation_key (Optional)
  # 設定内容: リソース作成時のゲートウェイアクティベーションキーを指定します。
  #          gateway_ip_addressと競合するため、どちらか一方のみ指定します。
  # 設定可能な値: アクティベーションキー文字列
  # 省略時: gateway_ip_addressによる自動取得
  # 注意: gateway_ip_addressを使用する場合、TerraformはポートIPアドレスへのHTTP（ポート80）GETリクエストを実行できる必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/userguide/get-activation-key.html
  activation_key = null

  # gateway_ip_address (Optional)
  # 設定内容: リソース作成時にアクティベーションキーを取得するゲートウェイのIPアドレスを指定します。
  #          activation_keyと競合するため、どちらか一方のみ指定します。
  # 設定可能な値: ゲートウェイインスタンスのIPv4アドレス
  # 省略時: activation_keyによる手動指定
  # 注意: TerraformからゲートウェイIPアドレスへのポート80でのHTTPアクセスが必要です。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/userguide/get-activation-key.html
  gateway_ip_address = "1.2.3.4"

  #-------------------------------------------------------------
  # ゲートウェイタイプ設定
  #-------------------------------------------------------------

  # gateway_type (Optional)
  # 設定内容: ゲートウェイのタイプを指定します。
  # 設定可能な値:
  #   - "STORED" (デフォルト): ボリュームゲートウェイ（ストア型）
  #   - "CACHED": ボリュームゲートウェイ（キャッシュ型）
  #   - "FILE_S3": S3ファイルゲートウェイ
  #   - "FILE_FSX_SMB": Amazon FSx File Gateway
  #   - "VTL": テープゲートウェイ（Virtual Tape Library）
  # 省略時: "STORED"
  gateway_type = "FILE_S3"

  # gateway_vpc_endpoint (Optional)
  # 設定内容: ゲートウェイのアクティベーション時に使用するVPCエンドポイントアドレスを指定します。
  #          プライベートサブネット内のインスタンスを使用する場合に設定します。
  # 設定可能な値: VPCエンドポイントのDNS名またはIPアドレス
  # 省略時: VPCエンドポイントを使用しない（インターネット経由でのアクティベーション）
  # 注意: VPCエンドポイントセキュリティグループで必要なポートが開放されている必要があります。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/userguide/gateway-private-link.html
  gateway_vpc_endpoint = null

  #-------------------------------------------------------------
  # 帯域幅制限設定
  #-------------------------------------------------------------

  # average_download_rate_limit_in_bits_per_sec (Optional)
  # 設定内容: 平均ダウンロード帯域幅レート制限をビット/秒で指定します。
  #          CACHED、STORED、VTLゲートウェイタイプでサポートされます。
  # 設定可能な値: 正の整数（ビット/秒）
  # 省略時: 帯域幅制限なし
  average_download_rate_limit_in_bits_per_sec = null

  # average_upload_rate_limit_in_bits_per_sec (Optional)
  # 設定内容: 平均アップロード帯域幅レート制限をビット/秒で指定します。
  #          CACHED、STORED、VTLゲートウェイタイプでサポートされます。
  # 設定可能な値: 正の整数（ビット/秒）
  # 省略時: 帯域幅制限なし
  average_upload_rate_limit_in_bits_per_sec = null

  #-------------------------------------------------------------
  # ログ設定
  #-------------------------------------------------------------

  # cloudwatch_log_group_arn (Optional)
  # 設定内容: ゲートウェイのイベントを監視・ログ記録するために使用するCloudWatch LogsロググループのARNを指定します。
  # 設定可能な値: 有効なCloudWatch Logs LogGroup ARN
  # 省略時: CloudWatchへのログ記録を行わない
  cloudwatch_log_group_arn = null

  #-------------------------------------------------------------
  # SMBファイル共有設定
  #-------------------------------------------------------------

  # smb_guest_password (Optional)
  # 設定内容: SMBファイル共有のゲストパスワードを指定します。
  #          FILE_S3およびFILE_FSX_SMBゲートウェイタイプでのみ有効です。
  #          GuestAccess認証のSMBファイル共有を作成する前に設定する必要があります。
  # 設定可能な値: パスワード文字列（機密情報として扱われます）
  # 省略時: ゲストアクセスなし
  # 注意: TerraformはゲストパスワードのValue変更は検知できますが、ゲートウェイ上の実際の値とのドリフトは検知できません。
  smb_guest_password = null

  # smb_security_strategy (Optional)
  # 設定内容: SMBセキュリティ戦略のタイプを指定します。
  # 設定可能な値:
  #   - "ClientSpecified": クライアントが指定したセキュリティレベル
  #   - "MandatorySigning": 必須署名
  #   - "MandatoryEncryption": 必須暗号化
  # 省略時: 自動設定（計算値）
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/userguide/managing-gateway-file.html#security-strategy
  smb_security_strategy = null

  # smb_file_share_visibility (Optional)
  # 設定内容: このゲートウェイ上の共有を一覧表示する際に表示するかどうかを指定します。
  # 設定可能な値:
  #   - true: 共有を表示する
  #   - false: 共有を非表示にする
  # 省略時: デフォルトの表示設定
  smb_file_share_visibility = null

  #-------------------------------------------------------------
  # テープゲートウェイ設定
  #-------------------------------------------------------------

  # medium_changer_type (Optional)
  # 設定内容: テープゲートウェイに使用するメディアチェンジャーのタイプを指定します。
  # 設定可能な値:
  #   - "STK-L700": StorageTek L700 メディアチェンジャー
  #   - "AWS-Gateway-VTL": AWS Storage Gateway VTL
  #   - "IBM-03584L32-0402": IBM 03584L32-0402 メディアチェンジャー
  # 省略時: デフォルトのメディアチェンジャー
  # 注意: Terraformはこの引数のドリフトを検知できません。
  medium_changer_type = null

  # tape_drive_type (Optional)
  # 設定内容: テープゲートウェイに使用するテープドライブのタイプを指定します。
  # 設定可能な値:
  #   - "IBM-ULT3580-TD5": IBM ULT3580-TD5 テープドライブ
  # 省略時: デフォルトのテープドライブ
  # 注意: Terraformはこの引数のドリフトを検知できません。
  tape_drive_type = null

  #-------------------------------------------------------------
  # リージョン設定
  #-------------------------------------------------------------

  # region (Optional)
  # 設定内容: このリソースを管理するリージョンを指定します。
  # 設定可能な値: 有効なAWSリージョンコード（例: us-east-1, ap-northeast-1）
  # 省略時: プロバイダー設定のリージョンを使用
  # 参考: https://docs.aws.amazon.com/general/latest/gr/rande.html#regional-endpoints
  region = null

  #-------------------------------------------------------------
  # タグ設定
  #-------------------------------------------------------------

  # tags (Optional)
  # 設定内容: リソースに割り当てるタグのマップを指定します。
  # 設定可能な値: キーと値のペアのマップ
  # 省略時: タグなし
  # 関連機能: AWSリソースタグ付け
  #   プロバイダーレベルのdefault_tags設定ブロックで定義されたタグと
  #   一致するキーを持つタグは、プロバイダーレベルで定義されたものを上書きします。
  #   - https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  tags = {
    Name        = "example-gateway"
    Environment = "production"
  }

  #-------------------------------------------------------------
  # メンテナンス開始時刻設定
  #-------------------------------------------------------------

  # maintenance_start_time (Optional)
  # 設定内容: ゲートウェイの週次メンテナンス開始時刻を指定します。
  #          メンテナンス時刻はゲートウェイのタイムゾーンで表示されます。
  # 参考: https://docs.aws.amazon.com/storagegateway/latest/userguide/MaintenanceManagement.html
  maintenance_start_time {
    # hour_of_day (Required)
    # 設定内容: メンテナンス開始時刻の時間コンポーネントを指定します。
    # 設定可能な値: 0〜23の整数（ゲートウェイのタイムゾーン基準）
    hour_of_day = 2

    # minute_of_hour (Optional)
    # 設定内容: メンテナンス開始時刻の分コンポーネントを指定します。
    # 設定可能な値: 0〜59の整数
    # 省略時: 0（0分）
    minute_of_hour = 0

    # day_of_week (Optional)
    # 設定内容: メンテナンス開始時刻の曜日コンポーネントを指定します。
    # 設定可能な値: 0〜6の整数（0=日曜、1=月曜、...、6=土曜）
    # 省略時: 月次メンテナンスの場合はday_of_monthを使用
    day_of_week = "0"

    # day_of_month (Optional)
    # 設定内容: メンテナンス開始時刻の日付コンポーネントを指定します（月次メンテナンス用）。
    # 設定可能な値: 1〜28の整数（1=1日、28=28日）
    # 省略時: 週次メンテナンスの場合はday_of_weekを使用
    day_of_month = null
  }

  #-------------------------------------------------------------
  # SMB Active Directory設定
  #-------------------------------------------------------------

  # smb_active_directory_settings (Optional)
  # 設定内容: SMBファイル共有のActive Directoryドメイン参加情報を指定します。
  #          FILE_S3およびFILE_FSX_SMBゲートウェイタイプでのみ有効です。
  #          ActiveDirectory認証のSMBファイル共有を作成する前に設定する必要があります。
  smb_active_directory_settings {
    # domain_name (Required)
    # 設定内容: ゲートウェイが参加するドメインの名前を指定します。
    # 設定可能な値: 有効なActive DirectoryドメインのFQDN（例: "corp.example.com"）
    domain_name = "corp.example.com"

    # username (Required)
    # 設定内容: ゲートウェイをActive Directoryドメインに追加する権限を持つユーザーのユーザー名を指定します。
    # 設定可能な値: Active Directoryユーザー名
    username = "Admin"

    # password (Required)
    # 設定内容: ゲートウェイをActive Directoryドメインに追加する権限を持つユーザーのパスワードを指定します。
    # 設定可能な値: パスワード文字列（機密情報として扱われます）
    # 注意: プレーンテキストでのパスワード記述は避け、変数や秘密管理サービスを使用してください。
    password = "avoid-plaintext-passwords"

    # timeout_in_seconds (Optional)
    # 設定内容: JoinDomain操作が完了するまでの秒数を指定します。
    # 設定可能な値: 正の整数（秒）
    # 省略時: 20秒
    timeout_in_seconds = null

    # organizational_unit (Optional)
    # 設定内容: ゲートウェイが参加するActive Directory内の組織単位（OU）を指定します。
    # 設定可能な値: OUの識別名（例: "OU=Gateways,DC=corp,DC=example,DC=com"）
    # 省略時: デフォルトのコンテナに配置
    organizational_unit = null

    # domain_controllers (Optional)
    # 設定内容: ドメインサーバーのIPv4アドレス、NetBIOS名、またはホスト名のリストを指定します。
    #          ポート番号を含める場合はコロン区切りで指定します（例: "mydc.mydomain.com:389"）。
    # 設定可能な値: IPアドレス、NetBIOS名、またはホスト名の文字列セット
    # 省略時: 自動検出
    domain_controllers = null
  }

  #-------------------------------------------------------------
  # タイムアウト設定
  #-------------------------------------------------------------

  # timeouts (Optional)
  # 設定内容: リソース操作のタイムアウト時間を指定します。
  timeouts {
    # create (Optional)
    # 設定内容: リソース作成時のタイムアウト時間を指定します。
    # 設定可能な値: 時間文字列（例: "10m", "1h"）
    # 省略時: デフォルトのタイムアウト時間
    create = "10m"
  }
}

#---------------------------------------------------------------
# Attributes Reference (読み取り専用属性)
#---------------------------------------------------------------
# このリソースは以下の属性をエクスポートします:
#
# - id: ゲートウェイのAmazon Resource Name (ARN)
#
# - arn: ゲートウェイのAmazon Resource Name (ARN)
#
# - gateway_id: ゲートウェイの識別子
#
# - ec2_instance_id: ゲートウェイの起動に使用されたEC2インスタンスのID
#
# - endpoint_type: ゲートウェイのエンドポイントタイプ
#
# - host_environment: ホストで使用されているハイパーバイザー環境のタイプ
#
# - gateway_network_interface: ゲートウェイネットワークインターフェースの説明配列
#   - ipv4_address: インターフェースのIPv4アドレス
#
# - tags_all: プロバイダーのdefault_tags設定ブロックから継承されたタグを含む、
#             リソースに割り当てられたすべてのタグのマップ
#---------------------------------------------------------------
